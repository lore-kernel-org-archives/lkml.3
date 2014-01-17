Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaAQKXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:23:44 -0500
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4370 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaAQKXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:23:30 -0500
Message-ID: <52D90490.3080407@xs4all.nl>
Date: Fri, 17 Jan 2014 11:23:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH, RFC 05/30] [media] omap_vout: avoid sleep_on race
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-6-git-send-email-arnd@arndb.de>
In-Reply-To: <1388664474-1710039-6-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 01/02/2014 01:07 PM, Arnd Bergmann wrote:
> sleep_on and its variants are broken and going away soon. This changes
> the omap vout driver to use interruptible_sleep_on_timeout instead,

I assume you mean wait_event_interruptible_timeout here :-)

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

If there are no other comments, then I plan to merge this next week.

Regards,

	Hans

> which fixes potential race where the dma is complete before we
> schedule.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/platform/omap/omap_vout_vrfb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
> index cf1c437..62e7e57 100644
> --- a/drivers/media/platform/omap/omap_vout_vrfb.c
> +++ b/drivers/media/platform/omap/omap_vout_vrfb.c
> @@ -270,7 +270,8 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
>  	omap_dma_set_global_params(DMA_DEFAULT_ARB_RATE, 0x20, 0);
>  
>  	omap_start_dma(tx->dma_ch);
> -	interruptible_sleep_on_timeout(&tx->wait, VRFB_TX_TIMEOUT);
> +	wait_event_interruptible_timeout(tx->wait, tx->tx_status == 1,
> +					 VRFB_TX_TIMEOUT);
>  
>  	if (tx->tx_status == 0) {
>  		omap_stop_dma(tx->dma_ch);
> 

