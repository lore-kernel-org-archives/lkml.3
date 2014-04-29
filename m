Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaD2IEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:04:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36197 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaD2IED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:04:03 -0400
Message-ID: <535F5CEC.8090401@ti.com>
Date: Tue, 29 Apr 2014 11:03:56 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] drivercore: deferral race condition fix
References: <1397040727-2447-1-git-send-email-peter.ujfalusi@ti.com>	<5358BDDF.1010709@ti.com>	<CACxGe6sJtEeMOx+qMws2BCC4tuHMnWRAZv9NkEPADAtXAvtM4g@mail.gmail.com> <20140428141844.8AFB9C40AF4@trevor.secretlab.ca>
In-Reply-To: <20140428141844.8AFB9C40AF4@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 05:18 PM, Grant Likely wrote:
> On Thu, 24 Apr 2014 22:01:02 +0100, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Thu, Apr 24, 2014 at 8:31 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>>> Hi Greg, Grant,
>>>
>>> On 04/09/2014 01:52 PM, Peter Ujfalusi wrote:
>>>> Hi,
>>>>
>>>> Changes since v1:
>>>> - The deferral race detection and handling has been moved to
>>>>   driver_deferred_probe_trigger() and driver_deferred_probe_add() functions with
>>>>   comment section.
>>>> - driver_deferred_probe_add/del function needed to be moved. Both of them placed
>>>>   after driver_deferred_probe_trigger() so they remain together.
>>>> - I have not added the Acked-by from Mark and Grant since the patch itself
>>>>   changed from v1, but the functionality remained.
>>>
>>> Is this solution sounds good? Do you want me to resend the two patch?
>>
>> You don't need to resend. I just got back from vacation. I will look
>> at it tomorrow.
> 
> Hi Peter,
> 
> I think I have a cleaner solution. I think it avoids a lot of the corner
> cases that I was concerned about with the flag approach. Can you look at
> this and tell me if it works for you?
> 
> Basically, at the start of each probe, really_probe() checks how many
> triggers have occurred, and then later in the defer failure path, it
> checks to see if the trigger number has changed. If it has, then it is
> possible that the dependencies are resolved, so it does a trigger again.
> 
> I could refine this a bit more. The local_trigger_count could be passed
> into driver_deferred_probe_add() and the add function could be more
> intelligent about only adding that one device to the active list instead
> of the entire pending list. However, I don't think doing a full trigger
> is actually going to be expensive in the conditions that will trigger
> the race. Unless you can convince me otherwise, I think it is better to
> keep it simple.

I don't think we can be more clever with this. I just noticed that my patch
would fail to trigger in the following case (because it was trying to be clever):
Four drivers probing at the same time and they return from their probes with:
1st driver: deferred
2nd driver: probe OK
3rd driver: deferred
4th driver: Error

With my patch we would not have driver_deferred_probe_trigger() called to
check if the 3rd driver has it's dependency because when it was deferring it
was not the last driver and the last driver is returned with error.

Your patch would handle this fine since it is going to call
driver_deferred_probe_trigger() for the 3rd driver.

