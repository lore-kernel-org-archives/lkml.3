Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935141Ab3DJGHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:07:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45344 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934966Ab3DJGHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:07:44 -0400
Message-ID: <516501A0.4000004@ti.com>
Date: Wed, 10 Apr 2013 11:37:28 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>, <vaibhav.bedia@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv3] driver: serial: prevent UART console idle on suspend
 while using "no_console_suspend"
References: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com>	<87mwtclvua.fsf@linaro.org> <516463D2.2070008@ti.com> <87obdnh6au.fsf@linaro.org>
In-Reply-To: <87obdnh6au.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Wednesday 10 April 2013 12:37 AM, Kevin Hilman wrote:
> Sourav Poddar<sourav.poddar@ti.com>  writes:
>
>> Hi Kevin,
>> On Friday 05 April 2013 11:10 PM, Kevin Hilman wrote:
>>> Sourav Poddar<sourav.poddar@ti.com>   writes:
>>>
>>>> With dt boot, uart wakeup after suspend is non functional while using
>>>> "no_console_suspend" in the bootargs. With "no_console_suspend" used, we
>>>> should prevent the runtime suspend of the uart port which is getting used
>>>> as an console.
>>>>
>>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>> Cc: Felipe Balbi<balbi@ti.com>
>>>> Cc: Rajendra nayak<rnayak@ti.com>
>>>> Tested on omap5430evm, omap4430sdp.
>>>>
>>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>>> Rather than make these special checks inside the driver's runtime PM
>>> callbacks, you should just disable runtime PM (pm_runtime_disable())
>>>
>>> Then, this should be broken into 2 patches.
>>>
>>> 1) serial core: add the '->is_console' flag.  (nit on naming: don't call
>>>      it port_is_console, since the struct is already a uart_port)
>>>
>>> 2) In the OMAP UART driver's ->prepare callback, check the is_console flag
>>>      and pm_runtime_disable() accordingly  (then pm_runtime_enable() in
>>>      the drivers's ->complete callback.
>>>
>>> Kevin
>> I was working on your above suggestions, but realised there is not
>> only console
>> uart which has the requirement of keeping the clocks enabled while going on
>> suspend.
>>
>> If you see arch/arm/boot/dts/am33xx.dtsi, there is a ocmcram which has
>> "no_idle_on_suspend" property used.
> Can you please ask the AM33xx folks how (and why) this is being used?
>
> I don't see/find a driver for this device in mainline, so without a
> driver this flag will not be used.
>
Looping in Vaibhav Bedia for ocmcram..

[Vaibhav]:
   There is a discussion going on about a cleaner way of handling
   ti, no_idle_on_suspend" part (as this is a sort of hack). We got a way
   around for UART ($subject) by making serial core/driver handle this 
for us.
   But with this, we will delete codes around "no_idle_on_suspend" flag in
   omap_device file.

   But, we realised that its not only UART which requires the clocks to 
be active
   whie going for suspend. There is a dts entry for ocmcram also.

   As Kevin also pointed out, we don't see a driver for this device in 
mainline, It would be
   great if you can explain how its getting used?

   You can find the complete discussion on v3 here:
      https://lkml.org/lkml/2013/4/5/239

>>      ocmcram: ocmcram@40300000 {
>>                          compatible = "ti,am3352-ocmcram";
>>                          reg =<0x40300000 0x10000>;
>>                          ti,hwmods = "ocmcram";
>>                          ti,no_idle_on_suspend;
>>          };
>> This property gets checked in omap_device file and correspondingly
>> od->flags is set.
>>
>> Based on your above inputs, the patches which I cooked up is
>> inlined[1]. Though, the below
>> patches works fine for uart case. The patches will effect ocmcram case
>> and I am inling them
>> "just for discussion".
> Could you also have a look at Russell's suggestion for getting rid of
> the 'is_console' flag.
>
[Kevin]: Yes, will do that.
> Thanks,
>
> Kevin
~Sourav
