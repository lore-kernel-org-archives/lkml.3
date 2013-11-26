Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab3KZHkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:40:00 -0500
Received: from smtp-out-049.synserver.de ([212.40.185.49]:1440 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751777Ab3KZHj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:39:57 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16930
Message-ID: <5294506C.60701@metafoo.de>
Date: Tue, 26 Nov 2013 08:40:28 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] dma: add common of_dma_slave_xlate()
References: <1385429104-7001-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1385429104-7001-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 02:25 AM, Stephen Warren wrote:
[...]
> +struct dma_chan *of_dma_slave_xlate(struct of_phandle_args *dma_spec,
> +				    struct of_dma *ofdma)
> +{
> +	struct of_dma_slave_xlate_info *info = ofdma->of_dma_data;
> +	struct dma_chan *candidate, *chan;
> +	int ret;
> +
> +retry:
> +	candidate = NULL;
> +
> +	/*
> +	 * walk the list of channels registered with the current instance and
> +	 * find one that is currently unused
> +	 */
> +	list_for_each_entry(chan, &info->device->channels, device_node)
> +		if (chan->client_count == 0) {
> +			candidate = chan;
> +			break;
> +		}
> +
> +	if (!candidate)
> +		return NULL;
> +
> +	/*
> +	 * dma_get_slave_channel will return NULL if we lost a race between
> +	 * the lookup and the reservation
> +	 */
> +	chan = dma_get_slave_channel(candidate);
> +	if (!chan)
> +		goto retry;

I think it will be better to implement this functionality in the core. This
means we can hold the dma_list_mutex and don't have to do this retry loop
and do not have to peek at the client_count field in non-core code.
Something like dma_get_free_slave_channel(), which would call
private_candidate() followed by dma_chan_get().

> +
> +	if (info->post_alloc) {
> +		ret = info->post_alloc(chan, dma_spec);

If you need to do something at the end of the function I think it is nicer
to just wrap this function with your own function instead of adding a callback.

- Lars


