Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaFZTe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:34:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:46978 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbaFZTey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:34:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,555,1400050800"; 
   d="scan'208";a="553810722"
Date: Thu, 26 Jun 2014 12:33:33 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Tang, Feng" <feng.tang@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] x86: intel-mid: fix conflicts between 78a3bb9e408b and
 9f354b0252b8
Message-ID: <20140626193333.GA24934@psi-dev26.jf.intel.com>
References: <20140622084227.GA13974@gmail.com>
 <1403490643-26187-1-git-send-email-jiang.liu@linux.intel.com>
 <20140623173807.GA27942@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623173807.GA27942@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:38:07AM -0700, David Cohen wrote:
> Hi Jiang,
> 
> On Mon, Jun 23, 2014 at 10:30:35AM +0800, Jiang Liu wrote:
> > Commit 9f354b0252b8 "x86, irq: Clean up unused IOAPIC interface" kills
> > interface io_apic_set_pci_routing(), so change arch/x86/platform/
> > intel-mid/device_libs/platform_wdt.c to use new interfaces.
> > 
> > Due to hardware resource restriction, this patch only passes compilation
> > without functional tests.
> 
> I'll test this patch.

It sounds good.
Acked-by: David Cohen <david.a.cohen@linux.intel.com>

> 
> BR, David
> 
> > 
> > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> > ---
> >  .../platform/intel-mid/device_libs/platform_wdt.c  |   22 ++++++--------------
> >  1 file changed, 6 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
> > index 973cf3bfa9fd..0b283d4d0ad7 100644
> > --- a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
> > +++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
> > @@ -26,28 +26,18 @@ static struct platform_device wdt_dev = {
> >  
> >  static int tangier_probe(struct platform_device *pdev)
> >  {
> > -	int ioapic;
> > -	int irq;
> > +	int gsi;
> >  	struct intel_mid_wdt_pdata *pdata = pdev->dev.platform_data;
> > -	struct io_apic_irq_attr irq_attr = { 0 };
> >  
> >  	if (!pdata)
> >  		return -EINVAL;
> >  
> > -	irq = pdata->irq;
> > -	ioapic = mp_find_ioapic(irq);
> > -	if (ioapic >= 0) {
> > -		int ret;
> > -		irq_attr.ioapic = ioapic;
> > -		irq_attr.ioapic_pin = irq;
> > -		irq_attr.trigger = 1;
> > -		/* irq_attr.polarity = 0; -> Active high */
> > -		ret = io_apic_set_pci_routing(NULL, irq, &irq_attr);
> > -		if (ret)
> > -			return ret;
> > -	} else {
> > +	/* IOAPIC builds identity mapping between GSI and IRQ on MID */
> > +	gsi = pdata->irq;
> > +	if (mp_set_gsi_attr(gsi, 1, 0, cpu_to_node(0)) ||
> > +	    mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC) <= 0) {
> >  		dev_warn(&pdev->dev, "cannot find interrupt %d in ioapic\n",
> > -			 irq);
> > +			 gsi);
> >  		return -EINVAL;
> >  	}
> >  
> > -- 
> > 1.7.10.4
> > 
