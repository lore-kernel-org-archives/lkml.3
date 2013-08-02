Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3HBUAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:00:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45866 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3HBUAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:00:03 -0400
Message-ID: <51FC0FBF.9010107@wwwdotorg.org>
Date: Fri, 02 Aug 2013 13:59:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Richard Zhao <rizhao@nvidia.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vinod.koul@intel.com, djbw@fb.com, grant.likely@linaro.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH] DMA: add help function to check whether dma controller
 registered
References: <1375423458-6868-1-git-send-email-rizhao@nvidia.com>
In-Reply-To: <1375423458-6868-1-git-send-email-rizhao@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 12:04 AM, Richard Zhao wrote:
> DMA client device driver usually needs to know at probe time whether
> dma controller has been registered to deffer probe. So add a help
> function of_dma_check_controller.
> 
> DMA request channel functions can also used to check it, but they
> are usually called at open() time.

> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index e1c4d3b..b6828c1 100644

> +int of_dma_check_controller(struct device *dev, const char *name)


> +	for (i = 0; i < count; i++) {
> +		if (of_dma_match_channel(np, name, i, &dma_spec))
> +			continue;
> +
> +		mutex_lock(&of_dma_lock);
> +		ofdma = of_dma_find_controller(&dma_spec);
> +		mutex_unlock(&of_dma_lock);
> +		of_node_put(dma_spec.np);

Do we need to add the following here:

if (ofdma)
	break

To ensure that as soon as a successful match is found, the loop exits?
Otherwise, if there are multiple providers for that name, and the first
N are registered but the last isn't, this function will still return
failure.

> +	if (ofdma)
> +		return 0;
> +	else
> +		return -ENODEV;

That probably should be -EPROBE_DEFER?

Although, what about differentiating between "entry not found by
of_dma_match_channel" and "controller not yet probed"?
