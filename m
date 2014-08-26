Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaHZVVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:21:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:56996 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbaHZVVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:21:15 -0400
Date: Tue, 26 Aug 2014 23:20:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Bugfix] x86, irq: Fix bug in setting IOAPIC pin attributes
In-Reply-To: <20140826095221.GO1660@lahna.fi.intel.com>
Message-ID: <alpine.DEB.2.10.1408262319500.3323@nanos>
References: <20140822124145.GF1660@lahna.fi.intel.com> <1409042706-11958-1-git-send-email-jiang.liu@linux.intel.com> <20140826095221.GO1660@lahna.fi.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Mika Westerberg wrote:

> On Tue, Aug 26, 2014 at 04:45:01PM +0800, Jiang Liu wrote:
> > On startup, IOAPIC driver preallocates IRQ descriptors and programs
> > IOAPIC pins with default level and polarity attributes for all legacy
> > IRQs. Later legacy IRQ users may fail to set IOAPIC pin attributes
> > if the requested attributes conflicts with the default IOAPIC pin
> > attributes. So change mp_irqdomain_map() to allow the first legacy IRQ
> > user to reprogram IOAPIC pin with different attributes.
> > 
> > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> 
> I tried this and now we get further in setting up the IOAPIC but it
> still doesn't work :-(
> 
> I noticed that mp_set_gsi_attr() never programs the IOAPIC in case
> info->set is 0 so I added following on top of your patch. With the below
> patch, the system seems to work as expected.
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 66c2700c9f83..777762a0ad09 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3942,10 +3942,16 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
>  
>  	mutex_lock(&ioapic_mutex);
>  	if (!info->set) {
> +		struct io_apic_irq_attr attr;
> +
>  		info->trigger = trigger;
>  		info->polarity = polarity;
>  		info->node = node;
>  		info->set = 1;
> +
> +		/* Now program the IOAPIC with the new attributes */
> +		set_io_apic_irq_attr(&attr, ioapic, pin, trigger, polarity);
> +		ret = io_apic_setup_irq_pin(gsi, node, &attr);
>  	} else if (info->trigger != trigger || info->polarity != polarity) {
>  		ret = -EBUSY;
>  	}

Can someone please combine this into a single patch with a proper
changelog?

Thanks,

	tglx

