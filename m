Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3AMRrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:47:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35141 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755632Ab3AMRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:49 -0500
Message-Id: <20130113174300.443582270@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:17 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 22/49] NFS: Fix access to suid/sgid executables
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@netapp.com>

commit f8d9a897d4384b77f13781ea813156568f68b83e upstream.

nfs_open_permission_mask() should only check MAY_EXEC for files that
are opened with __FMODE_EXEC.

Also fix NFSv4 access-in-open path in a similar way -- openflags must be
used because fmode will not always have FMODE_EXEC set.

This patch fixes https://bugzilla.kernel.org/show_bug.cgi?id=49101

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/dir.c      |   16 ++++++++++------
 fs/nfs/nfs4proc.c |   18 +++++++++++-------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 32e6c53..1b2d7eb 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2153,12 +2153,16 @@ static int nfs_open_permission_mask(int openflags)
 {
 	int mask = 0;
 
-	if ((openflags & O_ACCMODE) != O_WRONLY)
-		mask |= MAY_READ;
-	if ((openflags & O_ACCMODE) != O_RDONLY)
-		mask |= MAY_WRITE;
-	if (openflags & __FMODE_EXEC)
-		mask |= MAY_EXEC;
+	if (openflags & __FMODE_EXEC) {
+		/* ONLY check exec rights */
+		mask = MAY_EXEC;
+	} else {
+		if ((openflags & O_ACCMODE) != O_WRONLY)
+			mask |= MAY_READ;
+		if ((openflags & O_ACCMODE) != O_RDONLY)
+			mask |= MAY_WRITE;
+	}
+
 	return mask;
 }
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5d864fb..cf747ef 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1626,7 +1626,8 @@ static int _nfs4_recover_proc_open(struct nfs4_opendata *data)
 
 static int nfs4_opendata_access(struct rpc_cred *cred,
 				struct nfs4_opendata *opendata,
-				struct nfs4_state *state, fmode_t fmode)
+				struct nfs4_state *state, fmode_t fmode,
+				int openflags)
 {
 	struct nfs_access_entry cache;
 	u32 mask;
@@ -1638,11 +1639,14 @@ static int nfs4_opendata_access(struct rpc_cred *cred,
 
 	mask = 0;
 	/* don't check MAY_WRITE - a newly created file may not have
-	 * write mode bits, but POSIX allows the creating process to write */
-	if (fmode & FMODE_READ)
-		mask |= MAY_READ;
-	if (fmode & FMODE_EXEC)
-		mask |= MAY_EXEC;
+	 * write mode bits, but POSIX allows the creating process to write.
+	 * use openflags to check for exec, because fmode won't
+	 * always have FMODE_EXEC set when file open for exec. */
+	if (openflags & __FMODE_EXEC) {
+		/* ONLY check for exec rights */
+		mask = MAY_EXEC;
+	} else if (fmode & FMODE_READ)
+		mask = MAY_READ;
 
 	cache.cred = cred;
 	cache.jiffies = jiffies;
@@ -1896,7 +1900,7 @@ static int _nfs4_do_open(struct inode *dir,
 	if (server->caps & NFS_CAP_POSIX_LOCK)
 		set_bit(NFS_STATE_POSIX_LOCKS, &state->flags);
 
-	status = nfs4_opendata_access(cred, opendata, state, fmode);
+	status = nfs4_opendata_access(cred, opendata, state, fmode, flags);
 	if (status != 0)
 		goto err_opendata_put;
 


