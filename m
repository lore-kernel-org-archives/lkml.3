Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbaD2NNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:13:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaD2NNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:13:04 -0400
Date: Tue, 29 Apr 2014 06:13:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH v4] drivercore: deferral race condition fix
Message-ID: <20140429131332.GA7049@kroah.com>
References: <1398774909-13649-1-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398774909-13649-1-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 01:35:09PM +0100, Grant Likely wrote:
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
> v4: New approach; keep track of trigger events instead of nested probing.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Stable <stable@vger.kernel.org> # v3.4+
> ---
> 
> Hi Greg,
> 
> This change needs to go into 3.15. I've got this patch in the
> devicetree/merge branch of my tree and can ask Linus to pull it directly
> if you would like.

Sure, that would be fine:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
