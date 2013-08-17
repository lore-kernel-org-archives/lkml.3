Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3HQTJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:09:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab3HQTJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:09:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC v1 5/5] ARM: mvebu: add board init for Armada 1500
Date: Sat, 17 Aug 2013 21:08:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376682098-10580-6-git-send-email-sebastian.hesselbarth@gmail.com> <20130816204831.GX13964@titan.lakedaemon.net>
In-Reply-To: <20130816204831.GX13964@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308172108.38824.arnd@arndb.de>
X-Provags-ID: V02:K0:9xjJYc7QN/GEGFfKrAeAaZ6Z3CHel8c68vA7aWOHPoz
 UHrobq/jUbhWsrAEeHblc1yuihqqyUPhrh7a2ikdPGPUySRuc+
 sof5pZ+x4tmnEEiiZABzPuUN9PuH/l+K/af/8Maxd3m8GKMEVa
 kBG7vVK9L68leTHMp+oyXRAQiClrtS42HOh5Qr6mWRaKfvR5Wr
 26Lr7y2sYlQzDnCTI/EHjaggVP7GbAW0aGNezgS2UfqH6mmMJ6
 nWbHjtiW16dgqfLF4t0g+wg1WWvDVFLEGaEZ8HIRtV8AHSFquH
 o1FnrRsiBPoc9bqi7JH/t8u5txacnlPWYVUmxUW680VPHk30Ig
 xwrYvMRIoG410Jp+PXBc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 August 2013, Jason Cooper wrote:
> > +
> > +#define ARMADA_1500_REG_BASE_VIRT	0xf6000000
> > +#define ARMADA_1500_REG_BASE_SIZE	0x03000000
> > +
> > +static struct map_desc armada_1500_io_desc[] __initdata = {
> > +	{
> > +		.virtual	= ARMADA_1500_REG_BASE_VIRT,
> > +		.pfn		= __phys_to_pfn(ARMADA_1500_REG_BASE_VIRT),
> > +		.length		= ARMADA_1500_REG_BASE_SIZE,
> > +		.type		= MT_DEVICE,
> > +	},
> > +};

You should really try to find out what driver uses this. If you have a requirement
that VIRT == PHYS here, the most likely explanation is that some driver accidentally
uses readl/writel on the physical address rather than on the result of ioremap.

You can try shrinking the area using bisection until you have found the offending
driver based on the address.

> > +static void __init armada_1500_timer_and_clk_init(void)
> > +{
> > +	of_clk_init(NULL);
> > +	clocksource_of_init();
> > +}
> > +
> > +static void __init armada_1500_dt_init(void)
> > +{
> > +	l2x0_of_init(0x70c00000, 0xfeffffff);

New platforms should call this as 'l2x0_of_init(0, 0);' and get the bits from DT.

Note that we should really change the common code to do both the of_clk_init()
and the l2x0_of_init() automatically, but that needs to be done with some care,
in order to not break any of the existing platforms. Would you be able to do
one of the two? We can then get the next person that wants to add a platform
to do the last one ;-)

	Arnd
