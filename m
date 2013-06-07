Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3FGMNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:13:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53814 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3FGMNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:13:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] ethernet/arc/arc_emac - Add new driver
Date: Fri, 07 Jun 2013 14:13:14 +0200
Message-ID: <2468036.im0srnzmHT@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <4881796E12491D4BB15146FE0209CE643F5C77EC@DE02WEMBXB.internal.synopsys.com>
References: <1370348510-23754-1-git-send-email-abrodkin@synopsys.com> <1505761.5DsauZd6eq@wuerfel> <4881796E12491D4BB15146FE0209CE643F5C77EC@DE02WEMBXB.internal.synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o227tIlNxyoW42z9R3TneRqISovTzQ31ZAwUxGx7HNO
 JnSr5snqllcq41d3BiEjvQD2D5PAOL+Bt1nR9AaWEyBxIfuN8Q
 6+cx9AAu/TUp1Yp14IeQZFfb+C4GOJ1+BHef7UeY5VPiu33iP4
 e+YCuQNdQAL2VGWgFH5w1/s9Sdrtjce/jwngFet99nNKXXtFxp
 hU2RxYn9lDPtgWcziLrl2pyErjObSuidb//i3w3ZhQs5UqTFWg
 /4kN7Is/A6QWUufhaK2IyTq9TiTVMsZHQrBPK8bH38Uc4JeBU4
 IqlESNkFXMDQsc/2eQenuK0YY+edVSfki0ixNlCBqPOTRYvF+N
 ZRqpWLDHCrYUP7HiA5IE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013 10:42:28 Alexey Brodkin wrote:
> On 06/07/2013 12:47 PM, Arnd Bergmann wrote:

> > I wonder if it would be better to name the directory "synopsys" or
> > "designware" rather than "arc" now. Is there a chance that the same
> > controller is used on non-arc CPUs?
> 
> The thing is - "arc_emac" is a custom ARC's (that was implemented before 
> acquisition of ARC by Synopsys) IP (it's not an IC - just a part of CPU) 
> Ethernet controller that only exists in some legacy FPGA boards we 
> (ex-ARC and our customers) still use a lot in development process.
> 
> Synopsys itself doesn't actively sell this device so there's no point in 
> putting ARC EMAC into Synopsys folder.
> 
> And indeed we don't expect this device to be used with non-ARC CPU's.
> 
> I didn't add dependency on ARC in Kconfig just because I wanted to leave 
> an ability to build this driver on x86 machine. I thought this is 
> important requirement - allow anybody to at least build this driver to 
> make sure it builds and doesn't cause tons of warnings to appear.
> 
> If it's totally fine to add dependency on ARC - then it would be even 
> easier for me - refer to the next block of comments.

No, I think making it generally available for all architectures is better.

> >> +static int arc_emac_probe(struct platform_device *pdev)
> >> +{
> >> +	struct net_device *net_dev;
> >> +	struct arc_emac_priv *priv;
> >> +	int err;
> >> +	unsigned int clock_frequency;
> >> +	unsigned int id;
> >> +	struct resource res_regs;
> >> +#ifdef CONFIG_OF_IRQ
> >> +	struct resource res_irq;
> >> +#endif
> >> +	const char *mac_addr = NULL;
> >
> > Please remove the #ifdef here. The driver does not work without this
> > anyway, so better make it 'depend on OF_IRQ' in Kconfig.
> 
> As stated above I wanted to make it possible to compile on x86.
> And for this I needed to:
> 1. Add explicit mentions of "linux/platform_device.h" because with 
> existence of OF "linux/of_platform.h" has "linux/platform_device.h" 
> included internally.
> 2. Enclose "of_irq_to_resource" and "of_get_mac_address" in ifdefs 
> because neither of them has a stub for non-OF situation.

But you can enable CONFIG_OF on x86. An allmodconfig build should
still enable this driver. The #ifdefs are generally considered ugly,
and there is no point adding them when the driver clearly wouldn't
work on any architecture without them even if that hardware was
available.

> So if I may depend on ARC then I'm sure OF is selected and no need to worry.
> Otherwise do I need to add stubs for "of_irq_to_resource" and 
> "of_get_mac_address" somewhere in "of/of_xxx.h"?

We are currently discussing those changes to the header files elsewhere.
I think with a dependency on CONFIG_OF_IRQ and other symbols you need,
you get the best compromise of the various requirements.

	Arnd
