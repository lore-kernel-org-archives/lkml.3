Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbaIIOyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:54:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:53749 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbaIIOyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:43 -0400
Date: Tue, 9 Sep 2014 16:54:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
cc: Conrad Kostecki <ck@conrad-kostecki.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: AW: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
In-Reply-To: <540F06F1.1040608@lsexperts.de>
Message-ID: <alpine.DEB.2.10.1409091649510.11037@nanos>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.e
 <0363648bf9644167bf5aa0a954cd145b@DB4PR04MB265.eurprd04.prod.outlook.com> <540F06F1.1040608@lsexperts.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014, Eric Sesterhenn wrote:
> On 02/14/2014 07:28 PM, Conrad Kostecki wrote:
> This patch enables a quirk for the Soekris net6501 HPET if
> pciquirks=soekris_e6xx" is supplied at the kernel commandline,
> Without these patches the clocksource defaults to jiffies, which
> is unstable.
> 
> Signed-off-by: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
> 
> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> index ff898bb..7c3faf5 100644
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -6,6 +6,25 @@
> 
>  #include <asm/hpet.h>
> 
> +static int pciquirk_soekris;
> +
> +static int __init parse_pciquirks(char *str)
> +{
> +
> +	while (str) {
> +		char *next = strchr(str, ',');
> +
> +		if (next)
> +			*next++ = 0;
> +		if (!strncmp("soekris_e6xx", str, 12))
> +			pciquirk_soekris = 1;
> +		str = next;
> +	}
> +        return 1;
> +}
> +__setup("pciquirks=", parse_pciquirks);

Eew. No, we really can do without random new quirk interfaces.

>  #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
> 
>  static void quirk_intel_irqbalance(struct pci_dev *dev)
> @@ -498,6 +517,28 @@ void force_hpet_resume(void)
>  }
> 
>  /*
> + * Soekris net6501, based on Atom E6xx series, does not have ACPI.
> + * HPET should be force enabled on such platforms.
> + */
> +static void e6xx_force_enable_hpet(struct pci_dev *dev)
> +{
> +	if (hpet_address || force_hpet_address)
> +		return;
> +
> +	if (pciquirk_soekris != 1)
> +		return;

Thinking more about it, this is really not necessary.

@hpa: You asked whether this might affect any other e6xx devices.

According to the atom e6xx-series datasheet the HPET is non optional
and always memory mapped to 0xfed00000. I don't see how that would
harm any machine which has the hpet proper advertised via ACPI.

Thanks,

	tglx

> +
> +	force_hpet_address = 0xFED00000;
> +	force_hpet_resume_type = NONE_FORCE_HPET_RESUME;
> +	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
> +		"0x%lx\n", force_hpet_address);
> +	return;
> +}
> +
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E6XX_CU,
> +			 e6xx_force_enable_hpet);
