Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaBUMvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:51:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47271 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618AbaBUMvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 107/121] lockd: send correct lock when granting a delayed lock.
Date: Fri, 21 Feb 2014 12:48:51 +0000
Message-Id: <1392986945-9693-108-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/lockd/svclock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index e066a39..ab798a8 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -779,6 +779,7 @@ nlmsvc_grant_blocked(struct nlm_block *block)
 	struct nlm_file		*file = block->b_file;
 	struct nlm_lock		*lock = &block->b_call->a_args.lock;
 	int			error;
+	loff_t			fl_start, fl_end;
 
 	dprintk("lockd: grant blocked lock %p\n", block);
 
@@ -796,9 +797,16 @@ nlmsvc_grant_blocked(struct nlm_block *block)
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
1.9.0

