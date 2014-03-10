Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaCJKqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:46:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62316 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbaCJKqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:46:48 -0400
Date: Mon, 10 Mar 2014 10:45:58 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the arm-soc tree
Message-ID: <20140310104558.GB8830@mudshark.cambridge.arm.com>
References: <20140309115514.GY28112@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140309115514.GY28112@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2014 at 11:55:14AM +0000, Mark Brown wrote:
> Hi all,

Hi Mark,

> After merging the arm-soc tree, today's linux-next build (20140309)
> failed for arm64 defconfig like this:
> 
> /home/broonie/next/next/drivers/irqchip/irq-gic.c: In function 'gic_raise_softirq':
> /home/broonie/next/next/drivers/irqchip/irq-gic.c:666:2: error: implicit declaration of function 'dmb' [-Werror=implicit-function-declaration]
>   dmb(ishst);
>   ^

Damnit, that's because we ended up going with dmb instead of dsb after it
(surprisingly) turned out to be sufficient. The simple patch below fixes the
problem -- Catalin, can we get this into -next please?

I have an extra patch which actually makes use of the options, but we should
get things building again first.

Cheers,

Will

--->8

>From bacbd4af61a671ad21f58197ed16116ff41b54cd Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Mon, 10 Mar 2014 10:36:52 +0000
Subject: [PATCH] arm64: barriers: add dmb barrier

Commit 8adbf57fc429 ("irqchip: gic: use dmb ishst instead of dsb when
raising a softirq") added an explicit dmb(...) call to the GIC driver.

This patch adds a simple dmb() macro to arm64, which expands to a DMB SY
instruction.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/barrier.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 409ca370cfe2..66eb7648043b 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -25,6 +25,7 @@
 #define wfi()		asm volatile("wfi" : : : "memory")
 
 #define isb()		asm volatile("isb" : : : "memory")
+#define dmb(opt)	asm volatile("dmb sy" : : : "memory")
 #define dsb(opt)	asm volatile("dsb sy" : : : "memory")
 
 #define mb()		dsb()
-- 
1.8.2.2
