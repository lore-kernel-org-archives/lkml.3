Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863AbaDJJCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:02:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:48710 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934647AbaDJJBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:01:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,833,1389772800"; 
   d="scan'208";a="518201139"
Date: Thu, 10 Apr 2014 12:08:26 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: "Du, Wenkai" <wenkai.du@intel.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Message-ID: <20140410090826.GW19349@intel.com>
References: <20140404184232.GC19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
 <20140405061316.GF19349@intel.com>
 <20140406185818.3aaca03d@alan.etchedpixels.co.uk>
 <20140407090403.GG19349@intel.com>
 <20140407154252.6b8f0f7e@alan.etchedpixels.co.uk>
 <20140407151107.GL19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A72207@ORSMSX109.amr.corp.intel.com>
 <20140408103006.GQ19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A73919@ORSMSX109.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A73919@ORSMSX109.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 02:45:54AM +0300, Du, Wenkai wrote:
> > -----Original Message-----
> > From: Westerberg, Mika
> > Sent: Tuesday, April 08, 2014 3:30 AM
> > To: Du, Wenkai
> > Cc: One Thousand Gnomes; linux-i2c@vger.kernel.org; Wolfram Sang; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller enable
> 
> > Yes, but only after resume. In normal cases the driver re-programs DW_IC_INTR_TX_EMPTY to
> > the mask (the other 3 flags are already set but they should be harmless as long as the TX fifo is
> > still empty).
> I have sent you failure traces in normal path. None of 4 interrupt
> sources was masked.  

OK, I went through it and can't explain why those are not masked :-( And I
can't reproduce this myself.

> > Where did you get this 25us required delay? My spec doesn't say anything about that. It does
> > however say that if the state bit is not yet changed, wait 25us (@400kHz) and re-read the bit.
> > So it can be that we don't wait at all once we toggle that bit.
> I believe the delay patch ("i2c-designware: enable/disable the controller
> properly") was from you? I would be happy to see the patch reverted if
> these delay are really not needed. 25us-250us delay 3 times (2 disable, 1
> enable) at every transfer slow down the bus too much.

It is enough to have IC_ENABLE_STATUS reporting the desired state. We want
to be sure that the hardware is properly enabled/disabled before doing
anything else that might need it to be in certain state. For example writes
to some registers succeed only when the controller is disabled.

The procedure is taken directly from the I2C DW databook IIRC.

> > All in all, I think we can solve this resume path timeout issue, by moving
> > __i2c_dw_enable() to be last in i2c_dw_xfer_init().
> This will invalidate 2 previous patches from you: " i2c-designware:
> enable/disable the controller properly" , and "i2c-designware: always
> clear interrupts before enabling them". Are you sure they can be all
> reverted?

No.

> > In addition we should fix the potential posted-write problem Alan pointed out (as a separate
> > patch). That could actually explain the issue you have seen where timeout occurs during normal
> > operation. Maybe fix here is to mask all interrupts at the end of the ISR and make sure that
> > possible posted writes gets flushed to the hardware before returning?
>
> But these patches attempt to fix "leaking" as we know of today. In my
> view, masking interrupts right before enable HW is still the best, which
> is common practice to most drivers. It is the spirit of the original
> driver as well: the original driver enables interrupts _after_ core
> enable. I think the author must have thought the interrupt have been
> disabled, otherwise why enable them again? Masking interrupts fixes all
> the known and unknown leaks and is future proof.

Yes, let's do that for now.

Unfortunately we still don't know why the issue you observed happens (the
suspend and normal operation failures). At least we can make sure that
whatever "leaks" doesn't prevent further transactions happening.

Can you resend this patch with a changelog that explains the resume issue?
Along the lines of:

 The default value after reset for DW_IC_INTR_MASK (interrupt mask
 register) is 0x8ff. When we start the first transaction after resuming
 from system sleep TX_EMPTY interrupt is already unmasked (because of the
 hardware default). This causes call to __i2c_dw_enable() to immediatelly
 start the transfer which leads to timeout...

or something similar. So that it is understood that it's the default value
that makes the driver to go astray.
