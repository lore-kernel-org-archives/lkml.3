Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444Ab3EOOwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:52:31 -0400
Received: from smtp-out-070.synserver.de ([212.40.185.70]:1285 "EHLO
	smtp-out-069.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759182Ab3EOOwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:52:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25614
Message-ID: <5193A113.4050301@metafoo.de>
Date: Wed, 15 May 2013 16:52:03 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC/PATCH] dma: of: Make of_dma_simple_xlate match on DMA device
 and channel ID
References: <1368624449-29003-1-git-send-email-laurent.pinchart@ideasonboard.com> <51938FFD.2020300@metafoo.de> <3106852.EdI2KVGSEm@avalon>
In-Reply-To: <3106852.EdI2KVGSEm@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 03:55 PM, Laurent Pinchart wrote:
> Hi Lars-Peter,
> 
> (CC'ing LAKML, I had forgotten to do so when I sent the patch)
> 
> On Wednesday 15 May 2013 15:39:09 Lars-Peter Clausen wrote:
>> On 05/15/2013 03:27 PM, Laurent Pinchart wrote:
>>> When translating a DT DMA channel specifier, the most common use case is
>>> to match the DMA channel based on the channel DMA engine and channel ID.
>>> Modify the of_dma_simple_xlate() function to do so, simplifying the API
>>> for DMA engine drivers.
>>>
>>> There is no need to check the DMA cells count in the filter function as
>>> the check is already performed by the caller in of_dma_get_controller().
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>
>> Hi,
>>
>> I've submitted a very similar patch some time ago, see
>> https://lkml.org/lkml/2013/3/25/250
> 
> Thanks. So my patch makes at least some sense :-)

> 
> I had the impression that this is what omap-dma needs as well, hence the 
> modification to the existing xlate function. I'm fine with a separate function 
> as well if the current code covers different use cases.

My first attempt was to modify simple_xlate function, but I think it didn't
work for all users (some of which aren't applied yet), so I added a separate
function.

> 
>>> ---
>>>
>>>  drivers/dma/of-dma.c   | 39 +++++++++++++++++++++++++++++++--------
>>>  drivers/dma/omap-dma.c |  8 +-------
>>>  include/linux/of_dma.h |  5 -----
>>>  3 files changed, 32 insertions(+), 20 deletions(-)
>>>
>>> I've implemented this function while working on a DMA engine driver, and
>>> realized that it wasn't specific to my driver at all. As I'm new to the
>>> DMA engine API, I'd appreciate feedback on whether this change makes
>>> sense, or if I should instead keep the existing of_dma_simple_xlate()
>>> function and create a separate simple xlate helper.
>>>
>>> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
>>> index 7aa0864..702a45d 100644
>>> --- a/drivers/dma/of-dma.c
>>> +++ b/drivers/dma/of-dma.c
>>> @@ -202,6 +202,27 @@ struct dma_chan *of_dma_request_slave_channel(struct
>>> device_node *np,
>>>  	return NULL;
>>>  }
>>>
>>> +struct of_dma_filter_args {
>>> +	struct dma_device *device;
>>> +	unsigned int chan_id;
>>> +};
>>> +
>>> +/**
>>> + * of_dma_simple_xlate_filter - Channel filter function for
>>> of_dma_simple_xlate + * @dma_chan:	pointer to candidate DMA channel
>>> + * @param:	pointer to filter parameter
>>> + *
>>> + * Filter out candidate DMA channels that don't match the channel ID or
>>> + * DMA engine device passed as arguments.
>>> + */
>>> +static bool of_dma_simple_xlate_filter(struct dma_chan *chan, void
>>> *param)
>>> +{
>>> +	struct of_dma_filter_args *fargs = param;
>>> +
>>> +	return (chan->device == fargs->device) &&
>>> +	       (chan->chan_id == fargs->chan_id);
>>> +}
>>> +
>>>  /**
>>>   * of_dma_simple_xlate - Simple DMA engine translation function
>>>   * @dma_spec:	pointer to DMA specifier as found in the device tree
>>> @@ -216,16 +237,18 @@ struct dma_chan *of_dma_request_slave_channel(struct
>>> device_node *np,> 
>>>  struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
>>>  						struct of_dma *ofdma)
>>>  {
>>> -	int count = dma_spec->args_count;
>>> -	struct of_dma_filter_info *info = ofdma->of_dma_data;
>>> +	struct dma_device *dev = ofdma->of_dma_data;
>>> +	struct of_dma_filter_args fargs;
>>> +	dma_cap_mask_t cap;
>>>
>>> -	if (!info || !info->filter_fn)
>>> -		return NULL;
>>> +	/* There's no need to specify matching caps as we're going to match a
>>> +	 * specific DMA channel anyway.
>>> +	 */
>>> +	dma_cap_zero(cap);
>>>
>>> -	if (count != 1)
>>> -		return NULL;
>>> +	fargs.device = dev;
>>> +	fargs.chan_id = dma_spec->args[0];
>>>
>>> -	return dma_request_channel(info->dma_cap, info->filter_fn,
>>> -			&dma_spec->args[0]);
>>> +	return dma_request_channel(cap, of_dma_simple_xlate_filter, &fargs);
>>>  }
>>>  EXPORT_SYMBOL_GPL(of_dma_simple_xlate);
>>> diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
>>> index ec3fc4f..7e7ff06 100644
>>> --- a/drivers/dma/omap-dma.c
>>> +++ b/drivers/dma/omap-dma.c
>>> @@ -69,10 +69,6 @@ static const unsigned es_bytes[] = {
>>>  	[OMAP_DMA_DATA_TYPE_S32] = 4,
>>>  };
>>>
>>> -static struct of_dma_filter_info omap_dma_info = {
>>> -	.filter_fn = omap_dma_filter_fn,
>>> -};
>>> -
>>>  static inline struct omap_dmadev *to_omap_dma_dev(struct dma_device *d)
>>>  {
>>>  	return container_of(d, struct omap_dmadev, ddev);
>>> @@ -641,11 +637,9 @@ static int omap_dma_probe(struct platform_device
>>> *pdev)> 
>>>  	platform_set_drvdata(pdev, od);
>>>  	if (pdev->dev.of_node) {
>>> -		omap_dma_info.dma_cap = od->ddev.cap_mask;
>>> -
>>>  		/* Device-tree DMA controller registration */
>>>  		rc = of_dma_controller_register(pdev->dev.of_node,
>>> -				of_dma_simple_xlate, &omap_dma_info);
>>> +				of_dma_simple_xlate, &od->ddev);
>>>  		if (rc) {
>>>  			pr_warn("OMAP-DMA: failed to register DMA controller\n");
>>>  			dma_async_device_unregister(&od->ddev);
>>> diff --git a/include/linux/of_dma.h b/include/linux/of_dma.h
>>> index 364dda7..3c0d9ac 100644
>>> --- a/include/linux/of_dma.h
>>> +++ b/include/linux/of_dma.h
>>> @@ -27,11 +27,6 @@ struct of_dma {
>>>  	void			*of_dma_data;
>>>  };
>>>
>>> -struct of_dma_filter_info {
>>> -	dma_cap_mask_t	dma_cap;
>>> -	dma_filter_fn	filter_fn;
>>> -};
>>> -
>>>
>>>  #ifdef CONFIG_OF
>>>  extern int of_dma_controller_register(struct device_node *np,
>>>  		struct dma_chan *(*of_dma_xlate)

