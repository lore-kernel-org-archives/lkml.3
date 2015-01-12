Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbbALS2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:28:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57507 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbALSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 048/216] nfs41: fix nfs4_proc_layoutget error handling
Date: Mon, 12 Jan 2015 18:02:45 +0000
Message-Id: <1421085933-32536-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Tao <tao.peng@primarydata.com>

commit 4bd5a980de87d2b5af417485bde97b8eb3d6cf6a upstream.

nfs4_layoutget_release() drops layout hdr refcnt. Grab the refcnt
early so that it is safe to call .release in case nfs4_alloc_pages
fails.

Signed-off-by: Peng Tao <tao.peng@primarydata.com>
Fixes: a47970ff78147 ("NFSv4.1: Hold reference to layout hdr in layoutget")
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 2768d382a4d1..c401b4de6b01 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7581,6 +7581,9 @@ nfs4_proc_layoutget(struct nfs4_layoutget *lgp, gfp_t gfp_flags)
 
 	dprintk("--> %s\n", __func__);
 
+	/* nfs4_layoutget_release calls pnfs_put_layout_hdr */
+	pnfs_get_layout_hdr(NFS_I(inode)->layout);
+
 	lgp->args.layout.pages = nfs4_alloc_pages(max_pages, gfp_flags);
 	if (!lgp->args.layout.pages) {
 		nfs4_layoutget_release(lgp);
@@ -7593,9 +7596,6 @@ nfs4_proc_layoutget(struct nfs4_layoutget *lgp, gfp_t gfp_flags)
 	lgp->res.seq_res.sr_slot = NULL;
 	nfs4_init_sequence(&lgp->args.seq_args, &lgp->res.seq_res, 0);
 
-	/* nfs4_layoutget_release calls pnfs_put_layout_hdr */
-	pnfs_get_layout_hdr(NFS_I(inode)->layout);
-
 	task = rpc_run_task(&task_setup_data);
 	if (IS_ERR(task))
 		return ERR_CAST(task);
-- 
2.1.4

