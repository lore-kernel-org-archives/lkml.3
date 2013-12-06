Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab3LFVxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:53:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab3LFVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 3.12 81/83] aio: clean up aio ring in the fail path
Date: Fri,  6 Dec 2013 13:52:11 -0800
Message-Id: <20131206214647.569365213@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gu Zheng <guz.fnst@cn.fujitsu.com>

commit d1b9432712a25eeb06114fb4b587133525a47de5 upstream.

Clean up the aio ring file in the fail path of aio_setup_ring
and ioctx_alloc. And maybe it can fix the GPF issue reported by
Dave Jones:
https://lkml.org/lkml/2013/11/25/898

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -367,8 +367,10 @@ static int aio_setup_ring(struct kioctx
 	if (nr_pages > AIO_RING_PAGES) {
 		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *),
 					  GFP_KERNEL);
-		if (!ctx->ring_pages)
+		if (!ctx->ring_pages) {
+			put_aio_ring_file(ctx);
 			return -ENOMEM;
+		}
 	}
 
 	ctx->mmap_size = nr_pages * PAGE_SIZE;
@@ -645,7 +647,7 @@ static struct kioctx *ioctx_alloc(unsign
 	    aio_nr + nr_events < aio_nr) {
 		spin_unlock(&aio_nr_lock);
 		err = -EAGAIN;
-		goto err;
+		goto err_ctx;
 	}
 	aio_nr += ctx->max_reqs;
 	spin_unlock(&aio_nr_lock);
@@ -662,6 +664,8 @@ static struct kioctx *ioctx_alloc(unsign
 
 err_cleanup:
 	aio_nr_sub(ctx->max_reqs);
+err_ctx:
+	aio_free_ring(ctx);
 err:
 	free_percpu(ctx->cpu);
 	free_percpu(ctx->reqs.pcpu_count);


