Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaC0ArW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:47:22 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51922 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754782AbaC0ArU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:47:20 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2014 20:47:20 EDT
Message-ID: <53337513.1010708@hurleysoftware.com>
Date: Wed, 26 Mar 2014 20:47:15 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>
CC: linux-serial@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        m-karicheri2@ti.com, b32955@freescale.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11] bluetooth: hci_ldisc: fix deadlock condition
References: <1395343807-21618-1-git-send-email-balbi@ti.com> <1395343807-21618-9-git-send-email-balbi@ti.com>
In-Reply-To: <1395343807-21618-9-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +to Marcel Holtmann ]

On 03/20/2014 03:30 PM, Felipe Balbi wrote:
> LDISCs shouldn't call tty->ops->write() from within
> ->write_wakeup().
>
> ->write_wakeup() is called with port lock taken and
> IRQs disabled, tty->ops->write() will try to acquire
> the same port lock and we will deadlock.
>
> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> Reported-by: Huang Shijie <b32955@freescale.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

I just noticed this patch wasn't addressed to Marcel;
seems like this should go through the bluetooth tree (but not
through bluetooth-next because it fixes an oops).

Marcel,

You may want to build on top of this patch split handling;
I noticed some of the protocol drivers are calling
hci_uart_tx_wakeup() from work functions already (so don't
need to schedule another work...)

Regards,
Peter Hurley

> ---
>   drivers/bluetooth/hci_ldisc.c | 24 +++++++++++++++++++-----
>   drivers/bluetooth/hci_uart.h  |  1 +
>   2 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
> index 6e06f6f..77af52f 100644
> --- a/drivers/bluetooth/hci_ldisc.c
> +++ b/drivers/bluetooth/hci_ldisc.c
> @@ -118,10 +118,6 @@ static inline struct sk_buff *hci_uart_dequeue(struct hci_uart *hu)
>
>   int hci_uart_tx_wakeup(struct hci_uart *hu)
>   {
> -	struct tty_struct *tty = hu->tty;
> -	struct hci_dev *hdev = hu->hdev;
> -	struct sk_buff *skb;
> -
>   	if (test_and_set_bit(HCI_UART_SENDING, &hu->tx_state)) {
>   		set_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
>   		return 0;
> @@ -129,6 +125,22 @@ int hci_uart_tx_wakeup(struct hci_uart *hu)
>
>   	BT_DBG("");
>
> +	schedule_work(&hu->write_work);
> +
> +	return 0;
> +}
> +
> +static void hci_uart_write_work(struct work_struct *work)
> +{
> +	struct hci_uart *hu = container_of(work, struct hci_uart, write_work);
> +	struct tty_struct *tty = hu->tty;
> +	struct hci_dev *hdev = hu->hdev;
> +	struct sk_buff *skb;
> +
> +	/* REVISIT: should we cope with bad skbs or ->write() returning
> +	 * and error value ?
> +	 */
> +
>   restart:
>   	clear_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
>
> @@ -153,7 +165,6 @@ restart:
>   		goto restart;
>
>   	clear_bit(HCI_UART_SENDING, &hu->tx_state);
> -	return 0;
>   }
>
>   static void hci_uart_init_work(struct work_struct *work)
> @@ -281,6 +292,7 @@ static int hci_uart_tty_open(struct tty_struct *tty)
>   	tty->receive_room = 65536;
>
>   	INIT_WORK(&hu->init_ready, hci_uart_init_work);
> +	INIT_WORK(&hu->write_work, hci_uart_write_work);
>
>   	spin_lock_init(&hu->rx_lock);
>
> @@ -318,6 +330,8 @@ static void hci_uart_tty_close(struct tty_struct *tty)
>   	if (hdev)
>   		hci_uart_close(hdev);
>
> +	cancel_work_sync(&hu->write_work);
> +
>   	if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
>   		if (hdev) {
>   			if (test_bit(HCI_UART_REGISTERED, &hu->flags))
> diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
> index fffa61f..12df101 100644
> --- a/drivers/bluetooth/hci_uart.h
> +++ b/drivers/bluetooth/hci_uart.h
> @@ -68,6 +68,7 @@ struct hci_uart {
>   	unsigned long		hdev_flags;
>
>   	struct work_struct	init_ready;
> +	struct work_struct	write_work;
>
>   	struct hci_uart_proto	*proto;
>   	void			*priv;
>

