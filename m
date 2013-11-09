Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab3KIGzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:55:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab3KIGxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:53:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Simon Baatz <gmbnomis@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.11 65/94] lib/scatterlist.c: dont flush_kernel_dcache_page on slab page
Date: Fri,  8 Nov 2013 22:52:11 -0800
Message-Id: <20131109065208.874792878@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/scatterlist.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -577,7 +577,8 @@ void sg_miter_stop(struct sg_mapping_ite
 		miter->__offset += miter->consumed;
 		miter->__remaining -= miter->consumed;
 
-		if (miter->__flags & SG_MITER_TO_SG)
+		if ((miter->__flags & SG_MITER_TO_SG) &&
+		    !PageSlab(miter->page))
 			flush_kernel_dcache_page(miter->page);
 
 		if (miter->__flags & SG_MITER_ATOMIC) {


