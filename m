Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbaLVP70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:59:26 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:39732 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754975AbaLVP7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:59:25 -0500
Message-ID: <54983FB9.2040805@arm.com>
Date: Mon, 22 Dec 2014 15:58:49 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] ASoC: dwc: Add devicetree support for Designware
 I2S
References: <cover.1418826016.git.Andrew.Jackson@arm.com> <9699e11a566938b8d1821f9be3df3276d57cd979.1418826016.git.Andrew.Jackson@arm.com> <20141222141014.GS17800@sirena.org.uk>
In-Reply-To: <20141222141014.GS17800@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/14 14:10, Mark Brown wrote:
> On Fri, Dec 19, 2014 at 04:18:08PM +0000, Andrew Jackson wrote:
> 
>> +union snd_dma_data {
>> +	struct i2s_dma_data pd;
>> +	struct snd_dmaengine_dai_dma_data dt;
>> +};
>> +
> 
> This is a driver local union with a very generic name, it seems likely
> that this will collide in future causing build breaks

I'll change it.

> 
>> -	ret = dev->i2s_clk_cfg(config);
>> -	if (ret < 0) {
>> -		dev_err(dev->dev, "runtime audio clk config fail\n");
>> -		return ret;
>> +		/* TODO: Validate sample rate against permissible set */
>> +		bitclk = config->sample_rate * config->data_width * 2;
>> +		clk_set_rate(dev->clk, bitclk);
>>  	}
> 
> This is ignoring errors in clk_set_rate().
> 
>> +/* Maximum resolution of a channel - not uniformly spaced */
>> +static const u32 fifo_width[] = {
>> +	12, 16, 20, 24, 32, 0, 0, 0
>> +};
>> +
>> +/* Width of (DMA) bus */
>> +static const u32 bus_widths[] = {
>> +	DMA_SLAVE_BUSWIDTH_1_BYTE,
>> +	DMA_SLAVE_BUSWIDTH_2_BYTES,
>> +	DMA_SLAVE_BUSWIDTH_4_BYTES,
>> +	DMA_SLAVE_BUSWIDTH_UNDEFINED
>> +};
> 
>> +	u32 bus_width = bus_widths[COMP1_APB_DATA_WIDTH(comp1)];
>> +	u32 fifo_depth = 1 << (1 + COMP1_FIFO_DEPTH_GLOBAL(comp1));
>> +	u32 max_size;
> 
> I'd feel a lot more comfortable if there were bounds checking on these
> array indexes, especially since the arrays aren't explicitly sized and
> instead just have the number of elements that is (hopefully) safe with
> no comments or anything.  As things stand this is all using really
> fraigle idioms, this could easily be broken if someone is updating the
> driver for new IP features or even just cleaning up the code.

I will add robustness.  

> 
>> -	dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
>> -	dev->clk = clk_get(&pdev->dev, NULL);
>> +		dev->clk = clk_get(&pdev->dev, NULL);
>> +	} else {
>> +		dw_configure_dai_by_dt(dev, dw_i2s_dai, res);
>> +
>> +		dev->clk = devm_clk_get(&pdev->dev, "i2sclk");
>> +	}
> 
> This changes from clk_get() to devm_clk_get() but I'm not seeing
> anything that removes clk_put() calls.
> 
>> +#ifdef CONFIG_OF
>> +		.of_match_table = dw_i2s_of_match,
>> +#endif
> 
> of_match_ptr().
> 

Thanks for all the comments.

	Andrew
