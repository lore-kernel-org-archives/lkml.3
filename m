Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbaCDJgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:36:15 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:49316 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbaCDJgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:36:12 -0500
Message-ID: <1393925767.3038.23.camel@x220>
Subject: [PATCH v2] NVMe: silence GCC warning on 32 bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2014 10:36:07 +0100
In-Reply-To: <alpine.LRH.2.03.1402210921010.4656@AMR>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	 <1392934261.15264.22.camel@x220> <alpine.LRH.2.03.1402210921010.4656@AMR>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2014 09:36:11.0159 (UTC) FILETIME=[2D937A70:01CF378D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

These are false positives. Apparently GCC can't determine that bvprv
will only be used if first is false and has, therefore, been
initialized. It turned out hard to reorganize the code to help GCC
understand the flow of this code. So take the easy way out and
initialize bvprv to { NULL }.

And, since we're touching this code, make first a bool.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
v2: redone, as required by Keith's review. Note that initializing bvprv
to { NULL } is already done twice in block/blk-merge.c, which inspired
me to take the easy way out here.

Also note that it's actually not clear to me why these warnings only
trigger on 32 bit. I guess there's some int/long conversion lurking
somewhere. I haven't found it. 

bvprv? Would that mean bio_vec private? But it looks like some temporary
variable, so something like tmp may make more sense. Anyhow, still
compile tested only (on 32 and 64 bit x86).

 drivers/block/nvme-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 51824d1..60f98be 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -495,11 +495,11 @@ static int nvme_split_and_submit(struct bio *bio, struct nvme_queue *nvmeq,
 static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 		struct bio *bio, enum dma_data_direction dma_dir, int psegs)
 {
-	struct bio_vec bvec, bvprv;
+	struct bio_vec bvec, bvprv = { NULL };
 	struct bvec_iter iter;
 	struct scatterlist *sg = NULL;
 	int length = 0, nsegs = 0, split_len = bio->bi_iter.bi_size;
-	int first = 1;
+	bool first = true;
 
 	if (nvmeq->dev->stripe_size)
 		split_len = nvmeq->dev->stripe_size -
@@ -525,7 +525,7 @@ static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 			return nvme_split_and_submit(bio, nvmeq, split_len);
 		length += bvec.bv_len;
 		bvprv = bvec;
-		first = 0;
+		first = false;
 	}
 	iod->nents = nsegs;
 	sg_mark_end(sg);
-- 
1.8.5.3

