Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaIBJ0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:26:34 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:49061
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751503AbaIBJ0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:26:32 -0400
From: Fancy Fang <chen.fang@freescale.com>
To: <m.chehab@samsung.com>, <hverkuil@xs4all.nl>, <viro@ZenIV.linux.org.uk>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Fancy Fang <chen.fang@freescale.com>
Subject: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().
Date: Tue, 2 Sep 2014 16:23:16 +0800
Message-ID: <1409646196-29506-1-git-send-email-chen.fang@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(74502001)(84676001)(89996001)(76482001)(31966008)(74662001)(575784001)(230783001)(83072002)(21056001)(26826002)(87936001)(105606002)(69596002)(107046002)(102836001)(97736001)(99396002)(19580395003)(83322001)(19580405001)(104166001)(79102001)(77982001)(62966002)(68736004)(92566001)(50986999)(2201001)(93916002)(85852003)(88136002)(92726001)(6806004)(86362001)(47776003)(64706001)(81156004)(20776003)(80022001)(46102001)(77156001)(90102001)(44976005)(95666004)(50466002)(33646002)(229853001)(106466001)(36756003)(81542001)(48376002)(85306004)(50226001)(87286001)(4396001)(104016003)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB559;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0322B4EDE1
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
---
 drivers/media/v4l2-core/videobuf-dma-contig.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index bf80f0f..8bd9889 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -305,7 +305,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	/* Try to remap memory */
 	size = vma->vm_end - vma->vm_start;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	retval = vm_iomap_memory(vma, mem->dma_handle, size);
+	retval = remap_pfn_range(vma, vma->vm_start,
+				 mem->dma_handle >> PAGE_SHIFT,
+				 size, vma->vm_page_prot);
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ",
 			retval);
-- 
1.9.1

