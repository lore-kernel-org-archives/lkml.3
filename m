Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3HUVKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:10:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47161 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3HUVKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <520D44C5.6080205@ti.com>
References: <51E83A4F.5080904@ti.com>
	<CACRpkdY3nQaWimTwB-Zt-8+Q_KZr8a0rpB1SUQq=AuoG4bAYnQ@mail.gmail.com>
	<51ED2385.60108@ti.com>
	<51ED5C66.1010407@ti.com>
	<51EFFBE1.4090505@ti.com>
	<51F0031B.1050307@ti.com>
	<51F00530.9090703@ti.com>
	<51F02069.3050207@ti.com>
	<51F0223E.4050008@ti.com>
	<51F0240F.3050507@ti.com>
	<20130813081003.GU7656@atomide.com>
	<520A02BA.4090805@ti.com>
	<CACRpkda+m82PYJsExLM6JLsLa8-bVhdvy_r_+-uKfVT2NG7Cbg@mail.gmail.com>
	<520D398D.9040806@ti.com>
	<CACRpkdYeo1y-HhftkRWgwyq8o-NVuJ978Uq+ON880LHhUxC=hg@mail.gmail.com>
	<520D44C5.6080205@ti.com>
Date: Wed, 21 Aug 2013 23:10:14 +0200
Message-ID: <CACRpkdagSHxzV3=427O9iftNxM+N=w9aPds=iDvGQPoG3H-cWw@mail.gmail.com>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sricharan R <r.sricharan@ti.com>, Tony Lindgren <tony@atomide.com>,
        Nishanth Menon <nm@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Felipe Balbi <balbi@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 11:14 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On Thursday 15 August 2013 04:51 PM, Linus Walleij wrote:
(...)
>> Sorry I don't understand what thread that is... can you point me there?
>> My previous statement on this issue what this:
>> http://marc.info/?l=linux-kernel&m=137442541628641&w=2
(...)
>>> I don't see how you can make this happen with an irqchip
>>> infrastructure.
>>
>> I think my post above describes this.
>>
> Sorry for being dumb but I don't think cascaded irqchip examples
> like GPIO and cross-bars are same. If you take an example of
> GPIO irqchip, it always have a physical connection even if it
> is 1 IRQ line for (32 logical/sparse IRQs). That goes with
> other MFD examples too.
>
> So may be I am still missing something in your proposal.

Why does it matter if it is a GPIO or MFD or whatever?
The point is that the IRQ line passes thru something else,
and this we model as an irqdomain.

Anyway here is a silicon cascaded IRQ chip:
arch/arm/mach-versatile/core.c
See versatile_init_irq():

__vic_init(VA_VIC_BASE, IRQ_VIC_START, ~0, 0, np);
(...)
fpga_irq_init(VA_SIC_BASE, "SIC", IRQ_SIC_START,
                IRQ_VICSOURCE31, PIC_VALID, np);

The VIC in the versatile has the SIC cascaded from one of
its IRQ lines. Both the VIC and SIC (fpga IRQ) are
using irqdomains so the SIC spawns a child irqdomain
from IRQ 31 (last IRQ) of the VIC.

The difference with a crossbar is that it can software-config
which IRQ goes where, and does not have a callback
to clear interrupts or anything like that, it just passes them
thru. But it is best modeled as an irqdomain IMO.

Yours,
Linus Walleij
