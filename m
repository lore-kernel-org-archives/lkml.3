Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaCAAbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:31:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaCAAbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:31:42 -0500
Date: Fri, 28 Feb 2014 16:33:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] drivercore: deferral race condition fix
Message-ID: <20140301003320.GA31852@kroah.com>
References: <1393398414-10822-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393398414-10822-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 09:06:54AM +0200, Peter Ujfalusi wrote:
> When the kernel is built with CONFIG_PREEMPT it is possible to reach a state
> when all modules are loaded but some driver still stuck in the deferred list
> and there is a need for external event to kick the deferred queue to probe
> these drivers.
> 
> The issue has been observed on embedded systems with CONFIG_PREEMPT enabled,
> audio support built as modules and using nfsroot for root filesystem.
> 
> The following fragment of a log shows such sequence when all audio modules
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
> it's probing (12.615118) and finishes first as well.
> The machine driver tries to construct the sound card (12.950839) but did
> not found one of the components so it fails. After this McASP driver
> registers all the ASoC components and the deferred work is prepared at
> 13.099026 (note that this time the machine driver is not in the lists so it
> is not going to be handled when the work is executing).
> Lastly the machine driver exit from it's probe and the core places it to the
> deferred list but there will be no other driver going to load and the
> deferred queue is not going to be kicked again - till we have external event
> like connecting USB stick, etc.
> 
> The proposed solution is to try the deferred queue once more when the last
> driver is asking for deferring and we had drivers loaded while this last
> driver was probing.

"once more"?  What happens if we get a new driver in when that one is
being probed?

It sounds like there's a race condition here somewhere, or improper
locking going on, just "let's try it again" doesn't sound like the
correct fix to me, does it to you?

thanks,

greg k-h
