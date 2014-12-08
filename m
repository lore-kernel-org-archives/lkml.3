Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbaLHRNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:13:11 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:62559 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbaLHRNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:13:07 -0500
MIME-Version: 1.0
In-Reply-To: <20141208085202.GA13486@pengutronix.de>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
	<1418007589-3688-1-git-send-email-addy.ke@rock-chips.com>
	<20141208085202.GA13486@pengutronix.de>
Date: Mon, 8 Dec 2014 09:13:05 -0800
X-Google-Sender-Auth: GE59caOzqKJlzf9GzZx50o8QxI8
Message-ID: <CAD=FV=V=PDPiDhDmd+j8ePsF43EvuFP-LxKgMKo7ZRBzSMyOJA@mail.gmail.com>
Subject: Re: [PATCH v3] i2c: rk3x: fix bug that cause measured high_ns doesn't
 meet I2C spec
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Addy Ke <addy.ke@rock-chips.com>, Wolfram Sang <wsa@the-dreams.de>,
        Max Schwarz <max.schwarz@online.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tao Huang <huangtao@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jianqun Xu <xjq@rock-chips.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        caesar <caesar.wang@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Han Jiang <hj@rock-chips.com>, Shunqian Zheng <zhengsq@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 8, 2014 at 12:52 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> Hello Addy,
>
> On Mon, Dec 08, 2014 at 10:59:49AM +0800, Addy Ke wrote:
>> high_ns calculated from the low division of CLKDIV register is the sum
>> of actual measured high_ns and rise_ns. The rise time which related to
> I think "actual measured" is misleading here. (The driver doesn't
> dermine these parameters automatically, right?)
>
> Maybe something like the following is more correct and understandable?:
>
>         The number of clock cycles to be written into the XYZ register
>         that determines the i2c clk high phase includes the rise time.
>         So to meet the timing requirements defined in the i2c
>         specification which defines the minimal time SCL has to be high,
>         the rise time has to taken into account. The same applies to the
>         low phase with falling time.

I agree that the prose of the commit message could be cleaned up.  I
don't think English is Addy's primary language.  Your proposals sound
fine to me, though I would probably replace XYZ by "CLKDIV".  You
should capitalize I2C here, too.


>> external pull-up resistor can be up to the maximum rise time in I2C spec.
>>
>> In my test, if external pull-up resistor is 4.7K, rise_ns is about
> It would be nice to point out the actual board you used (if it's a
> publically available machine).

He probably tested on rk3288-pinky, which is not an upstream board yet.


>> 700ns. So the actual measured high_ns is about 3900ns, which is less
>> than 4000ns(the minimum high_ns in I2C spec).
> s/s(/s (/;
> s/spec/specification for Standard-mode/
>
> There are different capitalisation of i2c in the patch and the commit log. I
> don't know what Wolfram prefers here, but using the same spelling
> everywhere would be nice.

Can you please point out?  IIRC you should always capitalize I2C in
prose (descriptions, comments, documentation, etc).  However when used
in places which specific capitalization standards it should be
lowercase.  That means file names, directory names, device tree
property names, etc should be lower case.

I think Addy got it right in most cases and places where it's wrong
are probably my fault.  I think I missed a few in my patches.  :(


>> To fix this bug, min_low_ns should include fall time and min_high_ns
>> should include rise time too.
>>
>> This patch merged the patch that Doug submitted to chromium, which
> Isn't Chromium a web browser? Does it really contain i2c stuff?
> I bet it's about Chromium OS.

Chromium OS is part of the Chromium project.


>> +     (t(r) in i2c spec). If not specified this is assumed to be the max the
> s/spec/specification/; s/max/maximum/

This should have been I2C, not i2c (capital).


>> +     might cause slightly slower communication.
>> + - i2c-scl-falling-time-ns : Number of nanoseconds the signal takes to fall
>> +     (t(f) in the i2c0 spec).  If not specified this is assumed to be the
> s/i2c0/i2c/

Same here: I2C.


>>        * min_low_ns:  The minimum number of ns we need to hold low
>> -      *              to meet i2c spec
>> +      *              to meet i2c spec, should include fall time.
>>        * min_high_ns: The minimum number of ns we need to hold high
>> -      *              to meet i2c spec
>> +      *              to meet i2c spec, should include rise time.
>>        * max_low_ns:  The maximum number of ns we can hold low
>> -      *              to meet i2c spec
>> +      *              to meet i2c spec.

...and those should be I2C.


>>        *
>>        * Note: max_low_ns should be (max data hold time * 2 - buffer)
>>        *       This is because the i2c host on Rockchip holds the data line
>>        *       for half the low time.
>>        */
>>       if (scl_rate <= 100000) {
>                 /* Standard-mode */
>> -             min_low_ns = 4700;
>> -             min_high_ns = 4000;
>> -             max_data_hold_ns = 3450;
>> -             data_hold_buffer_ns = 50;
>> +             spec_min_low_ns = 4700;
>> +             spec_min_high_ns = 4000;
>> +             spec_max_data_hold_ns = 3450;
> The specification calls this "data valid time" (t_(VD;DAT)).

Could change this if need be, but the old code had it as "data hold".
Maybe we could argue about it in a future patch?


>> +             spec_data_hold_buffer_ns = 50;
> I didn't find this parameter in the spec, also it doesn't differ for
> Standard-mode vs. Fast-mode. What is this?

I believe I put it in an earlier bit of sample code when Addy was
worried about things being too close to the margins.  I'm not sure
what specifically Addy was worried about.  Maybe this should actually
be the falling time for data?

Again, this is not something new so perhaps we could debate in a future patch?


>> +     /* Read rise and fall ns; if not there use the default max from spec */
>> +     if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-rising-time-ns",
>> +                              &i2c->rise_ns)) {
>> +             if (i2c->scl_frequency <= 100000)
>> +                     i2c->rise_ns = 1000;
>> +             else
>> +                     i2c->rise_ns = 300;
>> +     }
>> +     if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-falling-time-ns",
>> +                              &i2c->fall_ns))
>> +             i2c->fall_ns = 300;
>> +
> I don't know if other drivers do the same (I assume they should). If so,
> moving this logic into the core would be nice. I guess this can still be
> done later.
>
> The i2c specification also has a minimum for t(r) and t(f). I don't know
> why these are limited, but I think it would be good to check for these
> limits, too.

One of these two properties is in another driver (the Designware one).
However, different hardware seems to take in different parameters for
I2C.  It seems like for now the best thing to do is to keep drivers
consistent.  If we notice a pattern then stuff should move to the
core.

-Doug
