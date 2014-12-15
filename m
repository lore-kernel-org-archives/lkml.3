Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaLOIil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:38:41 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:43721 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750836AbaLOIij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:38:39 -0500
Message-ID: <548E9DE0.7050502@arm.com>
Date: Mon, 15 Dec 2014 08:37:52 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] ASoC: dwc: Ensure FIFOs are flushed to prevent
 channel swap
References: <cover.1418372910.git.Andrew.Jackson@arm.com> <a3b4a11dfe1688eea07471c6cfa27676cc9a58a8.1418372910.git.Andrew.Jackson@arm.com> <548AB75E.9030302@metafoo.de>
In-Reply-To: <548AB75E.9030302@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/14 09:37, Lars-Peter Clausen wrote:
> On 12/12/2014 10:25 AM, Andrew Jackson wrote:
>> From: Andrew Jackson <Andrew.Jackson@arm.com>
>>
>> If the FIFOs aren't flushed, the left/right channels may be swapped:
>> this may occur if the FIFOs are not empty when the streams start.
>>
>> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
>> ---
>>   sound/soc/dwc/designware_i2s.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
>> index ef771ea..b9d6a25 100644
>> --- a/sound/soc/dwc/designware_i2s.c
>> +++ b/sound/soc/dwc/designware_i2s.c
>> @@ -228,12 +228,14 @@ static int dw_i2s_hw_params(struct snd_pcm_substream *substream,
>>   	i2s_disable_channels(dev, substream->stream);
>>
>>   	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
>> +		i2s_write_reg(dev->i2s_base, TXFFR, 1);
>>   		i2s_write_reg(dev->i2s_base, TCR(ch_reg), xfer_resolution);
>>   		i2s_write_reg(dev->i2s_base, TFCR(ch_reg), 0x02);
>>   		irq = i2s_read_reg(dev->i2s_base, IMR(ch_reg));
>>   		i2s_write_reg(dev->i2s_base, IMR(ch_reg), irq & ~0x30);
>>   		i2s_write_reg(dev->i2s_base, TER(ch_reg), 1);
>>   	} else {
>> +		i2s_write_reg(dev->i2s_base, RXFFR, 1);
>>   		i2s_write_reg(dev->i2s_base, RCR(ch_reg), xfer_resolution);
>>   		i2s_write_reg(dev->i2s_base, RFCR(ch_reg), 0x07);
>>   		irq = i2s_read_reg(dev->i2s_base, IMR(ch_reg));
>>
> 
> This should probably go into the prepare callback. prepare is for example 
> also called when recovering from a underrun/overrun. Whereas hwparams is 
> only called during initial setup of the stream.

That's a good idea: thank you.  I'll rework the patch with this in mind.

	Andrew

