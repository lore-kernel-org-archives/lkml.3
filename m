Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935798Ab3DITHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:07:11 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47065 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538Ab3DITHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:07:09 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv3] driver: serial: prevent UART console idle on suspend while using "no_console_suspend"
References: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com>
	<87mwtclvua.fsf@linaro.org> <516463D2.2070008@ti.com>
Date: Tue, 09 Apr 2013 12:07:05 -0700
In-Reply-To: <516463D2.2070008@ti.com> (Sourav Poddar's message of "Wed, 10
	Apr 2013 00:24:10 +0530")
Message-ID: <87obdnh6au.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav Poddar <sourav.poddar@ti.com> writes:

> Hi Kevin,
> On Friday 05 April 2013 11:10 PM, Kevin Hilman wrote:
>> Sourav Poddar<sourav.poddar@ti.com>  writes:
>>
>>> With dt boot, uart wakeup after suspend is non functional while using
>>> "no_console_suspend" in the bootargs. With "no_console_suspend" used, we
>>> should prevent the runtime suspend of the uart port which is getting used
>>> as an console.
>>>
>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>> Cc: Felipe Balbi<balbi@ti.com>
>>> Cc: Rajendra nayak<rnayak@ti.com>
>>> Tested on omap5430evm, omap4430sdp.
>>>
>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> Rather than make these special checks inside the driver's runtime PM
>> callbacks, you should just disable runtime PM (pm_runtime_disable())
>>
>> Then, this should be broken into 2 patches.
>>
>> 1) serial core: add the '->is_console' flag.  (nit on naming: don't call
>>     it port_is_console, since the struct is already a uart_port)
>>
>> 2) In the OMAP UART driver's ->prepare callback, check the is_console flag
>>     and pm_runtime_disable() accordingly  (then pm_runtime_enable() in
>>     the drivers's ->complete callback.
>>
>> Kevin
>
> I was working on your above suggestions, but realised there is not
> only console
> uart which has the requirement of keeping the clocks enabled while going on
> suspend.
>
> If you see arch/arm/boot/dts/am33xx.dtsi, there is a ocmcram which has
> "no_idle_on_suspend" property used.

Can you please ask the AM33xx folks how (and why) this is being used?

I don't see/find a driver for this device in mainline, so without a
driver this flag will not be used.

>     ocmcram: ocmcram@40300000 {
>                         compatible = "ti,am3352-ocmcram";
>                         reg = <0x40300000 0x10000>;
>                         ti,hwmods = "ocmcram";
>                         ti,no_idle_on_suspend;
>         };
> This property gets checked in omap_device file and correspondingly
> od->flags is set.
>
> Based on your above inputs, the patches which I cooked up is
> inlined[1]. Though, the below
> patches works fine for uart case. The patches will effect ocmcram case
> and I am inling them
> "just for discussion".

Could you also have a look at Russell's suggestion for getting rid of
the 'is_console' flag.

Thanks,

Kevin
