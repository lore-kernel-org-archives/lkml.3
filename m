Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792AbaJDAcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:32:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbaJCVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Weston Andros Adamson <dros@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.16 165/357] pnfs: add pnfs_put_lseg_async
Date: Fri,  3 Oct 2014 14:29:11 -0700
Message-Id: <20141003212938.429961993@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Weston Andros Adamson <dros@primarydata.com>

commit e6cf82d1830f5e16a10d566f58db70f297ba5da8 upstream.

This is useful when lsegs need to be released while holding locks.

Signed-off-by: Weston Andros Adamson <dros@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |   17 +++++++++++++++++
 fs/nfs/pnfs.h |    7 +++++++
 2 files changed, 24 insertions(+)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -361,6 +361,23 @@ pnfs_put_lseg(struct pnfs_layout_segment
 }
 EXPORT_SYMBOL_GPL(pnfs_put_lseg);
 
+static void pnfs_put_lseg_async_work(struct work_struct *work)
+{
+	struct pnfs_layout_segment *lseg;
+
+	lseg = container_of(work, struct pnfs_layout_segment, pls_work);
+
+	pnfs_put_lseg(lseg);
+}
+
+void
+pnfs_put_lseg_async(struct pnfs_layout_segment *lseg)
+{
+	INIT_WORK(&lseg->pls_work, pnfs_put_lseg_async_work);
+	schedule_work(&lseg->pls_work);
+}
+EXPORT_SYMBOL_GPL(pnfs_put_lseg_async);
+
 static u64
 end_offset(u64 start, u64 len)
 {
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -32,6 +32,7 @@
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
+#include <linux/workqueue.h>
 
 enum {
 	NFS_LSEG_VALID = 0,	/* cleared when lseg is recalled/returned */
@@ -46,6 +47,7 @@ struct pnfs_layout_segment {
 	atomic_t pls_refcount;
 	unsigned long pls_flags;
 	struct pnfs_layout_hdr *pls_layout;
+	struct work_struct pls_work;
 };
 
 enum pnfs_try_status {
@@ -179,6 +181,7 @@ extern int nfs4_proc_layoutreturn(struct
 /* pnfs.c */
 void pnfs_get_layout_hdr(struct pnfs_layout_hdr *lo);
 void pnfs_put_lseg(struct pnfs_layout_segment *lseg);
+void pnfs_put_lseg_async(struct pnfs_layout_segment *lseg);
 
 void set_pnfs_layoutdriver(struct nfs_server *, const struct nfs_fh *, u32);
 void unset_pnfs_layoutdriver(struct nfs_server *);
@@ -410,6 +413,10 @@ static inline void pnfs_put_lseg(struct
 {
 }
 
+static inline void pnfs_put_lseg_async(struct pnfs_layout_segment *lseg)
+{
+}
+
 static inline int pnfs_return_layout(struct inode *ino)
 {
 	return 0;


