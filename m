Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbaKSVE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:04:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457AbaKSVEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 048/122] nfs: fix pnfs direct write memory leak
Date: Wed, 19 Nov 2014 12:51:38 -0800
Message-Id: <20141119205210.408328242@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/direct.c         |    1 +
 include/linux/nfs_xdr.h |   11 +++++++++++
 2 files changed, 12 insertions(+)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -178,6 +178,7 @@ static void nfs_direct_req_free(struct k
 {
 	struct nfs_direct_req *dreq = container_of(kref, struct nfs_direct_req, kref);
 
+	nfs_free_pnfs_ds_cinfo(&dreq->ds_cinfo);
 	if (dreq->l_ctx != NULL)
 		nfs_put_lock_context(dreq->l_ctx);
 	if (dreq->ctx != NULL)
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1247,11 +1247,22 @@ struct nfs41_free_stateid_res {
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


