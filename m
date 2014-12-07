Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaLGN7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 08:59:54 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47565 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaLGN7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 08:59:51 -0500
Message-ID: <54845D53.1070903@codeaurora.org>
Date: Sun, 07 Dec 2014 15:59:47 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] UBI: Fastmap: Notify user in case of an ubi_update_fastmap()
 failure
References: <1417347340-6872-1-git-send-email-richard@nod.at> <1417347340-6872-4-git-send-email-richard@nod.at>
In-Reply-To: <1417347340-6872-4-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 11/30/2014 1:35 PM, Richard Weinberger wrote:
> If ubi_update_fastmap() fails notify the user.
> This is not a hard error as ubi_update_fastmap() makes sure that upon failure
> the current on-flash fastmap will no be used upon next UBI attach.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   drivers/mtd/ubi/wl.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index 523d8a4..7821342 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -657,7 +657,11 @@ again:
>   	 * refill the WL pool synchronous. */
>   	if (pool->used == pool->size || wl_pool->used == wl_pool->size) {
>   		spin_unlock(&ubi->wl_lock);
> -		ubi_update_fastmap(ubi);
> +		ret = ubi_update_fastmap(ubi);
> +		if (ret) {
> +			ubi_msg(ubi, "Unable to write a new fastmap: %i", ret);
> +			return -ENOSPC;

Why do you fail the whole function (ubi_wl_get_peb) if fastmap update 
failed? Its possible that the fm_pools were refilled correctly, and the 
actual fastmap_write failed, so there is nothing preventing the user to 
get peb allocated and continue working. You invalidate the fastmap, so 
if powercut occurs a full scan will be performed. So its possible to 
allocate from fm_pools (although fastmap is not valid on disc) and try 
writing fastmap again when the pools filled up.
I'm for the ubi_msg but against "return -ENOSPC;"

> +		}
>   		spin_lock(&ubi->wl_lock);
>   	}
>
>


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project
