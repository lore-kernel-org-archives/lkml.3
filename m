Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbbALQOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:14:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57369 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbbALQOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:14:33 -0500
Message-ID: <54B3F2E3.7050208@codeaurora.org>
Date: Mon, 12 Jan 2015 21:44:27 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Chintan Pandya <cpandya@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        David Rientjes <rientjes@google.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] lowmemorykiller: Avoid excessive/redundant calling of
 LMK
References: <1421078923-29485-1-git-send-email-cpandya@codeaurora.org>
In-Reply-To: <1421078923-29485-1-git-send-email-cpandya@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch. My extreme bad that I merged commit messages 
applicable to some very old kernel into this patch. Updating shortly.

On 01/12/2015 09:38 PM, Chintan Pandya wrote:
> The global shrinker will invoke lowmem_shrink in a loop.
> The loop will be run (total_scan_pages/batch_size) times.
> The default batch_size will be 128 which will make
> shrinker invoking 100s of times. LMK does meaningful
> work only during first 2-3 times and then rest of the
> invocations are just CPU cycle waste. Fix that by giving
> excessively large batch size so that lowmem_shrink will
> be called just once and in the same try LMK does the
> needful.
>
> Signed-off-by: Chintan Pandya<cpandya@codeaurora.org>
> ---
>   drivers/staging/android/lowmemorykiller.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
> index b545d3d..5bf483f 100644
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -110,7 +110,7 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
>   	if (min_score_adj == OOM_SCORE_ADJ_MAX + 1) {
>   		lowmem_print(5, "lowmem_scan %lu, %x, return 0\n",
>   			     sc->nr_to_scan, sc->gfp_mask);
> -		return 0;
> +		return SHRINK_STOP;
>   	}
>
>   	selected_oom_score_adj = min_score_adj;
> @@ -163,6 +163,9 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
>   		set_tsk_thread_flag(selected, TIF_MEMDIE);
>   		send_sig(SIGKILL, selected, 0);
>   		rem += selected_tasksize;
> +	} else {
> +		rcu_read_unlock();
> +		return SHRINK_STOP;
>   	}
>
>   	lowmem_print(4, "lowmem_scan %lu, %x, return %lu\n",


-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
