Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaILKiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:38:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:46859 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaILKh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:37:59 -0400
Date: Fri, 12 Sep 2014 12:37:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Peter Neubauer <pneubauer@bluerwhite.org>
Subject: Re: [PATCH] x86: HPET force enable for Soekris net6501
In-Reply-To: <5412BFAF.7050900@lsexperts.de>
Message-ID: <alpine.DEB.2.10.1409121221580.4178@nanos>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.e
 <0363648bf9644167bf5aa0a954cd145b@DB4PR04MB265.eurprd04.prod.outlook.com> <540F06F1.1040608@lsexperts.de> <alpine.DEB.2.10.1409091649510.11037@nanos> <540F1C43.2080708@zytor.com> <5412BFAF.7050900@lsexperts.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Eric Sesterhenn wrote:
> On 09/09/2014 05:26 PM, H. Peter Anvin wrote:
> > On 09/09/2014 07:54 AM, Thomas Gleixner wrote:
> >>
> >> @hpa: You asked whether this might affect any other e6xx devices.
> >>
> >> According to the atom e6xx-series datasheet the HPET is non optional
> >> and always memory mapped to 0xfed00000. I don't see how that would
> >> harm any machine which has the hpet proper advertised via ACPI.
> >>
> > 
> > That seems straightforward then.
> 
> this means the original patch written by Conrad is going to be applied?
> Is there anything we can do to help regarding this issue?

Yes, it needs some massaging.

> Subject: [PATCH] x86: HPET force enable for Soekris net6501

This change is not soekris specific. It enables the force mechanism
for all e6xx based systems.

> Original patch by Peter Neubauer, slightly modified by me.
> -> http://www.mail-archive.com/soekris-tech@lists.soekris.com/msg06462.html

> Signed-off-by: Peter Neubauer <pneubauer@bluerwhite.org>

I can't see a SOB from Peter in his post on the soekris list, but he's
clearly the original author. So the patch is missing a From: .... line
at the top of the mail body.

> Signed-off-by: Conrad Kostecki <ck@conrad-kostecki.de>

--- a/arch/x86/kernel/quirks.c	2014-02-14 11:13:27.703432732 +0100
+++ b/arch/x86/kernel/quirks.c	2014-02-14 11:14:32.327496474 +0100
@@ -498,6 +498,25 @@ void force_hpet_resume(void)
 }
 
>  /*
> + * Soekris net6501, based on Atom E6xx series, does not have ACPI.
> + * HPET should be force enabled on such platforms.
> + */

Again this is not soekris specific. We rather want an explanation WHY
it is safe to do so, e.g. something like:

/*
 * According to datasheet e6xx systems have the HPET hardwired to
 * 0xfed00000
 */

That's the information we need and which avoids questions about the
correctness of the approach. Its clear that ACPI did not populate HPET
if hpet_address is 0.

> +static void e6xx_force_enable_hpet(struct pci_dev *dev)
> +{
> +	if (hpet_address || force_hpet_address)
> +		return;
> +
> +	force_hpet_address = 0xFED00000;
> +	force_hpet_resume_type = NONE_FORCE_HPET_RESUME;
> +	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
> +		"0x%lx\n", force_hpet_address);
> +	return;
> +}
> +

Remove the new line please.

> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E6XX_CU,
> +			 e6xx_force_enable_hpet);

Thanks,

	tglx
