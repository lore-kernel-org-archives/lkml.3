Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3H3ViB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 17:38:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33132 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3H3Vh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:37:59 -0400
Message-ID: <522110AA.7040700@wwwdotorg.org>
Date: Fri, 30 Aug 2013 15:37:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/5] clk: dt: binding for basic multiplexer clock
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org> <1377150793-27864-4-git-send-email-mturquette@linaro.org> <2A930389-012E-45C3-93EB-6B4A41DB2EF5@codeaurora.org> <20130829011425.8231.78802@quantum> <39BAF1F8-41AD-4667-BF76-22BDF709415A@codeaurora.org> <20130830203334.10934.10011@quantum>
In-Reply-To: <20130830203334.10934.10011@quantum>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 02:33 PM, Mike Turquette wrote:
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

That sounds like the opposite of what we should be doing.

It's fine for kernel code/data to change; that's a natural part of
development. Obviously, we should minimize churn, through thorough
review, domain knowledge, etc.

Saying that we must shove the data out into DT because it changes
pre-supposes that we should be changing the DT!

We should strive to write the DT for a particular piece of HW once, and
have it be a complete and accurate description of the HW. That's hard
enough to do with small amounts of simple data. Deliberately pushing
data that's known to be hard to get right and churn a lot into DT seems
to be destined to make most DTs contain incorrect data.

DT-as-an-ABI works both ways; the binding definition needs to stay
constant /and/ the data in any particular DT needs to be accurate too.
