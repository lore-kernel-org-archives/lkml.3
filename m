Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbbAGCAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:00:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbbAGBwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ingo Molnar <mingo@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.18 72/84] mm/CMA: fix boot regression due to physical address of high_memory
Date: Tue,  6 Jan 2015 17:50:15 -0800
Message-Id: <20150107014031.313067529@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit 6b101e2a3ce4d2a0312087598bd1ab4a1db2ac40 upstream.

high_memory isn't direct mapped memory so retrieving it's physical address
isn't appropriate.  But, it would be useful to check physical address of
highmem boundary so it's justfiable to get physical address from it.  In
x86, there is a validation check if CONFIG_DEBUG_VIRTUAL and it triggers
following boot failure reported by Ingo.

  ...
  BUG: Int 6: CR2 00f06f53
  ...
  Call Trace:
    dump_stack+0x41/0x52
    early_idt_handler+0x6b/0x6b
    cma_declare_contiguous+0x33/0x212
    dma_contiguous_reserve_area+0x31/0x4e
    dma_contiguous_reserve+0x11d/0x125
    setup_arch+0x7b5/0xb63
    start_kernel+0xb8/0x3e6
    i386_start_kernel+0x79/0x7d

To fix boot regression, this patch implements workaround to avoid
validation check in x86 when retrieving physical address of high_memory.
__pa_nodebug() used by this patch is implemented only in x86 so there is
no choice but to use dirty #ifdef.

[akpm@linux-foundation.org: tweak comment]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Ingo Molnar <mingo@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/cma.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/cma.c
+++ b/mm/cma.c
@@ -215,9 +215,21 @@ int __init cma_declare_contiguous(phys_a
 			bool fixed, struct cma **res_cma)
 {
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
-	phys_addr_t highmem_start = __pa(high_memory);
+	phys_addr_t highmem_start;
 	int ret = 0;
 
+#ifdef CONFIG_X86
+	/*
+	 * high_memory isn't direct mapped memory so retrieving its physical
+	 * address isn't appropriate.  But it would be useful to check the
+	 * physical address of the highmem boundary so it's justfiable to get
+	 * the physical address from it.  On x86 there is a validation check for
+	 * this case, so the following workaround is needed to avoid it.
+	 */
+	highmem_start = __pa_nodebug(high_memory);
+#else
+	highmem_start = __pa(high_memory);
+#endif
 	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
 		__func__, &size, &base, &limit, &alignment);
 