This is why I think we can not be too clever. Actually we can be clever but it
means we need to add more code and logic.

Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> g.
> 
> ---
> 
> drivercore: deferral race condition fix
> 
> When the kernel is built with CONFIG_PREEMPT it is possible to reach a state
> when all modules loaded but some driver still stuck in the deferred list
> and there is a need for external event to kick the deferred queue to probe
> these drivers.
> 
> The issue has been observed on embedded systems with CONFIG_PREEMPT enabled,
> audio support built as modules and using nfsroot for root filesystem.
> 
> The following log fragment shows such sequence when all audio modules
> were loaded but the sound card is not present since the machine driver has
> failed to probe due to missing dependency during it's probe.
> The board is am335x-evmsk (McASP<->tlv320aic3106 codec) with davinci-evm
> machine driver:
> 
> ...
> [   12.615118] davinci-mcasp 4803c000.mcasp: davinci_mcasp_probe: ENTER
> [   12.719969] davinci_evm sound.3: davinci_evm_probe: ENTER
> [   12.725753] davinci_evm sound.3: davinci_evm_probe: snd_soc_register_card
> [   12.753846] davinci-mcasp 4803c000.mcasp: davinci_mcasp_probe: snd_soc_register_component
> [   12.922051] davinci-mcasp 4803c000.mcasp: davinci_mcasp_probe: snd_soc_register_component DONE
> [   12.950839] davinci_evm sound.3: ASoC: platform (null) not registered
> [   12.957898] davinci_evm sound.3: davinci_evm_probe: snd_soc_register_card DONE (-517)
> [   13.099026] davinci-mcasp 4803c000.mcasp: Kicking the deferred list
> [   13.177838] davinci-mcasp 4803c000.mcasp: really_probe: probe_count = 2
> [   13.194130] davinci_evm sound.3: snd_soc_register_card failed (-517)
> [   13.346755] davinci_mcasp_driver_init: LEAVE
> [   13.377446] platform sound.3: Driver davinci_evm requests probe deferral
> [   13.592527] platform sound.3: really_probe: probe_count = 0
> 
> In the log the machine driver enters it's probe at 12.719969 (this point it
> has been removed from the deferred lists). McASP driver already executing
> it's probing (since 12.615118).
> The machine driver tries to construct the sound card (12.950839) but did
> not found one of the components so it fails. After this McASP driver
> registers all the ASoC components (the machine driver still in it's probe
> function after it failed to construct the card) and the deferred work is
> prepared at 13.099026 (note that this time the machine driver is not in the
> lists so it is not going to be handled when the work is executing).
> Lastly the machine driver exit from it's probe and the core places it to
> the deferred list but there will be no other driver going to load and the
> deferred queue is not going to be kicked again - till we have external event
> like connecting USB stick, etc.
> 
> The proposed solution is to check if a trigger has occured during probe, and
> if so then trigger the deferred queue again in the defer path.
> 
> This way we can avoid drivers stuck in the deferred queue.
> 
> [commit description written by Peter Ujfalusi]
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> 
> ---
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 8986b9f22781..af76fcd8da64 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -52,6 +52,7 @@ static DEFINE_MUTEX(deferred_probe_mutex);
>  static LIST_HEAD(deferred_probe_pending_list);
>  static LIST_HEAD(deferred_probe_active_list);
>  static struct workqueue_struct *deferred_wq;
> +static atomic_t deferred_trigger_count = ATOMIC_INIT(0);
>  
>  /**
>   * deferred_probe_work_func() - Retry probing devices in the active list.
> @@ -135,6 +136,17 @@ static bool driver_deferred_probe_enable = false;
>   * This functions moves all devices from the pending list to the active
>   * list and schedules the deferred probe workqueue to process them.  It
>   * should be called anytime a driver is successfully bound to a device.
> + *
> + * Note, there is a race condition in multi-threaded probe. In the case where
> + * more than one device is probing at the same time, it is possible for one
> + * probe to complete successfully while another is about to defer. If the second
> + * depends on the first, then it will get put on the pending list after the
> + * trigger event has already occured and will be stuck there.
> + *
> + * The atomic 'deferred_trigger_count' is used to determine if a successful
> + * trigger has occurred in the midst of probing a driver. If the trigger count
> + * changes in the midst of a probe, then deferred processing should be triggered
> + * again.
>   */
>  static void driver_deferred_probe_trigger(void)
>  {
> @@ -147,6 +159,7 @@ static void driver_deferred_probe_trigger(void)
>  	 * into the active list so they can be retried by the workqueue
>  	 */
>  	mutex_lock(&deferred_probe_mutex);
> +	atomic_inc(&deferred_trigger_count);
>  	list_splice_tail_init(&deferred_probe_pending_list,
>  			      &deferred_probe_active_list);
>  	mutex_unlock(&deferred_probe_mutex);
> @@ -265,6 +278,7 @@ static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
>  static int really_probe(struct device *dev, struct device_driver *drv)
>  {
>  	int ret = 0;
> +	int local_trigger_count = atomic_read(&deferred_trigger_count);
>  
>  	atomic_inc(&probe_count);
>  	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
> @@ -310,6 +324,8 @@ probe_failed:
>  		/* Driver requested deferred probing */
>  		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
>  		driver_deferred_probe_add(dev);
> +		if (local_trigger_count != atomic_read(&deferred_trigger_count))
> +			driver_deferred_probe_trigger();
>  	} else if (ret != -ENODEV && ret != -ENXIO) {
>  		/* driver matched but the probe failed */
>  		printk(KERN_WARNING
> 


-- 
Péter
