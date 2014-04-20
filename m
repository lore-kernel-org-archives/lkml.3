Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaDTH7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 03:59:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaDTH7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 03:59:46 -0400
Date: Sun, 20 Apr 2014 09:59:37 +0200
From: Borislav Petkov <bp@suse.de>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        suravee.suthikulpanit@amd.com, aravind.gopalakrishnan@amd.com,
        kim.naru@amd.com, daniel@numascale.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, bp@suse.de,
        sp@numascale.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range
 capabilities
Message-ID: <20140420075936.GA19672@pd.tnic>
References: <20140419025308.2408.51252.stgit@amt.stowe>
 <20140419025323.2408.88764.stgit@amt.stowe>
 <20140419135219.GC8109@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140419135219.GC8109@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop Andreas' old email address from CC as it keeps bouncing.

On Sat, Apr 19, 2014 at 03:52:20PM +0200, Borislav Petkov wrote:
> > -static void __init pci_enable_pci_io_ecs(void)
> > +static void __init pci_enable_pci_io_ecs(u8 bus, u8 slot)
> >  {
> >  #ifdef CONFIG_AMD_NB
> >  	unsigned int i, n;
> > +	u8 limit;
> >  
> >  	for (n = i = 0; !n && amd_nb_bus_dev_ranges[i].dev_limit; ++i) {
> > -		u8 bus = amd_nb_bus_dev_ranges[i].bus;
> > -		u8 slot = amd_nb_bus_dev_ranges[i].dev_base;
> > -		u8 limit = amd_nb_bus_dev_ranges[i].dev_limit;
> > +		/* Try matching for the bus range */
> > +		if ((bus != amd_nb_bus_dev_ranges[i].bus) ||
> > +		    (slot != amd_nb_bus_dev_ranges[i].dev_base))
> > +			continue;
> > +
> > +		limit = amd_nb_bus_dev_ranges[i].dev_limit;
> >  
> > +		/* Setup all northbridges within the range */
> >  		for (; slot < limit; ++slot) {
> >  			u32 val = read_pci_config(bus, slot, 3, 0);
> > -
> > -			if (!early_is_amd_nb(val))
> > +			if (!val)
> >  				continue;
> >  
> >  			val = read_pci_config(bus, slot, 3, 0x8c);
> > @@ -375,13 +457,14 @@ static void __init pci_enable_pci_io_ecs(void)
> >  				val |= ENABLE_CF8_EXT_CFG >> 32;
> 
> What a fun shifting!
> 
> Maybe you should do
> 
> #define ENABLE_CF8_EXT_CFG	BIT(46 - 32)
> 
> to show exactly what you mean and how the bit is defined in MSR NB_CFG1
> and also show how the high 32-bits are mapped into F3x8c, while at it.
> 
> And then you can drop the shifting at the call site.

Ok, I see another fun with this ECS enabling:

There's a enable_pci_io_ecs() which enables ECS through the NB_CFG MSR
which is called as part of the notifier *and* there's a PCI write to
that same bit in pci_enable_pci_io_ecs() which iterates over all NBs.

So, AFAICT, we do it twice and the second time is not needed. Which
means, you probably can drop pci_enable_pci_io_ecs() completely and use
solely the notifier?

Yes, no?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
