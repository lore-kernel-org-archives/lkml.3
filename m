Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaKYLD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:03:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58969 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaKYKnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 194/254] nfs: fix pnfs direct write memory leak
Date: Tue, 25 Nov 2014 10:39:04 +0000
Message-Id: <1416912004-5928-195-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Tao <tao.peng@primarydata.com>

commit 8c393f9a721c30a030049a680e1bf896669bb279 upstream.

For pNFS direct writes, layout driver may dynamically allocate ds_cinfo.buckets.
So we need to take care to free them when freeing dreq.

Ideally this needs to be done inside layout driver where ds_cinfo.buckets
are allocated. But buckets are attached to dreq and reused across LD IO iterations.
So I feel it's OK to free them in the generic layer.

Signed-off-by: Peng Tao <tao.peng@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/direct.c         |  1 +
 include/linux/nfs_xdr.h | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 1b34eeb0d8de..73a3023e2702 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -270,6 +270,7 @@ static void nfs_direct_req_free(struct kref *kref)
 {
 	struct nfs_direct_req *dreq = container_of(kref, struct nfs_direct_req, kref);
 
+	nfs_free_pnfs_ds_cinfo(&dreq->ds_cinfo);
 	if (dreq->l_ctx != NULL)
 		nfs_put_lock_context(dreq->l_ctx);
 	if (dreq->ctx != NULL)
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 2c35d524ffc6..a8f111be79a0 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1231,11 +1231,22 @@ struct nfs41_free_stateid_res {
 	unsigned int			status;
 };
 
+static inline void
+nfs_free_pnfs_ds_cinfo(struct pnfs_ds_commit_info *cinfo)
+{
+	kfree(cinfo->buckets);
+}
+
 #else
 
 struct pnfs_ds_commit_info {
 };
 
+static inline void
+nfs_free_pnfs_ds_cinfo(struct pnfs_ds_commit_info *cinfo)
+{
+}
+
 #endif /* CONFIG_NFS_V4_1 */
 
 struct nfs_page;
-- 
2.1.0

