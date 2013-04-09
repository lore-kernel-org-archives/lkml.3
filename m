Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab3DIMha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:37:30 -0400
Received: from smtp-out-158.synserver.de ([212.40.185.158]:1042 "EHLO
	smtp-out-158.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763878Ab3DIMh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:37:26 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3444
Message-ID: <51640B48.5060506@metafoo.de>
Date: Tue, 09 Apr 2013 14:36:24 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>, Padmavathi Venna <padma.v@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dma: of: Add generic xlate function for matching
 by channel id
References: <1364217412-31905-1-git-send-email-lars@metafoo.de> <20130329214951.GA10326@intel.com> <5156A49E.5030901@metafoo.de> <20130409112816.GH31193@intel.com>
In-Reply-To: <20130409112816.GH31193@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 01:28 PM, Vinod Koul wrote:
> On Sat, Mar 30, 2013 at 09:38:54AM +0100, Lars-Peter Clausen wrote:
>> On 03/29/2013 10:49 PM, Vinod Koul wrote:
>>> On Mon, Mar 25, 2013 at 02:16:51PM +0100, Lars-Peter Clausen wrote:
>>>> This patch adds a new generic of dma xlate callback function which will match a
>>>> channel by its id.
>>> how will the client know which "id" to request? 
>>
>> The devicetree tells it, or what exactly do you mean?
> Is this global id? Anrd, what does the id mean in DT?

It's more or less a device specific cookie. And in this case we are using a
1 to 1 mapping to the channel number.

- Lars

>>
>> - Lars
>>
>>>
>>>>
>>>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>>> ---
>>>>  drivers/dma/of-dma.c   | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>>>>  include/linux/of_dma.h |  4 ++++
>>>>  2 files changed, 51 insertions(+)
>>>>
>>>> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
>>>> index 00db454..7cad4d7 100644
>>>> --- a/drivers/dma/of-dma.c
>>>> +++ b/drivers/dma/of-dma.c
>>>> @@ -269,3 +269,50 @@ struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
>>>>  			&dma_spec->args[0]);
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(of_dma_simple_xlate);
>>>> +
>>>> +struct of_dma_filter_by_chan_id_args {
>>>> +	struct dma_device *dev;
>>>> +	unsigned int chan_id;
>>>> +};
>>>> +
>>>> +static bool of_dma_filter_by_chan_id(struct dma_chan *chan, void *params)
>>>> +{
>>>> +	struct of_dma_filter_by_chan_id_args *args = params;
>>>> +
>>>> +	return chan->device == args->dev && chan->chan_id == args->chan_id;
>>>> +}
>>>> +
>>>> +/**
>>>> + * of_dma_xlate_by_chan_id - Translate dt property to DMA channel by channel id
>>>> + * @dma_spec:	pointer to DMA specifier as found in the device tree
>>>> + * @of_dma:	pointer to DMA controller data
>>>> + *
>>>> + * This function can be used as the of xlate callback for DMA driver which want
>>>> + * to match the channel based on the channel id. When using this xlate function
>>>> + * the #dma-cells propety of the DMA controller dt node needs to be set to 1.
>>>> + * The data parameter of of_dma_controller_register must be a pointer to the
>>>> + * dma_device struct the function should match uppon.
>>>> + *
>>>> + * Returns pointer to appropriate dma channel on success or NULL on error.
>>>> + */
>>>> +struct dma_chan *of_dma_xlate_by_chan_id(struct of_phandle_args *dma_spec,
>>>> +					 struct of_dma *ofdma)
>>>> +{
>>>> +	struct of_dma_filter_by_chan_id_args args;
>>>> +	dma_cap_mask_t cap;
>>>> +
>>>> +	args.dev = ofdma->of_dma_data;
>>>> +	if (!args.dev)
>>>> +		return NULL;
>>>> +
>>>> +	if (dma_spec->args_count != 1)
>>>> +		return NULL;
>>>> +
>>>> +	dma_cap_zero(cap);
>>>> +	dma_cap_set(DMA_SLAVE, cap);
>>>> +
>>>> +	args.chan_id = dma_spec->args[0];
>>>> +
>>>> +	return dma_request_channel(cap, of_dma_filter_by_chan_id, &args);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(of_dma_xlate_by_chan_id);
>>>> diff --git a/include/linux/of_dma.h b/include/linux/of_dma.h
>>>> index ce6a8ab..46732d3 100644
>>>> --- a/include/linux/of_dma.h
>>>> +++ b/include/linux/of_dma.h
>>>> @@ -43,6 +43,8 @@ extern struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
>>>>  						     const char *name);
>>>>  extern struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
>>>>  		struct of_dma *ofdma);
>>>> +extern struct dma_chan *of_dma_xlate_by_chan_id(struct of_phandle_args *dma_spec,
>>>> +		struct of_dma *ofdma);
>>>>  #else
>>>>  static inline int of_dma_controller_register(struct device_node *np,
>>>>  		struct dma_chan *(*of_dma_xlate)
>>>> @@ -69,6 +71,8 @@ static inline struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_s
>>>>  	return NULL;
>>>>  }
>>>>  
>>>> +#define of_dma_xlate_by_chan_id NULL
>>>> +
>>>>  #endif
>>>>  
>>>>  #endif /* __LINUX_OF_DMA_H */
>>>> -- 
>>>> 1.8.0
>>>>
>>

