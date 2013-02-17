Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab3BQKo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 05:44:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab3BQKo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 05:44:26 -0500
Date: Sun, 17 Feb 2013 07:44:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 07/13] edac: add support for raw error reports
Message-ID: <20130217074404.05786692@redhat.com>
In-Reply-To: <20130216165748.GC27207@pd.tnic>
References: <cover.1360931635.git.mchehab@redhat.com>
	<e08f797b129a50b4e1b39e8c31bff82904aea65d.1360931635.git.mchehab@redhat.com>
	<20130215141330.GF14387@pd.tnic>
	<20130215132530.4f3b7dab@redhat.com>
	<20130215154123.GH14387@pd.tnic>
	<20130215134929.3909cfa2@redhat.com>
	<20130215160257.GK14387@pd.tnic>
	<20130215162029.3bcbf50a@redhat.com>
	<20130216165748.GC27207@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 16 Feb 2013 17:57:48 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Fri, Feb 15, 2013 at 04:20:29PM -0200, Mauro Carvalho Chehab wrote:
> > Yeah, pre-allocating a buffer is something that it was on my plans. It
> > seems it is time to do it in a clean way. I prefer to keep this as a
> > separate patch from 07/13, as it has a different rationale, and mixing
> > with 07/13 would just mix two different subjects.
> >
> > Also, having it separate helps reviewing.
> 
> Yep.
> 
> > ---
> > 
> > [PATCH] edac: put all arguments for the raw error handling call into a struct
> > 
> > The number of arguments for edac_raw_mc_handle_error() is too big;
> > put them into a structure and allocate space for it inside
> > edac_mc_alloc().
> > 
> > That reduces a lot the stack usage and simplifies the raw API call.
> > 
> > Tested with sb_edac driver and MCE error injection. Worked as expected:
> > 
> > [  143.066100] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
> > [  143.086424] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
> > [  143.106570] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
> > [  143.126712] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> > index 9c5da11..9cf33a5 100644
> > --- a/drivers/edac/edac_core.h
> > +++ b/drivers/edac/edac_core.h
> > @@ -454,21 +454,20 @@ extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
> >  extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
> >  				      unsigned long page);
> >  
> > +static inline void edac_raw_error_desc_clean(struct edac_raw_error_desc *e)
> > +{
> > +	int offset = offsetof(struct edac_raw_error_desc, grain);
> > +
> > +	*e->location = '\0';
> > +	*e->label = '\0';
> 
> Why the special handling? Why not memset the whole thing?

We don't want to clean the pointers for the allocated area, just to
clean the strings.

> 
> > +
> > +	memset(e + offset, 0, sizeof(*e) - offset);
> > +}
> > +
> > +
> >  void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
> > -			  struct mem_ctl_info *mci,
> > -			  long grain,
> > -			  const u16 error_count,
> > -			  const int top_layer,
> > -			  const int mid_layer,
> > -			  const int low_layer,
> > -			  const unsigned long page_frame_number,
> > -			  const unsigned long offset_in_page,
> > -			  const unsigned long syndrome,
> > -			  const char *msg,
> > -			  const char *location,
> > -			  const char *label,
> > -			  const char *other_detail,
> > -			  const bool enable_per_layer_report);
> > +			      struct mem_ctl_info *mci,
> > +			      struct edac_raw_error_desc *e);
> >  
> >  void edac_mc_handle_error(const enum hw_event_mc_err_type type,
> >  			  struct mem_ctl_info *mci,
> > diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> > index 8fddf65..d72853b 100644
> > --- a/drivers/edac/edac_mc.c
> > +++ b/drivers/edac/edac_mc.c
> > @@ -42,6 +42,12 @@
> >  static DEFINE_MUTEX(mem_ctls_mutex);
> >  static LIST_HEAD(mc_devices);
> >  
> > +/* Maximum size of the location string */
> > +#define LOCATION_SIZE 80
> > +
> > +/* String used to join two or more labels */
> > +#define OTHER_LABEL " or "
> > +
> >  /*
> >   * Used to lock EDAC MC to just one module, avoiding two drivers e. g.
> >   *	apei/ghes and i7core_edac to be used at the same time.
> > @@ -232,6 +238,11 @@ static void _edac_mc_free(struct mem_ctl_info *mci)
> >  		}
> >  		kfree(mci->csrows);
> >  	}
> > +
> > +	/* Frees the error report string area */
> > +	kfree(mci->error_event.location);
> > +	kfree(mci->error_event.label);
> > +
> >  	kfree(mci);
> >  }
> >  
> > @@ -445,6 +456,12 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
> >  		}
> >  	}
> >  
> > +	/* Allocate memory for the error report */
> > +	mci->error_event.location = kmalloc(LOCATION_SIZE, GFP_KERNEL);
> > +	mci->error_event.label = kmalloc((EDAC_MC_LABEL_LEN + 1 +
> > +					 sizeof(OTHER_LABEL)) * mci->tot_dimms,
> > +					 GFP_KERNEL);
> 
> I see, those are separate strings. Why not embed them into struct
> edac_raw_error_desc? This would simplify the whole buffer handling even
> more and you won't need to kmalloc them.

We could do it for the location. The space for label, however, depends on
how many DIMMs are in the system, as multiple dimm's may be present, and
the core will point to all possible affected DIMMs.

