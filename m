Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3LEIle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:41:34 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:34123 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3LEIla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:41:30 -0500
MIME-Version: 1.0
In-Reply-To: <xa1tiov78kmp.fsf@mina86.com>
References: <1385744870-10164-1-git-send-email-mpn@google.com>
	<20131201004715.11125.qmail@stuge.se>
	<xa1tiov78kmp.fsf@mina86.com>
Date: Thu, 5 Dec 2013 08:41:29 +0000
Message-ID: <CAFSJ42YckTDO=UV=fWG9mmVXSBYep1x6xiHahzGDcrB4dy0oOQ@mail.gmail.com>
Subject: Re: [PATCHv2] net: wireless: wcn36xx: fix potential NULL pointer dereference
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Peter Stuge <peter@stuge.se>, "John W. Linville" <linville@tuxdriver.com>,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +               if (msg_ind)
> +                       break;
> +               /* FIXME: Do something smarter then just printing an error. */
> +               wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",

I think code will look neater if error case will be handled in "else"
statement something like:
if (msg_ind) {
...
} else {
/*print message*/
}
/*unlock and break;*/

How about that?


On Mon, Dec 2, 2013 at 1:09 PM, Michal Nazarewicz <mina86@mina86.com> wrote:
>
> If kmalloc fails wcn36xx_smd_rsp_process will attempt to dereference
> a NULL pointer.  There might be a better error recovery then just
> printing an error, but printing an error message is better then the
> current behaviour.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> On Sun, Dec 01 2013, Peter Stuge wrote:
>> Michal Nazarewicz wrote:
>>> +                    wcn36xx_err("Run out of memory while hnadling SMD_EVENT (%d)\n",
>>> +                                msg_header->msg_type);
>>
>> Typo hnadling.
>
> Fixed.
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index de9eb2c..3663394 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -2041,13 +2041,20 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
>         case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
>                 mutex_lock(&wcn->hal_ind_mutex);
>                 msg_ind = kmalloc(sizeof(*msg_ind), GFP_KERNEL);
> -               msg_ind->msg_len = len;
> -               msg_ind->msg = kmalloc(len, GFP_KERNEL);
> -               memcpy(msg_ind->msg, buf, len);
> -               list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
> -               queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
> -               wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
> +               if (msg_ind) {
> +                       msg_ind->msg_len = len;
> +                       msg_ind->msg = kmalloc(len, GFP_KERNEL);
> +                       memcpy(msg_ind->msg, buf, len);
> +                       list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
> +                       queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
> +                       wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
> +               }
>                 mutex_unlock(&wcn->hal_ind_mutex);
> +               if (msg_ind)
> +                       break;
> +               /* FIXME: Do something smarter then just printing an error. */
> +               wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
> +                           msg_header->msg_type);
>                 break;
>         default:
>                 wcn36xx_err("SMD_EVENT (%d) not supported\n",
> --
> 1.8.4.1
>
> --
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
> ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--



-- 
Best regards,
Eugene
