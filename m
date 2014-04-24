Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaDXHbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:31:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50775 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaDXHbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:31:50 -0400
Message-ID: <5358BDDF.1010709@ti.com>
Date: Thu, 24 Apr 2014 10:31:43 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <grant.likely@secretlab.ca>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] drivercore: deferral race condition fix
References: <1397040727-2447-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1397040727-2447-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Grant,

On 04/09/2014 01:52 PM, Peter Ujfalusi wrote:
> Hi,
> 
> Changes since v1:
> - The deferral race detection and handling has been moved to
>   driver_deferred_probe_trigger() and driver_deferred_probe_add() functions with
>   comment section.
> - driver_deferred_probe_add/del function needed to be moved. Both of them placed
>   after driver_deferred_probe_trigger() so they remain together.
> - I have not added the Acked-by from Mark and Grant since the patch itself
>   changed from v1, but the functionality remained.

Is this solution sounds good? Do you want me to resend the two patch?

Regards,
Péter

> Explanantion of the issue (from patch 2):
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
> Regards,
> Peter
> ---
> Peter Ujfalusi (2):
>   drivercore: dd: Move driver_deferred_probe_add/del function down in
>     the code
>   drivercore: deferral race condition fix
> 
>  drivers/base/dd.c | 71 +++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 48 insertions(+), 23 deletions(-)

