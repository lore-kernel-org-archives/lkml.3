Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaKFJ7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 04:59:11 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:53763 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaKFJ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 04:58:43 -0500
Date: Thu, 6 Nov 2014 09:58:39 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH RFC 1/2] drivers: pci: fix window allocation order wrt
 bus_range filtering
Message-ID: <20141106095839.GB1923@red-moon>
References: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com>
 <20141106000536.GL6168@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106000536.GL6168@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 12:05:36AM +0000, Bjorn Helgaas wrote:
> On Thu, Oct 23, 2014 at 04:23:06PM +0100, Lorenzo Pieralisi wrote:
> > The number of windows allocated for the host bridge depends on the
> > bus resource. Instead of first allocating the windows and then
> > limit the bus resource, this patch reshuffles the code so that if any
> > limitation is applied to the bus resource it is taken into account in
> > the windows allocation.
> > 
> > Cc: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> 
> I applied these with Will's acks to pci/host-generic for v3.19, thanks!

Thank you !

> In my mind, posting patches to the list is implicitly a request for
> comments, so I usually don't pay too much attention to things explicitly
> marked "RFC" because I figure that's a hint that "this is work-in-progress,
> please comment if you see anything obviously broken."

I decided to give it an RFC tag because it is a rework of existing code
on top of the new range parsing API and also new iospace remap API, I
just wanted to be cautious.

Thank you,
Lorenzo

> 
> Bjorn
> 
> > ---
> >  drivers/pci/host/pci-host-generic.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
> > index 3d2076f..1e1a80f 100644
> > --- a/drivers/pci/host/pci-host-generic.c
> > +++ b/drivers/pci/host/pci-host-generic.c
> > @@ -276,17 +276,17 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
> >  		return err;
> >  	}
> >  
> > -	pci->cfg.win = devm_kcalloc(dev, resource_size(&pci->cfg.bus_range),
> > -				    sizeof(*pci->cfg.win), GFP_KERNEL);
> > -	if (!pci->cfg.win)
> > -		return -ENOMEM;
> > -
> >  	/* Limit the bus-range to fit within reg */
> >  	bus_max = pci->cfg.bus_range.start +
> >  		  (resource_size(&pci->cfg.res) >> pci->cfg.ops->bus_shift) - 1;
> >  	pci->cfg.bus_range.end = min_t(resource_size_t, pci->cfg.bus_range.end,
> >  				       bus_max);
> >  
> > +	pci->cfg.win = devm_kcalloc(dev, resource_size(&pci->cfg.bus_range),
> > +				    sizeof(*pci->cfg.win), GFP_KERNEL);
> > +	if (!pci->cfg.win)
> > +		return -ENOMEM;
> > +
> >  	/* Map our Configuration Space windows */
> >  	if (!devm_request_mem_region(dev, pci->cfg.res.start,
> >  				     resource_size(&pci->cfg.res),
> > -- 
> > 2.1.2
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
