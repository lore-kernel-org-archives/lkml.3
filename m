Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaFPQFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:05:00 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.137]:61815 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857AbaFPQE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:04:57 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 12:04:57 EDT
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-3.tower-178.messagelabs.com!1402934313!28781388!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH 4/8] iio: Add support for DA9150 GPADC
Thread-Topic: [PATCH 4/8] iio: Add support for DA9150 GPADC
Thread-Index: AQHPhWXnsW9Hzw1urUGbXZZXqpSfwZtykp4AgAEsJ/A=
Date: Mon, 16 Jun 2014 15:58:33 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB4FD9C7@SW-EX-MBX01.diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
 <3c1a7551c7deaeccdca731fa95f4349c57e04249.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
 <539DFFC8.3080406@kernel.org>
In-Reply-To: <539DFFC8.3080406@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5GG57sf032083

On June 15, 2014 21:19, Jonathon Cameron wrote:

> Hi Adam
> 
> Reasonably clean code, but the _ channels stuff doesn't comply with the ABI
> and is rather confusing.

To be honest I did debate this in my head for a while. The reason I went with
the current approach was to make the driver channel layout match that of the 
datasheet for the device. Sounds like it wasn't the correct direction though.

> If it really does make sense to allow reading these channels at different
> ranges (presumably to enhance the effective adc resolution) then we need
> to control this via existing ABIs. Controlling it via scale with a
> range attribute if required (read only but changes with whatever the
> scale attribute it set to).

Yes, with smaller range then you get a better degree of accuracy. Ok, will have
a look at this and see if I can improve things based on your comments.

> Often, for slow parts at least it makes little sense to have provide
> software support for variable input ranges.
> 
> Looking at what is covered, is it the case that only one option will make
> sense for a given hardware setup? (cover the required range and nothing more).
> 
> If so, perhaps this wants to go into the device tree or similar?

Possibly. Having read your comments further on though, and given that
it seems reasonable to use the range/scale attribute to choose the resolution,
I'd prefer to opt for that approach (seems more flexible).

> Please get rid of excess white space and comments that just tell you
> something obvious about the code following them.

Preferably I'd like to keep it this way as I think it makes the code
easier to read, but if you're dead against it then I'll remove them.

> Linear in the coeeficients, so fine for raw output with a scale and offset.

Ok will have a look at re-working this as per your comment.

> Ah, so here is your reasoning behind the 'interesting' underscore channels.
> This is just doing different range checks on the channel?  If so allow one
> at a time and provide a writable scale info_mask element to control which
> is used..
> 
> Looks like there are only thes two channels doing this, so shouldn't be
> too hard to support it via more conventional means.

The GPIO, VBUS and VSYS related channels provide different ranges. I guess they
should all follow the same approach for implementing this alternate range. So I
will assume that for the 'repeat' channels where the same raw value is provided
on both the _ and non _ channels only one channel should be provided.

> Don't use the |=, just = and you can't avoid assigning reg above.
> Actually, it's not complex enough that you couldn't just do it directly into
> the write function and skip this local variable.

Ok fine. Will update to tidy up.

> Unlock first, then check for error.

Yep. Makes sense. Will update.

> The mixture of having defs here for the shift.
> > +	/* MSBs - 8 bits */
> > +	result |= result_regs[0] << 2;
> and not here is inconsistent.  I honestly don't mind which way, but
> just use one style.
> 
> You could just use an endian conversion and shift the combined 16bit result

Fair point. Will make this cleaner.

> It very rarely makes sense to provide both raw and processed interfaces.
> If the transform is nasty and non linear then userspace won't have the info
> to do anything with it.  If the transform is linear, then provide scale
> and offset and let userspace perform the computation.

The charger module uses certain channels for its readings, and to me it makes
more sense for that calculation to be done by the GPADC. However having looked
at the inkern.c framework code it looks like if you request a processed channel
and it's doesn't provide that feature, then the code drops to linear scaling if
possible to provide the processed value. I take it this is the preferred
approach then? Just thought it was more consistent to see the calculation using
dedicated functions (processed channel approach).

> Get rid of this comment and any other ones that don't add any
> actual information.  Also this is single line comment, please
> check the comment syntax.

As per previous comment on this topic.

> Why a blank line here.

Accidental. Will remove it.

> The device register call is the one that exposes userspace interfaces. As
> a general rule it wants to be the last thing in probe as everything
> else should be setup first.

Ok, that's something I missed. Will make the change.

> > +#include <linux/iio/machine.h>
> This isn't used in the header, so should be included in the c file, not here.

Yes, is something I meant to remove during development increments. Consider it
gone.

> > +#include <linux/mfd/da9150/core.h>
> Having moved the struct definition into the c file
> this header include will not want to be here.

I personally would prefer a separate header for the definitions as I believe
this is tidier. Have never really liked struct definitions in c files. I could
move this header to the same directory as the source file, if that is preferred.
As it stands this header is only related to DA9150 in its current location, so
is this a big issue? If not then I'd rather keep it as is.

> > +/* Private data */
> Why is this in the header?  Should be defined directly in the c file
> as nothing outside the driver should be touching it.

As per previous comment.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
