Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbaDHK2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 06:28:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:25719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbaDHK2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:28:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,817,1389772800"; 
   d="scan'208";a="509160026"
Date: Tue, 8 Apr 2014 13:30:06 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: "Du, Wenkai" <wenkai.du@intel.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Message-ID: <20140408103006.GQ19349@intel.com>
References: <20140404181613.GB19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
 <20140404184232.GC19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
 <20140405061316.GF19349@intel.com>
 <20140406185818.3aaca03d@alan.etchedpixels.co.uk>
 <20140407090403.GG19349@intel.com>
 <20140407154252.6b8f0f7e@alan.etchedpixels.co.uk>
 <20140407151107.GL19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A72207@ORSMSX109.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A72207@ORSMSX109.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 07:48:02PM +0300, Du, Wenkai wrote:
> > -----Original Message-----
> > From: Westerberg, Mika
> > Sent: Monday, April 07, 2014 8:11 AM
> > To: One Thousand Gnomes
> > Cc: Du, Wenkai; linux-i2c@vger.kernel.org; Wolfram Sang; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller enable
> > 
> > 
> > Do you think we can fix it with adding a dummy read right after write to the mask register, like
> > the snippet below?
> > 
> > diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-
> > core.c
> > index 14c4b30d4ccc..ff9090381d8b 100644
> > --- a/drivers/i2c/busses/i2c-designware-core.c
> > +++ b/drivers/i2c/busses/i2c-designware-core.c
> > @@ -535,6 +535,7 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
> >  		intr_mask = 0;
> > 
> >  	dw_writel(dev, intr_mask,  DW_IC_INTR_MASK);
> > +	dw_readl(dev, DW_IC_INTR_MASK);
> >  }
> > 
> 
> I have tried this read back earlier during debugging, it didn't help. You
> can confirm yourself as well.

I mean that it helps for the posted writes to the mask register issue, Alan
pointed out.

> On the ISR code execution path, here is the list to my understanding:
> 
> 1. TX abort: this path masks all interrupt by writing 0 to interrupt mask register;
> 2. RX full: this path doesn't do anything on masking interrupts;
> 3. TX empty: this path only mask TX empty under certain conditions; it
> doesn't mask other interrupt sources;
> 4. i2c STOP condition: this path call complete() to finish the transfer;
> it doesn't do anything on masking interrupts;

You are right.

The driver enables the controller and then unmasks following interrupt
sources:

	DW_IC_INTR_RX_FULL
	DW_IC_INTR_TX_EMPTY
	DW_IC_INTR_TX_ABRT
	DW_IC_INTR_STOP_DET

This will immediately trigger TX_EMPTY interrupt and the transfer begins.
If it finishes successfully, the driver only clears DW_IC_INTR_TX_EMPTY and
disables the controller. In Subsequent transfers the same happens and it
seems to work fine (as we have the controller disabled whenever we are done
with the transfer).

I'm not sure I agree that this is the best approach but like I said, it
seems to work just fine.

Except when we resume after suspend when the controller is reset. This will
mess up the "expected" mask and trigger interrupt immediately when the
controller is enabled in i2c_dw_xfer_init().

> The above analysis agrees with the debug logs: most of interrupts are
> left unmasked in original code when i2c core is being enabled.

Yes, but only after resume. In normal cases the driver re-programs
DW_IC_INTR_TX_EMPTY to the mask (the other 3 flags are already set but
they should be harmless as long as the TX fifo is still empty).

> I think we want all interrupts masked when enabling HW. This will ensure
> the required 25us core turn on delay being respected. Also there could be
> spurious interrupts when HW is being turned on that should be ignored.

Where did you get this 25us required delay? My spec doesn't say anything
about that. It does however say that if the state bit is not yet changed,
wait 25us (@400kHz) and re-read the bit. So it can be that we don't wait at
all once we toggle that bit.

All in all, I think we can solve this resume path timeout issue, by moving
__i2c_dw_enable() to be last in i2c_dw_xfer_init().

In addition we should fix the potential posted-write problem Alan pointed
out (as a separate patch). That could actually explain the issue you have
seen where timeout occurs during normal operation. Maybe fix here is to
mask all interrupts at the end of the ISR and make sure that possible
posted writes gets flushed to the hardware before returning?
