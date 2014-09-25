Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaIYDMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:12:01 -0400
Received: from mail-bn1bon0118.outbound.protection.outlook.com ([157.56.111.118]:17591
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751281AbaIYDL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:11:59 -0400
From: Fancy Fang <chen.fang@freescale.com>
To: <m.szyprowski@samsung.com>, <hverkuil@xs4all.nl>, <m.chehab@samsung.com>
CC: <shawn.guo@freescale.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] [media] videobuf-dma-contig: set vm_pgoff to be zero to pass the sanity check in vm_iomap_memory().
Date: Thu, 25 Sep 2014 10:07:13 +0800
Message-ID: <1411610833-22590-1-git-send-email-chen.fang@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(4396001)(48376002)(31966008)(89996001)(102836001)(83322001)(95666004)(62966002)(88136002)(85306004)(50986999)(105606002)(87936001)(84676001)(50226001)(99396003)(50466002)(21056001)(106466001)(120916001)(19580395003)(19580405001)(87286001)(76482002)(97736003)(85852003)(36756003)(10300001)(6806004)(107046002)(92566001)(93916002)(64706001)(2201001)(575784001)(86362001)(104166001)(77156001)(92726001)(47776003)(20776003)(80022003)(90102001)(81542003)(74502003)(81342003)(68736004)(44976005)(74662003)(83072002)(230783001)(79102003)(229853001)(33646002)(77982003)(46102003)(104016003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB337;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB337;
X-Forefront-PRVS: 0345CFD558
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
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

