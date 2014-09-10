Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaIJGs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:48:27 -0400
Received: from mail-bn1bon0119.outbound.protection.outlook.com ([157.56.111.119]:16205
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750789AbaIJGs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:48:26 -0400
X-Greylist: delayed 948 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 02:48:25 EDT
From: Fancy Fang <chen.fang@freescale.com>
To: <m.chehab@samsung.com>, <hverkuil@xs4all.nl>, <viro@ZenIV.linux.org.uk>
CC: <shawn.guo@freescale.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Fancy Fang <chen.fang@freescale.com>
Subject: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().
Date: Wed, 10 Sep 2014 13:28:57 +0800
Message-ID: <1410326937-31140-1-git-send-email-chen.fang@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(189002)(199003)(50466002)(77982001)(76482001)(79102001)(229853001)(107046002)(97736003)(62966002)(33646002)(104016003)(106466001)(46102001)(77156001)(90102001)(85306004)(48376002)(230783001)(6806004)(83322001)(19580395003)(19580405001)(44976005)(81542001)(68736004)(47776003)(20776003)(64706001)(81342001)(80022001)(74662001)(74502001)(31966008)(99396002)(50986999)(83072002)(85852003)(92566001)(92726001)(2201001)(4396001)(87936001)(89996001)(88136002)(86362001)(93916002)(21056001)(575784001)(50226001)(102836001)(104166001)(87286001)(26826002)(105606002)(95666004)(84676001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB344;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
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

