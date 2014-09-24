Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaIXHvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:51:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16797 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaIXHvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:51:45 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-fa-5422780e02d3
Message-id: <1411545101.4861.1.camel@AMDC1943>
Subject: Re: [PATCH] ARM: cacheflush: Fix exynos build breakage on ARMv6 by
 using macros for ISB/DSB
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        "David A. Long" <dave.long@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Vinayak Kale <vkale@apm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Wed, 24 Sep 2014 09:51:41 +0200
In-reply-to: <alpine.LFD.2.11.1409231244470.8647@knanqh.ubzr>
References: <1410871979-12470-1-git-send-email-k.kozlowski@samsung.com>
 <54219AEC.2060204@samsung.com> <alpine.LFD.2.11.1409231244470.8647@knanqh.ubzr>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t/xy7p8FUohBi0HrSw2zljPajH14RM2
	i497FrBZ9C64ymZxtukNu8X2zhnsFpseX2O1uLxrDpvF7cu8FmuP3GW3WHr9IpPFp2f/2C1W
	7frDaDHv2Wk2i5cfT7A48Ht8XP+J0WPNvDWMHi3NPWwel/t6mTx2zrrL7rFpVSebx51re9g8
	Ni+p9+jbsorR4/MmuQCuKC6blNSczLLUIn27BK6MrrlXWQrmKFR0fHrI3MD4TqKLkYNDQsBE
	4vkSwS5GTiBTTOLCvfVsXYxcHEICSxkl1pz8zwThfGaUuHvuHiNIFa+AnsSa/SeYQJqFBdIk
	Pv83BwmzCRhLbF6+hA3EFhHQkTg68zUzSC+zwEoWiWezVrGDJFgEVCUWzF/LAmJzCthK3G46
	ww6xYCajxMvnj8G6mQXUJSbNW8QMcZ2yRGO/G8ReQYkfk++xQJTIS2xe85Z5AqPALCQds5CU
	zUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSIx93cG49JjVIUYBDkYlHt6J4koh
	QqyJZcWVuYcYJTiYlUR4T5QChXhTEiurUovy44tKc1KLDzEycXBKNTAe+K1+rPfx/10Hwg2X
	3Vq4UPNc+TbVW5+NmqIWaOo6My05l+v4rCi7/LGeVuKSM2Gq7zizqxIS7270mZMqnZs2b7uk
	saSMP1+y9c4Jse4purzfBfPaCsI/KH7WKw+2NhUSN22wz3nx8+vizIdHavQtUwrWBZxzOsN+
	I5TzT3K1P2t25FMZXyWW4oxEQy3mouJEAKYfrfaPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-09-23 at 12:54 -0400, Nicolas Pitre wrote:
