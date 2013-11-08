Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3KHAIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:08:36 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:61583 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3KHAI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:08:27 -0500
Message-ID: <527C2B78.2070201@ti.com>
Date: Thu, 07 Nov 2013 18:08:24 -0600
From: Nishanth Menon <nm@ti.com>
Reply-To: nm@ti.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, paul@pwsan.com, rnayak@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: omap_device: maintain sane runtime pm status
 around suspend/resume
References: <1383857942-23630-1-git-send-email-nm@ti.com> <87iow3rd3y.fsf@linaro.org>
In-Reply-To: <87iow3rd3y.fsf@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 05:44 PM, Kevin Hilman wrote:
> Nishanth Menon <nm@ti.com> writes:
>
>> OMAP device hooks around suspend|resume_noirq ensures that hwmod
>> devices are forced to idle using omap_device_idle/enable as part of
>> the last stage of suspend activity.
>>
>> For a device such as i2c who uses autosuspend, it is possible to enter
>> the suspend path with dev->power.runtime_status = RPM_ACTIVE.
>>
>> As part of the suspend flow, the generic runtime logic would increment
>> it's dev->power.disable_depth to 1. This should prevent further
>> pm_runtime_get_sync from succeeding once the runtime_status has been
>> set to RPM_SUSPENDED.
>>
>> Now, as part of the suspend_noirq handler in omap_device, we force the
>> following: if the device status is !suspended, we force the device
>> to idle using omap_device_idle (clocks are cut etc..). This ensures
>> that from a hardware perspective, the device is "suspended". However,
>> runtime_status is left to be active.
>>
>> *if* an operation is attempted after this point to
>> pm_runtime_get_sync, runtime framework depends on runtime_status to
>> indicate accurately the device status, and since it sees it to be
>> ACTIVE, it assumes the module is functional and returns a non-error
>> value. As a result the user will see pm_runtime_get succeed, however a
>> register access will crash due to the lack of clocks.
>
> Ouch.
>
> Dumb Q: who is requesting an i2c transaction after ->suspend_noirq().
> The i2c driver itself should be able to detect that it's being accessed
> after this point and return an error.

i2c dropped it generic suspend handlers at
commit 584b408d37af4e0b38ad5b60f236381bcdf396bc
Author: Kevin Hilman <khilman@ti.com>
Date:   Thu Aug 4 07:53:02 2011 -0700

     Revert "i2c-omap: fix static suspend vs. runtime suspend"

     Also, as of v3.1, the PM domain level code for OMAP handles device
     power state transistions automatically for devices, so drivers no
     longer need to specifically call the bus/pm_domain methods themselves.


- So it is rightly in the mercy of runtime PM to adequately represent 
it's state. I disagree that i2c driver should in addition have to 
remember what it's generic suspend state is.
  - See the link to the cpufreq and the logs to see the call stack where 
it fails.

Now, this is fine, since omap_i2c_xfer should ideally fail with a 
pm_runtime_get_sync returning -EACCESS when device is really suspended 
(remember, we are doing autosuspend - so, in the case I caught, there 
was regulator voltage set prior to entering suspend, but timeout was not 
yet hit for autosuspend of i2c to kick in yet).

>
> That being said, I agree that omap_device should still be catching this
> case in order to find/fix driver races like this.

>
>> To prevent this from happening, we should ensure that runtime_status
>> exactly indicates the device status. As a result of this change
>> any further calls to pm_runtime_get* would return -EACCES (since
>> disable_depth is 1). On resume, we restore the clocks and runtime
>> status exactly as we suspended with.
>>
>> Reported-by: J Keerthy <j-keerthy@ti.com>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> Acked-by: Rajendra Nayak <rnayak@ti.com>
>> ---
>> patch baseline: V3.12 tag (also applies on linux-next next-20131107 tag)
>>
>> Logs from 3.12 based vendor kernel:
>> Before: http://pastebin.com/m5KxnB7a
>> After: http://pastebin.com/8AfX4e7r
>>
>> The discussion on cpufreq side of the story which triggered this scenario:
>> 	http://marc.info/?l=linux-pm&m=138263811321921&w=2
>>
>> Tested on TI vendor kernel (with dt boot):
>> 	AM335x: evm, BBB, sk, BBW
>> 	OMAP5uEVM, DRA7-evm
>>
>>   arch/arm/mach-omap2/omap_device.c |   16 ++++++++++++++--
>>   arch/arm/mach-omap2/omap_device.h |    1 +
>>   2 files changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
>> index b69dd9a..87ecbb0 100644
>> --- a/arch/arm/mach-omap2/omap_device.c
>> +++ b/arch/arm/mach-omap2/omap_device.c
>> @@ -621,6 +621,13 @@ static int _od_suspend_noirq(struct device *dev)
>>
>>   	if (!ret && !pm_runtime_status_suspended(dev)) {
>>   		if (pm_generic_runtime_suspend(dev) == 0) {
>> +			if (!pm_runtime_suspended(dev)) {
>
> Why the addition check for supended here?

pm_runtime_status_suspended checks only the dev->power.runtime_status
but that may not truely indicate device was in previous use - in the 
case of devices like i2c who depend on autosuspend.

pm_runtime_suspended checks for dev->power.runtime_status == 
RPM_SUSPENDED and disable_depth

>
> This version (as opposed to the _status_suspended() version above will
> fail if runtime PM has been disabled from userspace (via
> /sys/devices/.../power/control), and will thus prevent low power states
> from being hit in suspend if runtime suspend has been disabled from
> userspace.  That's a bug.

yes, and so it should fail to achieve low power state. we explicitly 
stated disable suspend, yet we go behind the runtime PM's back and force 
disable the module clocks. now drivers should NOT know what the state of 
the omap_device meddling is and should obey the configuration and 
completely trust pm_runtime to accurately denote the module state.

>
>> +				/* NOTE: *might* indicate driver race */
>
> Yes, a driver race which should then be fixed in the driver.

true if this is a non-autosuspend device, in auto suspend devices, this 
could be a regular phenomenon if timeout is pretty large.. but atleast 
that should allow debug.
>
>> +				dev_dbg(dev, "%s: Force suspending\n",
>> +					__func__);
>> +				pm_runtime_set_suspended(dev);
>> +				od->flags |= OMAP_DEVICE_SUSPEND_FORCED;
>
> Not sure why you need an additonal flag.  Why not just always do this
> and use the existin OMAP_DEVICE_SUSPENDED flag.

restore of runtime data structure state is only needed for specific 
devices - not all..

--
Regards,
Nishanth Menon
