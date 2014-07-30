Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaG3OBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:01:12 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaG3OBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:01:10 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, paulmck@linux.vnet.ibm.com,
        jeffm@suse.com, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@sigma-star.at>
Subject: [PATCH] vfs: Fix RCU usage in __propagate_umount()
Date: Wed, 30 Jul 2014 15:59:16 +0200
Message-Id: <1406728756-32443-1-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we use the plain list_empty() we might not see the
hlist_del_init_rcu() and therefore miss one member of the
list.

It fixes the following issue:
$ unshare -m /usr/bin/sleep 10000 &
$ mkdir -p foo/proc
$ mount -t proc none foo/proc
$ mount -t binfmt_misc none foo/proc/sys/fs/binfmt_misc
$ umount -l foo/proc
$ rmdir foo/proc
rmdir: failed to remove ‘foo/proc’: Device or resource busy

rmdir fails because the last entry in the RCU list, "proc", was
not propagated as list_empty() still returned false instead of true.

Signed-off-by: Richard Weinberger <richard@sigma-star.at>
---
Hi!

Please review this patch with care, the comments in rculist.h
confused me like hell:

First it says:
/*
 * Why is there no list_empty_rcu()?  Because list_empty() serves this
 * purpose.  The list_empty() function fetches the RCU-protected pointer
 * and compares it to the address of the list head, but neither dereferences
 * this pointer itself nor provides this pointer to the caller.  Therefore,
 * it is not necessary to use rcu_dereference(), so that list_empty() can
 * be used anywhere you would want to use a list_empty_rcu().
 */

And later:
/**
 * Where are list_empty_rcu() and list_first_entry_rcu()?
 *
 * Implementing those functions following their counterparts list_empty() and
 * list_first_entry() is not advisable because they lead to subtle race
 * conditions as the following snippet shows:
 *
 * if (!list_empty_rcu(mylist)) {
 *      struct foo *bar = list_first_entry_rcu(mylist, struct foo, list_member);
 *      do_something(bar);
 * }
 *
 * The list may not be empty when list_empty_rcu checks it, but it may be when
 * list_first_entry_rcu rereads the ->next pointer.
 *
 * Rereading the ->next pointer is not a problem for list_empty() and
 * list_first_entry() because they would be protected by a lock that blocks
 * writers.
 *
 * See list_first_or_null_rcu for an alternative.
 */

To my understanding we cannot use list_empty() and have to use list_first_or_null_rcu(),
or am I missing something?

Thanks,
//richard

 fs/pnode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/pnode.c b/fs/pnode.c
index 302bf22..883901c 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -380,7 +380,8 @@ static void __propagate_umount(struct mount *mnt)
 		 * umount the child only if the child has no
 		 * other children
 		 */
-		if (child && list_empty(&child->mnt_mounts)) {
+		if (child && list_first_or_null_rcu(&child->mnt_mounts,
+						    struct mount, mnt_mounts)) {
 			hlist_del_init_rcu(&child->mnt_hash);
 			hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
 		}
-- 
1.8.4.5

