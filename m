Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161352Ab3LFW2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:28:16 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:33635 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161122Ab3LFW2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:28:13 -0500
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5k/AuK2RDA==
X-RZG-CLASS-ID: mo00
User-Agent: K-9 Mail for Android
In-Reply-To: <1386363082-15144-1-git-send-email-khoroshilov@ispras.ru>
References: <1386363082-15144-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] can: ems_usb: fix a leak in ems_usb_start_xmit()
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Fri, 06 Dec 2013 23:28:12 +0100
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Message-ID: <6e046a57-0383-41ae-bc8c-8eaaa4709a4c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





Alexey Khoroshilov <khoroshilov@ispras.ru> schrieb:
>There is spare code with obvious misprint in ems_usb_start_xmit():
>usb_free_urb() should be used to deallocate urb instead of
>usb_unanchor_urb().
>
>Found by Linux Driver Verification project (linuxtesting.org).
>
>Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>---
> drivers/net/can/usb/ems_usb.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/can/usb/ems_usb.c
>b/drivers/net/can/usb/ems_usb.c
>index 5f9a7ad9b964..beae1ec255f4 100644
>--- a/drivers/net/can/usb/ems_usb.c
>+++ b/drivers/net/can/usb/ems_usb.c
>@@ -798,7 +798,7 @@ static netdev_tx_t ems_usb_start_xmit(struct
>sk_buff *skb, struct net_device *ne
> 	 * allowed (MAX_TX_URBS).
> 	 */
> 	if (!context) {
>-		usb_unanchor_urb(urb);
>+		usb_free_urb(urb);
> 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
> 

looks like you are introducing a new use after free problem here ...

> 		netdev_warn(netdev, "couldn't find free context\n");

-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
