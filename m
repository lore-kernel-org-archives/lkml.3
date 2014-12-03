Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaLCLt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:49:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbaLCL1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 042/101] nfs: fix pnfs direct write memory leak
Date: Wed,  3 Dec 2014 12:26:04 +0100
Message-Id: <d0c8187c16fa9294a2ff8fbbe85c15776ca3fa72.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8c393f9a721c30a030049a680e1bf896669bb279 upstream.

For pNFS direct writes, layout driver may dynamically allocate ds_cinfo.buckets.
So we need to take care to free them when freeing dreq.

Ideally this needs to be done inside layout driver where ds_cinfo.buckets
are allocated. But buckets are attached to dreq and reused across LD IO iterations.
So I feel it's OK to free them in the generic layer.

Signed-off-by: Peng Tao <tao.peng@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/direct.c         |  1 +
 include/linux/nfs_xdr.h | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index af5f3ffcb157..d751a2383c24 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -179,6 +179,7 @@ static void nfs_direct_req_free(struct kref *kref)
 {
 	struct nfs_direct_req *dreq = container_of(kref, struct nfs_direct_req, kref);
 
+	nfs_free_pnfs_ds_cinfo(&dreq->ds_cinfo);
 	if (dreq->l_ctx != NULL)
 		nfs_put_lock_context(dreq->l_ctx);
 	if (dreq->ctx != NULL)
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 2b307018979d..715671e4c7e6 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1223,11 +1223,22 @@ struct nfs41_free_stateid_res {
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
2.1.3

