Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaGBMsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:48:33 -0400
Received: from smtp-out-155.synserver.de ([212.40.185.155]:1051 "EHLO
	smtp-out-155.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaGBMsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:48:32 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28462
Message-ID: <53B3FF9C.6060102@metafoo.de>
Date: Wed, 02 Jul 2014 14:48:28 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, tiwai@suse.de,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        joelf@ti.com, nsekhar@ti.com
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 4/4] ALSA: pcm_dmaengine: Correct support for 3 physical
 bytes samples
References: <1404300570-14082-1-git-send-email-peter.ujfalusi@ti.com> <1404300570-14082-5-git-send-email-peter.ujfalusi@ti.com> <53B3FEB5.1040508@ti.com>
In-Reply-To: <53B3FEB5.1040508@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 02:44 PM, Peter Ujfalusi wrote:
> On 07/02/2014 02:29 PM, Peter Ujfalusi wrote:
>> In case of _3LE/_3BE formats the samples are stored in 3 consecutive bytes
>> without padding it to 4 bytes. This means that the DMA needs to be able to
>> support 3 bytes word length in order to read/write the samples from memory
>> correctly. Originally the code treated 24 bits physical length samples as
>> they were 32 bits which leads to corruption when playing or recording audio.
>>
>> In snd_dmaengine_pcm_open() we should check the slave_caps of the dma if it
>> supports DMA_SLAVE_BUSWIDTH_3_BYTES. Based on this information we initialize
>> the runtime->hw.formats: if DMA_SLAVE_BUSWIDTH_3_BYTES is not supported or
>> the slave_caps is not provided by the driver we mask out the 24 bits
>> physical width sample formats so they will be not available for user space
>> to pick. If the DMA_SLAVE_BUSWIDTH_3_BYTES is supported _3LE/_3BE formats
>> will not be masked so later on they can be valid if both CPU and codec dai
>> supports them.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>   sound/core/pcm_dmaengine.c | 39 ++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 38 insertions(+), 1 deletion(-)
>>
>> diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
>> index d5611ec80381..519b500c5669 100644
>> --- a/sound/core/pcm_dmaengine.c
>> +++ b/sound/core/pcm_dmaengine.c
>> @@ -72,6 +72,8 @@ int snd_hwparams_to_dma_slave_config(const struct snd_pcm_substream *substream,
>>   		buswidth = DMA_SLAVE_BUSWIDTH_1_BYTE;
>>   	else if (bits == 16)
>>   		buswidth = DMA_SLAVE_BUSWIDTH_2_BYTES;
>> +	else if (bits == 24)
>> +		buswidth = DMA_SLAVE_BUSWIDTH_3_BYTES;
>>   	else if (bits <= 32)
>>   		buswidth = DMA_SLAVE_BUSWIDTH_4_BYTES;
>>   	else
>> @@ -292,8 +294,12 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_request_channel);
>>   int snd_dmaengine_pcm_open(struct snd_pcm_substream *substream,
>>   	struct dma_chan *chan)
>>   {
>> +	struct snd_pcm_runtime *runtime = substream->runtime;
>>   	struct dmaengine_pcm_runtime_data *prtd;
>> -	int ret;
>> +	struct dma_slave_caps dma_caps;
>> +	bool dma_3bytes_supported = false;
>> +	u64 fmt_mask = 0;
>> +	int i, ret;
>>
>>   	if (!chan)
>>   		return -ENXIO;
>> @@ -311,6 +317,37 @@ int snd_dmaengine_pcm_open(struct snd_pcm_substream *substream,
>>
>>   	substream->runtime->private_data = prtd;
>>
>> +	/*
>> +	 * Prepare formats mask for valid/allowed sample types. If the dma does
>> +	 * not support 3bytes word size, it needs to be masked out so user space
>> +	 * can not use the format which produces corrupted audio.
>> +	 * If the dma driver does not implement get_slave_caps callback, treat
>> +	 * it as no 3bytes word support.
>> +	 */
>> +	if (!dma_get_slave_caps(prtd->dma_chan, &dma_caps)) {
>> +		u32 addr_widths;
>> +
>> +		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
>> +			addr_widths = dma_caps.dstn_addr_widths;
>> +		else
>> +			addr_widths = dma_caps.src_addr_widths;
>> +
>> +		if (addr_widths & BIT(DMA_SLAVE_BUSWIDTH_3_BYTES))
>> +			dma_3bytes_supported = true;
>> +	}
>> +
>> +	for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
>> +		int bits = snd_pcm_format_physical_width(i);
>> +
>> +		if (bits == 24 && !dma_3bytes_supported)
>> +			fmt_mask |= (1LL << i);
>> +	}
>
> per discussion over the irc with Lars we could extend the masking to other
> widths as well, which would look something like this:
> u32 addr_widths = BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
> 		  BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
> 		  BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
> ...
> /*
>   * Prepare formats mask for valid/allowed sample types. If the dma does
>   * not have support for the given physical word size, it needs to be
>   * masked out so user space can not use the format which produces
>   * corrupted audio.
>   * In case the dma driver does not implement the slave_caps the default
>   * assumption is that it supports 1, 2 and 4 bytes widths.
>   */
> if (!dma_get_slave_caps(prtd->dma_chan, &dma_caps)) {
> 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> 		addr_widths = dma_caps.dstn_addr_widths;
> 	else
> 		addr_widths = dma_caps.src_addr_widths;
> }
>
> for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
> 	int bits = snd_pcm_format_physical_width(i);
>
> 	switch (bits) {
> 	case 8:
> 		if (!(addr_widths & BIT(DMA_SLAVE_BUSWIDTH_1_BYTE)))
> 			fmt_mask |= (1LL << i);
> 		break;
> 	case 16:
> 		if (!(addr_widths & BIT(DMA_SLAVE_BUSWIDTH_2_BYTES)))
> 			fmt_mask |= (1LL << i);
> 		break;
> 	case 24:
> 		if (!(addr_widths & BIT(DMA_SLAVE_BUSWIDTH_3_BYTES)))
> 			fmt_mask |= (1LL << i);
> 		break;
> 	case 32:
> 		if (!(addr_widths & BIT(DMA_SLAVE_BUSWIDTH_4_BYTES)))
> 			fmt_mask |= (1LL << i);
> 		break;
> 	case 64:
> 		if (!(addr_widths & BIT(DMA_SLAVE_BUSWIDTH_8_BYTES)))
> 			fmt_mask |= (1LL << i);
> 		break;
> 	default:
> 		fmt_mask |= (1LL << i);
> 		break;
> 	}
> }
>
> Is this sounds better?

Sounds good. I think we can assume that DMA_SLAVE_BUSWIDTH_1_BYTE = 1, ...
So (addr_width & BIT(bits / 8)) should work fine and we do not need to 
duplicate the case branches.

The other thing is this should go into dmaengine_pcm_set_runtime_hwparams() 
where we also restrict the other hardware parameters based on the dmaengine 
capabilities.

- Lars
