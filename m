Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaI3S1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:27:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53287 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaI3S1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:27:13 -0400
Message-ID: <542AF5FE.1000006@codeaurora.org>
Date: Tue, 30 Sep 2014 11:27:10 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: DT: apq8064: add rpm support
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org> <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org> <5429DA95.80505@codeaurora.org> <20140930050203.GG28481@sonymobile.com>
In-Reply-To: <20140930050203.GG28481@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/14 22:02, Bjorn Andersson wrote:
> On Mon 29 Sep 15:17 PDT 2014, Stephen Boyd wrote:
>
>> On 09/29/14 02:14, Srinivas Kandagatla wrote:
>>> @@ -246,6 +247,24 @@
>>>  			#reset-cells = <1>;
>>>  		};
>>>  
>>> +		apcs: syscon@2011000 {
>>> +			compatible = "syscon";
>>> +			reg = <0x2011000 0x1000>;
>>> +		};
>> This is actually a clock controller block that hw designers decided was
>> good place to shove the ipc bits (because there's room!). Can we call it
>>
>>                 l2cc: clock-controller@2011000 {
>>                         compatible = "syscon";
>>                         reg = <0x2011000 0x1000>;
>>                 };
>>
>> Eventually I'll add the specific krait compatible when we merge krait
>> clock support:
>>
>>                 l2cc: clock-controller@2011000 {
>>                         compatible = "qcom,kpss-gcc", "syscon";
>>                         reg = <0x2011000 0x1000>;
>>                         clock-output-names = "acpu_l2_aux";
>>                 };
>>
> As long as we can get hold of the regmap that would be fine. I pressume the
> idea is to have the kpss-gcc using syscon, just like the rpm. But hopefully the
> syscon patches that are floating around (merged?) will allow any driver to
> expose a "syscon regmap".

Agreed. I'm not sure if kpss-gcc will use syscon. With the floating
patches I don't see a reason why we need to use it.

>
>>> +
>>> +		rpm@108000 {
>>> +			compatible	= "qcom,rpm-apq8064";
>>> +			reg		= <0x108000 0x1000>;
>>> +			qcom,ipc = <&apcs 0x8 2>;
>> There are actually 3 ipc bits. I guess if we ever have to use the other
>> two we'll extend this binding to have the other bits specified some
>> other way?
> I haven't seen any indications of us using more than this bit. If we want to do
> that, we could simply make it <&apcs 8 2 &apcs 8 3 &apcs 8 4> (or whatever
> those indices are). That way this should be easy it keep compatible.
>

Good to hear we're not forced to use a new property. The indices have
always been 2, 1, and 0 as far as I know.

We use bit 1 to ack the RPM if it ever crashes. We know that it crashes
because we receive the error interrupt. Instead of calling panic like we
do downstream we can gracefully fail any new rpm requests. There really
isn't any way to recover from this scenario though besides rebooting.
Looking at the code I see this is all wrong and we use bit 2 to ack the
error.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

