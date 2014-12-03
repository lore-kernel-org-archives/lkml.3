Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaLCJtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:49:19 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:33135 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaLCJtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:49:17 -0500
MIME-Version: 1.0
In-Reply-To: <547EAC4E.1090902@mentor.com>
References: <547C41C0.9090000@mentor.com>
	<CAPDyKFpdJCRCtJe8EHGtYHhSk+ont2pzkidx=GbAay1BT8=5eQ@mail.gmail.com>
	<547C5787.3060205@mentor.com>
	<CAPDyKFpOio0soa6OnmAv2AKDJ65WOdFhrRrKQuzek=JstUzX-Q@mail.gmail.com>
	<547EAC4E.1090902@mentor.com>
Date: Wed, 3 Dec 2014 10:49:16 +0100
Message-ID: <CAPDyKFrRTtL5qaywTh8o0sq80rEvSC2G7HLauDBqjP4OOYLsDg@mail.gmail.com>
Subject: Re: [Patch] Improve error handling in allocation of bounce buffers in mmc_init_queue
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Bhuvanesh <bhuvanesh_surachari@mentor.com>
Cc: Chris Ball <chris@printf.net>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@fb.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Joe Perches <joe@perches.com>, harish_kandiga@mentor.com,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 December 2014 at 07:23, Bhuvanesh <bhuvanesh_surachari@mentor.com> wrote:
> Hi,
>
>   Thanks for guiding. I read through Documentation/SubmittingPatches.
> Fixed the warnings given by checkpatch. Kindly review the updated patch.

Could you also resend it as a separate patch, not replying to this email thread.

Kind regards
Uffe

>
> From 7ea020e32e1fbe4d05d104e31815d908af92f2a5 Mon Sep 17 00:00:00 2001
> From: Bhuvanesh Surachari <bhuvanesh_surachari@mentor.com>
> Date: Mon, 1 Dec 2014 02:23:02 -0500
> Subject: [PATCH] mmc: queue:Improve error handling during allocation of
>  bounce buffers.
>
> Allocation of previous bounce buffer in mmc_init_queue when the current
> bounce buffer allocation fails was leading to a crash later in
> __blk_segment_map_sg. Error handling is improved by allocating previous
> bounce buffer only if the current bounce buffer allocation succeeds.
>
> Signed-off-by: Bhuvanesh Surachari <bhuvanesh_surachari@mentor.com>
> Signed-off-by: Harish Jenny K N <harish_kandiga@mentor.com>
> ---
>  drivers/mmc/card/queue.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index cfa6110..236d194 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -232,13 +232,15 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
>                         if (!mqrq_cur->bounce_buf) {
>                                 pr_warn("%s: unable to allocate bounce cur buffer\n",
>                                         mmc_card_name(card));
> -                       }
> -                       mqrq_prev->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
> -                       if (!mqrq_prev->bounce_buf) {
> -                               pr_warn("%s: unable to allocate bounce prev buffer\n",
> -                                       mmc_card_name(card));
> -                               kfree(mqrq_cur->bounce_buf);
> -                               mqrq_cur->bounce_buf = NULL;
> +                       } else {
> +                               mqrq_prev->bounce_buf =
> +                                               kmalloc(bouncesz, GFP_KERNEL);
> +                               if (!mqrq_prev->bounce_buf) {
> +                                       pr_warn("%s: unable to allocate bounce prev buffer\n",
> +                                               mmc_card_name(card));
> +                                       kfree(mqrq_cur->bounce_buf);
> +                                       mqrq_cur->bounce_buf = NULL;
> +                               }
>                         }
>                 }
>
> --
> 1.7.9.5
>
>
>
> Thank you,
> Regards,
> Bhuvanesh
>
> On 12/02/2014 05:01 PM, Ulf Hansson wrote:
>> On 1 December 2014 at 12:56, Bhuvanesh <bhuvanesh_surachari@mentor.com> wrote:
>>> Hi,
>>>
>>>   Please find the patch inline.
>>
>> Apparently you didn't read /Documentation/SubmittingPatches.
>>
>> If you want me to review, please follow that guide. For example, I
>> expect you to run checkpatch.
>>
>> Kind regards
>> Uffe
>>
