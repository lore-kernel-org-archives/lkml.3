Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbaIEPXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:23:53 -0400
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1063 "EHLO
	smtp-out-239.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbaIEPXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:23:51 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 27007
Message-ID: <5409D585.1040302@metafoo.de>
Date: Fri, 05 Sep 2014 17:23:49 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC PATCH] dma: pl330: add Power Management support
References: <1409929562-29583-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1409929562-29583-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 05:06 PM, Krzysztof Kozlowski wrote:
[...]
> @@ -2168,11 +2199,23 @@ static void pl330_issue_pending(struct dma_chan *chan)
>   {
>   	struct dma_pl330_chan *pch = to_pchan(chan);
>   	unsigned long flags;
> +	bool power_up;
>
>   	spin_lock_irqsave(&pch->lock, flags);
> +	power_up = list_empty(&pch->work_list);
>   	list_splice_tail_init(&pch->submitted_list, &pch->work_list);
>   	spin_unlock_irqrestore(&pch->lock, flags);
>
> +	if (power_up) {
> +		/*
> +		 * Warn on nothing pending. This may break our pm_runtime
> +		 * usage counter as it is updated on work_list emptiness
> +		 * status.
> +		 */
> +		WARN_ON(list_empty(&pch->work_list));
> +		pm_runtime_get_sync(pch->dmac->ddma.dev);

Unfortunately this does not work. pm_runtime_get_sync() may sleep, where as 
the issue_pending callback needs to be able to run from contexts in which 
sleeping is not possible.

> +	}
> +
>   	pl330_tasklet((unsigned long)pch);
>   }
>
[...]
