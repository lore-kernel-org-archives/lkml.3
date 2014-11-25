Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaKYDbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 22:31:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaKYDby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 22:31:54 -0500
Message-ID: <5473F818.4050304@redhat.com>
Date: Tue, 25 Nov 2014 11:31:36 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dexuan Cui <decui@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, kys@microsoft.com
CC: haiyangz@microsoft.com
Subject: Re: [PATCH v2] hv: hv_balloon: avoid memory leak on alloc_error of
 2MB memory block
References: <1416889963-31602-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1416889963-31602-1-git-send-email-decui@microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 12:32 PM, Dexuan Cui wrote:
> If num_ballooned is not 0, we shouldn't neglect the
> already-partially-allocated 2MB memory block(s).
>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>
> v2: I fixed the logic error in v1, pointed by Jason Wang:
> 	In v1: in the case of partially-allocated 2MB, alloc_error is true,
> 	so we'll run "done = true" and hence we won't proceed with
> 	the next iteration of trying 4K allocation.
>
>     I also changed the WARN_ON to WARN_ON_ONCE in case the host behavior
>     changes in the future.
>
>  drivers/hv/hv_balloon.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index 5e90c5d..b958ded 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -1087,10 +1087,12 @@ static void balloon_up(struct work_struct *dummy)
>  	struct dm_balloon_response *bl_resp;
>  	int alloc_unit;
>  	int ret;
> -	bool alloc_error = false;
> +	bool alloc_error;
>  	bool done = false;
>  	int i;
>  
> +	/* The host balloons pages in 2M granularity. */
> +	WARN_ON_ONCE(num_pages % PAGES_IN_2M != 0);
>  
>  	/*
>  	 * We will attempt 2M allocations. However, if we fail to
> @@ -1107,16 +1109,18 @@ static void balloon_up(struct work_struct *dummy)
>  
>  
>  		num_pages -= num_ballooned;
> +		alloc_error = false;
>  		num_ballooned = alloc_balloon_pages(&dm_device, num_pages,
>  						bl_resp, alloc_unit,
>  						 &alloc_error);
>  
> -		if ((alloc_error) && (alloc_unit != 1)) {
> +		if (alloc_unit != 1 && num_ballooned == 0) {
>  			alloc_unit = 1;
>  			continue;
>  		}
>  
> -		if ((alloc_error) || (num_ballooned == num_pages)) {
> +		if ((alloc_unit == 1 && alloc_error) ||
> +			(num_ballooned == num_pages)) {
>  			bl_resp->more_pages = 0;
>  			done = true;
>  			dm_device.state = DM_INITIALIZED;

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks
