Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3JKKWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:22:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:29513 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab3JKKWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:22:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1079,1371106800"; 
   d="scan'208";a="409350138"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Song, Youquan" <youquan.song@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 1/2] dma: Add interface to calculate data transferred
Thread-Topic: [PATCH 1/2] dma: Add interface to calculate data transferred
Thread-Index: AQHOxmj7TKNMun2fTEyCvrAxr1aQIZnvOdeA
Date: Fri, 11 Oct 2013 10:22:15 +0000
Message-ID: <1381486917.29062.107.camel@smile>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
	 <1381527738-9339-2-git-send-email-youquan.song@intel.com>
In-Reply-To: <1381527738-9339-2-git-send-email-youquan.song@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5A0724CCC736746936D7BBA4A54A761@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9BAN2fN028226

On Fri, 2013-10-11 at 17:42 -0400, Youquan Song wrote:
> Currently, the DMA channel calculates its data transferred only at network
> device driver. When other devices like UART or SPI etc, transfers data by DMA 
> mode, but it always shows 0 at /sys/class/dma/dma0chan*/bytes_transferred.
> 
> This patch add a new function which will calculate how many the data has been
> transferred after doing it by DMA mode. It can be used by other modules and
> also simplify current duplicated code.

Thanks for the patch. My comments below.

First of all, what is the point to have every device driver that uses
DMA to increment bytes_transferred value? It will show just amount of
data transferred through certain channel. How it could be used then?

> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -901,6 +901,23 @@ void dma_async_device_unregister(struct dma_device *device)
>  }
>  EXPORT_SYMBOL(dma_async_device_unregister);
>  
> +dma_cookie_t
> +dma_tx_submit_cal(struct dma_async_tx_descriptor *tx,
> +		struct dma_chan *chan, size_t len)

I think there is a better name for the function.
dmaengine_submit_and_count() for example?

> +{
> +
> +	dma_cookie_t cookie;

Above lines probably have to be exchanged.

> +	cookie = tx->tx_submit(tx);

And you may incorporate this line into above.

> +
> +	preempt_disable();
> +	__this_cpu_add(chan->local->bytes_transferred, len);
> +	__this_cpu_inc(chan->local->memcpy_count);
> +	preempt_enable();
> +
> +	return cookie;
> +

Redundant empty line.

> +}

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
