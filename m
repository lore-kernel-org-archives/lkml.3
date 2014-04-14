Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaDNHl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:41:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36290 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaDNHl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:41:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu
References: <87sipmbe8x.fsf@x220.int.ebiederm.org>
	<20140409175322.GZ18016@ZenIV.linux.org.uk>
	<20140409182830.GA18016@ZenIV.linux.org.uk>
	<87txa286fu.fsf@x220.int.ebiederm.org>
	<87fvlm860e.fsf_-_@x220.int.ebiederm.org>
	<20140409232423.GB18016@ZenIV.linux.org.uk>
	<87lhva5h4k.fsf@x220.int.ebiederm.org>
	<20140413053956.GM18016@ZenIV.linux.org.uk>
	<87zjjp3e7w.fsf@x220.int.ebiederm.org>
	<87ppkl1xb7.fsf@x220.int.ebiederm.org>
	<20140413215242.GP18016@ZenIV.linux.org.uk>
	<87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
Date: Mon, 14 Apr 2014 00:41:31 -0700
In-Reply-To: <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 14 Apr 2014 00:38:47 -0700")
Message-ID: <87ha5wuzmc.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Qj5KomdDym3GKo4OQ/5wlvuo5R1MBWhg=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4997]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 3/4] vfs: In mntput run deactivate_super on a shallow stack.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mntput as part of path_put is called from all over the vfs sometimes
as in the case of symlink chasing from some rather deep call chains.
During lazy filesystem unmount with the right set of races those
innocuous little mntput calls (that take very little stack space) can
call deactivate_super and wind up taking 3k of stack space or more
(David Chinner reports 5k for xfs).

Avoid deactivate_super being called from a deep stack by moving
the cleanup of the mount into a work queue.

To avoid semantic changes mntput waits for deactivate_super to complete
before returning.

With this change all filesystem unmounting happens with about 7400
bytes free on the stack at the point where deactivate_super is called.
Giving filesystems plenty of room to do I/O and not overflow the
kernel stack during unmounting.

The extra fields mnt_cleanup_work, and mnt_undone are added in
a union to avoid growing struct mount unnecessarily.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/mount.h     | 14 +++++++++++---
 fs/namespace.c | 32 +++++++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index a4111f19fd2e..7272fc416580 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -48,8 +48,17 @@ struct mount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct mount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
-	struct mountpoint *mnt_mp;	/* where is it mounted */
-	struct list_head mnt_mp_list;	/* list mounts with the same mountpoint */
+	union {
+		struct {
+			struct path mnt_ex_mountpoint;
+			struct list_head mnt_mp_list;	/* list mounts with the same mountpoint */
+			struct mountpoint *mnt_mp;	/* where is it mounted */
+		};
+		struct {
+			struct work_struct mnt_cleanup_work;
+			struct completion *mnt_undone;
+		};
+	};
 #ifdef CONFIG_FSNOTIFY
 	struct hlist_head mnt_fsnotify_marks;
 	__u32 mnt_fsnotify_mask;
@@ -58,7 +67,6 @@ struct mount {
 	int mnt_group_id;		/* peer group identifier */
 	int mnt_expiry_mark;		/* true if marked for expiry */
 	int mnt_pinned;
-	struct path mnt_ex_mountpoint;
 };
 
 #define MNT_NS_INTERNAL ERR_PTR(-EINVAL) /* distinct from any mnt_namespace */
diff --git a/fs/namespace.c b/fs/namespace.c
index 2abd5a2416d0..ac589ad9f22d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -983,8 +983,25 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	return ERR_PTR(err);
 }
 
+static void cleanup_mnt(struct mount *mnt)
+{
+	fsnotify_vfsmount_delete(&mnt->mnt);
+	dput(mnt->mnt.mnt_root);
+	deactivate_super(mnt->mnt.mnt_sb);
+	mnt_free_id(mnt);
+	complete(mnt->mnt_undone);
+	call_rcu(&mnt->mnt_rcu, delayed_free_vfsmnt);
+}
+
+static void cleanup_mnt_work(struct work_struct *work)
+{
+	cleanup_mnt(container_of(work, struct mount, mnt_cleanup_work));
+}
+
 static void mntput_no_expire(struct mount *mnt)
 {
+	struct completion undone;
+
 	rcu_read_lock();
 	mnt_add_count(mnt, -1);
 	if (likely(mnt->mnt_ns)) { /* shouldn't be the last one */
@@ -1027,11 +1044,16 @@ static void mntput_no_expire(struct mount *mnt)
 	 * so mnt_get_writers() below is safe.
 	 */
 	WARN_ON(mnt_get_writers(mnt));
-	fsnotify_vfsmount_delete(&mnt->mnt);
-	dput(mnt->mnt.mnt_root);
-	deactivate_super(mnt->mnt.mnt_sb);
-	mnt_free_id(mnt);
-	call_rcu(&mnt->mnt_rcu, delayed_free_vfsmnt);
+	/* The stack may be deep here, cleanup the mount on a work
+	 * queue where the stack is guaranteed to be shallow.
+	 */
+	init_completion(&undone);
+	mnt->mnt_undone = &undone;
+
+	INIT_WORK(&mnt->mnt_cleanup_work, cleanup_mnt_work);
+	schedule_work(&mnt->mnt_cleanup_work);
+
+	wait_for_completion(&undone);
 }
 
 void mntput(struct vfsmount *mnt)
-- 
1.9.1

