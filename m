Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbaDHNfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:35:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42413 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552AbaDHNfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:35:40 -0400
Message-ID: <5343FB23.8090309@ti.com>
Date: Tue, 8 Apr 2014 16:35:31 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] drivercore: deferral race condition fix
References: <1396509127-23819-1-git-send-email-peter.ujfalusi@ti.com> <20140408124335.D7843C4092C@trevor.secretlab.ca>
In-Reply-To: <20140408124335.D7843C4092C@trevor.secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 03:43 PM, Grant Likely wrote:
> On Thu, 3 Apr 2014 10:12:07 +0300, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> When the kernel is built with CONFIG_PREEMPT it is possible to reach a state
>> when all modules loaded but some driver still stuck in the deferred list
>> and there is a need for external event to kick the deferred queue to probe
>> these drivers.
>>
>> The issue has been observed on embedded systems with CONFIG_PREEMPT enabled,
>> audio support built as modules and using nfsroot for root filesystem.
>>
>> The following log fragment shows such sequence when all audio modules
>> were loaded but the sound card is not present since the machine driver has
>> failed to probe due to missing dependency during it's probe.
>> The board is am335x-evmsk (McASP<->tlv320aic3106 codec) with davinci-evm
>> machine driver:
>>
>> ...
>> [   12.615118] davinci-mcasp 4803c000.mcasp: davinci_mcasp_probe: ENTER
>> [   12.719969] davinci_evm sound.3: davinci_evm_probe: ENTER
>> [   12.725753] davinci_evm sound.3: davinci_evm_probe: snd_soc_register_card
>> [   12.753846] davinci-mcasp 4803c000.mcasp: davinci_mcasp_probe: snd_soc_register_component
>> [   12.922051] davinci-mcasp 4803c000.mcasp: davinci_mcasp_probe: snd_soc_register_component DONE
>> [   12.950839] davinci_evm sound.3: ASoC: platform (null) not registered
>> [   12.957898] davinci_evm sound.3: davinci_evm_probe: snd_soc_register_card DONE (-517)
>> [   13.099026] davinci-mcasp 4803c000.mcasp: Kicking the deferred list
>> [   13.177838] davinci-mcasp 4803c000.mcasp: really_probe: probe_count = 2
>> [   13.194130] davinci_evm sound.3: snd_soc_register_card failed (-517)
>> [   13.346755] davinci_mcasp_driver_init: LEAVE
>> [   13.377446] platform sound.3: Driver davinci_evm requests probe deferral
>> [   13.592527] platform sound.3: really_probe: probe_count = 0
>>
>> In the log the machine driver enters it's probe at 12.719969 (this point it
>> has been removed from the deferred lists). McASP driver already executing
>> it's probing (since 12.615118).
>> The machine driver tries to construct the sound card (12.950839) but did
>> not found one of the components so it fails. After this McASP driver
>> registers all the ASoC components (the machine driver still in it's probe
>> function after it failed to construct the card) and the deferred work is
>> prepared at 13.099026 (note that this time the machine driver is not in the
>> lists so it is not going to be handled when the work is executing).
>> Lastly the machine driver exit from it's probe and the core places it to
>> the deferred list but there will be no other driver going to load and the
>> deferred queue is not going to be kicked again - till we have external event
>> like connecting USB stick, etc.
>>
>> The proposed solution is to try the deferred queue once more when the last
>> driver is asking for deferring and we had drivers loaded while this last
>> driver was probing.
>>
>> This way we can avoid drivers stuck in the deferred queue.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>  drivers/base/dd.c | 22 +++++++++++++++++++---
>>  1 file changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
>> index 06051767393f..80703de6e6ad 100644
>> --- a/drivers/base/dd.c
>> +++ b/drivers/base/dd.c
>> @@ -53,6 +53,10 @@ static LIST_HEAD(deferred_probe_pending_list);
>>  static LIST_HEAD(deferred_probe_active_list);
>>  static struct workqueue_struct *deferred_wq;
>>  
>> +static atomic_t probe_count = ATOMIC_INIT(0);
>> +static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
>> +static bool deferral_retry;
>> +
>>  /**
>>   * deferred_probe_work_func() - Retry probing devices in the active list.
>>   */
>> @@ -141,6 +145,11 @@ static void driver_deferred_probe_trigger(void)
>>  	if (!driver_deferred_probe_enable)
>>  		return;
>>  
>> +	if (atomic_read(&probe_count) > 1)
>> +		deferral_retry = true;
>> +	else
>> +		deferral_retry = false;
> 
> A few comments:
> - Really need to comment why these lines are being added.
> - I think this hunk needs to be moved to realy_probe(). It
>   doesn't make any sense when called via deferred_probe_initcall(), and
>   it doesn't work in the device_bind_driver path because the probe_count
>   is not incremented there. In fact, the device_bind_driver() path has
>   the same race condition, but it is unlikely to be a problem in
>   practice because device_bind_driver() is used very rarely and doesn't
>   execute any driver code.

