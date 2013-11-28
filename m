Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab3K1IDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:03:55 -0500
Received: from 11.mo6.mail-out.ovh.net ([188.165.38.119]:40567 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750820Ab3K1IDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:03:54 -0500
Message-ID: <5296F8B2.9080807@overkiz.com>
Date: Thu, 28 Nov 2013 09:02:58 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>
CC: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] clk: add accuracy support for fixed clock
References: <1385556285-19180-1-git-send-email-b.brezillon@overkiz.com> <1385556285-19180-3-git-send-email-b.brezillon@overkiz.com> <20131127145620.GR2879@titan.lakedaemon.net> <5296298C.9040300@overkiz.com> <20131127181042.16819.36364@quantum>
In-Reply-To: <20131127181042.16819.36364@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 17924045042210273308
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/2013 19:10, Mike Turquette wrote:
> Quoting boris brezillon (2013-11-27 09:19:08)
>> Hi Jason,
>>
>> On 27/11/2013 15:56, Jason Cooper wrote:
>>> Boris,
>>>
>>> Thanks for posting this series.  Bear with me as I'm attempting to give
>>> MikeT a hand.
>> Nice to hear.
>> Mike already took a look at this series, but I'm happy to get more
>> feedbacks.
>>
>>> Don't be afraid to tell me a question is stupid :-)
>> Your questions are far from stupid ;-).
>>
>>> On Wed, Nov 27, 2013 at 01:44:45PM +0100, Boris BREZILLON wrote:
>>>> This patch adds support for accuracy retrieval on fixed clocks.
>>>> It also adds a new dt property called 'clock-accuracy' to define the clock
>>>> accuracy.
>>>>
>>>> This can be usefull for oscillator (RC, crystal, ...) definitions which are
>>>> always given an accuracy characteristic.
>>> I think we need to be more explicit in the binding and the API,
>>> especially when providing a method to recalculate the accuracy.  I
>>> presume this recalculated value would be relative against the root
>>> clock?
>> Yes, indirectly.
>> Actually the clk accuracy depends on the whole clock chain, and is
>> calculated
>> either by comparing the real clk rate to the theorical clk rate
>> (accuracy = absolute_value((theorical_clk_rate - real_clk_rate)) /
>> theorical_clk_rate),
>> or by adding all the accuracies (expressed in ppm, ppb or ppt) of the
>> clk chain
>> (accuracy = current_clk_accuracy + parent_clk_accuracy).
>>
>> Say you have a root clk with a +-10000 ppb accuracy, then a pll multiplying
>> this root clk by 40 and introducing a possible drift of +- 1000 ppb and
>> eventually a system clk based on this pll with a perfect div by 2 prescaler
>> (accuracy = 0 ppb).
>>
>> If I understand correctly how accuracy propagates accross the clk tree,
>> you'll end up with a system clk with a +- 11000 ppb accuracy.
>>
>> e.g.:
>>    root clk = 12MHz +- 10000 ppb => 12 MHz * (1 - (10000 / 10^9)) < root
>> clk < 12 MHz * (1 + (10000 / 10^9))
>>                                                       => 11,99988 MHz <
>> root clk < 12,00012 MHz
>>    pll clk = ((root clk) * 40) +- 1000 ppb =>  (11,99988 MHz * 40) * (1 -
>> (1000 / 10^9)) < pll clk < (12,00012 MHz * 40) * (1 + (1000 / 10^9))
>>                                                              =>
>> 479,994720005 MHz < pll clk < 480,005280005 MHz
>>
>>    system clk = ((pll clk) / 2) +- XXX ppb => 479,994720005 MHz / 2 <
>> system clk < 480,005280005 MHz / 2
>>                                                                 =>
>> 239,997360002 MHz < system clk < 240,002640002 MHz
>>                                                                 => system
>> clk accuracy = 0,002640002 / 240 = 11000 ppb
>>
>> Please tell me if my assumptions are false.
>>> There really needs to be two attributes here:  the rated accuracy from
>>> the manufacturer, and the calculated accuracy wrt another clock in the
>>> system.  We only need a binding for the manufacturer rating since the
>>> calculated accuracy is determined at runtime.
>> Actually when I proposed this new functionnality I only had the theorical
>> (or manufacturer rated) accuracy in mind.
>> But providing an estimated accuracy (based on another clk) sounds
>> interresting if your reference clk is an extremly accurate one.
> Is there a need to model clock accuracy across the clock chain?
> I'm OK
> modeling it in DT, and the code to do it in the clk framework isn't very
> much ... but I also wonder if we're just adding complexity for no
> reason.

