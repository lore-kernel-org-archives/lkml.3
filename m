Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3KZQ5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:57:24 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:59868 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab3KZQ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:57:20 -0500
MIME-Version: 1.0
In-Reply-To: <5294506C.60701@metafoo.de>
References: <1385429104-7001-1-git-send-email-swarren@wwwdotorg.org>
	<5294506C.60701@metafoo.de>
Date: Tue, 26 Nov 2013 08:57:19 -0800
Message-ID: <CAPcyv4hx5nVth2f4SSDYWBNR+bs-4Rj+Bnua=w97S9OLoq0Gqw@mail.gmail.com>
Subject: Re: [PATCH V2] dma: add common of_dma_slave_xlate()
From: Dan Williams <dan.j.williams@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 11:40 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 11/26/2013 02:25 AM, Stephen Warren wrote:
> [...]
>> +struct dma_chan *of_dma_slave_xlate(struct of_phandle_args *dma_spec,
>> +                                 struct of_dma *ofdma)
>> +{
>> +     struct of_dma_slave_xlate_info *info = ofdma->of_dma_data;
>> +     struct dma_chan *candidate, *chan;
>> +     int ret;
>> +
>> +retry:
>> +     candidate = NULL;
>> +
>> +     /*
>> +      * walk the list of channels registered with the current instance and
>> +      * find one that is currently unused
>> +      */
>> +     list_for_each_entry(chan, &info->device->channels, device_node)
>> +             if (chan->client_count == 0) {
>> +                     candidate = chan;
>> +                     break;
>> +             }
>> +
>> +     if (!candidate)
>> +             return NULL;
>> +
>> +     /*
>> +      * dma_get_slave_channel will return NULL if we lost a race between
>> +      * the lookup and the reservation
>> +      */
>> +     chan = dma_get_slave_channel(candidate);
>> +     if (!chan)
>> +             goto retry;
>
> I think it will be better to implement this functionality in the core. This
> means we can hold the dma_list_mutex and don't have to do this retry loop
> and do not have to peek at the client_count field in non-core code.
> Something like dma_get_free_slave_channel(), which would call
> private_candidate() followed by dma_chan_get().
>
>> +
>> +     if (info->post_alloc) {
>> +             ret = info->post_alloc(chan, dma_spec);
>
> If you need to do something at the end of the function I think it is nicer
> to just wrap this function with your own function instead of adding a callback.
>

Agree with both points above.  And if the common pattern is to limit
the domain to children of a given parent device that can be
implemented generically with a device_for_each_child_loop or similar.
