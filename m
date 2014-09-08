Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaIHR5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:57:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48717 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaIHR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:57:42 -0400
Message-ID: <540DEE13.4090203@codeaurora.org>
Date: Mon, 08 Sep 2014 11:57:39 -0600
From: Jeffrey Hugo <jhugo@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Kumar Gala <galak@codeaurora.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Suman Anna <s-anna@ti.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Eric Holmberg <eholmber@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonymobile.com>
Subject: Re: [PATCH v3] hwspinlock: qcom: Add support for Qualcomm HW Mutex
 block
References: <1409688246-16530-1-git-send-email-bjorn.andersson@sonymobile.com> <2B6A9AA9-E69F-47DF-A1E7-5C95B4E6FA94@codeaurora.org> <20140903145508.GA16352@sonymobile.com> <5B5C3B14-0FC8-4B4B-AE33-69030B7863D8@codeaurora.org> <20140903163448.GB16352@sonymobile.com>
In-Reply-To: <20140903163448.GB16352@sonymobile.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/2014 10:34 AM, Bjorn Andersson wrote:
> On Wed 03 Sep 08:22 PDT 2014, Kumar Gala wrote:
>
>>
>> On Sep 3, 2014, at 9:55 AM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:
>>
>>> On Wed 03 Sep 05:49 PDT 2014, Kumar Gala wrote:
>>>
>>>>
>>>> On Sep 2, 2014, at 3:04 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:
>>>>
>>>>> Changes since v2:
>>>>> - MODULE_DEVICE_TABLE
>>>>> - Changed prefix to qcom
>>>>> - Cleaned up includes
>>>>> - Rely on reg and num-locks to figure out stride, instead of of_match data
>>>>
>>>> I know Jeff prefers this method of computing stride, but I’m not a fan as
>>>> there isn’t a reason one could adjust qcom,num-locks in the dt for some
>>>> reason and leave regs alone.
>>>>
>>>
>>> All the current platform it's 32 consecutive mutexes with either 4 or 128 byte
>>> stride, so encoding it as data either way works fine. The hardware you're
>>> trying to describe with your dt is the addresses that spans your mutex
>>> registers and how many there are. So from the HW/dts pov I don't see why you
>>> would like to do this.
>>>
>>> Then looking in the caf code, there is a limit of max 8 mutexes. So apparently
>>> there is some sort of usecase, I just don't know what or if it's valid from a
>>> dt pov.
>>
>> I believe not all the mutexes are meant for the cores running linux.
>> However, I think we just expect linux to play nice and not touch anything it
>> isn’t using explicitly.
>>
>
> I would expect so too.

Currently, and I expect this to continue, the first 8 mutexes involve 
usecases which involve Linux.  The remaining implemented locks support 
usecases which do not involve the Linux cores.  Generally we expect 
Linux to play nice, however it is possible to have hardware memory 
protection units in the SoC configured to prevent the Linux cores from 
accessing those upper locks.  From the global SoC pov, Linux should only 
"see" the first 8.

>
> One problem I see is that it's not very robust relying on the relationship
> between reg and num-locks. I consider this an implementation detail leaking
> into the dt binding and it's not described enough currently...
>
>>> Going to that future awesome SoCs where it's still called tcsr-mutex, but with
>>> a stride of 4096 bytes makes me wonder; is that really a consecutive 128kb with
>>> nothing else in-between that we can ioremap?
>>
>> think 64-bit machines with more address space to burn and wanting to separate
>> resources to use MMUs for protection.
>>
>
> Makes sense, I just don't have any documentation verifying this.
>
>>> I.e. can we really reuse this driver straight off for that SoC?
>>
>> I dont see why not.
>>
>
> As long as the space inbetween is just wasted, there is no issue.

Have a look at the msm8916.dtsi in the downstream repository.  I think 
it'll help with your questions concerning the 0x1000 stride case.

>
>>>>> diff --git a/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt
>>>>> +- compatible:
>>>>> +	Usage: required
>>>>> +	Value type: <string>
>>>>> +	Definition: must be one of:
>>>>> +		    "qcom,sfpb-mutex",
>>>>> +		    "qcom,tcsr-mutex”
>>>>
>>>> I dont get the purpose of having different compatible strings if there is no
>>>> difference in the code between them.
>>>>
>>>
>>> The semantics are the same, but there are no mutex registers in the tcsr block
>>> in e.g 8960, so the name is just missleading. I assume that's why you didn't
>>> follow caf and used the compatible "sfpb" in the first place?
>>
>> What do you expect the 8960 dt node to look like?  I’m not 100% against ‘sfpb’
>>
>> I’m feel like we we should use compat for stride, so we’d end up with something like:
>>
>> qcom,sfpb-mutex: stride 4 bytes, base: 0x01200604, reset: 0x01200600
>> qcom,tcsr-mutex: stride 128 bytes, base: 0xFD484000, reset: 0xFD485380
>> qcom,tcsr-4k-mutex: stride 4k bytes, base: 0x740000, reset: 0x767000
>>
>
> Maybe these are the best names for the 3 hw blocks after all.
>
> The alternative would be either to encode the platform name in the compatible
> or adding the stride as a separate property. The first is waste and the second
> doesn't describe how hw is connected. So netiher are good alternatives.
>
>
> I think your suggestion is reasonable and will move the stride back into
> compat. It's the most robust solution.
>
> Is the 4k block finalized (don't see it in 8994 docs)? Should I add it to the
> driver now as well?
>
> Thanks for your input!
>
> Regards,
> Bjorn
>


Jeffrey Hugo
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation.
