Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaCML5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:57:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37045 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbaCML5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:57:33 -0400
Message-ID: <53219D08.9070308@ti.com>
Date: Thu, 13 Mar 2014 13:56:56 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        <nsekhar@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jyri Sarha <jsarha@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>, <mporter@linaro.org>,
        <dan.j.williams@intel.com>, <vinod.koul@intel.com>
Subject: Re: [alsa-devel] [PATCH 14/18] ASoC: davinci: Add edma dmaengine
 platform driver
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com> <1394702320-21743-15-git-send-email-peter.ujfalusi@ti.com> <53218835.3080909@metafoo.de>
In-Reply-To: <53218835.3080909@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 12:28 PM, Lars-Peter Clausen wrote:
> On 03/13/2014 10:18 AM, Peter Ujfalusi wrote: [...]
>> +static const struct snd_pcm_hardware edma_pcm_hardware = { +    .info
>> = SNDRV_PCM_INFO_MMAP | +                  SNDRV_PCM_INFO_MMAP_VALID | +
>> SNDRV_PCM_INFO_BATCH | +                  SNDRV_PCM_INFO_PAUSE |
>> SNDRV_PCM_INFO_RESUME | +                  SNDRV_PCM_INFO_INTERLEAVED, +
>> .buffer_bytes_max    = 128 * 1024, +    .period_bytes_min    = 32, +
>> .period_bytes_max    = 64 * 1024, +    .periods_min        = 2, +
>> .periods_max        = 19, /* Limit by edma dmaengine driver */ +};
> 
> The idea is that we can auto-discover all the things using the
> dma_slave_caps API. Too bad we removed the possibility to specify the
> maximum number of segments from the API. Maybe we need to add it back. Is
> the 19 a hard-limit or could it be worked around by software in the
> dmaengine driver?

The edma dmaengine driver will refuse to configure more than 20 paRAM slots (1
for the channel + 19 for the periods). Depending on the SoC we might have
different number of paRAM entries available. The intention with the limit was
to prevent cases when we run out of paRAM entires for other devices because
audio took most of them.

>> + +static const struct snd_dmaengine_pcm_config edma_dmaengine_pcm_config
>> = { +    .pcm_hardware = &edma_pcm_hardware, +    .prepare_slave_config =
>> snd_dmaengine_pcm_prepare_slave_config, +    .prealloc_buffer_size = 128
>> * 1024,
> 
> Unless there is a very good reason for exactly this size, just leave it 0
> and let the generic dmaengine driver use the default.

I'd rather keep this here. Since I have the .pcm_hardware the core will ignore
the snd_pcm_hardware.buffer_bytes_max when preallocating and it is in fact
going to go for:
	prealloc_buffer_size = 512 * 1024;
	max_buffer_size = SIZE_MAX;

While I have 128 * 1024 for the snd_pcm_hardware.buffer_bytes_max.

I think as long as I have the .pcm_hardware provided from the edma-pcm driver
I will have the .prealloc_buffer_size as well.

>> +}; + +static const struct snd_dmaengine_pcm_config 
>> edma_compat_dmaengine_pcm_config = { +    .pcm_hardware =
>> &edma_pcm_hardware, +    .prepare_slave_config =
>> snd_dmaengine_pcm_prepare_slave_config, +    .compat_filter_fn =
>> edma_filter_fn, +    .prealloc_buffer_size = 128 * 1024, +};
> 
> There is no need for different configs for DT and non-DT.
> 
>> + +int edma_pcm_platform_register(struct device *dev) +{ +    if
>> (dev->of_node) +        return snd_dmaengine_pcm_register(dev, +
>> &edma_dmaengine_pcm_config, +
>> SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
> 
> Since the edma dmaengine driver implements the slave cap API there is no
> need to manually specify SND_DMAENGINE_PCM_FLAG_NO_RESIDUE manually. But
> since the edma driver sets the granularity to
> DMA_RESIDUE_GRANULARITY_DESCRIPTOR in this case the generic dmaengine will
> not set SND_DMAENGINE_PCM_FLAG_NO_RESIDUE automatically since it assumes
> that the dmaengine driver is capable of properly reporting the DMA
> position.
> 
>> +    else +        return snd_dmaengine_pcm_register(dev, +
>> &edma_compat_dmaengine_pcm_config, +
>> SND_DMAENGINE_PCM_FLAG_NO_RESIDUE | +
>> SND_DMAENGINE_PCM_FLAG_NO_DT | +
>> SND_DMAENGINE_PCM_FLAG_COMPAT);
> 
> 
> If you set the flags to just SND_DMAENGINE_PCM_FLAG_COMPAT it will do the 
> right thing in the generic dmaengine driver depending on whether
> dev->of_node is set or not.

I have missed these in the core. Makes the code simpler for sure.

> There is also a devm_ version of snd_dmaengine_pcm_register() it probably 
> makes sense to use it here.

I forgot about the devm_ version. True, I'll use that instead.

-- 
Péter