The reason why I have added the flagging to driver_deferred_probe_trigger()
because this is the place where the deferred drivers will be kicked.
When the drivers are loaded in order during the boot it is not really
interesting for this situation. When a driver has been moved to deferred queue
is the time we need to watch for the 'race' to handle.
I did have this flagging first in really_probe() but as far as I recall it
exhibited random misses.
The driver_deferred_probe_trigger() will be called every time when a driver
probed with success - from driver_bound(), right? So what we are doing is that
we set the deferral_retry flag if we have more than one driver's probe in
progress and see if when the last driver leaves it's probe we had another
loaded with success.
The probe_count will be decremented after the driver_bound() so if we had only
the two racy driver as last, we will have the flag set.
Hrm, probably it might be better for readability to move the deferral_retry
flag code just before the driver_bound() call in really_probe(). Inthis way we
will have these in one place.

> - The 'if' is unnecessary:
> 	deferred_retry = (atomic_read(&probe_count) > 1);
> 
>> +
>>  	/*
>>  	 * A successful probe means that all the devices in the pending list
>>  	 * should be triggered to be reprobed.  Move all the deferred devices
>> @@ -259,9 +268,6 @@ int device_bind_driver(struct device *dev)
>>  }
>>  EXPORT_SYMBOL_GPL(device_bind_driver);
>>  
>> -static atomic_t probe_count = ATOMIC_INIT(0);
>> -static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
>> -
>>  static int really_probe(struct device *dev, struct device_driver *drv)
>>  {
>>  	int ret = 0;
>> @@ -310,6 +316,16 @@ probe_failed:
>>  		/* Driver requested deferred probing */
>>  		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
>>  		driver_deferred_probe_add(dev);
>> +		/*
>> +		 * This is the last driver to load and asking to be deferred.
>> +		 * If other driver(s) loaded while this driver was loading, we
>> +		 * should try the deferred modules again to avoid missing
>> +		 * dependency for this driver.
>> +		 */
>> +		if (atomic_read(&probe_count) == 1 && deferral_retry) {
>> +			deferral_retry = false;
>> +			driver_deferred_probe_trigger();
>> +		}
> 
> Testing the probe count probably isn't necessary. Clearing the flag
> though is probably racy if there are two deferred drivers in flight.

I think it is a good thing to have to avoid kicking the deferred list all the
time. If we still have 5 driver still probing we can just wait till the last
is gone and just check if we need to do an 'emergency' kick to the deferred list.

> I would rather be happier if each probe could track on its own if there
> had been any successful probes and then decide whether or not to trigger
> again based on that, but when I played with it I found that it just
> creates another race condition between calling really_probe() and
> really_probe() grabbing a probe state footprint. Everything I tried made
> things more complicated than less.

Yes, I also experimented with other ways but things got more fragile with even
more corner cases to handle and understand...

> Go ahead and add my a-b when you
> respin the patch.
> 
> Acked-by: Grant Likely <grant.likely@linaro.org>

Thanks, I'll send the v2 tomorrow.

> 
> 
>>  	} else if (ret != -ENODEV && ret != -ENXIO) {
>>  		/* driver matched but the probe failed */
>>  		printk(KERN_WARNING
>> -- 
>> 1.9.1
>>
> 


-- 
Péter
