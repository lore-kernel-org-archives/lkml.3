Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbbASIDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:03:46 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35321 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbbASIDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:03:44 -0500
MIME-Version: 1.0
In-Reply-To: <1394712342-15778-119-Taiwan-albertk@realtek.com>
References: <1394712342-15778-118-Taiwan-albertk@realtek.com>
	<1394712342-15778-119-Taiwan-albertk@realtek.com>
Date: Mon, 19 Jan 2015 00:03:42 -0800
Message-ID: <CAE4R7bAv26f-+DW-TmjspJxAb-3Add5sf563mnMUTGCyiqG3rQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] r8152: adjust rx_bottom
From: Scott Feldman <sfeldma@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: Netdev <netdev@vger.kernel.org>, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 11:13 PM, Hayes Wang <hayeswang@realtek.com> wrote:
> If a error occurs when submitting rx, skip the remaining submissions
> and try to submit them again next time.
>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 2e22442..78a8917 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -1655,7 +1655,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
>  {
>         unsigned long flags;
>         struct list_head *cursor, *next, rx_queue;
> -       int work_done = 0;
> +       int ret = 0, work_done = 0;
>
>         if (!skb_queue_empty(&tp->rx_queue)) {
>                 while (work_done < budget) {
> @@ -1746,7 +1746,18 @@ find_next_rx:
>                 }
>
>  submit:
> -               r8152_submit_rx(tp, agg, GFP_ATOMIC);
> +               if (!ret) {
> +                       ret = r8152_submit_rx(tp, agg, GFP_ATOMIC);
> +               } else {
> +                       urb->actual_length = 0;
> +                       list_add_tail(&agg->list, next);

Do you need a spin_lock_irqsave(&tp->rx_lock, flags) around this?

> +               }
> +       }
> +
> +       if (!list_empty(&rx_queue)) {
> +               spin_lock_irqsave(&tp->rx_lock, flags);
> +               list_splice_tail(&rx_queue, &tp->rx_done);
> +               spin_unlock_irqrestore(&tp->rx_lock, flags);
>         }
>
>  out1:
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
