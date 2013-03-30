Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3C3HAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 03:00:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:27928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab3C3HAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 03:00:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,377,1363158000"; 
   d="scan'208";a="310631458"
Date: Sat, 30 Mar 2013 09:04:53 +0200
From: Mika Westerberg <mika.westerberg@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/6] dma: acpi-dma: parse CSRT to extract additional
 resources
Message-ID: <20130330070453.GE21804@intel.com>
References: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1364374682-8547-4-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130329213350.GZ10326@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329213350.GZ10326@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 03:03:50AM +0530, Vinod Koul wrote:
> On Wed, Mar 27, 2013 at 10:57:59AM +0200, Andy Shevchenko wrote:
> > Since we have CSRT only to get additional DMA controller resources, let's get
> > rid of drivers/acpi/csrt.c and move its logic inside ACPI DMA helpers code.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> for such a patch git format-patch -M is your friend. It generates patch to show
> file movement. It helps review greatly if you just move the file and then do
> additions on second patch, as diffstat tells me some changes have been done.

OK, thanks for the tip. We will use -M with the next revision.

> > @@ -23,6 +25,117 @@ static LIST_HEAD(acpi_dma_list);
> >  static DEFINE_MUTEX(acpi_dma_lock);
> >  
> >  /**
> > + * acpi_dma_parse_resource_group - match device and parse resource group
> > + * @grp:	CSRT resource group
> > + * @adev:	ACPI device to match with
> > + * @adma:	struct acpi_dma of the given DMA controller
> > + *
> > + * Returns 1 on success, 0 when no information is available, or appropriate
> > + * errno value on error.
> > + *
> > + * In order to match a device from DSDT table to the corresponding CSRT device
> > + * we use MMIO address and IRQ.
> > + */
> >  
> > +/**
> > + * acpi_dma_update_dma_spec - prepare dma specifier to pass to translation function
> > + * @adma:	struct acpi_dma of DMA controller
> > + * @dma_spec:	dma specifier to update
> > + *
> > + * Returns 0, if no information is avaiable, -1 on mismatch, and 1 otherwise.
> > + *
> > + * Accordingly to ACPI 5.0 Specification Table 6-170 "Fixed DMA Resource
> > + * Descriptor":
> > + *	DMA Request Line bits is a platform-relative number uniquely
> > + *	identifying the request line assigned. Request line-to-Controller
> > + *	mapping is done in a controller-specific OS driver.
> > + * That's why we can safely adjust slave_id when the appropriate controller is
> > + * found.
> > + */
> > +static int acpi_dma_update_dma_spec(struct acpi_dma *adma,
> > +		struct acpi_dma_spec *dma_spec)
> > +{
> > +	/* Set link to the DMA controller device */
> > +	dma_spec->dev = adma->dev;
> > +
> > +	/* Check if the request line range is available */
> > +	if (adma->base_request_line == 0 && adma->end_request_line == 0)
> > +		return 0;
> > +
> > +	/* Check if slave_id falls to the range */
> > +	if (dma_spec->slave_id < adma->base_request_line ||
> > +	    dma_spec->slave_id > adma->end_request_line)
> > +		return -1;
> > +
> > +	/*
> > +	 * Here we adjust slave_id. It should be a relative number to the base
> > +	 * request line.
> > +	 */
> > +	dma_spec->slave_id -= adma->base_request_line;
> where are you getting the base_request_line, i didnt see anything for this in
> ACPI spec?

It comes from the CSRT table. In this same patch there is a function
acpi_dma_parse_resource_group() that extracts it.

If you check the kerneldoc of this function (acpi_dma_update_dma_spec()) it
says this:

Accordingly to ACPI 5.0 Specification Table 6-170 "Fixed DMA Resource
Descriptor":
	DMA Request Line bits is a platform-relative number uniquely
	identifying the request line assigned. Request line-to-Controller
	mapping is done in a controller-specific OS driver.

So this patch series is actually the "controller-specific OS driver". And
we use CSRT table to extract the request line range for a given controller.

> > +	return 1;
> > +}
> > +
> >  struct acpi_dma_parser_data {
> >  	struct acpi_dma_spec dma_spec;
> >  	size_t index;
> > @@ -193,6 +347,7 @@ struct dma_chan *acpi_dma_request_slave_chan_by_index(struct device *dev,
> >  	struct acpi_device *adev;
> >  	struct acpi_dma *adma;
> >  	struct dma_chan *chan;
> > +	int found;
> >  
> >  	/* Check if the device was enumerated by ACPI */
> >  	if (!dev || !ACPI_HANDLE(dev))
> > @@ -219,9 +374,20 @@ struct dma_chan *acpi_dma_request_slave_chan_by_index(struct device *dev,
> >  	mutex_lock(&acpi_dma_lock);
> >  
> >  	list_for_each_entry(adma, &acpi_dma_list, dma_controllers) {
> > -		dma_spec->dev = adma->dev;
> > +		/*
> > +		 * We are not going to call translation function if slave_id
> > +		 * doesn't fall to the request range.
> > +		 */
> > +		found = acpi_dma_update_dma_spec(adma, dma_spec);
> > +		if (found < 0)
> > +			continue;
> >  		chan = adma->acpi_dma_xlate(dma_spec, adma);
> > -		if (chan) {
> > +		/*
> > +		 * Try to get a channel only from the DMA controller that
> > +		 * matches the slave_id. See acpi_dma_update_dma_spec()
> > +		 * description for the details.
> > +		 */
> > +		if (found > 0 || chan) {
> >  			mutex_unlock(&acpi_dma_lock);
> >  			return chan;
> >  		}
> > diff --git a/include/linux/acpi_dma.h b/include/linux/acpi_dma.h
> > index d09deab..fb02980 100644
> > --- a/include/linux/acpi_dma.h
> > +++ b/include/linux/acpi_dma.h
> > @@ -37,6 +37,8 @@ struct acpi_dma_spec {
> >   * @dev:		struct device of this controller
> >   * @acpi_dma_xlate:	callback function to find a suitable channel
> >   * @data:		private data used by a callback function
> > + * @base_request_line:	first supported request line (CSRT)
> > + * @end_request_line:	last supported request line (CSRT)
> okay here it is, can you add the width here as well

You mean the width from FixedDMA descriptor?

If yes, then I think it does not belong here. This stuff is for controllers
and FixedDMA belongs to the clients. It can be differrent for each FixedDMA
descriptor for each client (although we have only seen 32-bit widhts
currently).

> >   */
> >  struct acpi_dma {
> >  	struct list_head	dma_controllers;
> > @@ -44,6 +46,8 @@ struct acpi_dma {
> >  	struct dma_chan		*(*acpi_dma_xlate)
> >  				(struct acpi_dma_spec *, struct acpi_dma *);
> >  	void			*data;
> > +	unsigned short		base_request_line;
> > +	unsigned short		end_request_line;
> how do you define these two?

It is the range of request lines assigned for each controller, if that is
what you asked. In ACPI 5 it is the request line in FixedDMA descriptor
that is used to locate the right controller. The request line should be
unique accross the platform.

> >  };
> >  
> >  /* Used with acpi_dma_simple_xlate() */
> > -- 
> > 1.8.2.rc0.22.gb3600c3
> > 
