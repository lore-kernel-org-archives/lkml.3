Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3FLMHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:07:13 -0400
Received: from smtp-out-004.synserver.de ([212.40.185.4]:1082 "EHLO
	smtp-out-004.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3FLMHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:07:10 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 2470
Message-ID: <51B8646E.5040907@metafoo.de>
Date: Wed, 12 Jun 2013 14:07:10 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-mips@linux-mips.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [alsa-devel] [PATCH v2 3/6] dma: Add a jz4740 dmaengine driver
References: <1369931105-28065-1-git-send-email-lars@metafoo.de> <1369931105-28065-4-git-send-email-lars@metafoo.de> <20130530171225.GA3767@intel.com> <51A79E8F.4070209@metafoo.de> <51B60D0A.7040307@metafoo.de> <20130612053810.GF4107@intel.com>
In-Reply-To: <20130612053810.GF4107@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 07:38 AM, Vinod Koul wrote:
> On Mon, Jun 10, 2013 at 07:29:46PM +0200, Lars-Peter Clausen wrote:
>> On 05/30/2013 08:46 PM, Lars-Peter Clausen wrote:
>>>>> +static int jz4740_dma_alloc_chan_resources(struct dma_chan *c)
>>>>> +{
>>>>> +	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
>>>>> +
>>>>> +	chan->jz_chan = jz4740_dma_request(chan, NULL);
>>>>> +	if (!chan->jz_chan)
>>>>> +		return -EBUSY;
>>>>> +
>>>>> +	jz4740_dma_set_complete_cb(chan->jz_chan, jz4740_dma_complete_cb);
>>>>> +
>>>>> +	return 0;
>>>> Sorry, I didnt reply on this one. The API expects you to allocate a pool of
>>>> descriptors. These descriptors are to be used in .device_prep_xxx calls later.
>>>
>>> The size of the descriptor is not fixed, so they can not be pre-allocated. And
>>> this is nothing new either, most of the more recently added dmaengine drivers
>>> allocate their descriptors on demand.
>>
>> Vinod, are you ok with this explanation?
> Sorry, I was travelling...
> 
> Can you explain more of a bit when you say size is not fixed.

This is the function that allocates the descriptor:

static struct jz4740_dma_desc *jz4740_dma_alloc_desc(unsigned int num_sgs)
{
	return kzalloc(sizeof(struct jz4740_dma_desc) +
		sizeof(struct jz4740_dma_sg) * num_sgs, GFP_ATOMIC);
}

So the size depends on the entries in the sg list.


> Why would it be
> issue if we allocate descriptors at the alloc_chan. The idea is that you 
> preallocated pool at alloc_chan and since the .device_prep_xxx calls can be
> called from atomic context as well, you dont need to do this later. You can use use
> these descriptors at that time. The idea is keep rotating the descriptors from
> free poll to used one

Yes, I know all that. And it makes sense to use a pool in certain
situations, e.g. if the hardware only supports a limited set of physical
descriptors. But in this case the descriptors are completely virtual.
Forcing the driver to use a pool would make it more complex, use more memory
and also a bit slower (although probably not noticeable).

- Lars
