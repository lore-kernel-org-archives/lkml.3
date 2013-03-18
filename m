Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3CREak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:30:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33378 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228Ab3CREaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:04 -0400
Message-Id: <20130318042144.636886230@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:48 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: [ 04/82] NFS: Dont allow NFS silly-renamed files to be deleted, no signal
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 5a7a613a47a715711b3f2d3322a0eac21d459166 upstream.

Commit 73ca100 broke the code that prevents the client from deleting
a silly renamed dentry.  This affected "delete on last close"
semantics as after that commit, nothing prevented removal of
silly-renamed files.  As a result, a process holding a file open
could easily get an ESTALE on the file in a directory where some
other process issued 'rm -rf some_dir_containing_the_file' twice.
Before the commit, any attempt at unlinking silly renamed files would
fail inside may_delete() with -EBUSY because of the
DCACHE_NFSFS_RENAMED flag.  The following testcase demonstrates
the problem:
  tail -f /nfsmnt/dir/file &
  rm -rf /nfsmnt/dir
  rm -rf /nfsmnt/dir
  # second removal does not fail, 'tail' process receives ESTALE

The problem with the above commit is that it unhashes the old and
new dentries from the lookup path, even in the normal case when
a signal is not encountered and it would have been safe to call
d_move.  Unfortunately the old dentry has the special
DCACHE_NFSFS_RENAMED flag set on it.  Unhashing has the
side-effect that future lookups call d_alloc(), allocating a new
dentry without the special flag for any silly-renamed files.  As a
result, subsequent calls to unlink silly renamed files do not fail
but allow the removal to go through.  This will result in ESTALE
errors for any other process doing operations on the file.

To fix this, go back to using d_move on success.
For the signal case, it's unclear what we may safely do beyond d_drop.

Reported-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/unlink.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -366,20 +366,14 @@ static void nfs_async_rename_done(struct
 	struct inode *old_dir = data->old_dir;
 	struct inode *new_dir = data->new_dir;
 	struct dentry *old_dentry = data->old_dentry;
-	struct dentry *new_dentry = data->new_dentry;
 
 	if (!NFS_PROTO(old_dir)->rename_done(task, old_dir, new_dir)) {
 		rpc_restart_call_prepare(task);
 		return;
 	}
 
-	if (task->tk_status != 0) {
+	if (task->tk_status != 0)
 		nfs_cancel_async_unlink(old_dentry);
-		return;
-	}
-
-	d_drop(old_dentry);
-	d_drop(new_dentry);
 }
 
 /**
@@ -589,6 +583,18 @@ nfs_sillyrename(struct inode *dir, struc
 	error = rpc_wait_for_completion_task(task);
 	if (error == 0)
 		error = task->tk_status;
+	switch (error) {
+	case 0:
+		/* The rename succeeded */
+		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
+		d_move(dentry, sdentry);
+		break;
+	case -ERESTARTSYS:
+		/* The result of the rename is unknown. Play it safe by
+		 * forcing a new lookup */
+		d_drop(dentry);
+		d_drop(sdentry);
+	}
 	rpc_put_task(task);
 out_dput:
 	dput(sdentry);