AFAIK the most important node in the clock chain (regarding accuracy)
is the root node.
But some nodes (like PLLs) might introduce more innacuracy.
This series propose a simple way (or at least tries to keep it simple 
:-)) to
express accuracy over the whole clk chain by means of the recalc_accuracy.

I'm not sure keeping the accuracy calculation (or retrieval) in the root 
clk node
only will simplify the calculation (or retrieval) of a leaf clk node 
accuracy (you'd
still have to walk over the clock chain to get the root clk accuracy).

My primary goal with this series is to provide a simple way (for a clock 
user) to
choose the most accurate clock among several available clocks.
This is a real need on AT91 platforms which provides internal RC oscillators
with a really poor accuracy (+- 5% <=> +- 50000 ppm).

>
>>> I would also prefer to see an unknown accuracy be -1.
>> I decided to keep 0 as a default value for unimplemented recalc_accuracy
>> (or unspecified fixed accuracy) to keep existing implementation coherent.
>>
>> 0 means the clk is perfect, and I thought it would be easier to handle a
>> perfect clk (even if this is not really the case) than handling an error
>> case.
>>
>> Another aspect is the propagation of the clk accuracy accross the clk tree.
>> Returning -1 in the middle of the clk chain will drop the previous clk
>> accuracy
>> calculation.
>>
>> Anyway, I can change this if you think this is more appropriate.
> What about the absence of the property?
> Instead of requiring a -1 value
> can we simply detect that the property does not exist? This is nicer for
> backwards compatibility with existing DTS.

I already handle the absence of the clock-accuracy property.
In this case the clock is considered perfect (accuracy = 0 ppb).

Mike, do you want me to return an error in the recalc_accuracy callback
to notifiy the absence of the clock-accuracy property ?

>
> Regards,
> Mike
>
>>> There are already
>>> clocks on the market (PPS reference clocks) with accuracies of
>>> 0.1ppb/day [1].  Obviously, these aren't system clocks.  So the limit on
>>> accuracy may be a non-issue.  However, it may be worth changing the
>>> binding property to express the units.
>> Wow, 0.1 ppb, this is impressive :-).
>>
>>
>> This needs more than changing the dt bindings: I currently store the
>> accuracy value in an unsigned long field, and expressing this in ppt
>> (parts per trillion) may implies storing this in an u64 field (or store a
>> unit field).
>>
>>
>>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>>> ---
>>>>    .../devicetree/bindings/clock/fixed-clock.txt      |    3 ++
>>>>    drivers/clk/clk-fixed-rate.c                       |   43 +++++++++++++++++---
>>>>    include/linux/clk-provider.h                       |    4 ++
>>>>    3 files changed, 44 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/clock/fixed-clock.txt b/Documentation/devicetree/bindings/clock/fixed-clock.txt
>>>> index 0b1fe78..48ea0ad 100644
>>>> --- a/Documentation/devicetree/bindings/clock/fixed-clock.txt
>>>> +++ b/Documentation/devicetree/bindings/clock/fixed-clock.txt
>>>> @@ -10,6 +10,8 @@ Required properties:
>>>>    - clock-frequency : frequency of clock in Hz. Should be a single cell.
>>>>    
>>>>    Optional properties:
>>>> +- clock-accuracy : accuracy of clock in ppb (parts per billion).
>>>> +               Should be a single cell.
>>> I would prefer to call this property 'clock-rated-ppb'.
>> Depending on what we choose to do with the accuracy field, this might be
>> an option.
>>
>>>>    - gpios : From common gpio binding; gpio connection to clock enable pin.
>>>>    - clock-output-names : From common clock binding.
>>>>    
>>>> @@ -18,4 +20,5 @@ Example:
>>>>               compatible = "fixed-clock";
>>>>               #clock-cells = <0>;
>>>>               clock-frequency = <1000000000>;
>>>> +            clock-accuracy = <100>;
>>>>       };
>>> thx,
>>>
>>> Jason.
>>>
>>> [1] http://www.vectron.com/products/modules/md-010.htm
>> Thanks for your review, and don't hesitate to ask more questions, or to
>> point out
>> incoherencies in my approach (I'm not an expert in clk and clk accuracy
>> calculation,
>> and I might be wrong ;-)).
>>
>> Best Regards,
>>
>> Boris

