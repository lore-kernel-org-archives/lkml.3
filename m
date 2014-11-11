Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaKKKDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:03:16 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49646 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752509AbaKKKDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:03:13 -0500
Date: Tue, 11 Nov 2014 11:03:08 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Kevin Cernekee <cernekee@gmail.com>, Kevin Hilman <khilman@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-sh@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        nicolas.ferre@atmel.com, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V4 04/14] genirq: Generic chip: Add big endian I/O
 accessors
Message-ID: <20141111110308.5bf7bbef@bbrezillon>
In-Reply-To: <20141110230301.GV4068@piout.net>
References: <1415342669-30640-1-git-send-email-cernekee@gmail.com>
	<1415342669-30640-5-git-send-email-cernekee@gmail.com>
	<7hy4riogwt.fsf@deeprootsystems.com>
	<CAJiQ=7CYjy-sWc-M3m2Mg8si8JacpDH=RPPm8S-Q4m88wk3Sqg@mail.gmail.com>
	<20141110230301.GV4068@piout.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 11 Nov 2014 00:03:01 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> Adding Boris in Cc: as he wrote that part.

Thanks for putting me in the loop.

> 
> On 10/11/2014 at 14:11:44 -0800, Kevin Cernekee wrote :
> > On Mon, Nov 10, 2014 at 2:00 PM, Kevin Hilman <khilman@kernel.org> wrote:
> > > Kevin Cernekee <cernekee@gmail.com> writes:
> > >
> > >> Use io{read,write}32be if the caller specified IRQ_GC_BE_IO when creating
> > >> the irqchip.
> > >>
> > >> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> > >
> > > I bisected a couple ARM boot failures in next-20141110 on atmel sama5 platforms down to
> > > this patch, though I'm not quite yet sure how it's causing the failure.
> > > I'm not getting any console output, so haven't been able to dig deeper
> > > yet.  Maybe the atmel maintainers (Cc'd) can help dig.
> > >
> > > I've confirmed that reverting $SUBJECT patch (commit
> > > b79055952badbd73710685643bab44104f2509ea2) on top of next-20141110 gets
> > > things booting again.
> > >
> > > Also, it only happens with sama5_defconfig, not with multi_v7_defconfig.
> > 
> > In drivers/irqchip/irq-atmel-aic-common.c I see:
> > 
> >         ret = irq_alloc_domain_generic_chips(domain, 32, 1, name,
> >                                              handle_level_irq, 0, 0,
> >                                              IRQCHIP_SKIP_SET_WAKE);
> > 
> > and IRQCHIP_SKIP_SET_WAKE is (1 << 4), same as IRQ_GC_BE_IO.
> > 
> > Is it possible that the caller is passing values intended for
> > irq_chip->flags into a function expecting
> > irq_domain_chip_generic->gc_flags ?

Indeed, I don't know what I tried to do in the first place but this is
completely wrong.
First because the last argument is not a valid flag as you pointed out,
then because I clearly have set irq_set_wake and thus setting
IRQCHIP_SKIP_SET_WAKE makes no sense.

I also realized I should directly pass handle_fasteoi_irq and not
handle_level_irq for the handler, that clr flags (IRQ_NOREQUEST |
IRQ_NOPROBE | IRQ_NOAUTOEN) are missing and that IRQ_GC_INIT_MASK_CACHE
is missing too.

I'll propose a patch fixing all those bugs.

Sorry for the inconvenience :-(.

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
