Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3KYOGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:06:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59037 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754619Ab3KYNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Will Deacon" <will.deacon@arm.com>,
        "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Simon Baatz" <gmbnomis@gmail.com>,
        "Ming Lei" <ming.lei@canonical.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "Aaro Koskinen" <aaro.koskinen@iki.fi>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Tejun Heo" <tj@kernel.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.245392394@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 87/87] lib/scatterlist.c: don't flush_kernel_dcache_page
 on slab page
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 lib/scatterlist.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -419,7 +419,8 @@ void sg_miter_stop(struct sg_mapping_ite
 	if (miter->addr) {
 		miter->__offset += miter->consumed;
 
-		if (miter->__flags & SG_MITER_TO_SG)
+		if ((miter->__flags & SG_MITER_TO_SG) &&
+		    !PageSlab(miter->page))
 			flush_kernel_dcache_page(miter->page);
 
 		if (miter->__flags & SG_MITER_ATOMIC) {

