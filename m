Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaJARre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:47:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59591 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaJARrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:47:33 -0400
Message-ID: <542C3E34.2060505@wwwdotorg.org>
Date: Wed, 01 Oct 2014 11:47:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Vidya Sagar <vidyas@nvidia.com>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device
 tree
References: <1411408675-32315-1-git-send-email-vidyas@nvidia.com> <5420731E.6040104@wwwdotorg.org> <1862760b05184b95948b5e4952db010d@bgmail103.nvidia.com> <54297E7E.1030306@wwwdotorg.org> <96955607a8414f75bb4110ebef5daa37@bgmail103.nvidia.com>
In-Reply-To: <96955607a8414f75bb4110ebef5daa37@bgmail103.nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 11:13 AM, Vidya Sagar wrote:
>
>
>> -----Original Message-----
>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>> Sent: Monday, September 29, 2014 9:15 PM
>> To: Vidya Sagar
>> Cc: thierry.reding@gmail.com; Laxman Dewangan; Krishna Thota; linux-
>> tegra@vger.kernel.org; linux@arm.linux.org.uk; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device
>> tree
>>
>> On 09/29/2014 04:25 AM, Vidya Sagar wrote:
>>>
>>>> -----Original Message-----
>>>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>>>> Sent: Tuesday, September 23, 2014 12:36 AM
>>>> To: Vidya Sagar
>>>> Cc: thierry.reding@gmail.com; Laxman Dewangan; Krishna Thota; linux-
>>>> tegra@vger.kernel.org; linux@arm.linux.org.uk; linux-
>>>> kernel@vger.kernel.org
>>>> Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1
>>>> device tree
>>>>
>>>> On 09/22/2014 11:57 AM, Vidya Sagar wrote:
>>>>> sd4 is an always on regulator which is turned on at boot time.
>>>>> It is externally controller through gpio. This change reflects the
>>>>> same in Jetson TK1 device tree
>>>>
>>>> In the schematics, the "Power Sequencing" timing diagram says "S/W
>>>> controlled" for SD4/+1.05V_RUN. I also don't see an "ENABLE1" pin on
>>>> the AS3722, which would be required for ...
>>
>> Can you please comment on this aspect of the issue?
>>
>>>>> +					ams,ext-control = <1>;
>>>>
>>>> ... to be valid.
>>>>
>>>> What's the source of information behind this change?
>>>>
>>>> What symptoms does this patch correct?
>>>
>>> I'm seeing one issue when I add support for PCIe suspend/resume
>> functionality.
>>> The issue is that, when regulator_bulk_diable() is called, disabling one of
>> the power rails (which is deriving its voltage from SD4) of PCIe is failing.
>>> The reason being, I2C controller is getting power gated
>>
>> Why is the fix being applied to SD4 if the issue is with a power rail derived
>> from SD4? Shouldn't any fix be applied directly to the problematic rail rather
>> than some parent rail?
>>
>> Since the I2C controller is part of the SoC and we don't have power domain
>> support yet, the only way the I2C controller can get power gated is when the
>> SoC as a whole is turned off.
>>
>>   > before power rail disable is called.
>>
>> ... so without making SD4 dependant on ext-control, since no SW can be
>> running at this point, the only way SD4 could get turned off is that the PMIC
>> turns it off itself at the appropriate point in the system power sequence
>> based on its OTP programming, or the board HW is already set up to turn off
>> SD4 at the appropriate time somehow. Is that not happening?
>> That would imply incorrect PMIC programming wouldn't it?
>>
>
> After some debugging, found that the I2C driver's suspend is getting called before the suspend
> of PCIe is called (BTW, PCie has suspend_noirq..!) Hence, when PCIe driver wants to disable regulators
> it fails because of I2C write failure, which is expected given I2C is already suspended.

Ah. It sounds like the PCIe driver should have a regular suspend 
function not a suspend_noirq function then. It's certainly expected that 
resources behind an I2C bus (i.e. most regulators) can't be manipulated 
in a suspend_noirq function.

> Hence, SD4 is made dependent on ENABLE1 input which is the sleep signal from Tegra.
>
>>> Hence SD4 is made dependent on ENABLE1, which is nothing but the deep
>>> sleep signal coming from Tegra, So eventually, SD4 will be powered off
>> when system enters into deep-sleep state.
>>
>> This sounds like a workaround that happens to make the system do what you
>> want rather than a root-cause fix.
>>
>>> Source of information is from downstream kernel
>>
>> We need to use HW schematics and other primary data to determine the
>> correct approach.

