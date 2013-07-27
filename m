Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab3G0Jnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 05:43:33 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12891 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3G0Jn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 05:43:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 27 Jul 2013 02:43:26 -0700
Message-ID: <51F398F8.5070602@nvidia.com>
Date: Sat, 27 Jul 2013 15:25:04 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Rhyland Klein <rklein@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: palmas: Add DVFS mux setting
References: <1374871308-490-1-git-send-email-achew@nvidia.com> <51F2E74E.2060107@wwwdotorg.org> <643E69AA4436674C8F39DCC2C05F763862A12740FB@HQMAIL03.nvidia.com> <51F2EC66.2080200@wwwdotorg.org> <643E69AA4436674C8F39DCC2C05F763862A1274113@HQMAIL03.nvidia.com> <51F2F22B.500@wwwdotorg.org> <643E69AA4436674C8F39DCC2C05F763862A1274137@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763862A1274137@HQMAIL03.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 July 2013 03:42 AM, Andrew Chew wrote:
>>>>>> How does this interact with the pinctrl driver that Laxman just
>>>>>> sent for Palmas?
>>>>>>
>>>>>> https://lkml.org/lkml/2013/7/26/141
>>>>>> [PATCH 0/2] pinctrl: palmas: add pincontrol driver
>>>>> Thanks for pointing this out.  Given this:
>>>>>
>>>>> +Optional properties:
>>>>> +- ti,palams-enable-dvfs1: Enable DVFS1. Configure pins for DVFS1
>> mode.
>>>>> +- ti,palams-enable-dvfs2: Enable DVFS2. Configure pins for DVFS2
>> mode.
>>>>> I think his work already encompasses what my patch is supposed to do.
>>>>>
>>>>> Abandoning this patch.
>>>> OK, that's simple!
>>>>
>>>> Are the existing ti,mux-pad1/ti,mux-pad2 properties already in the
>>>> binding redundant with Laxman's pinctrl driver?
>>> In linux-next (where I based my work), yes, those two properties
>>> already exist, and as far as I understand it, are redundant with Laxman's
>> pinctrl driver.
>>> I expect those properties will go away with Laxman's pinctrl driver.
>> Except those properties have been there for many kernel revisions and are
>> an ABI and hence can't be removed, although I noticed that they got
>> renamed recently, and of course we aren't technically being strict about this
>> quite yet...
>>
>> Re: the complete pinctrl driver: is anything outside the Palmas going to need
>> to reprogram the Palmas pinctrl HW at run-time? Are the functions that can
>> be routed to the pins just static configuration for PMIC features, or might
>> other generic (non-Palmas) drivers use those pins for something? If not,
>> perhaps it's be simpler to just add your ti,mux-pad3 property and be done.
> I can imagine other projects wanting to do runtime muxing on those pins.
> These pins can serve as GPIOs, or can be programmed for special functions.
> For my particular scenario, I just need to statically set that particular mux
> register (the power-on default value is not suitable for what we want to
> do, namely to use the GPIO_6 pin as an actual GPIO pin).  If the existing
> ti,mux-pad1 and ti,mux-pad2 properties are to stay, in the spirit of not changing
> the existing ABI, then sure, we can make a case for adding the missing one
> (ti,mux-pad3) for completeness.  In this case, if the palmas PMIC's pin
> configuration can be statically set at start of day, one won't even need to
> instantiate the palmas pinctrl driver at all, and with the addition of ti,mux-pad3,
> the pin configuration control will actually be complete.

In downstream, we are using it only during initialisation. There is no 
need to do it on runtime.

But main issue which I wanted to address by pinctrl driver is to:
- provide the abstraction.
- More configuration for open drain and pull up/down.

The way we are passing the mux_padx register value, it directly written 
into the register, And hence the is no abstraction and need to refer 
datasheet always to look the configuration. With the having proper 
pinmux driver, the initialisation is easy to handle and easy read from code.

Also on this apparach there is no configuration provided for the pull 
up/down and open drain. This will be available if we have pincontrol driver.

once we will have the pincontrol driver then mux pads are become redundant.


