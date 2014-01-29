Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaA2Udk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:33:40 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:37942 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaA2Udj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:33:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140129124132.GA3180@stfomichev-desktop>
References: <20140127173149.GA8099@stfomichev-desktop>
	<CAPcyv4gNdKqRYGfjNY0GyOysN-3WrTVRGbo-+6Jdb2ukFGPX9w@mail.gmail.com>
	<20140129124132.GA3180@stfomichev-desktop>
Date: Wed, 29 Jan 2014 12:33:38 -0800
Message-ID: <CAPcyv4j1=TY6P97RTpfONLN6nHE0NjJeg_gGPQEhgFVEWXBdpA@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] 3.10.26: net_dma: mark broken (b69ec589136c)
From: Dan Williams <dan.j.williams@intel.com>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        David Whipple <whipple@securedatainnovations.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 4:41 AM, Stanislav Fomichev
<stfomichev@yandex-team.ru> wrote:
>> I wonder if we are simply racing the initialization of the completion
>> vs when it is triggered by dma.
> We have wmb() in the ioat2_tx_submit_unlock (before submitting work to dma,
> but after init_completion), shouldn't it make race between interrupt handler
> and our waiting thread impossible?
>
> I also believe I traced x->done in the do_wait_for_common
> before and after 'timeout = action(timeout);' and it was as expected:
> 0 - before and 1 - after.
>
>> I also think we need to be waiting
>> for in-flight tasklet runs when stopping the channel.
> Yes, I also thought that's the reason of the race, because tasklet is in
> the queue, but it is disabled (on my weird trace I don't see the interrupt,
> so I abandoned this idea).
> But it seems to be possible only when we issue dma, wait_for_completion_timeout
> waits and times out, we do cleanup (tasklet_disable), we get interrupt and
> do tasklet_schedule. But (again) I don't see timeout and
> interrupt on my trace (could it be corrupted?).
>
> Despite all this theory, the patch below (which just replaces tasklet_disable
> with tasklet_kill in the cleanup routines) seems to be working (did about
> 40 reboots and didn't see the issue).
>
> I think replacing tasklet_disable with tasklet_kill is reasonable anyway, so
> should I send the patch rebased on 3.13 with comments or you'll take care
> and merge it into mainline and stable yourself?

I'll take it from here and I'll add your Reported-by and Tested-by.

Thank you!

--
Dan

>
> ---
> diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
> index 17a2393b3e25..6c62f4de02c0 100644
> --- a/drivers/dma/ioat/dma.c
> +++ b/drivers/dma/ioat/dma.c
> @@ -379,7 +379,7 @@ static void ioat1_dma_free_chan_resources(struct dma_chan *c)
>         if (ioat->desccount == 0)
>                 return;
>
> -       tasklet_disable(&chan->cleanup_task);
> +       tasklet_kill(&chan->cleanup_task);
>         del_timer_sync(&chan->timer);
>         ioat1_cleanup(ioat);
>
> diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
> index b925e1b1d139..268e93d1af2d 100644
> --- a/drivers/dma/ioat/dma_v2.c
> +++ b/drivers/dma/ioat/dma_v2.c
> @@ -809,7 +809,7 @@ void ioat2_free_chan_resources(struct dma_chan *c)
>         if (!ioat->ring)
>                 return;
>
> -       tasklet_disable(&chan->cleanup_task);
> +       tasklet_kill(&chan->cleanup_task);
>         del_timer_sync(&chan->timer);
>         device->cleanup_fn((unsigned long) c);
>         device->reset_hw(chan);
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index acb86507828a..94a5f04e114e 100644
