Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab3KLOge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:36:34 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49206 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3KLOgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:36:32 -0500
Date: Tue, 12 Nov 2013 09:36:29 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Christopher Covington <cov@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library
 functions
In-Reply-To: <yw1xhabhvgw0.fsf@unicorn.mansr.com>
Message-ID: <alpine.LFD.2.10.1311120933060.9667@knanqh.ubzr>
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.10.1311092357090.2314@knanqh.ubzr> <528193A0.7050505@codeaurora.org> <alpine.LFD.2.10.1311120839310.9667@knanqh.ubzr> <yw1xhabhvgw0.fsf@unicorn.mansr.com>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-903574381-1384266990=:9667"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-903574381-1384266990=:9667
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 12 Nov 2013, Måns Rullgård wrote:

> Nicolas Pitre <nicolas.pitre@linaro.org> writes:
> 
> > What about this patch which I think is currently your best option.  Note 
> > it would need to use the facilities from asm/opcodes.h to make it endian 
> > agnostic.
> >
> > diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > index 6a1b8a81b1..379cffe4ab 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -383,6 +383,34 @@ static void __init cpuid_init_hwcaps(void)
> >  		elf_hwcap |= HWCAP_IDIVT;
> >  	}
> >
> > +	/*
> > +	 * Patch our division routines with the corresponding opcode
> > +	 * if the hardware supports it.
> > +	 */
> > +	if (IS_ENABLED(CONFIG_THUMB2_KERNEL) && (elf_hwcap & HWCAP_IDIVT)) {
> > +		extern char __aeabi_uidiv, __aeabi_idiv;
> 
> It would be safer to declare these as arrays of unspecified size.
> Otherwise the compiler might do evil things with what to it looks like
> out of bounds indexing.

Right.

> 
> There should also be some cache maintenance after this patching, or is
> that already happening for some other reason?

This is so early during boot that the MMU isn't even fully initialized 
yet.  The cache will be flushed.


Nicolas
--8323328-903574381-1384266990=:9667--
