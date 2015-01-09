Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbbAIIC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:02:29 -0500
Received: from smtp-out-084.synserver.de ([212.40.185.84]:1106 "EHLO
	smtp-out-084.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbbAIIC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:02:28 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21981
Message-ID: <54AF8B0C.2050301@metafoo.de>
Date: Fri, 09 Jan 2015 09:02:20 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Jianqun Xu <jay.xu@rock-chips.com>, lgirdwood@gmail.com, heiko@sntech.de,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        sonnyrao@chromium.org
CC: linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH] ASoC: rockchip: i2s: add rockchip_dmaengine_pcm_config
References: <1420768369-6681-1-git-send-email-jay.xu@rock-chips.com>
In-Reply-To: <1420768369-6681-1-git-send-email-jay.xu@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 02:52 AM, Jianqun Xu wrote:
> This patch makes snd_dmaengine_pcm_register with rockchip_dmaengine_pcm_config,
> which configure the parameters of period and buffer match to rockchip DMAC.
>
> =======================
> without rockchip_dmaengine_pcm_config, and test with command -
> aplay -D hw:0,0 /tmp/a, there are the error dump:
> [  134.899396] dma-pl330 ffb20000.dma-controller: fill_queue:2251 Bad Desc(7)
> [  134.906270] dma-pl330 ffb20000.dma-controller: fill_queue:2251 Bad Desc(8)
> [  134.913141] dma-pl330 ffb20000.dma-controller: fill_queue:2251 Bad Desc(9)
>
> And bellow sound from DMA debugger:
> "I debugged it a little and it looks like what is happening is that requests
> which aren't a multiple of burst size * burst length are coming in.  Right
> now the i2s block is setting a burst size of 4 and burst length of 4, but
> the dmaengine code has no idea about this restriction.  I was able to
> eliminate the messages by changing burst length to 1 in the i2s driver.
> This fix would always work as long as we're sending a multiple of 4 bytes
> (which so far seems to be the case)"
>
> This patch can make the length of dma buffer is aligned to a multiple of burst size
> and burst length.

No, all it does it sets the maximum size to something that is aligned, an 
application can still choose something else.

And this is the wrong approach anyway, we don't want to have new 
snd_pcm_hardware for drivers using generic dmaengine PCM driver.

The right approach is to modify the dmaengine PCM driver to set a constraint 
that makes sure that the period size is a multiple of the burst size.

- Lars
