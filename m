Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbaDHMr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:47:58 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42639 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbaDHMrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:47:55 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RESEND] drivercore: deferral race condition fix
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, gregkh@linuxfoundation.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1396509127-23819-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396509127-23819-1-git-send-email-peter.ujfalusi@ti.com>
Date: Tue, 08 Apr 2014 13:43:35 +0100
Message-Id: <20140408124335.D7843C4092C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2014 10:12:07 +0300, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
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
> The proposed solution is to try the deferred queue once more when the last
> driver is asking for deferring and we had drivers loaded while this last
> driver was probing.
> 
> This way we can avoid drivers stuck in the deferred queue.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/base/dd.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 06051767393f..80703de6e6ad 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -53,6 +53,10 @@ static LIST_HEAD(deferred_probe_pending_list);
>  static LIST_HEAD(deferred_probe_active_list);
>  static struct workqueue_struct *deferred_wq;
>  
> +static atomic_t probe_count = ATOMIC_INIT(0);
> +static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
> +static bool deferral_retry;
> +
>  /**
>   * deferred_probe_work_func() - Retry probing devices in the active list.
>   */
> @@ -141,6 +145,11 @@ static void driver_deferred_probe_trigger(void)
>  	if (!driver_deferred_probe_enable)
>  		return;
>  
> +	if (atomic_read(&probe_count) > 1)
> +		deferral_retry = true;
> +	else
> +		deferral_retry = false;

A few comments:
- Really need to comment why these lines are being added.
- I think this hunk needs to be moved to realy_probe(). It
  doesn't make any sense when called via deferred_probe_initcall(), and
  it doesn't work in the device_bind_driver path because the probe_count
  is not incremented there. In fact, the device_bind_driver() path has
  the same race condition, but it is unlikely to be a problem in
  practice because device_bind_driver() is used very rarely and doesn't
  execute any driver code.
- The 'if' is unnecessary:
	deferred_retry = (atomic_read(&probe_count) > 1);

> +
>  	/*
>  	 * A successful probe means that all the devices in the pending list
>  	 * should be triggered to be reprobed.  Move all the deferred devices
> @@ -259,9 +268,6 @@ int device_bind_driver(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(device_bind_driver);
>  
> -static atomic_t probe_count = ATOMIC_INIT(0);
> -static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
> -
>  static int really_probe(struct device *dev, struct device_driver *drv)
>  {
>  	int ret = 0;
> @@ -310,6 +316,16 @@ probe_failed:
>  		/* Driver requested deferred probing */
>  		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
>  		driver_deferred_probe_add(dev);
> +		/*
> +		 * This is the last driver to load and asking to be deferred.
> +		 * If other driver(s) loaded while this driver was loading, we
> +		 * should try the deferred modules again to avoid missing
> +		 * dependency for this driver.
> +		 */
> +		if (atomic_read(&probe_count) == 1 && deferral_retry) {
> +			deferral_retry = false;
> +			driver_deferred_probe_trigger();
> +		}

Testing the probe count probably isn't necessary. Clearing the flag
though is probably racy if there are two deferred drivers in flight.

I would rather be happier if each probe could track on its own if there
had been any successful probes and then decide whether or not to trigger
again based on that, but when I played with it I found that it just
creates another race condition between calling really_probe() and
really_probe() grabbing a probe state footprint. Everything I tried made
things more complicated than less. Go ahead and add my a-b when you
respin the patch.

Acked-by: Grant Likely <grant.likely@linaro.org>


>  	} else if (ret != -ENODEV && ret != -ENXIO) {
>  		/* driver matched but the probe failed */
>  		printk(KERN_WARNING
> -- 
> 1.9.1
> 

