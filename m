Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbbAGB4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:56:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535AbbAGBwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.10 10/38] nfs41: fix nfs4_proc_layoutget error handling
Date: Tue,  6 Jan 2015 17:50:22 -0800
Message-Id: <20150107014954.153111132@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014952.440109372@linuxfoundation.org>
References: <20150107014952.440109372@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Tao <tao.peng@primarydata.com>

commit 4bd5a980de87d2b5af417485bde97b8eb3d6cf6a upstream.

nfs4_layoutget_release() drops layout hdr refcnt. Grab the refcnt
early so that it is safe to call .release in case nfs4_alloc_pages
fails.

Signed-off-by: Peng Tao <tao.peng@primarydata.com>
Fixes: a47970ff78147 ("NFSv4.1: Hold reference to layout hdr in layoutget")
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6418,6 +6418,9 @@ nfs4_proc_layoutget(struct nfs4_layoutge
 
 	dprintk("--> %s\n", __func__);
 
+	/* nfs4_layoutget_release calls pnfs_put_layout_hdr */
+	pnfs_get_layout_hdr(NFS_I(inode)->layout);
+
 	lgp->args.layout.pages = nfs4_alloc_pages(max_pages, gfp_flags);
 	if (!lgp->args.layout.pages) {
 		nfs4_layoutget_release(lgp);
@@ -6430,9 +6433,6 @@ nfs4_proc_layoutget(struct nfs4_layoutge
 	lgp->res.seq_res.sr_slot = NULL;
 	nfs41_init_sequence(&lgp->args.seq_args, &lgp->res.seq_res, 0);
 
-	/* nfs4_layoutget_release calls pnfs_put_layout_hdr */
-	pnfs_get_layout_hdr(NFS_I(inode)->layout);
-
 	task = rpc_run_task(&task_setup_data);
 	if (IS_ERR(task))
 		return ERR_CAST(task);


