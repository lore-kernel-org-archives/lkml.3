Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3H3UsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:48:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35994 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3H3UsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:48:17 -0400
Subject: Re: [PATCH v4 3/5] clk: dt: binding for basic multiplexer clock
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20130830203334.10934.10011@quantum>
Date: Fri, 30 Aug 2013 15:48:30 -0500
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Tero Kristo <t-kristo@ti.com>,
        =?iso-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        devicetree@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2B0F4B98-5738-48FF-BE30-36115FFCFF0C@codeaurora.org>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org> <1377150793-27864-4-git-send-email-mturquette@linaro.org> <2A930389-012E-45C3-93EB-6B4A41DB2EF5@codeaurora.org> <20130829011425.8231.78802@quantum> <39BAF1F8-41AD-4667-BF76-22BDF709415A@codeaurora.org> <20130830203334.10934.10011@quantum>
To: Mike Turquette <mturquette@linaro.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 30, 2013, at 3:33 PM, Mike Turquette wrote:

> Quoting Kumar Gala (2013-08-30 13:02:42)
>> On Aug 28, 2013, at 8:14 PM, Mike Turquette wrote:
>> 
>>> Quoting Kumar Gala (2013-08-28 08:50:10)
>>>> On Aug 22, 2013, at 12:53 AM, Mike Turquette wrote:
>>>> 
>>>>> Device Tree binding for the basic clock multiplexer, plus the setup
>>>>> function to register the clock.  Based on the existing fixed-clock
>>>>> binding.
>>>>> 
>>>>> Includes minor beautification of clk-provider.h where some whitespace is
>>>>> added and of_fixed_factor_clock_setup is relocated to maintain a
>>>>> consistent style.
>>>>> 
>>>>> Tero Kristo contributed helpful bug fixes to this patch.
>>>>> 
>>>>> Signed-off-by: Mike Turquette <mturquette@linaro.org>
>>>>> Tested-by: Heiko Stuebner <heiko@sntech.de>
>>>>> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
>>>>> ---
>>>>> Changes since v3:
>>>>> * replaced underscores with dashes in DT property names
>>>>> * bail from of clock setup function early if of_iomap fails
>>>>> * removed unecessary explict cast
>>>>> 
>>>>> .../devicetree/bindings/clock/mux-clock.txt        | 79 ++++++++++++++++++++++
>>>>> drivers/clk/clk-mux.c                              | 68 ++++++++++++++++++-
>>>>> include/linux/clk-provider.h                       |  5 +-
>>>>> 3 files changed, 150 insertions(+), 2 deletions(-)
>>>>> create mode 100644 Documentation/devicetree/bindings/clock/mux-clock.txt
>>>>> 
>>>>> diff --git a/Documentation/devicetree/bindings/clock/mux-clock.txt b/Documentation/devicetree/bindings/clock/mux-clock.txt
>>>>> new file mode 100644
>>>>> index 0000000..21eb3b3
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/clock/mux-clock.txt
>>>>> @@ -0,0 +1,79 @@
>>>>> +Binding for simple mux clock.
>>>>> +
>>>>> +This binding uses the common clock binding[1].  It assumes a
>>>>> +register-mapped multiplexer with multiple input clock signals or
>>>>> +parents, one of which can be selected as output.  This clock does not
>>>>> +gate or adjust the parent rate via a divider or multiplier.
>>>>> +
>>>>> +By default the "clocks" property lists the parents in the same order
>>>>> +as they are programmed into the regster.  E.g:
>>>>> +
>>>>> +     clocks = <&foo_clock>, <&bar_clock>, <&baz_clock>;
>>>>> +
>>>>> +results in programming the register as follows:
>>>>> +
>>>>> +register value               selected parent clock
>>>>> +0                    foo_clock
>>>>> +1                    bar_clock
>>>>> +2                    baz_clock
>>>>> +
>>>>> +Some clock controller IPs do not allow a value of zero to be programmed
>>>>> +into the register, instead indexing begins at 1.  The optional property
>>>>> +"index-starts-at-one" modified the scheme as follows:
>>>>> +
>>>>> +register value               selected clock parent
>>>>> +1                    foo_clock
>>>>> +2                    bar_clock
>>>>> +3                    baz_clock
>>>>> +
>>>>> +Additionally an optional table of bit and parent pairs may be supplied
>>>>> +like so:
>>>>> +
>>>>> +     table = <&foo_clock 0x0>, <&bar_clock, 0x2>, <&baz_clock, 0x4>;
>>>>> +
>>>> 
>>>> I think this is going way too far for what should be in a device tree.  Why should this not just be encoded in tables in the code?
>>> 
>>> To reduce kernel data bloat.
>> 
>> Why is this really an issue, for systems that are concerned about kernel size, they are going to be built targeting the HW platform of choice, for one's like a server, the bloat isn't going to be significant, and if so we can look at mechanisms like __init section that would free up after boot.
> 
> s/bloat/churn/
> 
> The clock _data_ seems to always have some churn to it. Moving it out to
> DT reduces that churn from Linux. My concern above is not about kernel
> data size.

And we have numerous concerns about DTs be non-changeable on shipping systems where kernels still seem to be viewed as acceptable to change.

Not sure I really get this argument about churn.  The churn still exists you've just shifted it.

>>> The mux-clock binding covers a quite a few platforms that have similar
>>> mux-clock programming requirements. If the DT binding is verbose enough
>>> then the basic mux clock driver is sufficient to initialize all of the
>>> mux clocks from DT: no new platform-specific clock driver with a bunch
>>> of data is necessary.
>> 
>> The same could be said of just embedded this info in a C struct that is well known, I don't need the data in the dt for bits and shifts.
>> 
>>> On the other hand if we rely on tables in C to define how mux-clock
>>> parents are selected then every platform will have to write their own
>>> clock driver just to define their clock data.
>> 
>> Why?  If you can have a common mechanism in the device tree there isn't any reason you can't have a common struct that looks similar in C.
>> 
>>> Having drivers written for the sole purpose of listing out a bunch of
>>> data sounds like something that DT was meant to solve, even if this
>>> isn't at the board level and is at the SoC level.
>> 
>> I just don't see the need for the data to be in the DT.  You can get the same goal w/a standard struct defined in C.
> 
> Absolutely you could put this stuff in C. Originally all of the clock
> registration mechanisms in the common clock implementation assumed
> static data in the kernel. That's how it used to be.
> 
> However DT came along to ARM and the clock framework and these "clock
> mapping" bindings started popping up, which are fragile. Adding a clock
> requires changes both to the DT binding AND to the kernel. That sucks.

Sure, we learn things as we see more patterns from how different implementations work.  It seems like you've figured out a good pattern, just don't see why it would need to be in the DT.

> Once again I'll point out that this binding (mux-clock) makes it so that
> devices with simpler clock trees do not need to merge any code into the
> kernel. What value does device tree bring to me if for every platform
> with 8 clocks I have to write a new Linux clock driver with that static
> data in it? That also sucks. In that case DT brings almost zero value,
> with the exception of linking clock phandles to clock consumers, which
> clkdev had been doing for us already.

Do you believe that we will ever get to a point that a new SoC will be supported w/o some new coded added into the kernel?  I don't see that ever happening for embedded systems.

I think this is about where to draw the line, I just very concerned about the pandora's box this potentially opens up.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

