Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaDHRiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:38:10 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:38633 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932117AbaDHRiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:38:08 -0400
Date: Tue, 8 Apr 2014 18:37:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 patches for 3.15
Message-ID: <20140408173711.GA1588@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 196adf2f3015eacac0567278ba538e3ffdd16d0e:

  arm64: Remove pgprot_dmacoherent() (2014-03-24 10:35:35 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-upstream

for you to fetch changes up to ebf81a938dade3b450eb11c57fa744cfac4b523f:

  arm64: Fix DMA range invalidation for cache line unaligned buffers (2014-04-08 11:45:08 +0100)

A second pull request for this merging window, mainly with fixes and
docs clarification. As I haven't rebased my tree, you'll get a conflict
with latest mainline in arch/arm64/kernel/head.S. The fix-up is below.
Thanks.

diff --cc arch/arm64/kernel/head.S
index 1fe5d8d2bdfd,26109682d2fa..0fd565000772
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@@ -461,12 -476,26 +476,23 @@@ __create_page_tables
  	sub	x6, x6, #1			// inclusive range
  	create_block_map x0, x7, x3, x5, x6
  1:
 -#ifdef CONFIG_EARLY_PRINTK
  	/*
 -	 * Create the pgd entry for the UART mapping. The full mapping is done
 -	 * later based earlyprintk kernel parameter.
 +	 * Create the pgd entry for the fixed mappings.
  	 */
 -	ldr	x5, =EARLYCON_IOBASE		// UART virtual address
 +	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
  	add	x0, x26, #2 * PAGE_SIZE		// section table address
  	create_pgd_entry x26, x0, x5, x6, x7
 -#endif
+ 
+ 	/*
+ 	 * Since the page tables have been populated with non-cacheable
+ 	 * accesses (MMU disabled), invalidate the idmap and swapper page
+ 	 * tables again to remove any speculatively loaded cache lines.
+ 	 */
+ 	mov	x0, x25
+ 	add	x1, x26, #SWAPPER_DIR_SIZE
+ 	bl	__inval_cache_range
+ 
+ 	mov	lr, x27
  	ret
  ENDPROC(__create_page_tables)
  	.ltorg

----------------------------------------------------------------
- Documentation clarification on CPU topology and booting requirements
- Additional cache flushing during boot (needed in the presence of
  external caches or under virtualisation)
- DMA range invalidation fix for non cache line aligned buffers
- Build failure fix with !COMPAT
- Kconfig update for STRICT_DEVMEM

----------------------------------------------------------------
Catalin Marinas (4):
      arm64: Update the TCR_EL1 translation granule definitions for 16K pages
      arm64: Relax the kernel cache requirements for boot
      Revert "arm64: virt: ensure visibility of __boot_cpu_mode"
      arm64: Fix DMA range invalidation for cache line unaligned buffers

Laura Abbott (1):
      arm64: Add missing Kconfig for CONFIG_STRICT_DEVMEM

Mark Brown (1):
      ARM: topology: Make it clear that all CPUs need to be described

Mark Salter (1):
      arm64: fix !CONFIG_COMPAT build failures

 Documentation/arm64/booting.txt                    | 10 ++++++--
 Documentation/devicetree/bindings/arm/topology.txt |  7 ++---
 arch/arm64/Kconfig.debug                           | 14 ++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h             |  6 ++++-
 arch/arm64/include/asm/virt.h                      | 13 ----------
 arch/arm64/kernel/head.S                           | 30 ++++++++++++++++++++--
 arch/arm64/kernel/perf_event.c                     |  4 +++
 arch/arm64/kernel/perf_regs.c                      |  2 ++
 arch/arm64/mm/cache.S                              | 24 ++++++++++++++---
 arch/arm64/mm/proc.S                               | 25 ++++++++++--------
 10 files changed, 99 insertions(+), 36 deletions(-)

-- 
Catalin
