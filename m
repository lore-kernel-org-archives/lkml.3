Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbaAFWNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:13:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59836 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbaAFWNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:13:10 -0500
Message-ID: <52CB2A6A.7090606@ti.com>
Date: Mon, 6 Jan 2014 17:12:58 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <rmk@arm.linux.org.uk>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
References: <20140106200758.a76bbd94508614b4decabdcd@canb.auug.org.au> <20140106172848.GA9162@flint.arm.linux.org.uk>
In-Reply-To: <20140106172848.GA9162@flint.arm.linux.org.uk>
Content-Type: multipart/mixed;
	boundary="------------000607040405060008010309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000607040405060008010309
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Stephen, Andrew, 

On Monday 06 January 2014 12:28 PM, Russell King wrote:
> On Mon, Jan 06, 2014 at 08:07:58PM +1100, Stephen Rothwell wrote:
>> Hi Andrew,
>>
>> After merging the akpm-current tree, today's linux-next build (arm
>> multi_v7_defconfig) failed like this:
>>
>> arch/arm/mm/init.c:199:13: error: conflicting types for 'arm_dma_zone_size'
>> include/linux/bootmem.h:259:11: note: previous declaration of 'arm_dma_zone_size' was here
>>
>> Caused by commit a3ae9362fafe ("mm/memblock: add memblock memory
>> allocation apis").
>>
>> For this build, BOOTMEM_LOW_LIMIT is defined as __pa(MAX_DMA_ADDRESS) and
>> MAX_DMA_ADDRESS is defined as:
>>
>> #define MAX_DMA_ADDRESS ({ \
>>         extern unsigned long arm_dma_zone_size; \
>>         arm_dma_zone_size ? \
>>                 (PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
>>
>> and in arch/arm/mm/init.c, arm_dma_zone_size is declared as:
>>
>> phys_addr_t arm_dma_zone_size __read_mostly;
>>
>> Urk!  :-(
>>
>> OK, so commit 364230b995214 ("ARM: use phys_addr_t for DMA zone sizes")
>> changed the definition of arm_dma_zone_size except it missed the one in
>> arch/arm/include/asm/dma.h.
>>
>> I have applied this merge fix patch for today:
> 
> There's more here than just this change required here.  We also need to
> limit it if PAGE_OFFSET + arm_dma_zone_size is greater than 4GB, as
> MAX_DMA_ADDRESS is a virtual address - we really don't want the 32-bit
> value of this wrapping.
> 
> Exactly how we go about this, I'm not sure at the moment, but maybe
> something like this:
> 
> #define MAX_DMA_ADDRESS ({ \
>         extern phys_addr_t arm_dma_zone_size; \
>         arm_dma_zone_size && arm_dma_zone_size < (0x10000000 - PAGE_OFFSET) ? \
>                 (PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
> 

Here is the patch as per the discussion. I have merged Steven's patch and update
suggested by Russell. Also attaching it, in case mailer eats tabs.


>From 779ab1fdaffbd7a4c8b3bba41f7a84c666c0c24e Mon Sep 17 00:00:00 2001
From: Russell King <rmk+kernel@arm.linux.org.uk>
Date: Mon, 6 Jan 2014 16:57:36 -0500
Subject: [PATCH] ARM: mm: change further appearance of arm_dma_zone_size to
 phys_addr_t

The definition was chagned in commit 364230b995214 ("ARM: use phys_addr_t
for DMA zone sizes").

Fixes this build error:

arch/arm/mm/init.c:199:13: error: conflicting types for 'arm_dma_zone_size'
include/linux/bootmem.h:259:11: note: previous declaration of 'arm_dma_zone_size' was here

While changing the type, we also need to limit MAX_DMA_ADDRESS  if
PAGE_OFFSET + arm_dma_zone_size is greater than 4GB. The MAX_DMA_ADDRESS
is a virtual address and we really don't want the 32-bit value of
this wrapping.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/include/asm/dma.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index 58b8c6a..9908443 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -8,8 +8,8 @@
 #define MAX_DMA_ADDRESS	0xffffffffUL
 #else
 #define MAX_DMA_ADDRESS	({ \
-	extern unsigned long arm_dma_zone_size; \
-	arm_dma_zone_size ? \
+	extern phys_addr_t arm_dma_zone_size; \
+	arm_dma_zone_size && arm_dma_zone_size < (0x10000000 - PAGE_OFFSET) ? \
 		(PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
 #endif
 
-- 
1.7.9.5


--------------000607040405060008010309
Content-Type: text/x-diff;
	name="0001-ARM-mm-change-further-appearance-of-arm_dma_zone_siz.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-ARM-mm-change-further-appearance-of-arm_dma_zone_siz.pa";
	filename*1="tch"

>From 01e1a4efcb9cb15e454cfa315a0431627245dfb2 Mon Sep 17 00:00:00 2001
From: Russell King <rmk+kernel@arm.linux.org.uk>
Date: Mon, 6 Jan 2014 16:57:36 -0500
Subject: [PATCH] ARM: mm: change further appearance of arm_dma_zone_size to
 phys_addr_t

The definition was changed in commit 364230b995214 ("ARM: use phys_addr_t
for DMA zone sizes").

Fixes this build error:

arch/arm/mm/init.c:199:13: error: conflicting types for 'arm_dma_zone_size'
include/linux/bootmem.h:259:11: note: previous declaration of 'arm_dma_zone_size' was here

While changing the type, we also need to limit MAX_DMA_ADDRESS  if
PAGE_OFFSET + arm_dma_zone_size is greater than 4GB. The MAX_DMA_ADDRESS
is a virtual address and we really don't want the 32-bit value of
this wrapping.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/include/asm/dma.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index 58b8c6a..9908443 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -8,8 +8,8 @@
 #define MAX_DMA_ADDRESS	0xffffffffUL
 #else
 #define MAX_DMA_ADDRESS	({ \
-	extern unsigned long arm_dma_zone_size; \
-	arm_dma_zone_size ? \
+	extern phys_addr_t arm_dma_zone_size; \
+	arm_dma_zone_size && arm_dma_zone_size < (0x10000000 - PAGE_OFFSET) ? \
 		(PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
 #endif
 
-- 
1.7.9.5


--------------000607040405060008010309--
