Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaHXNaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 09:30:19 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33435 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaHXNaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 09:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <53F8AED8.8010908@roeck-us.net>
References: <1408741894-24879-1-git-send-email-atull@opensource.altera.com>
	<1408741894-24879-3-git-send-email-atull@opensource.altera.com>
	<20140822214546.GD24407@sirena.org.uk>
	<53F8AED8.8010908@roeck-us.net>
Date: Sun, 24 Aug 2014 08:30:16 -0500
Message-ID: <CANk1AXTt1fo5M+QrDEa44t=z-PKvweDXQ3fi9fAJSKbznW-giA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] pmbus: ltc2978: add regulator gating
From: Alan Tull <delicious.quinoa@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Brown <broonie@kernel.org>, atull <atull@opensource.altera.com>,
        jdelvare@suse.de, lm-sensors@lm-sensors.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 10:10 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 08/22/2014 02:45 PM, Mark Brown wrote:
>>
>> On Fri, Aug 22, 2014 at 04:11:34PM -0500, atull@opensource.altera.com
>> wrote:
>>>
>>> From: Alan Tull <atull@opensource.altera.com>
>>>
>>> Add regulator with support for enabling or disabling all
>>> supplies.
>>
>>
>> Reviwed-by: Mark Brown <broonie@linaro.org>
>>
>> though it still looks like you should be able to create generic
>> functions for the operations.
>>
> Sorry I didn't have time to review the code myself. I'll have
> to check the datasheet about turning regulators on and off.
> Using page 0xff for the lm2978 looks wrong, as the chip supports
> up to 8 channels which should be controlled separately
> (I would assume) instead of turning them all on and off in
> one go. Maybe I am missing something, but my assumption would
> have been to have a separate regulator for each channel, and
> that each channel would have its own regulator which would be
> turned on and off separately. So I don't really understand the
> change between v1 and v2 of the core patch, which dropped the
> per-channel regulators. Someone will have to explain to me
> why that makes sense, especially since it means that I won't
> be able to use the regulator expansion in my system (which
> would require per-channel regulators, and which does not always
> have all channels enabled on a given chip).

The LTC2978 spec says that the OPERATION command register "responds to
the global page command (PAGE=0xFF)."  I originally took it to mean
that it *only* responds to 0xFF.  Now I get that yes I could turn
on/off each of 8 channels separately.

I will make the change have one regulator for each supply.  It would
be useful to still have a global regulator for turning them all on/off
together if that is not completely odious.

>
> In respect to generic functions, that really depends on the scope
> of the regulators. As written, where all regulators are turned on
> in a single operation, per-chip functions are needed. I thought
> we would only need per-chip configuration values, but that only
> applies if regulators are turned on one by one, not all in one go.

For all the parts supported by ltc2978.c, a banked write of 0x80 to
the OPERATION register turns a regulator on, writing 0x00 turns it
off.  I'm not sure how universal that is for other PMBUS parts.  I
will look at the PMBUS specs when I get back to the office Tuesday.

I'll look into it and see if I can push almost all of this code into
pmbus_core.c and just have per-chip config values in
pmbus_driver_info.   If many PMBUS parts have the same scheme (0x80 or
0x00 written to OPERATION register as a banked write) then  a flag bit
that is turned on in pmbus_driver_info could enable this scheme for
this chip.  If it is a different register or different on/off values,
then I'll need to add those to pmbus_driver_info.
>
> Either case, a wrapper for ltc2978_write_pmbus_operation needs to
> be added to pmbus_core.c as pmbus_write_byte_data and exported
> (as a separate patch). For paged reads, the existing
> pmbus_read_byte_data should be used. In general, avoid direct
> accesses to paged registers and use API functions instead
> if possible.

OK.  Will add pmbus_write_byte_data as a separate patch and use the
existing pmbus_read_byte_data.

Thanks for the review!

Alan

>
> Thanks,
> Guenter
>
