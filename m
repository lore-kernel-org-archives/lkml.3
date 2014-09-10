Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaIJQ2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:28:46 -0400
Received: from numascale.com ([213.162.240.84]:58671 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaIJQ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:28:45 -0400
X-Greylist: delayed 2645 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 12:28:44 EDT
Message-ID: <541071DB.3010704@numascale.com>
Date: Wed, 10 Sep 2014 23:44:27 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Dave Hansen <dave.hansen@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>
Subject: 3.14 x86 ACPI handover regression
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernels 3.14 and newer fail ACPI handover [1] on Supermicro H8QGL 
servers, invariant of BIOS version or settings, causing boot failure, 
confirmed across a bunch of servers.

Doing some bisect-fu, it turns out that reverting Yinghai's patch fixes 
the behaviour. Booting with Santosh's patch (5b6e529521d3, which Yinghai 
reverts) succeeds, but interestingly booting with the patch before 
Santosh's patch also succeeds, suggesting there's other interaction. 
Behaviour is stable at all places tested.

Any tips on how to proceed?

Thanks,
   Daniel

-- [1]

ACPI Error: Hardware did not enter ACPI mode (20131218/evxfevnt-113)
ACPI Warning: AcpiEnable failed (20131218/utxfinit-169)
ACPI: Unable to enable ACPI

-- [2]

commit 4ce7a8697cb795fda6bdf082c14743b4bcd551c3
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Mon Jan 27 17:06:50 2014 -0800

     x86: revert wrong memblock current limit setting

     Dave reported big numa system booting is broken.

     It turns out that commit 5b6e529521d3 ("x86: memblock: set current 
limit
     to max low memory address") sets the limit to low wrongly.

     max_low_pfn_mapped is different from max_pfn_mapped.
     max_low_pfn_mapped is always under 4G.

     That will memblock_alloc_nid all go under 4G.

     Revert 5b6e529521d3 to fix a no-boot regression which was triggered by
     457ff1de2d24 ("lib/swiotlb.c: use memblock apis for early memory
     allocations").

     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
     Reported-by: Dave Hansen <dave.hansen@intel.com>
     Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
     Cc: Russell King <linux@arm.linux.org.uk>
     Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
     Cc: Ingo Molnar <mingo@elte.hu>
     Cc: "H. Peter Anvin" <hpa@zytor.com>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/x86/include/asm/page_types.h 
b/arch/x86/include/asm/page_types.h
index 2f59cce..f97fbe3 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -51,9 +51,9 @@ extern int devmem_is_allowed(unsigned long pagenr);
  extern unsigned long max_low_pfn_mapped;
  extern unsigned long max_pfn_mapped;

-static inline phys_addr_t get_max_low_mapped(void)
+static inline phys_addr_t get_max_mapped(void)
  {
-       return (phys_addr_t)max_low_pfn_mapped << PAGE_SHIFT;
+       return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
  }

  bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c967559..06853e6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1119,7 +1119,7 @@ void __init setup_arch(char **cmdline_p)

         setup_real_mode();

-       memblock_set_current_limit(get_max_low_mapped());
+       memblock_set_current_limit(get_max_mapped());
         dma_contiguous_reserve(0);

         /*
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
