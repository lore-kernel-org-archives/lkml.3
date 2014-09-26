Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaIZH36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:29:58 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61045 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaIZH35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:29:57 -0400
From: Omar Sandoval <osandov@osandov.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: fix gfp_t/int coercion
Date: Fri, 26 Sep 2014 00:30:49 -0700
Message-Id: <1411716649-22526-1-git-send-email-osandov@osandov.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few implicit casts between int and gfp_t which were caught by sparse.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
This patch applies to v3.17-rc6.
 drivers/staging/lustre/lustre/llite/lloop.c            | 4 ++--
 drivers/staging/lustre/lustre/ptlrpc/client.c          | 2 +-
 drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 8086638..b0d8de5 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -126,7 +126,7 @@ struct lloop_device {
 	struct block_device *lo_device;
 	unsigned	     lo_blocksize;
 
-	int		  old_gfp_mask;
+	gfp_t		  old_gfp_mask;
 
 	spinlock_t		lo_lock;
 	struct bio		*lo_bio;
@@ -546,7 +546,7 @@ static int loop_clr_fd(struct lloop_device *lo, struct block_device *bdev,
 		       int count)
 {
 	struct file *filp = lo->lo_backing_file;
-	int gfp = lo->old_gfp_mask;
+	gfp_t gfp = lo->old_gfp_mask;
 
 	if (lo->lo_state != LLOOP_BOUND)
 		return -ENXIO;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 4146e8b..c4debbc 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -394,7 +394,7 @@ void ptlrpc_request_cache_fini(void)
 	kmem_cache_destroy(request_cache);
 }
 
-struct ptlrpc_request *ptlrpc_request_cache_alloc(int flags)
+struct ptlrpc_request *ptlrpc_request_cache_alloc(gfp_t flags)
 {
 	struct ptlrpc_request *req;
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h
index f7be007..7fe2e58 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpc_internal.h
@@ -57,7 +57,7 @@ struct ptlrpc_bulk_desc *ptlrpc_new_bulk(unsigned npages, unsigned max_brw,
 					 unsigned type, unsigned portal);
 int ptlrpc_request_cache_init(void);
 void ptlrpc_request_cache_fini(void);
-struct ptlrpc_request *ptlrpc_request_cache_alloc(int flags);
+struct ptlrpc_request *ptlrpc_request_cache_alloc(gfp_t flags);
 void ptlrpc_request_cache_free(struct ptlrpc_request *req);
 void ptlrpc_init_xid(void);
 
-- 
2.1.0

