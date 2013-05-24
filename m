Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3EXFzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 01:55:32 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:56578 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581Ab3EXFza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 01:55:30 -0400
Message-ID: <519F016C.4040901@metafoo.de>
Date: Fri, 24 May 2013 07:58:04 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/6] dma: Add a jz4740 dmaengine driver
References: <1369341387-19147-1-git-send-email-lars@metafoo.de> <1369341387-19147-4-git-send-email-lars@metafoo.de> <20130524045935.GM30200@intel.com>
In-Reply-To: <20130524045935.GM30200@intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 06:59 AM, Vinod Koul wrote:
> On Thu, May 23, 2013 at 10:36:24PM +0200, Lars-Peter Clausen wrote:
>> This patch adds dmaengine support for the JZ4740 DMA controller. For now the
>> driver will be a wrapper around the custom JZ4740 DMA API. Once all users of the
>> custom JZ4740 DMA API have been converted to the dmaengine API the custom API
>> will be removed and direct hardware access will be added to the dmaengine
>> driver.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> ---
> 
>> +static enum jz4740_dma_width jz4740_dma_width(enum dma_slave_buswidth width)
>> +{
>> +	switch (width) {
>> +	case DMA_SLAVE_BUSWIDTH_1_BYTE:
>> +		return JZ4740_DMA_WIDTH_8BIT;
>> +	case DMA_SLAVE_BUSWIDTH_2_BYTES:
>> +		return JZ4740_DMA_WIDTH_16BIT;
>> +	case DMA_SLAVE_BUSWIDTH_4_BYTES:
>> +		return JZ4740_DMA_WIDTH_32BIT;
>> +	default:
>> +		return JZ4740_DMA_WIDTH_32BIT;
>> +	}
> Only diff between the values here and dmaengien values is JZ4740_DMA_WIDTH_32BIT
> as 0. But the header tells me taht its default and SIZE one has values in that
> pattern too. If that is the case you maybe able to get rid on conversion and use
> dmaengine values directly.
> 

I'd prefer to keep it the way it is. The JZ4740_DMA_WIDTH constants end up
being written to the hardware, while the DMA_SLAVE_BUSWIDTH constants are Linux
internal. I prefer to not mix these two up.

>> +}
>> +
>> +static enum jz4740_dma_transfer_size jz4740_dma_maxburst(u32 maxburst)
>> +{
>> +	if (maxburst <= 1)
>> +		return JZ4740_DMA_TRANSFER_SIZE_1BYTE;
>> +	else if (maxburst <= 3)
>> +		return JZ4740_DMA_TRANSFER_SIZE_2BYTE;
>> +	else if (maxburst <= 15)
>> +		return JZ4740_DMA_TRANSFER_SIZE_4BYTE;
>> +	else if (maxburst <= 31)
>> +		return JZ4740_DMA_TRANSFER_SIZE_16BYTE;
>> +
>> +	return JZ4740_DMA_TRANSFER_SIZE_32BYTE;
>> +}
>> +
>> +static int jz4740_dma_slave_config(struct dma_chan *c,
>> +	const struct dma_slave_config *config)
>> +{
>> +	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
>> +	struct jz4740_dma_config jzcfg;
>> +
>> +	switch (config->direction) {
>> +	case DMA_MEM_TO_DEV:
>> +		jzcfg.flags = JZ4740_DMA_SRC_AUTOINC;
>> +		jzcfg.transfer_size = jz4740_dma_maxburst(config->dst_maxburst);
>> +		break;
>> +	case DMA_DEV_TO_MEM:
>> +		jzcfg.flags = JZ4740_DMA_DST_AUTOINC;
>> +		jzcfg.transfer_size = jz4740_dma_maxburst(config->src_maxburst);
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +
>> +	jzcfg.src_width = jz4740_dma_width(config->src_addr_width);
>> +	jzcfg.dst_width = jz4740_dma_width(config->dst_addr_width);
> this should be direction based, typically DMA engines have only one width to be
> programmed.

This one needs both.

>> +	jzcfg.mode = JZ4740_DMA_MODE_SINGLE;
>> +	jzcfg.request_type = config->slave_id;
>> +
>> +	chan->config = *config;
>> +
>> +	jz4740_dma_configure(chan->jz_chan, &jzcfg);
>> +
>> +	return 0;
> You are NOT use src_addr/dstn_addr? How else are you passing the periphral
> address?

I'm saving the whole config, which will later be used to retrieve the source or
dest address.

>> +}
[...]
>> +static int jz4740_dma_alloc_chan_resources(struct dma_chan *c)
>> +{
>> +	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
>> +
>> +	chan->jz_chan = jz4740_dma_request(chan, NULL);
>> +	if (!chan->jz_chan)
>> +		return -EBUSY;
>> +
>> +	jz4740_dma_set_complete_cb(chan->jz_chan, jz4740_dma_complete_cb);
>> +
>> +	return 0;
> Zero is not expected value, you need to return the descriptors allocated
> sucessfully.

Well, zero descriptors have been allocated. As far as I can see only a negative
return value is treated as an error. Also the core doesn't seem to use the
return value for anything else but checking if it is an error.

>> +}
>> +
[...]
>> +	dd->chancnt = 6;
> hard coding is not advised

But there are 6 channels ;)

[...]
>> +
>> +static struct platform_driver jz4740_dma_driver = {
>> +	.probe = jz4740_dma_probe,
>> +	.remove = jz4740_dma_remove,
>> +	.driver = {
>> +		.name = "jz4740-dma",
>> +		.owner = THIS_MODULE,
>> +	},
>> +};
>> +module_platform_driver(jz4740_dma_driver);
> typically lot of dma driver like to be higher up in the module order. The reason
> is to have device initialized before clients, pls check if you need that

I don't need it.

Thanks for the quick review.
- Lars
