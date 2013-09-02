Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab3IBEGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 00:06:06 -0400
Received: from mail.ispras.ru ([83.149.199.45]:35092 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab3IBEGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 00:06:04 -0400
Message-ID: <52240EA9.7010207@ispras.ru>
Date: Mon, 02 Sep 2013 07:06:01 +0300
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: larry.finger@lwfinger.net, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] rtl8187: fix use after free on failure path in rtl8187_init_urbs()
References: <1378021881.73447.YahooMailBasic@web172302.mail.ir2.yahoo.com>
In-Reply-To: <1378021881.73447.YahooMailBasic@web172302.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.09.2013 10:51, Hin-Tak Leung wrote:
> ------------------------------
> On Sat, Aug 31, 2013 22:18 BST Alexey Khoroshilov wrote:
>
>> In case of __dev_alloc_skb() failure rtl8187_init_urbs()
>> calls usb_free_urb(entry) where 'entry' can points to urb
>> allocated at the previous iteration. That means refcnt will be
>> decremented incorrectly and the urb can be used after memory
>> deallocation.
>>
>> The patch fixes the issue and implements error handling of init_urbs
>> in rtl8187_start().
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> ---
>> drivers/net/wireless/rtl818x/rtl8187/dev.c | 15 ++++++++++-----
>> 1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>> index f49220e..e83d53c 100644
>> --- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
>> +++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>> @@ -438,17 +438,16 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
>>          skb_queue_tail(&priv->rx_queue, skb);
>>          usb_anchor_urb(entry, &priv->anchored);
>>          ret = usb_submit_urb(entry, GFP_KERNEL);
>> +        usb_free_urb(entry);
>>          if (ret) {
>>              skb_unlink(skb, &priv->rx_queue);
>>              usb_unanchor_urb(entry);
>>              goto err;
>>          }
>> -        usb_free_urb(entry);
>>      }
>>      return ret;
>>
>> err:
>> -    usb_free_urb(entry);
>>      kfree_skb(skb);
>>      usb_kill_anchored_urbs(&priv->anchored);
>>      return ret;
> This part looks wrong - you free_urb(entry) then unanchor_urb(entry).
I do not see any problems here.
usb_free_urb() just decrements refcnt of the urb.
While usb_anchor_urb() and usb_unanchor_urb() increment and decrement it 
as well.
So actual memory deallocation will happen in usb_unanchor_urb().

>
>> @@ -956,8 +955,12 @@ static int rtl8187_start(struct ieee80211_hw *dev)
>>                    (RETRY_COUNT < 8  /* short retry limit */) |
>>                    (RETRY_COUNT < 0  /* long retry limit */) |
>>                    (7 < 21 /* MAX TX DMA */));
>> -        rtl8187_init_urbs(dev);
>> -        rtl8187b_init_status_urb(dev);
>> +        ret = rtl8187_init_urbs(dev);
>> +        if (ret)
>> +            goto rtl8187_start_exit;
>> +        ret = rtl8187b_init_status_urb(dev);
>> +        if (ret)
>> +            usb_kill_anchored_urbs(&priv->anchored);
>>          goto rtl8187_start_exit;
>>      }
>>
>> @@ -966,7 +969,9 @@ static int rtl8187_start(struct ieee80211_hw *dev)
>>      rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
>>      rtl818x_iowrite32(priv, &priv->map->MAR[1], ~0);
>>
>> -    rtl8187_init_urbs(dev);
>> +    ret = rtl8187_init_urbs(dev);
>> +    if (ret)
>> +        goto rtl8187_start_exit;
>>
>>      reg = RTL818X_RX_CONF_ONLYERLPKT |
>>            RTL818X_RX_CONF_RX_AUTORESETPHY |
>> -- 
>> 1.8.1.2
>>
>
>

