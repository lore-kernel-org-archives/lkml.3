Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab3KNTam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:30:42 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33330 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab3KNTad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:30:33 -0500
Message-ID: <528524BD.9010005@ti.com>
Date: Thu, 14 Nov 2013 13:30:05 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <paul@pwsan.com>, <rnayak@ti.com>,
        <khilman@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] ARM: OMAP2+: omap_device: maintain sane runtime pm
 status around suspend/resume
References: <1384297710-29694-1-git-send-email-nm@ti.com> <1384448716-3186-1-git-send-email-nm@ti.com> <20131114185558.GB16529@saruman.home>
In-Reply-To: <20131114185558.GB16529@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 12:55 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Nov 14, 2013 at 11:05:16AM -0600, Nishanth Menon wrote:
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
>>
>> To prevent this from happening, we should ensure that runtime_status
>> exactly indicates the device status. As a result of this change
>> any further calls to pm_runtime_get* would return -EACCES (since
>> disable_depth is 1). On resume, we restore the clocks and runtime
>> status exactly as we suspended with. These operations are not expected
>> to fail as we update the states after the core runtime framework has
>> suspended itself and restore before the core runtime framework has
>> resumed.
>>
>> Reported-by: J Keerthy <j-keerthy@ti.com>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> Acked-by: Rajendra Nayak <rnayak@ti.com>
>> Acked-by: Kevin Hilman <khilman@linaro.org>
>> ---
>> Changes in V3:
>> 	- Added WARN in case of unexpected failure of runtime pm status restore
>> v2: https://patchwork.kernel.org/patch/3176501/
>> v1: https://patchwork.kernel.org/patch/3154501/
>>
>> patch baseline: V3.12 tag (also applies on linux-next next-20131107 tag)
>>
>>  arch/arm/mach-omap2/omap_device.c |   13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
>> index b69dd9a..53f0735 100644
>> --- a/arch/arm/mach-omap2/omap_device.c
>> +++ b/arch/arm/mach-omap2/omap_device.c
>> @@ -621,6 +621,7 @@ static int _od_suspend_noirq(struct device *dev)
>>  
>>  	if (!ret && !pm_runtime_status_suspended(dev)) {
>>  		if (pm_generic_runtime_suspend(dev) == 0) {
>> +			pm_runtime_set_suspended(dev);
>>  			omap_device_idle(pdev);
>>  			od->flags |= OMAP_DEVICE_SUSPENDED;
>>  		}
>> @@ -634,10 +635,18 @@ static int _od_resume_noirq(struct device *dev)
>>  	struct platform_device *pdev = to_platform_device(dev);
>>  	struct omap_device *od = to_omap_device(pdev);
>>  
>> -	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
>> -	    !pm_runtime_status_suspended(dev)) {
>> +	if (od->flags & OMAP_DEVICE_SUSPENDED) {
>>  		od->flags &= ~OMAP_DEVICE_SUSPENDED;
>>  		omap_device_enable(pdev);
>> +		/*
>> +		 * XXX: we run before core runtime pm has resumed itself. At
>> +		 * this point in time, we just restore the runtime pm state and
>> +		 * considering symmetric operations in resume, we donot expect
>> +		 * to fail. If we failed, something changed in core runtime_pm
>> +		 * framework OR some device driver messed things up, hence, WARN
>> +		 */
>> +		WARN(pm_runtime_set_active(dev),
>> +		     "Could not set %s runtime state active\n", dev_name(dev));
> 
> if you want to print the device name, how about dev_WARN() ?
> 
> no strong feelings though:

I would like to stick with WARN as dev_WARN would probably need an
condition check.. unless someone has a strong opinion, I dont see it
adding value here.

> 
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> 


-- 
Regards,
Nishanth Menon
