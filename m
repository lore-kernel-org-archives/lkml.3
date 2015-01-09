Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbbAIKxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:53:18 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44524 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757402AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 44/78] nfs41: fix nfs4_proc_layoutget error handling
Date: Fri,  9 Jan 2015 11:31:53 +0100
Message-Id: <ebccfce81acf2c023ae5adeddd7612ef2351c421.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4bd5a980de87d2b5af417485bde97b8eb3d6cf6a upstream.

nfs4_layoutget_release() drops layout hdr refcnt. Grab the refcnt
early so that it is safe to call .release in case nfs4_alloc_pages
fails.

Signed-off-by: Peng Tao <tao.peng@primarydata.com>
Fixes: a47970ff78147 ("NFSv4.1: Hold reference to layout hdr in layoutget")
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/nfs4proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 759875038791..43c27110387a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7238,6 +7238,9 @@ nfs4_proc_layoutget(struct nfs4_layoutget *lgp, gfp_t gfp_flags)
 
 	dprintk("--> %s\n", __func__);
 
+	/* nfs4_layoutget_release calls pnfs_put_layout_hdr */
+	pnfs_get_layout_hdr(NFS_I(inode)->layout);
+
 	lgp->args.layout.pages = nfs4_alloc_pages(max_pages, gfp_flags);
 	if (!lgp->args.layout.pages) {
 		nfs4_layoutget_release(lgp);
@@ -7250,9 +7253,6 @@ nfs4_proc_layoutget(struct nfs4_layoutget *lgp, gfp_t gfp_flags)
 	lgp->res.seq_res.sr_slot = NULL;
 	nfs4_init_sequence(&lgp->args.seq_args, &lgp->res.seq_res, 0);
 
-	/* nfs4_layoutget_release calls pnfs_put_layout_hdr */
-	pnfs_get_layout_hdr(NFS_I(inode)->layout);
-
 	task = rpc_run_task(&task_setup_data);
 	if (IS_ERR(task))
 		return ERR_CAST(task);
-- 
2.2.1

