Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422846Ab3FUOM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:12:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53699 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422676Ab3FUOMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:12:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v6 4/8] ARM: Add .init_platform() callback to machine descriptor
Date: Fri, 21 Jun 2013 16:12:15 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Marc Zyngier <marc.zyngier@arm.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com> <51C429F4.60709@arm.com> <72209947.cQvP4jsDBz@amdc1227>
In-Reply-To: <72209947.cQvP4jsDBz@amdc1227>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306211612.15508.arnd@arndb.de>
X-Provags-ID: V02:K0:odRlFdP3yoKa0YXpVqoN/3z1N7/1nXrOqeq83IY3uHJ
 ItMCSqaG558Rnu7QRSCMHp/i8GHCb2VXXlx7e3OxgWlDFWLE+4
 sJj5ZZ0OclrexZDo+vZyBypznuBGZoi5+JSlKDubf1/vPzlGbQ
 LA8/gTamHaCpcjJkFQb3qEB26OLP7z/04saXqaI03oIgPr1Rkp
 ZeCiHeur7xT7KOSWfKsDNrtv7TxleikZAnlrYp4F0rtYs5kdt6
 7EvaxDyU1tuAzHm+hi3aZka1Tyf8yZHilGgn68iBbumolpCE28
 nrfldL3UZ2MQdhXLBLQMMS0Iucim5c+a9NdwngCDt0g2/nVEXF
 Z+tUKpbqr9xHV9eTdSlg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 June 2013, Tomasz Figa wrote:

> > To me, this new hook is strictly equivalent to init_irq. What do we gain
> > exactly? I didn't think init_irq was going away...
> > 
> > I know init_irq is not pretty, and we tend to overload it with other
> > stuff, but I don't really see the point of adding a new callback that
> > has the exact same properties.
> 
> Well, it doesn't really give us any functional benefits.
> 
> However in my opinion it looks much saner in case of DT-only platforms that 
> don't need any specific IRQ initialization, but need to call some platform 
> specific initialization routines, after memory management, but before 
> anything else is initialized.
> 
> This way irqchip_init() doesn't have to be explicitly called in platform 
> code.
> 
> Anyway, I don't have any strong opinion on this. If it is perfectly fine to 
> abuse irqchip_init() for anything that must be done at this stage of boot, 
> then I'm fine with this either and will modify the board file from further 
> patch from this series to not rely on this change any more.

Your init_platform only has these two calls in it:

+       of_clk_init(NULL);
+       samsung_wdt_reset_of_init();

Presumably you need of_clk_init() for the watchdog to work. But do you actually
need to initialize the reset logic this early? Why not turn
samsung_wdt_reset_of_init into a standalone driver, or call it from init_machine?

I would actually like to call of_clk_init from common code at some point
between init_irq and init_time, although I'm not sure if some platforms
need it to be called before init_irq.

	Arnd
