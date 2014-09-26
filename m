Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaIZOpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:45:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45111 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaIZOpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:45:32 -0400
Message-ID: <54257C25.2000308@wwwdotorg.org>
Date: Fri, 26 Sep 2014 08:45:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Bart Tanghe <bart.tanghe@thomasmore.be>, tim.kryger@linaro.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [resend rfc v3] pwm: add BCM2835 PWM driver
References: <1398689686-30317-1-git-send-email-bart.tanghe@thomasmore.be> <20140825131908.GG4163@ulmo.nvidia.com> <5408395E.2030305@thomasmore.be> <54088008.9080200@wwwdotorg.org> <20140926071109.GA31106@ulmo>
In-Reply-To: <20140926071109.GA31106@ulmo>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 01:11 AM, Thierry Reding wrote:
> On Thu, Sep 04, 2014 at 09:06:48AM -0600, Stephen Warren wrote:
>> On 09/04/2014 04:05 AM, Bart Tanghe wrote:
>>> No problem. Thanks for the feedback.
>>> I've got some question below.
>>>
>>> On 2014-08-25 15:19, Thierry Reding wrote:
>>>> Sorry for taking so long to reply to this, I had completely forgotten.
>>>>
>>>> On Mon, Apr 28, 2014 at 02:54:46PM +0200, Bart Tanghe wrote:
>>>>> 	Add some better error handling and Device table support
>>>>> 	Added Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt
>>>>> 	
>>>>> Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
>>
>>>>> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
>>>>> index 22f2f28..20341a3 100644
>>>>> --- a/drivers/pwm/Kconfig
>>>>> +++ b/drivers/pwm/Kconfig
>>>>> @@ -62,6 +62,18 @@ config PWM_ATMEL_TCB
>>>>>   	  To compile this driver as a module, choose M here: the module
>>>>>   	  will be called pwm-atmel-tcb.
>>>>>
>>>>> +config PWM_BCM2835
>>>>> +	tristate "BCM2835 PWM support"
>>>>> +	depends on MACH_BCM2835 || MACH_BCM2708
>>>>> +	help
>>>>> +	  PWM framework driver for BCM2835 controller (raspberry pi)
>>>>
>>>> I think the correct capitalization would be "Raspberry Pi".
>>>>
>>>>> +	  Only 1 channel is implemented.
>>>>
>>>> How many can it take? Why haven't all been implemented?
>>>
>>> BCM2835 can take 2 pwm channels.
>>> I can implement 2 channels but can't physically test the second channel. Is that a problem?
>>
>> I don't think that's a problem; I would expect the channels to be identical,
>> so testing 1 should be fine.
>
> Agreed. If it turns out not to work it can always be fixed.
>
>>>> I notice that you never prepare or enable the clock here. Perhaps this
>>>> isn't required because it's always on, but I think you should still call
>>>> clk_prepare_enable() here (and clk_disable_unprepare() in .remove()) to
>>>> make sure the driver is more portable.
>>> The frequency can be minimized by a clock_divider ( the pwm clock is default disabled). this has to be done by
>>> a clock driver, as mentioned in a previous comment by Stephen Warren.
>>>
>>> Any clock programming should be performed by a clock driver. We don't
>>> have one of those upstream yet, mainly because it would rely on talking
>>> to the firmware (running on the VideoCore) to manipulate the clocks, and
>>> we don't have a firmware protocol driver either.
>>>
>>> Nowadays, I'm using a userspace program to change the clock_divider, but would like to implement this in a clock driver.
>>> The clock hardware description isn't implemented in the datasheet. I can convert the userspace prog to a clock driver but this is very experimental.
>>> If anyone has some suggestions?
>>
>> Oh dear. It sounds like we need at least some form of clock driver for the
>> platform then. I still don't think there's complete documentation for the
>> HW, even though a lot of register docs were published which presumably cover
>> the clock HW? Equally, given that the VC firmware assumes it owns most of
>> the HW, it seems best to manipulate the clocks through the firmware
>> interface rather than directly touching the HW. Unfortunately, I don't
>> believe there's any ABI guarantee on the firmware interface. Perhaps we can
>> get one?
>
> Urgs... this VC firmware seems to be more of a headache that I thought
> it was. How is this handled in other drivers? Surely PWM isn't the first
> one that needs clocks?

For the other clocks, I've set up dummy fixed-rate clocks in the DT 
and/or "clock driver" code to satisfy references by phandle or clock 
name respectively. Since the other drivers don't actually manipulate the 
clock rates etc., this is enough for the drivers.

I always hoped that enough HW information would either be reverse 
engineered or released to somehow disable the VC firmware, and implement 
all the drivers within Linux talking to HW directly.
