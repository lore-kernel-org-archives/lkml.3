Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaLHIg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:36:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43300 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaLHIg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:36:27 -0500
Message-ID: <54856305.2070408@codeaurora.org>
Date: Mon, 08 Dec 2014 10:36:21 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] UBI: Fastmap: Don't allocate new ubi_wl_entry objects
References: <1417347340-6872-1-git-send-email-richard@nod.at> <1417347340-6872-3-git-send-email-richard@nod.at>
In-Reply-To: <1417347340-6872-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 1:35 PM, Richard Weinberger wrote:
> There is no need to allocate new ones every time, we can reuse
> the existing ones.
> This makes the code cleaner and more easy to follow.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   drivers/mtd/ubi/fastmap.c | 31 +++++--------------------------
>   drivers/mtd/ubi/wl.c      | 11 +++++++----
>   2 files changed, 12 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> index db3defd..9507702 100644
> --- a/drivers/mtd/ubi/fastmap.c
> +++ b/drivers/mtd/ubi/fastmap.c
> @@ -1446,19 +1446,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
>   	}
>
>   	new_fm->used_blocks = ubi->fm_size / ubi->leb_size;

Not related to this patch, but looking at this function it got me 
thinking: why do we need to re-calculate new_fm->used_blocks (and check 
calculated value) each time? fm_size doesn't changed at runtime. 
leb_size sure does not, so fm->used_blocks can be ubi device parameter 
and calculated & tested only once, and not each time we write fastmap. 
Correct?


> -
> -	for (i = 0; i < new_fm->used_blocks; i++) {
> -		new_fm->e[i] = kmem_cache_alloc(ubi_wl_entry_slab, GFP_KERNEL);
> -		if (!new_fm->e[i]) {
> -			while (i--)
> -				kfree(new_fm->e[i]);
> -
> -			kfree(new_fm);
> -			mutex_unlock(&ubi->fm_mutex);
> -			return -ENOMEM;
> -		}
> -	}
> -
>   	old_fm = ubi->fm;
>   	ubi->fm = NULL;
>


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
