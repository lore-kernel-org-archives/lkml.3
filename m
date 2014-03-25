Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaCYUMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:12:05 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:63778 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaCYUMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:12:02 -0400
MIME-Version: 1.0
In-Reply-To: <1393934464-23675-13-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	<1393934464-23675-13-git-send-email-hayeswang@realtek.com>
Date: Tue, 25 Mar 2014 13:12:01 -0700
Message-ID: <CANEJEGvB7K3EQ6hyyweT3MA3kWSMcvAGXNHSTZK=6_z=dHhTfA@mail.gmail.com>
Subject: Re: [PATCH net-next 12/12] r8152: modify the tx timeout funcfion
From: Grant Grundler <grundler@google.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev <netdev@vger.kernel.org>, nic_swsd@realtek.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 4:01 AM, Hayes Wang <hayeswang@realtek.com> wrote:
> Reset and reinitialize the device when the tx timeout occurs.

Hayes,
I believe this patch was dropped after the series was split.
Can you please repost this patch by itself?

(and fix the "function" typo in the patch header)

>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 41 +++++++++++++++++++++++++++++++----------
>  1 file changed, 31 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index e04fcbd..23e03a6 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -1791,16 +1791,6 @@ static void rtl_drop_queued_tx(struct r8152 *tp)
>         }
>  }
>
> -static void rtl8152_tx_timeout(struct net_device *netdev)
> -{
> -       struct r8152 *tp = netdev_priv(netdev);
> -       int i;
> -
> -       netif_warn(tp, tx_err, netdev, "Tx timeout\n");
> -       for (i = 0; i < RTL8152_MAX_TX; i++)
> -               usb_unlink_urb(tp->tx_info[i].urb);
> -}
> -
>  static void rtl8152_set_rx_mode(struct net_device *netdev)
>  {
>         struct r8152 *tp = netdev_priv(netdev);
> @@ -3177,6 +3167,37 @@ out:
>         return res;
>  }
>
> +static void rtl8152_tx_timeout(struct net_device *netdev)
> +{
> +       struct r8152 *tp = netdev_priv(netdev);
> +
> +       netif_warn(tp, tx_err, netdev, "Tx timeout\n");
> +
> +       if (usb_autopm_get_interface(tp->intf) < 0)
> +               return;
> +
> +       netif_stop_queue(netdev);
> +       clear_bit(WORK_ENABLE, &tp->flags);
> +       usb_kill_urb(tp->intr_urb);
> +       cancel_delayed_work_sync(&tp->schedule);
> +       tp->rtl_ops.down(tp);
> +
> +       usb_reset_device(tp->udev);
> +
> +       tp->rtl_ops.init(tp);
> +       tp->rtl_ops.up(tp);
> +       rtl8152_set_speed(tp, AUTONEG_ENABLE,
> +                         tp->mii.supports_gmii ? SPEED_1000 : SPEED_100,
> +                         DUPLEX_FULL);
> +       tp->speed = 0;

Nit: Could rtl_ops.up() set speed since it appears to be changing the
state of the link?

rtl8152_open() uses a remarkably similar code sequence. Is there an
opportunity to refactor and  make sure this sequence is consistent?
(different patch, not this one)

cheers,
grant

> +       netif_carrier_off(netdev);
> +       netif_start_queue(netdev);
> +       set_bit(WORK_ENABLE, &tp->flags);
> +       usb_submit_urb(tp->intr_urb, GFP_KERNEL);
> +
> +       usb_autopm_put_interface(tp->intf);
> +}
> +
>  static const struct net_device_ops rtl8152_netdev_ops = {
>         .ndo_open               = rtl8152_open,
>         .ndo_stop               = rtl8152_close,
> --
> 1.8.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
