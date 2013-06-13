Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab3FMWMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:12:54 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47180 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3FMWMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:12:53 -0400
Message-ID: <51BA43DC.7050805@gmail.com>
Date: Thu, 13 Jun 2013 23:12:44 +0100
From: Dave Kilroy <kilroyd@googlemail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] orinoco_usb: fix memory leak in ezusb_access_ltv() when
 device disconnected
References: <1371155171-15398-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1371155171-15398-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/2013 21:26, Alexey Khoroshilov wrote:
> If "device is disconnected" check occurs to be true in ezusb_access_ltv(),
> it just return -ENODEV. But that means request_context is leaked since
> there are no any references to it anymore.
> The patch adds a call to ezusb_request_context_put() before return.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>   drivers/net/wireless/orinoco/orinoco_usb.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
> index 1f9cb55..bdfe637 100644
> --- a/drivers/net/wireless/orinoco/orinoco_usb.c
> +++ b/drivers/net/wireless/orinoco/orinoco_usb.c
> @@ -881,7 +881,8 @@ static int ezusb_access_ltv(struct ezusb_priv *upriv,
>   
>   	if (!upriv->udev) {
>   		dbg("Device disconnected");
> -		return -ENODEV;
> +		retval = -ENODEV;
> +		goto exit;
>   	}
>   
>   	if (upriv->read_urb->status != -EINPROGRESS)
It looks like there is also loss of a request_context in
ezusb_xmit after orinoco_process_xmit_skb fails. Something like
the following should resolve it.

The remaining request_context allocations look ok to me.


Dave.
---
Apologies, this is cut+paste from an old tree and mangled to be
diff-like. Untested. Uncompiled.

diff a/drivers/net/wireless/orinoco/orinoco_usb.c 
b/drivers/net/wireless/orinoco/orinoco_usb.c
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1194,8 +1194,10 @@ static netdev_tx_t ezusb_xmit(struct sk_buff 
*skb, struct net_device *dev)

     err = orinoco_process_xmit_skb(skb, dev, priv, &tx_control,
                        &mic[0]);
-    if (err)
+    if (err) {
+        ezusb_request_context_put(ctx);
         goto drop;
+    }

     {
         __le16 *tx_cntl = (__le16 *)buf;

