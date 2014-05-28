Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaE1BU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 21:20:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbaE1BU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 21:20:27 -0400
Date: Wed, 28 May 2014 09:20:21 +0800
From: Amos Kong <akong@redhat.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org
Subject: Re: [PATCH] hv: use correct order when freeing monitor_pages
Message-ID: <20140528012021.GA3127@z.redhat.com>
References: <1401210980-2515-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401210980-2515-1-git-send-email-rkrcmar@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 07:16:20PM +0200, Radim Krčmář wrote:
> We try to free two pages when only one has been allocated.
> Cleanup path is unlikely, so I haven't found any trace that would fit,
> but I hope that free_pages_prepare() does catch it.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  Cc'd stable because the worst-case looks hard to debug.
>  Btw. the module can't get unloaded after we successfully connect?
> 
>  drivers/hv/connection.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
> index 7f10c15..e84f452 100644
> --- a/drivers/hv/connection.c
> +++ b/drivers/hv/connection.c
> @@ -224,8 +224,8 @@ cleanup:
>  		vmbus_connection.int_page = NULL;
>  	}
>  
> -	free_pages((unsigned long)vmbus_connection.monitor_pages[0], 1);
> -	free_pages((unsigned long)vmbus_connection.monitor_pages[1], 1);
> +	free_pages((unsigned long)vmbus_connection.monitor_pages[0], 0);
> +	free_pages((unsigned long)vmbus_connection.monitor_pages[1], 0);


Allocate order is 0. (2^0 = 1 page)

  vmbus_connection.monitor_pages[0] = (void *)__get_free_pages((GFP_KERNEL|__GFP_ZERO), 0);
  vmbus_connection.monitor_pages[1] = (void *)__get_free_pages((GFP_KERNEL|__GFP_ZERO), 0);

Looks good.

Reviewed-by: Amos Kong <akong@redhat.com>

>  	vmbus_connection.monitor_pages[0] = NULL;
>  	vmbus_connection.monitor_pages[1] = NULL;
>  
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
			Amos.
