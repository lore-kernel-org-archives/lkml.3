Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbaIOWeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:34:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51198 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbaIOWTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Chris Mason <clm@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 186/187] Btrfs: Fix memory corruption by ulist_add_merge() on 32bit arch
Date: Mon, 15 Sep 2014 15:09:56 -0700
Message-Id: <1410818997-9432-187-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4eb1f66dce6c4dc28dd90a7ffbe6b2b1cb08aa4e upstream.

We've got bug reports that btrfs crashes when quota is enabled on
32bit kernel, typically with the Oops like below:
 BUG: unable to handle kernel NULL pointer dereference at 00000004
 IP: [<f9234590>] find_parent_nodes+0x360/0x1380 [btrfs]
 *pde = 00000000
 Oops: 0000 [#1] SMP
 CPU: 0 PID: 151 Comm: kworker/u8:2 Tainted: G S      W 3.15.2-1.gd43d97e-default #1
 Workqueue: btrfs-qgroup-rescan normal_work_helper [btrfs]
 task: f1478130 ti: f147c000 task.ti: f147c000
 EIP: 0060:[<f9234590>] EFLAGS: 00010213 CPU: 0
 EIP is at find_parent_nodes+0x360/0x1380 [btrfs]
 EAX: f147dda8 EBX: f147ddb0 ECX: 00000011 EDX: 00000000
 ESI: 00000000 EDI: f147dda4 EBP: f147ddf8 ESP: f147dd38
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
 CR0: 8005003b CR2: 00000004 CR3: 00bf3000 CR4: 00000690
 Stack:
  00000000 00000000 f147dda4 00000050 00000001 00000000 00000001 00000050
  00000001 00000000 d3059000 00000001 00000022 000000a8 00000000 00000000
  00000000 000000a1 00000000 00000000 00000001 00000000 00000000 11800000
 Call Trace:
  [<f923564d>] __btrfs_find_all_roots+0x9d/0xf0 [btrfs]
  [<f9237bb1>] btrfs_qgroup_rescan_worker+0x401/0x760 [btrfs]
  [<f9206148>] normal_work_helper+0xc8/0x270 [btrfs]
  [<c025e38b>] process_one_work+0x11b/0x390
  [<c025eea1>] worker_thread+0x101/0x340
  [<c026432b>] kthread+0x9b/0xb0
  [<c0712a71>] ret_from_kernel_thread+0x21/0x30
  [<c0264290>] kthread_create_on_node+0x110/0x110

This indicates a NULL corruption in prefs_delayed list.  The further
investigation and bisection pointed that the call of ulist_add_merge()
results in the corruption.

ulist_add_merge() takes u64 as aux and writes a 64bit value into
old_aux.  The callers of this function in backref.c, however, pass a
pointer of a pointer to old_aux.  That is, the function overwrites
64bit value on 32bit pointer.  This caused a NULL in the adjacent
variable, in this case, prefs_delayed.

Here is a quick attempt to band-aid over this: a new function,
ulist_add_merge_ptr() is introduced to pass/store properly a pointer
value instead of u64.  There are still ugly void ** cast remaining
in the callers because void ** cannot be taken implicitly.  But, it's
safer than explicit cast to u64, anyway.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=887046
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/backref.c | 11 +++++------
 fs/btrfs/ulist.h   | 15 +++++++++++++++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 3775947..5ee99e3 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -263,9 +263,8 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			}
 			if (ret > 0)
 				goto next;
-			ret = ulist_add_merge(parents, eb->start,
-					      (uintptr_t)eie,
-					      (u64 *)&old, GFP_NOFS);
+			ret = ulist_add_merge_ptr(parents, eb->start,
+						  eie, (void **)&old, GFP_NOFS);
 			if (ret < 0)
 				break;
 			if (!ret && extent_item_pos) {
@@ -961,9 +960,9 @@ again:
 					goto out;
 				ref->inode_list = eie;
 			}
-			ret = ulist_add_merge(refs, ref->parent,
-					      (uintptr_t)ref->inode_list,
-					      (u64 *)&eie, GFP_NOFS);
+			ret = ulist_add_merge_ptr(refs, ref->parent,
+						  ref->inode_list,
+						  (void **)&eie, GFP_NOFS);
 			if (ret < 0)
 				goto out;
 			if (!ret && extent_item_pos) {
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index fb36731..3e62b57 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -74,6 +74,21 @@ void ulist_free(struct ulist *ulist);
 int ulist_add(struct ulist *ulist, u64 val, u64 aux, gfp_t gfp_mask);
 int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 		    u64 *old_aux, gfp_t gfp_mask);
+
+/* just like ulist_add_merge() but take a pointer for the aux data */
+static inline int ulist_add_merge_ptr(struct ulist *ulist, u64 val, void *aux,
+				      void **old_aux, gfp_t gfp_mask)
+{
+#if BITS_PER_LONG == 32
+	u64 old64 = (uintptr_t)*old_aux;
+	int ret = ulist_add_merge(ulist, val, (uintptr_t)aux, &old64, gfp_mask);
+	*old_aux = (void *)((uintptr_t)old64);
+	return ret;
+#else
+	return ulist_add_merge(ulist, val, (u64)aux, (u64 *)old_aux, gfp_mask);
+#endif
+}
+
 struct ulist_node *ulist_next(struct ulist *ulist,
 			      struct ulist_iterator *uiter);
 
-- 
1.9.1

