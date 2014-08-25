Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaHYRCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:02:17 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59072 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaHYRCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:02:16 -0400
Date: Mon, 25 Aug 2014 10:02:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Alan Tull <delicious.quinoa@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, atull <atull@opensource.altera.com>,
        jdelvare@suse.de, lm-sensors@lm-sensors.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 2/2] pmbus: ltc2978: add regulator gating
Message-ID: <20140825170210.GC14614@roeck-us.net>
References: <1408741894-24879-1-git-send-email-atull@opensource.altera.com>
 <1408741894-24879-3-git-send-email-atull@opensource.altera.com>
 <20140822214546.GD24407@sirena.org.uk>
 <53F8AED8.8010908@roeck-us.net>
 <CANk1AXTt1fo5M+QrDEa44t=z-PKvweDXQ3fi9fAJSKbznW-giA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANk1AXTt1fo5M+QrDEa44t=z-PKvweDXQ3fi9fAJSKbznW-giA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 08:30:16AM -0500, Alan Tull wrote:
> On Sat, Aug 23, 2014 at 10:10 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On 08/22/2014 02:45 PM, Mark Brown wrote:
> >>
> >> On Fri, Aug 22, 2014 at 04:11:34PM -0500, atull@opensource.altera.com
> >> wrote:
> >>>
> >>> From: Alan Tull <atull@opensource.altera.com>
> >>>
> >>> Add regulator with support for enabling or disabling all
> >>> supplies.
> >>
> >>
> >> Reviwed-by: Mark Brown <broonie@linaro.org>
> >>
> >> though it still looks like you should be able to create generic
> >> functions for the operations.
> >>
> > Sorry I didn't have time to review the code myself. I'll have
> > to check the datasheet about turning regulators on and off.
> > Using page 0xff for the lm2978 looks wrong, as the chip supports
> > up to 8 channels which should be controlled separately
> > (I would assume) instead of turning them all on and off in
> > one go. Maybe I am missing something, but my assumption would
> > have been to have a separate regulator for each channel, and
> > that each channel would have its own regulator which would be
> > turned on and off separately. So I don't really understand the
> > change between v1 and v2 of the core patch, which dropped the
> > per-channel regulators. Someone will have to explain to me
> > why that makes sense, especially since it means that I won't
> > be able to use the regulator expansion in my system (which
> > would require per-channel regulators, and which does not always
> > have all channels enabled on a given chip).
> 
> The LTC2978 spec says that the OPERATION command register "responds to
> the global page command (PAGE=0xFF)."  I originally took it to mean
> that it *only* responds to 0xFF.  Now I get that yes I could turn
> on/off each of 8 channels separately.
> 
> I will make the change have one regulator for each supply.  It would
> be useful to still have a global regulator for turning them all on/off
> together if that is not completely odious.
> 
> >
> > In respect to generic functions, that really depends on the scope
> > of the regulators. As written, where all regulators are turned on
> > in a single operation, per-chip functions are needed. I thought
> > we would only need per-chip configuration values, but that only
> > applies if regulators are turned on one by one, not all in one go.
> 
> For all the parts supported by ltc2978.c, a banked write of 0x80 to
> the OPERATION register turns a regulator on, writing 0x00 turns it
> off.  I'm not sure how universal that is for other PMBUS parts.  I
> will look at the PMBUS specs when I get back to the office Tuesday.
> 
It isn't. Other parts need a different value to be written for on/off.
However, that does not mean we need a chip specific _function_ to write
the values. All we should need is the values to write for on/off.

> I'll look into it and see if I can push almost all of this code into
> pmbus_core.c and just have per-chip config values in
> pmbus_driver_info.   If many PMBUS parts have the same scheme (0x80 or
> 0x00 written to OPERATION register as a banked write) then  a flag bit
> that is turned on in pmbus_driver_info could enable this scheme for
> this chip.  If it is a different register or different on/off values,
> then I'll need to add those to pmbus_driver_info.

Values should work, and the writes should all be banked, but a flag is
unfortunately insufficient. You should include a per-page flag to enable
the functionality (something like PMBUS_HAVE_REGULATOR). Some PMBus chips
don't have regulators on all pages.

> >
> > Either case, a wrapper for ltc2978_write_pmbus_operation needs to
> > be added to pmbus_core.c as pmbus_write_byte_data and exported
> > (as a separate patch). For paged reads, the existing
> > pmbus_read_byte_data should be used. In general, avoid direct
> > accesses to paged registers and use API functions instead
> > if possible.
> 
> OK.  Will add pmbus_write_byte_data as a separate patch and use the
> existing pmbus_read_byte_data.
> 
If you use per-page flags and values, you should not need those
at all.

Thanks,
Guenter
