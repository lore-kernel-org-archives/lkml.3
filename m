Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaKLBZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:25:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaKLBZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:25:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.17 123/319] media: vmalloc_sg: off by one in error handling
Date: Wed, 12 Nov 2014 10:14:21 +0900
Message-Id: <20141112011012.955397041@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 23d3090f8b44ab42162e99e8584445bc25b8922f upstream.

The "i--" needs to happen at the start of the loop or it will try to
release something bogus (probably it will crash) and it won't release
the first ->vaddr_page[].

Fixes: 7b4eeed174b7 ('[media] vmalloc_sg: make sure all pages in vmalloc area are really DMA-ready')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/videobuf-dma-sg.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -253,9 +253,11 @@ int videobuf_dma_init_kernel(struct vide
 	return 0;
 out_free_pages:
 	while (i > 0) {
-		void *addr = page_address(dma->vaddr_pages[i]);
-		dma_free_coherent(dma->dev, PAGE_SIZE, addr, dma->dma_addr[i]);
+		void *addr;
+
 		i--;
+		addr = page_address(dma->vaddr_pages[i]);
+		dma_free_coherent(dma->dev, PAGE_SIZE, addr, dma->dma_addr[i]);
 	}
 	kfree(dma->dma_addr);
 	dma->dma_addr = NULL;