> On Wed, 24 Sep 2014, Kukjin Kim wrote:
> 
> > On 09/16/14 21:52, Krzysztof Kozlowski wrote:
> > > This fixes build breakage of platsmp.c if ARMv6 was chosen for compile
> > > time options (e.g. by building allmodconfig):
> > >
> > > $ make allmodconfig
> > > $ make
> > >    CC      arch/arm/mach-exynos/platsmp.o
> > > /tmp/ccdQM0Eg.s: Assembler messages:
> > > /tmp/ccdQM0Eg.s:432: Error: selected processor does not support ARM mode
> > > `isb '
> > > /tmp/ccdQM0Eg.s:437: Error: selected processor does not support ARM mode
> > > `isb '
> > > /tmp/ccdQM0Eg.s:438: Error: selected processor does not support ARM mode
> > > `dsb '
> > > make[1]: *** [arch/arm/mach-exynos/platsmp.o] Error 1
> > >
> > > The error was introduced in commit "ARM: EXYNOS: Move code from
> > > hotplug.c to platsmp.c".  Previously code using
> > > v7_exit_coherency_flush() macro was built with '-march=armv7-a' flag but
> > > this flag dissapeared during the movement.
> > >
> > > Use isb() and dsb() macros in v7_exit_coherency_flush() so the proper
> > > code will be generated for ARMv6.
> > >
> > > Signed-off-by: Krzysztof Kozlowski<k.kozlowski@samsung.com>
> > > Reported-by: Mark Brown<broonie@kernel.org>
> > > Link: http://www.spinics.net/lists/linux-samsung-soc/msg36790.html
> > > ---
> > >   arch/arm/include/asm/cacheflush.h | 17 +++++++++++------
> > >   1 file changed, 11 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/arch/arm/include/asm/cacheflush.h
> > > b/arch/arm/include/asm/cacheflush.h
> > > index 79ecb4f34ffb..b74eeec971c0 100644
> > > --- a/arch/arm/include/asm/cacheflush.h
> > > +++ b/arch/arm/include/asm/cacheflush.h
> > > @@ -464,22 +464,27 @@ static inline void __sync_cache_range_r(volatile void
> > > *p, size_t size)
> > >    *   CONFIG_FRAME_POINTER=y.  ip is saved as well if ever r12-clobbering
> > >    *   trampoline are inserted by the linker and to keep sp 64-bit aligned.
> > >    */
> > > -#define v7_exit_coherency_flush(level) \
> > > +#define v7_exit_coherency_flush(level) do { \
> > >    asm volatile( \
> > >    "stmfd	sp!, {fp, ip} \n\t" \
> > >    "mrc	p15, 0, r0, c1, c0, 0	@ get SCTLR \n\t" \
> > >    "bic	r0, r0, #"__stringify(CR_C)" \n\t" \
> > >    "mcr	p15, 0, r0, c1, c0, 0	@ set SCTLR \n\t" \
> > > -	"isb	\n\t" \
> > > +	: : : "r0","r1","r2","r3","r4","r5","r6","r7", \
> > > +	      "r9","r10","lr","memory" ); \
> > > +	isb(); \
> > > +	asm volatile( \
> > >    "bl	v7_flush_dcache_"__stringify(level)" \n\t" \
> > >    "mrc	p15, 0, r0, c1, c0, 1	@ get ACTLR \n\t" \
> > >    "bic	r0, r0, #(1<<  6)	@ disable local coherency \n\t" \
> > >    "mcr	p15, 0, r0, c1, c0, 1	@ set ACTLR \n\t" \
> > > -	"isb	\n\t" \
> > > -	"dsb	\n\t" \
> > > -	"ldmfd	sp!, {fp, ip}" \
> > > : : : "r0","r1","r2","r3","r4","r5","r6","r7", \
> > > -	      "r9","r10","lr","memory" )
> > > +	      "r9","r10","lr","memory" ); \
> > > +	isb(); \
> > > +	dsb(); \
> > > +	asm volatile( \
> > > +	"ldmfd	sp!, {fp, ip}" ); \
> > > +	} while (0)
> > >
> > >   int set_memory_ro(unsigned long addr, int numpages);
> > >   int set_memory_rw(unsigned long addr, int numpages);
> > 
> > Hi Russell,
> > 
> > Can you please check this patch? Unfortunately I'm not sure about this, this
> > should resolve the build error though...
> 
> I don't like this patch at all.
> 
> The original assembly sequence was carefully written in a single segment 
> because it is important that the compiler does not attempt to schedule 
> anything in the middle.  Some definitions of isb() and dsb() need a 
> temporary register which needs to be allocated and initialized and who 
> knows what the compiler might do (such as spilling to the stack which 
> might be fatal here).
> 
> Instead, you should insert ".arch armv7-a" in the assembly sequence to 
> tell the assembler the isb and dsb instructions are going to be executed 
> on an ARMv7 capable CPU.
> 

Thank you for pointing this out. I'll send fixed patch.

Best regards,
Krzysztof

> 
> Nicolas

