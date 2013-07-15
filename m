Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3GOFFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 01:05:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab3GOFFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 01:05:30 -0400
Message-ID: <51E38304.4090508@redhat.com>
Date: Mon, 15 Jul 2013 13:05:08 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] Drivers: hv: balloon: Fix a bug in the hot-add
 code
References: <1373866669-9314-1-git-send-email-kys@microsoft.com> <1373866692-9353-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1373866692-9353-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 01:38 PM, K. Y. Srinivasan wrote:
> As we hot-add 128 MB chunks of memory, we wait to ensure that the memory
> is onlined before attempting to hot-add the next chunk. If the udev rule for
> memory hot-add is not executed within the allowed time, we would rollback the
> state and abort further hot-add. Since the hot-add has succeeded and the only
> failure is that the memory is not onlined within the allowed time, we should not
> be rolling back the state. Fix this bug.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Stable <stable@vger.kernel.org>
> ---
>  drivers/hv/hv_balloon.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index 4c605c7..61b7351 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -562,7 +562,7 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
>  				struct hv_hotadd_state *has)
>  {
>  	int ret = 0;
> -	int i, nid, t;
> +	int i, nid;
>  	unsigned long start_pfn;
>  	unsigned long processed_pfn;
>  	unsigned long total_pfn = pfn_count;
> @@ -607,14 +607,11 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
>  
>  		/*
>  		 * Wait for the memory block to be onlined.
> +		 * Since the hot add has succeeded, it is ok to
> +		 * proceed even if the pages in the hot added region
> +		 * have not been "onlined" within the allowed time.
>  		 */
> -		t = wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
> -		if (t == 0) {
> -			pr_info("hot_add memory timedout\n");
> -			has->ha_end_pfn -= HA_CHUNK;
> -			has->covered_end_pfn -=  processed_pfn;
> -			break;
> -		}
> +		wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
>  
>  	}
>  

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks
