Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaAFWIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:08:54 -0500
Received: from ni.piap.pl ([195.187.100.4]:59545 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaAFWIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:08:52 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <m38uv1uuzr.fsf@t19.piap.pl> <m3ha9gx63v.fsf@t19.piap.pl>
	<52CB051B.1040808@ti.com>
Date: Mon, 06 Jan 2014 23:08:50 +0100
In-Reply-To: <52CB051B.1040808@ti.com> (Santosh Shilimkar's message of "Mon, 6
	Jan 2014 14:33:47 -0500")
MIME-Version: 1.0
Message-ID: <m3ppo4sqz1.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: Regression (ARM) arch/arm/mm/init.c doesn't build without CONFIG_ARM_PATCH_PHYS_VIRT.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140106 #7262385, check: 20140106 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santosh Shilimkar <santosh.shilimkar@ti.com> writes:

> I am afraid you didn't understood what the fix is if you say above.
> arm_dma_limit is broken without this fix for LPAE machines with
> memory starting 4 GB physical boundary.

I wonder what CONFIG_ARM_PATCH_PHYS_VIRT and CONFIG_ZONE_DMA do they
use?

Of course, CONFIG_ZONE_DMA must be set, because otherwise the patch
changes a part disabled with #ifdef. CONFIG_ARM_PATCH_PHYS_VIRT must be
set because otherwise the kernel will not compile at all.

Do you accept the fact the configurations with CONFIG_ZONE_DMA and
without CONFIG_ARM_PATCH_PHYS_VIRT are now broken - by this very commit?

Now, what "fix" does this commit in its entirety do:

-     arm_dma_limit = PHYS_OFFSET + arm_dma_zone_size - 1;
+     arm_dma_limit = __pv_phys_offset + arm_dma_zone_size - 1;

if under the above circumstances (CONFIG_*) in
arch/arm/include/asm/memory.h we have:

extern u64 __pv_phys_offset;
^^^^^^^^^^^^^^^^^^^^^^^^^^^^ the only usable declaration of this variable
extern u64 __pv_offset;
extern void fixup_pv_table(const void *, unsigned long);
extern const void *__pv_table_begin, *__pv_table_end;

#define PHYS_OFFSET __pv_phys_offset
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
