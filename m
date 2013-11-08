Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab3KHCS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:18:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34598 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3KHCQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ming Lei <ming.lei@canonical.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 90/91] lib/scatterlist.c: don't flush_kernel_dcache_page on slab page
Date: Thu,  7 Nov 2013 18:15:45 -0800
Message-Id: <1383876946-2396-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit 3d77b50c5874b7e923be946ba793644f82336b75 upstream.

Commit b1adaf65ba03 ("[SCSI] block: add sg buffer copy helper
functions") introduces two sg buffer copy helpers, and calls
flush_kernel_dcache_page() on pages in SG list after these pages are
written to.

Unfortunately, the commit may introduce a potential bug:

 - Before sending some SCSI commands, kmalloc() buffer may be passed to
   block layper, so flush_kernel_dcache_page() can see a slab page
   finally

 - According to cachetlb.txt, flush_kernel_dcache_page() is only called
   on "a user page", which surely can't be a slab page.

 - ARCH's implementation of flush_kernel_dcache_page() may use page
   mapping information to do optimization so page_mapping() will see the
   slab page, then VM_BUG_ON() is triggered.

Aaro Koskinen reported the bug on ARM/kirkwood when DEBUG_VM is enabled,
and this patch fixes the bug by adding test of '!PageSlab(miter->page)'
before calling flush_kernel_dcache_page().

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Simon Baatz <gmbnomis@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 lib/scatterlist.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 7874b01..bd86887 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -495,7 +495,8 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 	if (miter->addr) {
 		miter->__offset += miter->consumed;
 
-		if (miter->__flags & SG_MITER_TO_SG)
+		if ((miter->__flags & SG_MITER_TO_SG) &&
+		    !PageSlab(miter->page))
 			flush_kernel_dcache_page(miter->page);
 
 		if (miter->__flags & SG_MITER_ATOMIC) {
-- 
1.8.1.2

