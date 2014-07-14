Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbaGNVUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:20:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37981 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbaGNVUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:20:38 -0400
Message-ID: <53C449A3.2010404@codeaurora.org>
Date: Mon, 14 Jul 2014 14:20:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Bjorn Andersson <bjorn@kryo.se>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/3] pinctrl: Device tree bindings for Qualcomm pm8xxx
 gpio block
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>  <1404782785-1824-3-git-send-email-bjorn.andersson@sonymobile.com>  <CACRpkdZ2hekBGe1-9GV-amqi50heghWhXJ9raW7P_Nif_Ci88g@mail.gmail.com>  <CAJAp7OghZoTXutxw7hAsq1XA_wAhOXDNFO0tz8u9ceQ1fD9W1w@mail.gmail.com>  <CACRpkdai=q3nmPk5OWQWn_UMdXmqcbFXJ90rxREBG9k6gdy88Q@mail.gmail.com>  <53C095EA.90000@codeaurora.org> <1405346335.13503.25.camel@iivanov-dev>
In-Reply-To: <1405346335.13503.25.camel@iivanov-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/14 06:58, Ivan T. Ivanov wrote:
> On Fri, 2014-07-11 at 18:56 -0700, Stephen Boyd wrote:
>> On 07/10/14 02:53, Linus Walleij wrote:
>>> On Wed, Jul 9, 2014 at 11:18 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
>>>> On Wed, Jul 9, 2014 at 1:53 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>>>> On Tue, Jul 8, 2014 at 3:26 AM, Bjorn Andersson
>>>>> <bjorn.andersson@sonymobile.com> wrote:
>>>>>
>>>>> +- function:
>>>>> +       Usage: optional
>>>>> +       Value type: <string>
>>>>> +       Definition: Specify the alternative function to be configured for the
>>>>> +                   specified pins.  Valid values are:
>>>>> +                       "normal",
>>>>> +                       "paired",
>>>>> +                       "func1",
>>>>> +                       "func2",
>>>>> +                       "dtest1",
>>>>> +                       "dtest2",
>>>>> +                       "dtest3",
>>>>> +                       "dtest4"
>>>>> These are a bit ambigous, why doesn't the driver present functions that
>>>>> are more specific than "func1", "func2"? Or "dtest1"?
>>>> I agree, unfortunately I have only seen traces of the actual function matrix;
>>>> for pm8xxx I have no documentation and for pm8x41 they are only listed as
>>>> func[1-2] and dtest[1-4].
>>>>
>>>> Maybe if someone at Qualcomm could release such a list we could provide a
>>>> proper table instead.
>>> I guess Stephen Boyd can help us. (?)
>> Ok. "normal" is pretty much gpio mode, i.e. don't mux anything. "paired"
>> is where we take the output of the gpio next to it and loop it back into
>> this gpio (and vice versa). So gpio1 is paired with gpio2, gpio 3 is
>> paired with gpio 4, etc. This allows us to make level translators by
>> choosing different supply voltages for the paired gpios. "func1" and
>> "func2" are used for muxing things internally. "dtest" is used to mux
>> specific things out for testing purposes, not really used in any
>> end-products but still useful while debugging. I can provide the
>> function to pin mapping if necessary. There are lots of pmics.
> Thank you Stephen. If understand it right, this is more like option for
> the pin when it is GPIO. Next generation of PMIC's have support for pin
> acting like analog-input/output and current sink.

Isn't this document only for the gpios? I think you're talking about the
MPPs, which also exist on these generation of pmics. We should probably
avoid mixing the two (gpios and mpps) in one binding because they're
really different hardware.

>  So I will like
> to keep "function" property for selecting one of the above functions.
> Choosing between "normal", "paired"... options in QPNP pinctrl driver
> is supported trough passing values, defined in DT header file, to
> "output-high" property. Please don't kill me :-).

Overloading output-high to choose the MPP mode doesn't seem to follow
the generic pinconfig binding. Does output-high even take a value? Why
can't we use the function property?

>> BTW, I see that power-source has made a comeback. What are the units? 
> Documentation states it is "a custom format" :-).
>
>

Ah, I was looking in the binding document. It looks like the code
comment around PIN_CONFIG_POWER_SOURCE says custom format. It's
concerning though. From what I can tell commit 5b81d55c4ccf (pinctrl:
remove bindings for pinconf options needing more thought, 2013-06-25)
removed this option along with slew-rate because they specifically
didn't have any units associated with them. But then slew-rate came back
in commit 8ba3f4d00078 (pinctrl: Adds slew-rate, input-enable/disable,
2013-12-11) even though it didn't have units and then power-source came
back without units too. Linus, what's going on?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

