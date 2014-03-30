Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaCaABa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:01:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753709AbaC3XnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "NeilBrown" <neilb@suse.de>,
        "J. Bruce Fields" <bfields@redhat.com>, "Olaf Kirch" <okir@suse.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.55555950@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 112/200] lockd: send correct lock when granting a
 delayed lock.
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/lockd/svclock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -741,6 +741,7 @@ nlmsvc_grant_blocked(struct nlm_block *b
 	struct nlm_file		*file = block->b_file;
 	struct nlm_lock		*lock = &block->b_call->a_args.lock;
 	int			error;
+	loff_t			fl_start, fl_end;
 
 	dprintk("lockd: grant blocked lock %p\n", block);
 
@@ -758,9 +759,16 @@ nlmsvc_grant_blocked(struct nlm_block *b
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

