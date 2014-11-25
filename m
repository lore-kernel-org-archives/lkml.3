Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaKYNlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:41:46 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46707 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaKYNlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:41:44 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-79-547487158842
Message-id: <54748714.1040005@samsung.com>
Date: Tue, 25 Nov 2014 14:41:40 +0100
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>, vinod.koul@intel.com
Cc: dan.j.williams@intel.com, ars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com
Subject: Re: [PATCH 2/2] dma: pl330: add DMA_PAUSE feature
References: <1416918346-2442-1-git-send-email-r.baldyga@samsung.com>
 <1416918346-2442-3-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1416918346-2442-3-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xa7qi7SUhBjOXWlhcONDJaDF96gVG
	i9VT/7JavH5haPFr2iQ2i8u75rBZrD1yl93iweGd7BYv+/azOHB6LN7zksljyZtDrB59W1Yx
	enzeJBfAEsVlk5Kak1mWWqRvl8CVsXeiXcE9/oqdx2YyNzA+5eli5OSQEDCR+N48mxHCFpO4
	cG89WxcjF4eQwFJGiWWzrjNCOJ8ZJebMO80GUsUroCXxe8NvoAQHB4uAqsSdSUwgYTYBD4lp
	33uYQWxRgQiJK2vmMEKUC0r8mHyPBaRcRMBB4sphZpCRzAJzGSUOXF4JNlJYwEri8oV2sHoh
	gXqJ3iUPwWxOAVeJpq0dYKuYBdQlpkzJBQkzC8hLbF7zlnkCo8AsJBtmIVTNQlK1gJF5FaNo
	amlyQXFSeq6RXnFibnFpXrpecn7uJkZImH/dwbj0mNUhRgEORiUe3htxJSFCrIllxZW5hxgl
	OJiVRHhzq4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGCsybNsnnO8WkDJKues0TVp3gfnnx+fr
	xA48jWcRX+PW8Ni7j5H3RDDvOrfs/TnLdh9vClV77Mxz+bhjf6y7hojziiId75KKaFv1+5x7
	WQ+K1Hnf2yBt4/zBb4HsWpnyN6xFrjvrP/C2xdoe2eHCVaUQODtt34bffhPvROSeF9B3OnKn
	wMhZiaU4I9FQi7moOBEA65zRsFECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.11.2014 13:25, Robert Baldyga wrote:
> DMA_PAUSE command is used for halting DMA transfer on chosen channel.
> It can be useful when we want to safely read residue before terminating
> all requests on channel. Otherwise there can be situation when some data
> is transferred before channel termination but after reading residue,
> which obviously results with data loss. To avoid this situation we can
> pause channel, read residue and then terminate all requests.
> This scenario is common, for example, in serial port drivers.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/dma/pl330.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index c32806d..9c64421 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2115,6 +2115,26 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
>  		list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
>  		spin_unlock_irqrestore(&pch->lock, flags);
>  		break;
> +	case DMA_PAUSE:

pm_runtime_get_sync() here? If transfer is ongoing this shouldn't be
needed but if this is called after all transfers complete then device
will be suspended.

> +		/*
> +		 * We don't support DMA_RESUME command because of hardware
> +		 * limitations, so after pausing the channel we cannot restore
> +		 * it to active state. We have to terminate channel and setup
> +		 * DMA transfer again. This pause feature was implemented to
> +		 * allow safely read residue before channel termination.
> +		 */
> +		spin_lock_irqsave(&pch->lock, flags);
> +
> +		spin_lock(&pl330->lock);
> +		_stop(pch->thread);
> +		spin_unlock(&pl330->lock);
> +
> +		pch->thread->req[0].desc = NULL;
> +		pch->thread->req[1].desc = NULL;
> +		pch->thread->req_running = -1;
> +
> +		spin_unlock_irqrestore(&pch->lock, flags);

symmetric pm_runtime_put + autosuspend.

Best regards,
Krzysztof


