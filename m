Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbaCCTOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:14:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaCCS5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:57:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 63/67] lockd: send correct lock when granting a delayed lock.
Date: Mon,  3 Mar 2014 10:55:51 -0800
Message-Id: <1393872955-28810-64-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 2ec197db1a56c9269d75e965f14c344b58b2a4f6 upstream.

If an NFS client attempts to get a lock (using NLM) and the lock is
not available, the server will remember the request and when the lock
becomes available it will send a GRANT request to the client to
provide the lock.

If the client already held an adjacent lock, the GRANT callback will
report the union of the existing and new locks, which can confuse the
client.

This happens because __posix_lock_file (called by vfs_lock_file)
updates the passed-in file_lock structure when adjacent or
over-lapping locks are found.

To avoid this problem we take a copy of the two fields that can
be changed (fl_start and fl_end) before the call and restore them
afterwards.
An alternate would be to allocate a 'struct file_lock', initialise it,
use locks_copy_lock() to take a copy, then locks_release_private()
after the vfs_lock_file() call.  But that is a lot more work.

Reported-by: Olaf Kirch <okir@suse.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>

--
v1 had a couple of issues (large on-stack struct and didn't really work properly).
This version is much better tested.
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/lockd/svclock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 57a3922..16b30a7 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -767,6 +767,7 @@ nlmsvc_grant_blocked(struct nlm_block *block)
 	struct nlm_file		*file = block->b_file;
 	struct nlm_lock		*lock = &block->b_call->a_args.lock;
 	int			error;
+	loff_t			fl_start, fl_end;
 
 	dprintk("lockd: grant blocked lock %p\n", block);
 
@@ -784,9 +785,16 @@ nlmsvc_grant_blocked(struct nlm_block *block)
 	}
 
 	/* Try the lock operation again */
+	/* vfs_lock_file() can mangle fl_start and fl_end, but we need
+	 * them unchanged for the GRANT_MSG
+	 */
 	lock->fl.fl_flags |= FL_SLEEP;
+	fl_start = lock->fl.fl_start;
+	fl_end = lock->fl.fl_end;
 	error = vfs_lock_file(file->f_file, F_SETLK, &lock->fl, NULL);
 	lock->fl.fl_flags &= ~FL_SLEEP;
+	lock->fl.fl_start = fl_start;
+	lock->fl.fl_end = fl_end;
 
 	switch (error) {
 	case 0:
-- 
1.8.3.2

