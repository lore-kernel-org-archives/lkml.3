Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaKRWBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 17:01:53 -0500
Received: from senator.holtmann.net ([87.106.208.187]:36676 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbaKRWBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 17:01:52 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] l2cap_core: automatically flushable packets aren't supported by LE-only devices
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1416321963-17336-1-git-send-email-stevenrwalter@gmail.com>
Date: Wed, 19 Nov 2014 07:01:42 +0900
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <106789BA-48C0-4428-BE3E-D0737F7A0641@holtmann.org>
References: <1416321963-17336-1-git-send-email-stevenrwalter@gmail.com>
To: Steven Walter <stevenrwalter@gmail.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

> The bluetooth spec states that automatically flushable packets may not
> be sent to a LE-only controller.  The code already supports
> non-automatically-flushable packets, but uses a bit in the controller
> feature field to determine whether to use them.  That bit is always zero
> for LE-only devices, so we need to check for the LE-only case explicitly.
> ---
> net/bluetooth/l2cap_core.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 4af3821..29d9b9c 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -764,7 +764,7 @@ static void l2cap_send_cmd(struct l2cap_conn *conn, u8 ident, u8 code, u16 len,
> 	if (!skb)
> 		return;
> 
> -	if (lmp_no_flush_capable(conn->hcon->hdev))
> +	if (lmp_no_flush_capable(conn->hcon->hdev) || !lmp_bredr_capable(conn->hcon->hdev))
> 		flags = ACL_START_NO_FLUSH;
> 	else
> 		flags = ACL_START;
> @@ -798,8 +798,9 @@ static void l2cap_do_send(struct l2cap_chan *chan, struct sk_buff *skb)
> 		return;
> 	}
> 
> -	if (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
> -	    lmp_no_flush_capable(hcon->hdev))
> +	if (!lmp_bredr_capable(hcon->hdev) ||
> +	    (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
> +	    lmp_no_flush_capable(hcon->hdev)))
> 		flags = ACL_START_NO_FLUSH;
> 	else
> 		flags = ACL_START;

I do not think doing it this way is correct. I am actually surprised that it using fine right now, but I assume that is because all dual-mode controllers also support non-flushable packets.

We should check the link type of the connection and if it is LE then we should always use non-flushable packets. The feature bits have really nothing to do with this. They only apply to the BR/EDR side of things. LE has its own supported feature bits.

Regards

Marcel

