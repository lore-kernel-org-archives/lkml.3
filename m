Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3JRRgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:36:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17913 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab3JRRgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:36:02 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-ba-52617180aaf4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, dave.jiang@intel.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        Dan Williams <djbw@fb.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 01/13] dmatest: make driver unmap also source buffers by
 itself
Date: Fri, 18 Oct 2013 19:35:21 +0200
Message-id: <1382117733-16720-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAd2GwsQgg1s9Gha9TdOZLDbOWM9q
	MX3qBUaLEzcb2Sw29z9gszjb9Ibd4vKuOWwWty/zWqyf8ZrF4mXffhYHLo+W5h42j4nN79g9
	Fu95yeQx72SgR9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGV8OfWMraCXt+LzxOuMDYzPuLoY
	OTkkBEwkfv1bzgxhi0lcuLeerYuRi0NIYBGjxNGpjxghnC4miY+LLoBVsQlYSUxsX8UIYosI
	yEhs+L+dGaSIWaCFSaL/22F2kISwQIjE9hNXwGwWAVWJ2btmsoDYvAIeElM2rmaCWCcv8fR+
	HxuIzSngKTFt33IwWwio5tyZl2wTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO
	vmdSOxhXNlgcYhTgYFTi4X1glxgkxJpYVlyZe4hRgoNZSYS3zBkoxJuSWFmVWpQfX1Sak1p8
	iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgXF/03X+5Teq52+U2z6B+cgc/1cRaV7N
	D6v+v8q+ynJ9vtP6jfslI9I2v558nUWq+cOfrbMWXOjcXb+gY4HHRf54NXP97T6b8h9wvI+I
	Mtkjc60tSTkq/+8Mu0ybJRf235j08dXxvBL9v4JbjDQ8EmrfmEvek9u3JCzgWJnj0qwz0Z6B
	L/Jc955SYinOSDTUYi4qTgQAZadk0ToCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the driver DMA unmap also source buffers by itself
(currently it DMA unmaps only destination buffers) as
a preparation for introducing generic 'ummap' data.

Cc: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/dmatest.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 92f796c..f4a2a25 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -597,11 +597,10 @@ static int dmatest_func(void *data)
 	set_user_nice(current, 10);
 
 	/*
-	 * src buffers are freed by the DMAEngine code with dma_unmap_single()
-	 * dst buffers are freed by ourselves below
+	 * src and dst buffers are freed by ourselves below
 	 */
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT
-	      | DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SRC_UNMAP_SINGLE;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
+		DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
 
 	while (!kthread_should_stop()
 	       && !(params->iterations && total_tests >= params->iterations)) {
@@ -750,7 +749,8 @@ static int dmatest_func(void *data)
 			continue;
 		}
 
-		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
+		/* Unmap by myself */
+		unmap_src(dev->dev, dma_srcs, len, src_cnt);
 		unmap_dst(dev->dev, dma_dsts, params->buf_size, dst_cnt);
 
 		error_count = 0;
-- 
1.8.2.3

