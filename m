Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaCCI1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:27:08 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53810 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbaCCI1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:27:05 -0500
Message-ID: <53143CD3.30209@ti.com>
Date: Mon, 3 Mar 2014 10:26:59 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] drivercore: deferral race condition fix
References: <1393398414-10822-1-git-send-email-peter.ujfalusi@ti.com> <20140301003320.GA31852@kroah.com>
In-Reply-To: <20140301003320.GA31852@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2014 02:33 AM, Greg Kroah-Hartman wrote:
> On Wed, Feb 26, 2014 at 09:06:54AM +0200, Peter Ujfalusi wrote:
>> When the kernel is built with CONFIG_PREEMPT it is possible to reach a state
>> when all modules are loaded but some driver still stuck in the deferred list
>> and there is a need for external event to kick the deferred queue to probe
>> these drivers.
>>
>> The issue has been observed on embedded systems with CONFIG_PREEMPT enabled,
>> audio support built as modules and using nfsroot for root filesystem.
>>
>> The following fragment of a log shows such sequence when all audio modules
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
>> it's probing (12.615118) and finishes first as well.
>> The machine driver tries to construct the sound card (12.950839) but did
>> not found one of the components so it fails. After this McASP driver
>> registers all the ASoC components and the deferred work is prepared at
>> 13.099026 (note that this time the machine driver is not in the lists so it
>> is not going to be handled when the work is executing).
>> Lastly the machine driver exit from it's probe and the core places it to the
>> deferred list but there will be no other driver going to load and the
>> deferred queue is not going to be kicked again - till we have external event
>> like connecting USB stick, etc.
>>
>> The proposed solution is to try the deferred queue once more when the last
>> driver is asking for deferring and we had drivers loaded while this last
>> driver was probing.
> 
> "once more"?  What happens if we get a new driver in when that one is
> being probed?
> 
> It sounds like there's a race condition here somewhere, or improper
> locking going on, just "let's try it again" doesn't sound like the
> correct fix to me, does it to you?

The whole idea of deferred_probe is to "let's try it again". The issue
surfaces under certain conditions (main factors being CONFIG_PREEMPT + nfsroot
+ single core vs multi core?) so this could be a race condition or it could be
just how things are.
After the first driver asks to be deferred we for sure have two paths from
where the drivers are probed: still not probed drivers and drivers from the
deferred probe list.
At this point nothing stops drivers to be probed in parallel and it is just a
matter of timing if we hit the state which I have been experiencing.
In this case we have two driver processing their probe and we do not yet know
if one of them going to be asking to be deferred so neither of them should be
in the deferred list.
So we have an empty deferred list and two drivers probing in parallel. driver2
needs driver1 to be loaded:

driver1_probe(..)
{
	driver1_setup();
	register_me_to_somewhere();

	return 0;
}

driver2_probe(..)
{
	driver2_setup();

	if(!is_driver1_there()) {
		driver2_cleanup();
		return -EPROBE_DEFER;
	}

	return 0;
}

It is perfectly normal that these are running in parallel. driver2 checks if
driver1 is loaded already but driver1 still inside of it's driver1_setup()
function. driver2 starts to clean up before returning with -EPROBE_DEFER
meanwhile driver1 registers itself and it is now loaded. In dd.c the deferred
probe list is empty (the deferred work has nothing to do) since driver1 has
just finished with success and driver2 not yet returned from it's probe.

Now driver2 finished the cleanup and returned with -EPROBE_DEFER, it is placed
to the deferred list. And that's where we need an external event (USB device
plug) which will kick the deferred logic to probe the drivers in the deferred
list.

I think it is correct to detect this situation without the need to have non
related drivers to be probed.
The patch is doing this exactly: detects if we had successful parallel driver
probe(s) while another driver was probing which ends up requesting to be
deferred. We only try the deferred list again if this condition has been
detected, we do not loop on the deferred list, we do not try the list again if
there were no other drivers loaded since nothing happened which could satisfy
the driver asking to be deferred.

-- 
Péter
