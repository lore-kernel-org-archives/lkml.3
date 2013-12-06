Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157Ab3LFW5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:57:54 -0500
Received: from mail.ispras.ru ([83.149.199.45]:59232 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3LFW5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:57:52 -0500
Message-ID: <52A2566B.3030302@ispras.ru>
Date: Sat, 07 Dec 2013 02:57:47 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] can: ems_usb: fix a leak in ems_usb_start_xmit()
References: <1386363082-15144-1-git-send-email-khoroshilov@ispras.ru> <6e046a57-0383-41ae-bc8c-8eaaa4709a4c@email.android.com>
In-Reply-To: <6e046a57-0383-41ae-bc8c-8eaaa4709a4c@email.android.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.12.2013 02:28, Oliver Hartkopp wrote:
> Alexey Khoroshilov <khoroshilov@ispras.ru> schrieb:
>> There is spare code with obvious misprint in ems_usb_start_xmit():
>> usb_free_urb() should be used to deallocate urb instead of
>> usb_unanchor_urb().
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> ---
>> drivers/net/can/usb/ems_usb.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/can/usb/ems_usb.c
>> b/drivers/net/can/usb/ems_usb.c
>> index 5f9a7ad9b964..beae1ec255f4 100644
>> --- a/drivers/net/can/usb/ems_usb.c
>> +++ b/drivers/net/can/usb/ems_usb.c
>> @@ -798,7 +798,7 @@ static netdev_tx_t ems_usb_start_xmit(struct
>> sk_buff *skb, struct net_device *ne
>> 	 * allowed (MAX_TX_URBS).
>> 	 */
>> 	if (!context) {
>> -		usb_unanchor_urb(urb);
>> +		usb_free_urb(urb);
>> 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
>>
> looks like you are introducing a new use after free problem here ...
>
You are right. usb_free_urb(urb) should be one line below.

I will resend the patch with one more similar fix in the driver.
