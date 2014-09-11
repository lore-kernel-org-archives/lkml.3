Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaIKJ2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:28:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:38454 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaIKJ2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:28:17 -0400
Date: Thu, 11 Sep 2014 11:27:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC Part1 v1 07/18] x86, irq: Introduce helpers to access struct
 irq_cfg
In-Reply-To: <1410423905-26239-8-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409111126410.4178@nanos>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com> <1410423905-26239-8-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Jiang Liu wrote:

> Change irq_cfg() from static to extern, also introduce helper function
> irqd_cfg(). Later we could rewrite these two helpers when enabling
> hierarchy irqdomain.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  arch/x86/include/asm/hw_irq.h  |    2 ++
>  arch/x86/kernel/apic/io_apic.c |    7 ++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> index 18e8717bf644..f457fcd0f3ba 100644
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -132,6 +132,8 @@ struct irq_cfg {
>  	};
>  };
>  
> +extern struct irq_cfg *irq_cfg(unsigned int irq);
> +extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
>  extern void setup_vector_irq(int cpu);
>  extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
>  extern void send_cleanup_vector(struct irq_cfg *);
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index ee3d3ff521a3..9b048c239dd4 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -281,11 +281,16 @@ int __init arch_early_irq_init(void)
>  	return 0;
>  }
>  
> -static inline struct irq_cfg *irq_cfg(unsigned int irq)
> +struct irq_cfg *irq_cfg(unsigned int irq)
>  {
>  	return irq_get_chip_data(irq);
>  }
>  
> +struct irq_cfg *irqd_cfg(struct irq_data *irq_data)
> +{
> +	return irq_data->chip_data;
> +}

We can make those inlines. There is no point to have that as global
functions.

Thanks,

	tglx
