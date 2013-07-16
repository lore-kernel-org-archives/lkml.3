Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3GPLQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:16:37 -0400
Received: from mail.abilis.ch ([195.70.19.74]:17793 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab3GPLQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:16:34 -0400
Date: Tue, 16 Jul 2013 13:16:18 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Shinya Kuribayashi <skuribay@pobox.com>
Cc: mika.westerberg@linux.intel.com, linux-i2c@vger.kernel.org,
        wsa@the-dreams.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
Message-ID: <20130716111616.GA25835@ab42.lan>
References: <20130708134216.GB6402@ab42.lan>
 <20130709084402.GF4898@intel.com>
 <20130709161927.GC30236@ab42.lan>
 <20130710105215.GY4898@intel.com>
 <20130710165634.GA30693@ab42.lan>
 <20130711073600.GG4898@intel.com>
 <20130711101330.GP4898@intel.com>
 <51DFB6C1.4040001@pobox.com>
 <20130712085140.GY4898@intel.com>
 <51E0E76B.1040304@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E0E76B.1040304@pobox.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 02:36:43PM +0900, Shinya Kuribayashi wrote:
> Hi,
> 
> Now I've had a look at the whole discussion.
> 
> Basically, DW I2C core provides a good enough (and quite direct) way
> to control tHIGH and tLOW timing specs, *HCNT and *LCNT registers.
> 
> But from my experience (with a slightly old version of DW I2C core
> around 2005, version 1.06a or so), DW I2C core was apparently lacking
> in an appropriate hardware mechanism to meet tHD;STA timing spec.  We
> then found that we could meet tHD;STA by increasing *HCNT values, so
> that's what currently we have in i2c-designware.c  I know with that
> workaround applied, tHIGH is to be configured with a larger value
> than necessary, but we have no choice.  For I2C bus systems, we must
> meet every timing constraint strictly as required.  If DW I2C core
> cannot meet tHD;STA without the sacrifice of tHIGH, and I would call
> it a hardware bug.

I agree. However, tHD;STA [min] is defined to the same value as tHIGH
[min] for all modes in the I2C specification. Do I understand you
correctly that the SCL_HCNT parameters control at the same time tHIGH
and tHD;STA?

Concerning SDA_HOLD_TIME, we have done a few measurements in our lab and
it looks like the delay between the falling edge clock of the start
condition and the rising edge of the first data bit of the start byte is
controlled by this parameter. I conclude that in the drawing below (1)
is controlled by SCL_HCNT whereas (2) is controlled by SDA_HOLD_TIME.

     _________
scl           \__________ ...
     ___           ______
sda     \_________/       ...

        |-----|---|
          (1)  (2)

> On Wed, Jul 10, 2013 at 06:56:35PM +0200, Christian Ruppert wrote:
> >>If I understand the above, it leaves Tf and Tr to be PCB specific and then
> >>these values are passed to the core driver from platform data, right?
> >
> >That would be the idea: Calculate Th' and Tl' in function of the desired
> >clock frequency and duty cycle and then adapt these values using
> >measured transition times.
> 
> I think this would be a good solution.
> 
> On 7/8/13 10:42 PM, Christian Ruppert wrote:
> >Anyway, the HCNT, LCNT and SDA hold time values we get from ACPI SSCN/FMCN
> >methods are measured by our HW guys on a certain board and they have
> >verified that using those we meet all the I2C timing specs.
> >
> >In order to take advantage of those we need some way to pass those values
> >to the i2c designware core. I have two suggestions:
> >
> >   - Use the method outlined in this patch and let the interface driver
> >     override *CNT values.
> 
> With *HCNT and *LCNT registers, we can control tHIGH, tLOW, tHD;STA
> quite accurately.  On the other hand, what we can't control with DW
> I2C core is tr and tf.  I assumed that it could never be longer than
> 300nsec (it's defined as a max. in the I2C specification), so I used
> it for calculation.
> 
> I agree that tr and tf are PCB specific, and it would a good first
> step toward timing optimization to make them configurable through
> platform data.
> 
> Second step is that if current i2c_dw_scl_hcnt and i2c_dw_scl_lcnt
> calculations don't suit with later DW I2C cores, then it would be
> nice for someone who can access to the data book to update formulas,
> or provide alternative formulas and make them selectable depending
> on DW core versions.

I'm not having the impression there is a huge difference between the
different generations of DW blocks. Probably we can find one formula
that suits all blocks. We just have to be careful (in doubt rather
conservative) with the transition times. This seems to be currently
the case and if I understand Mika correctly, his objective is to remove
some of this conservatism.

> It always helps us to have a way to calculate *HCNT and *LCNT values
> automatically.  As said above, DW I2C core can control tHIGH, tLOW,
> tHD;STA, etc. quite _accurate_, if HCNT/LCNT values were calculated
> with proper formulas.  It also helps hardware people as well to
> provide reference HCNT/LCNT values.
> 
> And as a third step, if we want to use optimized HCNT/LCNT values
> which can not be obtained from proper formulas + user-requested
> tf/tr, or if we want to use HCNT/LCNT settings verified by vendors
> or provided from hardware team, then I'm fine with having a way to
> _override_ HCNT/LCNT values.  Such direct way might be useful.

I agree. Probably it is best to have both, a default method based on
formulas and timing parameters (the formulas are quite simple anyway)
which works with device tree and such and a second method based on
register values which works with mechanisms like ACPI.

Christian
