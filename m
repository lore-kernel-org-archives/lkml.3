Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaGBM4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:56:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35903 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbaGBM4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:56:31 -0400
Message-ID: <53B4016F.9060005@ti.com>
Date: Wed, 2 Jul 2014 15:56:15 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        <joelf@ti.com>, <nsekhar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <dmaengine@vger.kernel.org>
Subject: Re: [PATCH 4/4] ALSA: pcm_dmaengine: Correct support for 3 physical
 bytes samples
References: <1404300570-14082-1-git-send-email-peter.ujfalusi@ti.com> <1404300570-14082-5-git-send-email-peter.ujfalusi@ti.com> <53B3FEB5.1040508@ti.com> <53B3FF9C.6060102@metafoo.de>
In-Reply-To: <53B3FF9C.6060102@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 03:48 PM, Lars-Peter Clausen wrote:
>> per discussion over the irc with Lars we could extend the masking to other
>> widths as well, which would look something like this:
>> u32 addr_widths = BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
>>           BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
>>           BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
>> ...
>> /*
>>   * Prepare formats mask for valid/allowed sample types. If the dma does
>>   * not have support for the given physical word size, it needs to be
>>   * masked out so user space can not use the format which produces
>>   * corrupted audio.
>>   * In case the dma driver does not implement the slave_caps the default
>>   * assumption is that it supports 1, 2 and 4 bytes widths.
>>   */
>> if (!dma_get_slave_caps(prtd->dma_chan, &dma_caps)) {
>>     if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
>>         addr_widths = dma_caps.dstn_addr_widths;
>>     else
>>         addr_widths = dma_caps.src_addr_widths;
>> }
>>
>> for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
>>     int bits = snd_pcm_format_physical_width(i);
>>
>>     switch (bits) {
>>     case 8:
>>         if (!(addr_widths & BIT(DMA_SLAVE_BUSWIDTH_1_BYTE)))
>>             fmt_mask |= (1LL << i);
>>         break;
>>     case 16:
>>         if (!(addr_widths & BIT(DMA_SLAVE_BUSWIDTH_2_BYTES)))
>>             fmt_mask |= (1LL << i);
>>         break;
>>     case 24:
>>         if (!(addr_widths & BIT(DMA_SLAVE_BUSWIDTH_3_BYTES)))
>>             fmt_mask |= (1LL << i);
>>         break;
>>     case 32:
>>         if (!(addr_widths & BIT(DMA_SLAVE_BUSWIDTH_4_BYTES)))
>>             fmt_mask |= (1LL << i);
>>         break;
>>     case 64:
>>         if (!(addr_widths & BIT(DMA_SLAVE_BUSWIDTH_8_BYTES)))
>>             fmt_mask |= (1LL << i);
>>         break;
>>     default:
>>         fmt_mask |= (1LL << i);
>>         break;
>>     }
>> }
>>
>> Is this sounds better?
> 
> Sounds good. I think we can assume that DMA_SLAVE_BUSWIDTH_1_BYTE = 1, ...
> So (addr_width & BIT(bits / 8)) should work fine and we do not need to
> duplicate the case branches.
> 
> The other thing is this should go into dmaengine_pcm_set_runtime_hwparams()
> where we also restrict the other hardware parameters based on the dmaengine
> capabilities.

true

-- 
Péter
