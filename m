Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaBTWLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:11:05 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:62647 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbaBTWLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:11:04 -0500
Message-ID: <1392934261.15264.22.camel@x220>
Subject: [PATCH] NVMe: silence GCC warning on 32 bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Feb 2014 23:11:01 +0100
In-Reply-To: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2014 22:11:02.0153 (UTC) FILETIME=[A427B790:01CF2E88]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 10:02 +0100, Geert Uytterhoeven wrote:
> *** WARNINGS ***
> 
> 188 regressions:
>   [...]
>   + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]:  => 514:18
>   + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]:  => 514:18
>   + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]:  => 511:17

And these popped up in v3.14-rc1 on 32 bit x86. This patch makes these
warnings go away. Compile tested only (on 32 and 64 bit x86).

Review is appreciated, because the code I'm touching here is far from
obvious to me.
-------->8--------
From: Paul Bolle <pebolle@tiscali.nl>

Building nvme-core.o on 32 bit x86 triggers a rather impressive set of
GCC warnings:
    In file included from drivers/block/nvme-core.c:20:0:
    drivers/block/nvme-core.c: In function 'nvme_submit_bio_queue':
    include/linux/bio.h:154:55: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wmaybe-uninitialized]
     #define bvec_to_phys(bv) (page_to_phys((bv)->bv_page) + (unsigned long) (bv)->bv_offset)
                                                           ^
    drivers/block/nvme-core.c:498:23: note: 'bvprv.bv_offset' was declared here
      struct bio_vec bvec, bvprv;
                           ^
    In file included from drivers/block/nvme-core.c:20:0:
    include/linux/bio.h:154:55: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wmaybe-uninitialized]
     #define bvec_to_phys(bv) (page_to_phys((bv)->bv_page) + (unsigned long) (bv)->bv_offset)
                                                           ^
    drivers/block/nvme-core.c:498:23: note: 'bvprv.bv_len' was declared here
      struct bio_vec bvec, bvprv;
                           ^
    In file included from [...]/arch/x86/include/asm/page.h:70:0,
                     from [...]/arch/x86/include/asm/processor.h:17,
                     from [...]/arch/x86/include/asm/atomic.h:6,
                     from include/linux/atomic.h:4,
                     from include/linux/mutex.h:18,
                     from include/linux/kernfs.h:13,
                     from include/linux/sysfs.h:15,
                     from include/linux/kobject.h:21,
                     from include/linux/pci.h:28,
                     from include/linux/nvme.h:23,
                     from drivers/block/nvme-core.c:19:
    include/asm-generic/memory_model.h:31:53: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wmaybe-uninitialized]
     #define __page_to_pfn(page) ((unsigned long)((page) - mem_map) + \
                                                         ^
    drivers/block/nvme-core.c:498:23: note: 'bvprv.bv_page' was declared here
      struct bio_vec bvec, bvprv;
                           ^

These are false positives. A bit of staring at the code reveals that
"struct bio_vec bvprv" and "int first" operate in lockstep: if first is
1 bvprv isn't yet initialized and if first is 0 bvprv will be
initialized. But if we convert bvprv to a pointer and initialize it to
NULL we can do away with first. And it turns out the warning is gone if
we do that. So that appears to be enough to help GCC understand the
flow of this code.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/block/nvme-core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 51824d1..f9fb28b 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -495,11 +495,10 @@ static int nvme_split_and_submit(struct bio *bio, struct nvme_queue *nvmeq,
 static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 		struct bio *bio, enum dma_data_direction dma_dir, int psegs)
 {
-	struct bio_vec bvec, bvprv;
+	struct bio_vec bvec, *bvprv = NULL;
 	struct bvec_iter iter;
 	struct scatterlist *sg = NULL;
 	int length = 0, nsegs = 0, split_len = bio->bi_iter.bi_size;
-	int first = 1;
 
 	if (nvmeq->dev->stripe_size)
 		split_len = nvmeq->dev->stripe_size -
@@ -508,10 +507,10 @@ static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 
 	sg_init_table(iod->sg, psegs);
 	bio_for_each_segment(bvec, bio, iter) {
-		if (!first && BIOVEC_PHYS_MERGEABLE(&bvprv, &bvec)) {
+		if (bvprv && BIOVEC_PHYS_MERGEABLE(bvprv, &bvec)) {
 			sg->length += bvec.bv_len;
 		} else {
-			if (!first && BIOVEC_NOT_VIRT_MERGEABLE(&bvprv, &bvec))
+			if (bvprv && BIOVEC_NOT_VIRT_MERGEABLE(bvprv, &bvec))
 				return nvme_split_and_submit(bio, nvmeq,
 							     length);
 
@@ -524,8 +523,7 @@ static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 		if (split_len - length < bvec.bv_len)
 			return nvme_split_and_submit(bio, nvmeq, split_len);
 		length += bvec.bv_len;
-		bvprv = bvec;
-		first = 0;
+		bvprv = &bvec;
 	}
 	iod->nents = nsegs;
 	sg_mark_end(sg);
-- 
1.8.5.3