Ok, perhaps we could just allocate one big area for it (like one page), 
as this would very likely be enough for it, and change the logic to take
the buffer size into account when filling it.

> Also just FYI, everytime you do kmalloc, you need to handle the case
> where it returns an error.

Yeah, I forgot to add the error handling logic.

> [ … ]
> 
> > @@ -1174,18 +1162,26 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
> >  			  const char *msg,
> >  			  const char *other_detail)
> >  {
> > -	/* FIXME: too much for stack: move it to some pre-alocated area */
> > -	char location[80];
> > -	char label[(EDAC_MC_LABEL_LEN + 1 + sizeof(OTHER_LABEL)) * mci->tot_dimms];
> >  	char *p;
> >  	int row = -1, chan = -1;
> >  	int pos[EDAC_MAX_LAYERS] = { top_layer, mid_layer, low_layer };
> >  	int i;
> > -	long grain;
> > -	bool enable_per_layer_report = false;
> > +	struct edac_raw_error_desc *e = &mci->error_event;
> >  
> >  	edac_dbg(3, "MC%d\n", mci->mc_idx);
> >  
> > +	/* Fills the error report buffer */
> > +	edac_raw_error_desc_clean(e);
> > +	e->error_count = error_count;
> > +	e->top_layer = top_layer;
> > +	e->mid_layer = mid_layer;
> > +	e->low_layer = low_layer;
> > +	e->page_frame_number = page_frame_number;
> > +	e->offset_in_page = offset_in_page;
> > +	e->syndrome = syndrome;
> > +	e->msg = msg;
> > +	e->other_detail = other_detail;
> 
> Btw, this could be simplified even further if we would've made it like
> this from the get-go: if lowlevel EDAC drivers would populate the buffer
> already, we wouldn't need to do that copying again. And, it is ironic
> but I did that already in amd64_edac - see __log_bus_error, where I have
> an amd64_edac-specific struct err_info descriptor which is being handed
> off up.
> 
> Oh well, maybe something for later.

I agree, but this is a separate patch, IMHO. It will require to change the
logic again on all drivers, and re-test compilation on all supported archs.

> [ … ]
> 
> > @@ -1302,14 +1297,9 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
> >  			     edac_layer_name[mci->layers[i].type],
> >  			     pos[i]);
> >  	}
> > -	if (p > location)
> > +	if (p > e->location)
> >  		*(p - 1) = '\0';
> >  
> > -	edac_raw_mc_handle_error(type, mci, grain, error_count,
> > -				 top_layer, mid_layer, low_layer,
> > -				 page_frame_number, offset_in_page,
> > -				 syndrome,
> > -				 msg, location, label, other_detail,
> > -				 enable_per_layer_report);
> > +	edac_raw_mc_handle_error(type, mci, e);
> 
> Ok, now this hunk looks nice. :-)
> 
> [ … ]
> 
> > diff --git a/include/linux/edac.h b/include/linux/edac.h
> > index 28232a0..7f929c3 100644
> > --- a/include/linux/edac.h
> > +++ b/include/linux/edac.h
> > @@ -555,6 +555,46 @@ struct errcount_attribute_data {
> >  	int layer0, layer1, layer2;
> >  };
> >  
> > +/**
> > + * edac_raw_error_desc - Raw error report structure
> > + * @grain:			minimum granularity for an error report, in bytes
> > + * @error_count:		number of errors of the same type
> > + * @top_layer:			top layer of the error (layer[0])
> > + * @mid_layer:			middle layer of the error (layer[1])
> > + * @low_layer:			low layer of the error (layer[2])
> > + * @page_frame_number:		page where the error happened
> > + * @offset_in_page:		page offset
> > + * @syndrome:			syndrome of the error (or 0 if unknown or if
> > + * 				the syndrome is not applicable)
> > + * @msg:			error message
> > + * @location:			location of the error
> > + * @label:			label of the affected DIMM(s)
> > + * @other_detail:		other driver-specific detail about the error
> > + * @enable_per_layer_report:	if false, the error affects all layers
> > + *				(typically, a memory controller error)
> > + */
> > +struct edac_raw_error_desc {
> > +	/*
> > +	 * NOTE: everything before grain won't be cleaned by
> > +	 * edac_raw_error_desc_clean()
> > +	 */
> > +	char *location;
> > +	char *label;
> > +	long grain;
> > +
> > +	/* the vars below and grain will be cleaned on every new error report */
> > +	u16 error_count;
> > +	int top_layer;
> > +	int mid_layer;
> > +	int low_layer;
> > +	unsigned long page_frame_number;
> > +	unsigned long offset_in_page;
> > +	unsigned long syndrome;
> > +	const char *msg;
> > +	const char *other_detail;
> > +	bool enable_per_layer_report;
> > +};
> > +
> >  /* MEMORY controller information structure
> >   */
> >  struct mem_ctl_info {
> > @@ -663,6 +703,12 @@ struct mem_ctl_info {
> >  	/* work struct for this MC */
> >  	struct delayed_work work;
> >  
> > +	/*
> > +	 * Used to report an error - by being at the global struct
> > +	 * makes the memory allocated by the EDAC core
> > +	 */
> > +	struct edac_raw_error_desc error_event;
> 
> I think 'error_desc' is clearer. This way you can refer to it everywhere
> with mci->error_desc and you know what it is. ->error_event is kinda
> ambiguous IMHO.

Ok, I'll replace it.


-- 

Cheers,
Mauro
