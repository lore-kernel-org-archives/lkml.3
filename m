Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbaIDIp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:45:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:50334 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbaIDIpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:45:54 -0400
Date: Thu, 4 Sep 2014 10:45:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource
 read API.
In-Reply-To: <69c4ca3ee1324a3894a6d5dc0bde38ed@BY2PR0301MB0613.namprd03.prod.outlook.com>
Message-ID: <alpine.DEB.2.10.1409041044350.3333@nanos>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com> <1409031951-39021-3-git-send-email-Li.Xiubo@freescale.com> <alpine.DEB.2.10.1409031236450.3333@nanos> <c5f60fc57cdf4cd3a01b8d3a87a4f3de@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <alpine.DEB.2.10.1409041032200.3333@nanos> <69c4ca3ee1324a3894a6d5dc0bde38ed@BY2PR0301MB0613.namprd03.prod.outlook.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014, Li.Xiubo@freescale.com wrote:
> > >
> > > Since the FTM will be in BE mode on LS1 platform, but will be in LE mode
> > > On LS2 platform.
> > >
> > > And ftm_clocksource_read_up() will adapt to this different.
> > 
> > You are missing the point. Why do you want a conditional in a hot
> > path? You know at init time whether the thing is BE or LE, so you can
> > have separate functions for BE/LE or whatever and register that with
> > clocksource_mmio_init(). i.e.
> > 
> >      if (be)
> >      	clocksource_mmio_init(....., cs_read_be);
> >      else if (le)
> >      	clocksource_mmio_init(....., cs_read_le);
> >      else if (magic)
> >      	clocksource_mmio_init(....., cs_read_magic);
> > 
> 
> There already has the following access interfaces:
> 
> static inline u32 ftm_readl(void __iomem *addr)
> {
>         if (priv->big_endian)
>                 return ioread32be(addr);
>         else
>                 return ioread32(addr);
> }
> 
> static inline void ftm_writel(u32 val, void __iomem *addr)
> {
>         if (priv->big_endian)
>                 iowrite32be(val, addr);
>         else
>                 iowrite32(val, addr);
> }
> 
> So I added the following code:
> 
> static cycle_t ftm_clocksource_read_up(struct clocksource *c)
> {
>         return ftm_readl(priv->clksrc_base + FTM_CNT) & 0xffff;
> }
> 
> clocksource_mmio_init(.....,ftm_clocksource_read_up);
> 
> Is this okay ?

No. Sit down, read and try to understand what I wrote, look at your
existing code and figure out WHY it is fundamentally different to what
I told you.

Thanks,

	tglx
