Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762907Ab3DCRsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:48:25 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53999 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab3DCRsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:48:21 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Rajendra nayak <rnayak@ti.com>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH/Resend 2/2] arm: mach-omap2: prevent UART console idle on suspend while using "no_console_suspend"
In-Reply-To: <515AA9CD.5000004@ti.com> (Sourav Poddar's message of "Tue, 2 Apr
	2013 15:20:05 +0530")
References: <1363612924-349-1-git-send-email-sourav.poddar@ti.com>
	<87fvzsilnv.fsf@linaro.org> <5149A221.5@ti.com>
	<5149A63C.4000102@ti.com> <515AA9CD.5000004@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Wed, 03 Apr 2013 10:48:18 -0700
Message-ID: <87txnnzesd.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav Poddar <sourav.poddar@ti.com> writes:

> Hi Kevin,
> On Wednesday 20 March 2013 05:36 PM, Sourav Poddar wrote:
>> Realised the list  to whom the patch was send got dropped. Ccing
>> them all..
>> On Wednesday 20 March 2013 05:18 PM, Sourav Poddar wrote:
>>> Hi Kevin,
>>> On Tuesday 19 March 2013 12:24 AM, Kevin Hilman wrote:
>>>> Sourav Poddar<sourav.poddar@ti.com>  writes:
>>>>
>>>>> With dt boot, uart wakeup after suspend is non functional on
>>>>> omap4/5 while using
>>>>> "no_console_suspend" in the bootargs. With "no_console_suspend"
>>>>> used, od->flags
>>>>> should be ORed with "OMAP_DEVICE_NO_IDLE_ON_SUSPEND", thereby not
>>>>> allowing the console
>>>>> to idle in the suspend path. For non-dt case, this was taken care
>>>>> by platform data.
>>>>>
>>>>> Tested on omap5430evm, omap4430sdp.
>>>>>
>>>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>>> Cc: Felipe Balbi<balbi@ti.com>
>>>>> Cc: Rajendra nayak<rnayak@ti.com>
>>>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>>>> This patch creates a dependency between omap_device (generic,
>>>> device-independent code) and a specific driver (UART.)
>>>>
>>>> If you need to do something like this that's DT boot specific, then
>>>> we probably need some late initcall in serial.c to handle this.
>>>> It does
>>>> not belong in omap_device.
>>>>
>>> The following function "omap_device_disable_idle_on_suspend(pdev)"
>>> should only
>>> be called once the omap device has been build, which in the case of
>>> device tree is
>>> done in omap_device.c file. Moreover, the above call should be
>>> executed conditionally
>>> and should depend on the following two parameter.
>>>
>>> [1]  a. Whether "no_console_suspend" is set and
>>>      b.  the device build is a console uart.
>>>
>>> When I look closely into the serial.c file, I realised that
>>> "core_initcall(omap_serial_early_init)" gets called irrespective
>>> of dt/non dt boot and will take care of most of the stuff(checking
>>> whether
>>> "no_console_suspend" is used and which uart is used as a console
>>> uart) which the
>>> $subject patch is proposing.
>>>
>>> But the problem is that we need to exchange the parsed information
>>> from serial.c to the omap_device file for the condtional execution of
>>> "omap_device_disable_idle_on_suspend"
>>>
>>> In this case,
>>> from "serial.c" we need
>>>     1. no_console_suspend = true
>>>     2. strcpy(console_name, oh_name), where oh_name corresponds to
>>> the console uart.
>>>
>>> then in "omap_device.c" do
>>>     if (no_console_suspend && !strcmp(oh->name, console_name))
>>>                 omap_device_disable_idle_on_suspend(pdev);
>>>
>>> Please correct if I am understanding it incorrectly.
>>>
>>> If the above understanding looks good to you, is there a way we can
>>> make this
>>> exchange of information happen between serial.c and omap_device.c file?
> Any input on this?
> As I explained earlier, that there is a need to parse information in
> serial.c and use that in
> omap_device.c only after the device is build.

As I explained earlier, any device specific hacks inside omap_device
should be a red flag that something has gone wrong.

How about fixing the UART driver/core to not runtime suspend if
no_console_suspend is given?  

Then we can get rid of this no_idle_on_suspend hack all together since
UART is the only remaining user.

Kevin
