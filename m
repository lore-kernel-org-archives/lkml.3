Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab3AMRpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:45:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35136 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755628Ab3AMRps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:48 -0500
Message-Id: <20130113174300.004370485@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 20/49] NFSv4: dont check MAY_WRITE access bit in OPEN
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

commit bbd3a8eee82a2a6f4aa1cce60ccb014f25e5c560 upstream.

Don't check MAY_WRITE as a newly created file may not have write mode bits,
but POSIX allows the creating process to write regardless.
This is ok because NFSv4 OPEN ops handle write permissions correctly -
the ACCESS in the OPEN compound is to differentiate READ v EXEC permissions.

Fixes a regression due to commit 6168f62c (NFSv4: Add ACCESS operation to
OPEN compound)

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 1e0faf9..ccada68 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1661,10 +1661,10 @@ static int nfs4_opendata_access(struct rpc_cred *cred,
 		return 0;
 
 	mask = 0;
+	/* don't check MAY_WRITE - a newly created file may not have
+	 * write mode bits, but POSIX allows the creating process to write */
 	if (fmode & FMODE_READ)
 		mask |= MAY_READ;
-	if (fmode & FMODE_WRITE)
-		mask |= MAY_WRITE;
 	if (fmode & FMODE_EXEC)
 		mask |= MAY_EXEC;
 
@@ -1673,7 +1673,7 @@ static int nfs4_opendata_access(struct rpc_cred *cred,
 	nfs_access_set_mask(&cache, opendata->o_res.access_result);
 	nfs_access_add_cache(state->inode, &cache);
 
-	if ((mask & ~cache.mask & (MAY_READ | MAY_WRITE | MAY_EXEC)) == 0)
+	if ((mask & ~cache.mask & (MAY_READ | MAY_EXEC)) == 0)
 		return 0;
 
 	/* even though OPEN succeeded, access is denied. Close the file */


