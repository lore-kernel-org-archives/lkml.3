Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaBJT61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:58:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbaBJTqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Weston Andros Adamson <dros@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 076/124] nfs4: fix discover_server_trunking use after free
Date: Mon, 10 Feb 2014 11:40:16 -0800
Message-Id: <1392061264-28124-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@primarydata.com>

commit abad2fa5ba67725a3f9c376c8cfe76fbe94a3041 upstream.

If clp is new (cl_count = 1) and it matches another client in
nfs4_discover_server_trunking, the nfs_put_client will free clp before
->cl_preserve_clid is set.

Signed-off-by: Weston Andros Adamson <dros@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4client.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index c53189d..08ff307 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -236,13 +236,11 @@ struct nfs_client *nfs4_init_client(struct nfs_client *clp,
 	error = nfs4_discover_server_trunking(clp, &old);
 	if (error < 0)
 		goto error;
-	nfs_put_client(clp);
-	if (clp != old) {
-		clp->cl_preserve_clid = true;
-		clp = old;
-	}
 
-	return clp;
+	if (clp != old)
+		clp->cl_preserve_clid = true;
+	nfs_put_client(clp);
+	return old;
 
 error:
 	nfs_mark_client_ready(clp, error);
-- 
1.8.3.2

