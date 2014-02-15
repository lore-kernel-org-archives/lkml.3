Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaBOAuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 19:50:19 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63481 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752605AbaBOAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 19:50:17 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ACPI, PCI, ISA: Call ISA-specific code only for architectures which support ISA.
Date: Sat, 15 Feb 2014 02:05 +0100
Message-ID: <1463162.p1Ukb4737y@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392037211-29349-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1392037211-29349-1-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 10, 2014 02:00:10 PM Tomasz Nowicki wrote:
> This commit enables ISA-specific code if and only if CONFIG_{E}ISA is set
> in the kernel configuration so that we do not have to maintain
> acpi_isa_irq_to_gsi() function for architectures which do not support ISA.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>  drivers/acpi/pci_irq.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> index 41c5e1b..b0e31b6 100644
> --- a/drivers/acpi/pci_irq.c
> +++ b/drivers/acpi/pci_irq.c
> @@ -418,6 +418,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>  	 * driver reported one, then use it. Exit in any case.
>  	 */
>  	if (gsi < 0) {
> +#if IS_ENABLED(CONFIG_ISA) || IS_ENABLED(CONFIG_EISA)

Can you please move the code in question into a separate function and make
that function depend on the above (with an empty stub for when they are not
enabled)?

>  		u32 dev_gsi;
>  		/* Interrupt Line values above 0xF are forbidden */
>  		if (dev->irq > 0 && (dev->irq <= 0xF) &&
> @@ -427,10 +428,9 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>  			acpi_register_gsi(&dev->dev, dev_gsi,
>  					  ACPI_LEVEL_SENSITIVE,
>  					  ACPI_ACTIVE_LOW);
> -		} else {
> -			dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
> -				 pin_name(pin));
> -		}
> +		} else
> +#endif
> +		dev_warn(&dev->dev, "PCI INT %c: no GSI\n", pin_name(pin));
>  
>  		return 0;
>  	}
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
