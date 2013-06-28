Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3F1Hwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:52:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:62443 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab3F1Hwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:52:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,957,1363158000"; 
   d="scan'208";a="357120057"
Message-ID: <51CD40E1.1030602@intel.com>
Date: Fri, 28 Jun 2013 15:53:05 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH 3/4] ACPI / PM: Rework and clean up acpi_dev_pm_get_state()
References: <6895318.cKDBc4OdI0@vostro.rjw.lan> <1756031.gcnLRAM3xz@vostro.rjw.lan> <51CBF3AA.2030508@intel.com> <3200056.Wt99JoHYx7@vostro.rjw.lan>
In-Reply-To: <3200056.Wt99JoHYx7@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 08:09 PM, Rafael J. Wysocki wrote:
> On Thursday, June 27, 2013 04:11:22 PM Aaron Lu wrote:
>> On 06/14/2013 08:32 PM, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> The acpi_dev_pm_get_state() function defined in device_pm.c is quite
>>> convoluted, which isn't really necessary, and it doesn't validate the
>>> values returned by the ACPI methods executed by it appropriately.
>>>
>>> To address these shortcomings modify it in the following way.
>>>
>>>  (1) Make its return value only mean whether or not it succeeded and
>>>      pass the device power states determined by it through pointers.
>>>
>>>  (2) Drop the d_max_in argument, used by only one of its callers,
>>>      from it, and move the code related to d_max_in into that caller,
>>>      acpi_pm_device_sleep_state().
>>>
>>>  (3) Make it always check the return value of acpi_evaluate_integer()
>>>      and handle failures as appropriate.  Moreover, make it check if
>>>      the values returned by the executed ACPI methods are not out of
>>>      range.
>>>
>>>  (4) Make it check if the values returned by the executed ACPI
>>>      methods represent valid power states of the given device and
>>>      handle situations in which that's not the case gracefully.
>>>
>>> Also update the kerneldoc comments of acpi_dev_pm_get_state() and
>>> acpi_pm_device_sleep_state() to reflect the code changes.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> ---
>>>  drivers/acpi/device_pm.c |  158 +++++++++++++++++++++++++++--------------------
>>>  1 file changed, 92 insertions(+), 66 deletions(-)
>>>
>>> Index: linux-pm/drivers/acpi/device_pm.c
>>> ===================================================================
>>> --- linux-pm.orig/drivers/acpi/device_pm.c
>>> +++ linux-pm/drivers/acpi/device_pm.c
>>> @@ -403,44 +403,37 @@ EXPORT_SYMBOL(acpi_bus_can_wakeup);
>>>   * @dev: Device whose preferred target power state to return.
>>>   * @adev: ACPI device node corresponding to @dev.
>>>   * @target_state: System state to match the resultant device state.
>>> - * @d_max_in: Deepest low-power state to take into consideration.
>>> - * @d_min_p: Location to store the upper limit of the allowed states range.
>>> - * Return value: Preferred power state of the device on success, -ENODEV
>>> - * (if there's no 'struct acpi_device' for @dev) or -EINVAL on failure
>>> + * @d_min_p: Location to store the highest power state available to the device.
>>> + * @d_max_p: Location to store the lowest power state available to the device.
>>>   *
>>> - * Find the lowest power (highest number) ACPI device power state that the
>>> - * device can be in while the system is in the state represented by
>>> - * @target_state.  If @d_min_p is set, the highest power (lowest number) device
>>> - * power state that @dev can be in for the given system sleep state is stored
>>> - * at the location pointed to by it.
>>> + * Find the lowest power (highest number) and highest power (lowest number) ACPI
>>> + * device power states that the device can be in while the system is in the
>>> + * state represented by @target_state.  Store the integer numbers representing
>>> + * those stats in the memory locations pointed to by @d_max_p and @d_min_p,
>>> + * respectively.
>>>   *
>>>   * Callers must ensure that @dev and @adev are valid pointers and that @adev
>>>   * actually corresponds to @dev before using this function.
>>> + *
>>> + * Returns 0 on success or -ENODATA when one of the ACPI methods fails or
>>> + * returns a value that doesn't make sense.  The memory locations pointed to by
>>> + * @d_max_p and @d_min_p are only modified on success.
>>>   */
>>>  static int acpi_dev_pm_get_state(struct device *dev, struct acpi_device *adev,
>>> -				 u32 target_state, int d_max_in, int *d_min_p)
>>> +				 u32 target_state, int *d_min_p, int *d_max_p)
>>>  {
>>> -	char acpi_method[] = "_SxD";
>>> -	unsigned long long d_min, d_max;
>>> +	char method[] = { '_', 'S', '0' + target_state, 'D', '\0' };
>>> +	acpi_handle handle = adev->handle;
>>> +	unsigned long long ret;
>>> +	int d_min, d_max;
>>>  	bool wakeup = false;
>>> +	acpi_status status;
>>>  
>>> -	if (d_max_in < ACPI_STATE_D0 || d_max_in > ACPI_STATE_D3_COLD)
>>> -		return -EINVAL;
>>> -
>>> -	if (d_max_in > ACPI_STATE_D3_HOT) {
>>> -		enum pm_qos_flags_status stat;
>>> -
>>> -		stat = dev_pm_qos_flags(dev, PM_QOS_FLAG_NO_POWER_OFF);
>>> -		if (stat == PM_QOS_FLAGS_ALL)
>>> -			d_max_in = ACPI_STATE_D3_HOT;
>>> -	}
>>> -
>>> -	acpi_method[2] = '0' + target_state;
>>>  	/*
>>> -	 * If the sleep state is S0, the lowest limit from ACPI is D3,
>>> -	 * but if the device has _S0W, we will use the value from _S0W
>>> -	 * as the lowest limit from ACPI.  Finally, we will constrain
>>> -	 * the lowest limit with the specified one.
>>> +	 * If the system state is S0, the lowest power state the device can be
>>> +	 * in is D3cold, unless the device has _S0W and is supposed to signal
>>> +	 * wakeup, in which case the return value of _S0W has to be used as the
>>> +	 * lowest power state available to the device.
>>>  	 */
>>>  	d_min = ACPI_STATE_D0;
>>>  	d_max = ACPI_STATE_D3_COLD;
>>> @@ -449,12 +442,30 @@ static int acpi_dev_pm_get_state(struct
>>>  	 * If present, _SxD methods return the minimum D-state (highest power
>>>  	 * state) we can use for the corresponding S-states.  Otherwise, the
>>>  	 * minimum D-state is D0 (ACPI 3.x).
>>> -	 *
>>> -	 * NOTE: We rely on acpi_evaluate_integer() not clobbering the integer
>>> -	 * provided -- that's our fault recovery, we ignore retval.
>>>  	 */
>>>  	if (target_state > ACPI_STATE_S0) {
>>> -		acpi_evaluate_integer(adev->handle, acpi_method, NULL, &d_min);
>>> +		/*
>>> +		 * We rely on acpi_evaluate_integer() not clobbering the integer
>>> +		 * provided if AE_NOT_FOUND is returned.
>>> +		 */
>>> +		ret = d_min;
>>> +		status = acpi_evaluate_integer(handle, method, NULL, &ret);
>>> +		if ((ACPI_FAILURE(status) && status != AE_NOT_FOUND)
>>> +		    || ret > ACPI_STATE_D3_COLD)
>>> +			return -ENODATA;
>>> +
>>> +		/*
>>> +		 * We need to handle legacy systems where D3hot and D3cold are
>>> +		 * the same and 3 is returned in both cases, so fall back to
>>> +		 * D3cold if D3hot is not a valid state.
>>> +		 */
>>> +		if (!adev->power.states[ret].flags.valid) {
>>> +			if (ret == ACPI_STATE_D3_HOT)
>>> +				ret = ACPI_STATE_D3_COLD;
>>> +			else
>>> +				return -ENODATA;
>>> +		}
>>> +		d_min = ret;
>>>  		wakeup = device_may_wakeup(dev) && adev->wakeup.flags.valid
>>>  			&& adev->wakeup.sleep_state >= target_state;
>>>  	} else if (dev_pm_qos_flags(dev, PM_QOS_FLAG_REMOTE_WAKEUP) !=
>>> @@ -470,36 +481,29 @@ static int acpi_dev_pm_get_state(struct
>>>  	 * can wake the system.  _S0W may be valid, too.
>>>  	 */
>>>  	if (wakeup) {
>>> -		acpi_status status;
>>> -
>>> -		acpi_method[3] = 'W';
>>> -		status = acpi_evaluate_integer(adev->handle, acpi_method, NULL,
>>> -						&d_max);
>>> -		if (ACPI_FAILURE(status)) {
>>> -			if (target_state != ACPI_STATE_S0 ||
>>> -			    status != AE_NOT_FOUND)
>>> +		method[3] = 'W';
>>> +		status = acpi_evaluate_integer(handle, method, NULL, &ret);
>>> +		if (status == AE_NOT_FOUND) {
>>> +			if (target_state > ACPI_STATE_S0)
>>>  				d_max = d_min;
>>> -		} else if (d_max < d_min) {
>>> -			/* Warn the user of the broken DSDT */
>>> -			printk(KERN_WARNING "ACPI: Wrong value from %s\n",
>>> -				acpi_method);
>>> -			/* Sanitize it */
>>> -			d_min = d_max;
>>> +		} else if (ACPI_SUCCESS(status) && ret <= ACPI_STATE_D3_COLD) {
>>> +			/* Fall back to D3cold if ret is not a valid state. */
>>> +			if (!adev->power.states[ret].flags.valid)
>>> +				ret = ACPI_STATE_D3_COLD;
>>> +
>>> +			d_max = ret > d_min ? ret : d_min;
>>> +		} else {
>>> +			return -ENODATA;
>>>  		}
>>>  	}
>>>  
>>> -	if (d_max_in < d_min)
>>> -		return -EINVAL;
>>>  	if (d_min_p)
>>>  		*d_min_p = d_min;
>>> -	/* constrain d_max with specified lowest limit (max number) */
>>> -	if (d_max > d_max_in) {
>>> -		for (d_max = d_max_in; d_max > d_min; d_max--) {
>>> -			if (adev->power.states[d_max].flags.valid)
>>> -				break;
>>> -		}
>>> -	}
>>> -	return d_max;
>>> +
>>> +	if (d_max_p)
>>> +		*d_max_p = d_max;
>>> +
>>> +	return 0;
>>>  }
>>>  
>>>  /**
>>> @@ -508,7 +512,8 @@ static int acpi_dev_pm_get_state(struct
>>>   * @d_min_p: Location to store the upper limit of the allowed states range.
>>>   * @d_max_in: Deepest low-power state to take into consideration.
>>>   * Return value: Preferred power state of the device on success, -ENODEV
>>> - * (if there's no 'struct acpi_device' for @dev) or -EINVAL on failure
>>> + * if there's no 'struct acpi_device' for @dev, -EINVAL if @d_max_in is
>>> + * incorrect, or -ENODATA on ACPI method failure.
>>>   *
>>>   * The caller must ensure that @dev is valid before using this function.
>>>   */
>>> @@ -516,14 +521,39 @@ int acpi_pm_device_sleep_state(struct de
>>>  {
>>>  	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
>>>  	struct acpi_device *adev;
>>> +	int ret, d_max;
>>> +
>>> +	if (d_max_in < ACPI_STATE_D0 || d_max_in > ACPI_STATE_D3_COLD)
>>> +		return -EINVAL;
>>> +
>>> +	if (d_max_in > ACPI_STATE_D3_HOT) {
>>> +		enum pm_qos_flags_status stat;
>>> +
>>> +		stat = dev_pm_qos_flags(dev, PM_QOS_FLAG_NO_POWER_OFF);
>>> +		if (stat == PM_QOS_FLAGS_ALL)
>>> +			d_max_in = ACPI_STATE_D3_HOT;
>>> +	}
>>>  
>>>  	if (!handle || acpi_bus_get_device(handle, &adev)) {
>>>  		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
>>>  		return -ENODEV;
>>>  	}
>>>  
>>> -	return acpi_dev_pm_get_state(dev, adev, acpi_target_system_state(),
>>> -				     d_max_in, d_min_p);
>>> +	ret = acpi_dev_pm_get_state(dev, adev, acpi_target_system_state(),
>>> +				    d_min_p, &d_max);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	if (d_max_in < *d_min_p)
>>> +		return -EINVAL;
>>
>> d_min_p can be NULL here.
>>
>> Call trace:
>> acpi_pm_device_sleep_state, where d_min_p is passed as NULL
>> acpi_pci_choose_state
>> pci_choose_state
>> atl1e_suspend
>> atl1e_shutdown
>> pci_device_shutdown
>> device_shutdown
> 
> Right, the patch below should fix that.

Confirmed, no more oops.
Feel free to add my Tested-by.

Thanks,
Aaron

> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / PM: Fix possible NULL pointer deref in acpi_pm_device_sleep_state()
> 
> After commit fa1675b (ACPI / PM: Rework and clean up
> acpi_dev_pm_get_state()) a NULL pointer dereference will take place
> if NULL is passed to acpi_pm_device_sleep_state() as the second
> argument.
> 
> Fix that by avoiding to use the pointer that may be NULL until
> it's necessary to store a return value at the location pointed to
> by it (if not NULL).
> 
> Reported-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/device_pm.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> Index: linux-pm/drivers/acpi/device_pm.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/device_pm.c
> +++ linux-pm/drivers/acpi/device_pm.c
> @@ -541,7 +541,7 @@ int acpi_pm_device_sleep_state(struct de
>  {
>  	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
>  	struct acpi_device *adev;
> -	int ret, d_max;
> +	int ret, d_min, d_max;
>  
>  	if (d_max_in < ACPI_STATE_D0 || d_max_in > ACPI_STATE_D3_COLD)
>  		return -EINVAL;
> @@ -560,19 +560,23 @@ int acpi_pm_device_sleep_state(struct de
>  	}
>  
>  	ret = acpi_dev_pm_get_state(dev, adev, acpi_target_system_state(),
> -				    d_min_p, &d_max);
> +				    &d_min, &d_max);
>  	if (ret)
>  		return ret;
>  
> -	if (d_max_in < *d_min_p)
> +	if (d_max_in < d_min)
>  		return -EINVAL;
>  
>  	if (d_max > d_max_in) {
> -		for (d_max = d_max_in; d_max > *d_min_p; d_max--) {
> +		for (d_max = d_max_in; d_max > d_min; d_max--) {
>  			if (adev->power.states[d_max].flags.valid)
>  				break;
>  		}
>  	}
> +
> +	if (d_min_p)
> +		*d_min_p = d_min;
> +
>  	return d_max;
>  }
>  EXPORT_SYMBOL(acpi_pm_device_sleep_state);
> 
> 

