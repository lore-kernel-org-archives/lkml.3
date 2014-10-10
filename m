Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaJJD0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 23:26:20 -0400
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:19584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751128AbaJJD0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 23:26:17 -0400
From: Fancy Fang <chen.fang@freescale.com>
To: <m.szyprowski@samsung.com>, <hverkuil@xs4all.nl>, <m.chehab@samsung.com>
CC: <shawn.guo@freescale.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] [media] videobuf-dma-contig: set vm_pgoff to be zero to pass the sanity check in vm_iomap_memory().
Date: Fri, 10 Oct 2014 10:21:22 +0800
Message-ID: <1412907682-26086-1-git-send-email-chen.fang@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(104166001)(92566001)(92726001)(2201001)(80022003)(46102003)(97736003)(104016003)(64706001)(4396001)(50226001)(102836001)(87286001)(85852003)(88136002)(87936001)(89996001)(50466002)(48376002)(93916002)(86362001)(575784001)(77156001)(26826002)(36756003)(31966008)(20776003)(47776003)(33646002)(50986999)(95666004)(120916001)(21056001)(62966002)(230783001)(99396003)(84676001)(19580405001)(19580395003)(44976005)(6806004)(69596002)(68736004)(105606002)(229853001)(107046002)(106466001)(81156004)(76482002)(85306004);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB337;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB337;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03607C04F0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=chen.fang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When user requests V4L2_MEMORY_MMAP type buffers, the videobuf-core
will assign the corresponding offset to the 'boff' field of the
videobuf_buffer for each requested buffer sequentially. Later, user
may call mmap() to map one or all of the buffers with the 'offset'
parameter which is equal to its 'boff' value. Obviously, the 'offset'
value is only used to find the matched buffer instead of to be the
real offset from the buffer's physical start address as used by
vm_iomap_memory(). So, in some case that if the offset is not zero,
vm_iomap_memory() will fail.

Signed-off-by: Fancy Fang <chen.fang@freescale.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/v4l2-core/videobuf-dma-contig.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index bf80f0f..e02353e 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -305,6 +305,15 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	/* Try to remap memory */
 	size = vma->vm_end - vma->vm_start;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	/* the "vm_pgoff" is just used in v4l2 to find the
+	 * corresponding buffer data structure which is allocated
+	 * earlier and it does not mean the offset from the physical
+	 * buffer start address as usual. So set it to 0 to pass
+	 * the sanity check in vm_iomap_memory().
+	 */
+	vma->vm_pgoff = 0;
+
 	retval = vm_iomap_memory(vma, mem->dma_handle, size);
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ",
-- 
1.9.1

