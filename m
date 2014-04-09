Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbaDIHDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:03:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35513 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaDIHDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:03:43 -0400
Message-ID: <5344F0C9.5000503@ti.com>
Date: Wed, 9 Apr 2014 10:03:37 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] drivercore: deferral race condition fix
References: <1396509127-23819-1-git-send-email-peter.ujfalusi@ti.com> <20140408124335.D7843C4092C@trevor.secretlab.ca> <5343FB23.8090309@ti.com>
In-Reply-To: <5343FB23.8090309@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 04:35 PM, Peter Ujfalusi wrote:
> On 04/08/2014 03:43 PM, Grant Likely wrote:
>>> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
>>> index 06051767393f..80703de6e6ad 100644
>>> --- a/drivers/base/dd.c
>>> +++ b/drivers/base/dd.c
>>> @@ -53,6 +53,10 @@ static LIST_HEAD(deferred_probe_pending_list);
>>>  static LIST_HEAD(deferred_probe_active_list);
>>>  static struct workqueue_struct *deferred_wq;
>>>  
>>> +static atomic_t probe_count = ATOMIC_INIT(0);
>>> +static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
>>> +static bool deferral_retry;
>>> +
>>>  /**
>>>   * deferred_probe_work_func() - Retry probing devices in the active list.
>>>   */
>>> @@ -141,6 +145,11 @@ static void driver_deferred_probe_trigger(void)
>>>  	if (!driver_deferred_probe_enable)
>>>  		return;
>>>  
>>> +	if (atomic_read(&probe_count) > 1)
>>> +		deferral_retry = true;
>>> +	else
>>> +		deferral_retry = false;
>>
>> A few comments:
>> - Really need to comment why these lines are being added.
>> - I think this hunk needs to be moved to realy_probe(). It
>>   doesn't make any sense when called via deferred_probe_initcall(), and
>>   it doesn't work in the device_bind_driver path because the probe_count
>>   is not incremented there. In fact, the device_bind_driver() path has
>>   the same race condition, but it is unlikely to be a problem in
>>   practice because device_bind_driver() is used very rarely and doesn't
>>   execute any driver code.
> 
> The reason why I have added the flagging to driver_deferred_probe_trigger()
> because this is the place where the deferred drivers will be kicked.
> When the drivers are loaded in order during the boot it is not really
> interesting for this situation. When a driver has been moved to deferred queue
> is the time we need to watch for the 'race' to handle.
> I did have this flagging first in really_probe() but as far as I recall it
> exhibited random misses.
> The driver_deferred_probe_trigger() will be called every time when a driver
> probed with success - from driver_bound(), right? So what we are doing is that
> we set the deferral_retry flag if we have more than one driver's probe in
> progress and see if when the last driver leaves it's probe we had another
> loaded with success.
> The probe_count will be decremented after the driver_bound() so if we had only
> the two racy driver as last, we will have the flag set.
> Hrm, probably it might be better for readability to move the deferral_retry
> flag code just before the driver_bound() call in really_probe(). Inthis way we
> will have these in one place.

Now that I had time to think about this again I think the really_probe() is a
wrong place for this failsafe mechanism.
At the end we need to look and handle the following case:
When a driver probed with success while other driver(s) still in their probe
(thus not present in the deferred lists) we need to flag this event in the
driver_deferred_probe_trigger() function, just before the
list_splice_tail_init() call - when the deferred list is prepared.
Basically we set a flag for later use, that we have prepared the deferred list
but there were drivers in-fligth which we do not yet know if they are going to
end up deferring.

We need to check this flag in driver_deferred_probe_add() function which adds
the driver to the deferred pending list in case it returned with -EPROBE_DEFER.
Here we check the flag and also check if this is the last driver known to us
probing (probe_count == 1).
If these conditions met, we call driver_deferred_probe_trigger() from here as
an automatic one shot try to see if the previously loaded driver had satisfied
the deferred last driver.

I need to move driver_deferred_probe_add() down a bit in the source file for
this and rename the flag I had to 'deferred_auto_retry' or something.
I think this is going to be more robust and also gives cleaner explanation
what this 'recovery' code meant to do.

> 
>> - The 'if' is unnecessary:
>> 	deferred_retry = (atomic_read(&probe_count) > 1);
>>
>>> +
>>>  	/*
>>>  	 * A successful probe means that all the devices in the pending list
>>>  	 * should be triggered to be reprobed.  Move all the deferred devices
>>> @@ -259,9 +268,6 @@ int device_bind_driver(struct device *dev)
>>>  }
>>>  EXPORT_SYMBOL_GPL(device_bind_driver);
>>>  
>>> -static atomic_t probe_count = ATOMIC_INIT(0);
>>> -static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
>>> -
>>>  static int really_probe(struct device *dev, struct device_driver *drv)
>>>  {
>>>  	int ret = 0;
>>> @@ -310,6 +316,16 @@ probe_failed:
>>>  		/* Driver requested deferred probing */
>>>  		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
>>>  		driver_deferred_probe_add(dev);
>>> +		/*
>>> +		 * This is the last driver to load and asking to be deferred.
>>> +		 * If other driver(s) loaded while this driver was loading, we
>>> +		 * should try the deferred modules again to avoid missing
>>> +		 * dependency for this driver.
>>> +		 */
>>> +		if (atomic_read(&probe_count) == 1 && deferral_retry) {
>>> +			deferral_retry = false;
>>> +			driver_deferred_probe_trigger();
>>> +		}
>>
>> Testing the probe count probably isn't necessary. Clearing the flag
>> though is probably racy if there are two deferred drivers in flight.
> 
> I think it is a good thing to have to avoid kicking the deferred list all the
> time. If we still have 5 driver still probing we can just wait till the last
> is gone and just check if we need to do an 'emergency' kick to the deferred list.
> 
>> I would rather be happier if each probe could track on its own if there
>> had been any successful probes and then decide whether or not to trigger
>> again based on that, but when I played with it I found that it just
>> creates another race condition between calling really_probe() and
>> really_probe() grabbing a probe state footprint. Everything I tried made
>> things more complicated than less.
> 
> Yes, I also experimented with other ways but things got more fragile with even
> more corner cases to handle and understand...
> 
>> Go ahead and add my a-b when you
>> respin the patch.
>>
>> Acked-by: Grant Likely <grant.likely@linaro.org>
> 
> Thanks, I'll send the v2 tomorrow.
> 
>>
>>
>>>  	} else if (ret != -ENODEV && ret != -ENXIO) {
>>>  		/* driver matched but the probe failed */
>>>  		printk(KERN_WARNING
>>> -- 
>>> 1.9.1
>>>
>>
> 
> 


-- 
Péter
