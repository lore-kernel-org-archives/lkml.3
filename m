Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab3LKQAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:00:38 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40850 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3LKQAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:00:18 -0500
Date: Wed, 11 Dec 2013 10:52:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>, Peter Stuge <peter@stuge.se>,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: wirelesse: wcn36xx: check allocation and trim
 critical section
Message-ID: <20131211155249.GD7411@tuxdriver.com>
References: <1385744870-10164-1-git-send-email-mpn@google.com>
 <20131201004715.11125.qmail@stuge.se>
 <xa1tiov78kmp.fsf@mina86.com>
 <CAFSJ42YckTDO=UV=fWG9mmVXSBYep1x6xiHahzGDcrB4dy0oOQ@mail.gmail.com>
 <878uvw1t49.fsf@mina86.com>
 <CAFSJ42a5ngsShaQPwwjfLxaj3ojvghwTAvCBggG=tPr9oLwhEg@mail.gmail.com>
 <8738m2uukz.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738m2uukz.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing Signed-off-by...

On Mon, Dec 09, 2013 at 12:34:04PM +0100, Michal Nazarewicz wrote:
> Commit [3469adb3: fix potential NULL pointer dereference] introduced
> a check of msg_ind allocation, but omitted allocation of msg_ind->msg.
> Moreover, it introduced two if statements, which looked a bit clunky.
> 
> This commit moves allocation code outside of the critical section so
> there's no need to dance around mutex_unlock, and adds the missing
> allocation check.
> 
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> On Mon, Dec 09 2013, Eugene Krasnikov wrote:
> > hal_ind_mutex suppose to protect msg_ind but with this patch
> > allocation will be done outside the critical section.
> 
> msg_ind is a local variable which is not shared outside of the function
> until it's added to a list.  I don't see how it matters if it's
> allocation and initialisation is done under mutex.
> 
> In fact, there's another kmalloc call that should be checked and can be
> done outside of the critical section, so disregard my previous patch,
> here's a new one.
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 823631c..713e3ce 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -2056,22 +2056,28 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
>  	case WCN36XX_HAL_OTA_TX_COMPL_IND:
>  	case WCN36XX_HAL_MISSED_BEACON_IND:
>  	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
> -		mutex_lock(&wcn->hal_ind_mutex);
>  		msg_ind = kmalloc(sizeof(*msg_ind), GFP_KERNEL);
> -		if (msg_ind) {
> -			msg_ind->msg_len = len;
> -			msg_ind->msg = kmalloc(len, GFP_KERNEL);
> -			memcpy(msg_ind->msg, buf, len);
> -			list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
> -			queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
> -			wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
> +		if (!msg_ind)
> +			goto nomem;
> +		msg_ind->msg_len = len;
> +		msg_ind->msg = kmalloc(len, GFP_KERNEL);
> +		if (!msg_ind->msg) {
> +			kfree(msg_ind);
> +nomem:
> +			/*
> +			 * FIXME: Do something smarter then just
> +			 * printing an error.
> +			 */
> +			wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
> +				    msg_header->msg_type);
> +			break;
>  		}
> +		memcpy(msg_ind->msg, buf, len);
> +		mutex_lock(&wcn->hal_ind_mutex);
> +		list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
> +		queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
>  		mutex_unlock(&wcn->hal_ind_mutex);
> -		if (msg_ind)
> -			break;
> -		/* FIXME: Do something smarter then just printing an error. */
> -		wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
> -			    msg_header->msg_type);
> +		wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
>  		break;
>  	default:
>  		wcn36xx_err("SMD_EVENT (%d) not supported\n",
> -- 
> 1.8.4
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
