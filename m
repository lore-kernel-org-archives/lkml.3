Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab3ICUJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:09:06 -0400
Received: from mail.ispras.ru ([83.149.199.45]:46453 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759990Ab3ICUJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:09:05 -0400
Message-ID: <522641DE.70902@ispras.ru>
Date: Wed, 04 Sep 2013 00:09:02 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: larry.finger@lwfinger.net, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] rtl8187: fix use after free on failure path in rtl8187_init_urbs()
References: <1378103685.43571.YahooMailBasic@web172301.mail.ir2.yahoo.com>
In-Reply-To: <1378103685.43571.YahooMailBasic@web172301.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.09.2013 10:34, Hin-Tak Leung wrote:
> ------------------------------
> On Mon, Sep 2, 2013 05:06 BST Alexey Khoroshilov wrote:
>
>> On 01.09.2013 10:51, Hin-Tak Leung wrote:
>>> ------------------------------
>>> On Sat, Aug 31, 2013 22:18 BST Alexey Khoroshilov wrote:
>>>
>>> In case of __dev_alloc_skb() failure rtl8187_init_urbs()
>>> calls usb_free_urb(entry) where 'entry' can points to urb
>>> allocated at the previous iteration. That means refcnt will be
>>> decremented incorrectly and the urb can be used after memory
>>> deallocation.
>>>
>>> The patch fixes the issue and implements error handling of init_urbs
>>> in rtl8187_start().
>>>
>>> Found by Linux Driver Verification project (linuxtesting.org).
>>>
>>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>>> ---
>>> drivers/net/wireless/rtl818x/rtl8187/dev.c | 15 ++++++++++-----
>>> 1 file changed, 10 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>>> index f49220e..e83d53c 100644
>>> --- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
>>> +++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>>> @@ -438,17 +438,16 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
>>>            skb_queue_tail(&priv->rx_queue, skb);
>>>            usb_anchor_urb(entry, &priv->anchored);
>>>            ret = usb_submit_urb(entry, GFP_KERNEL);
>>> +        usb_free_urb(entry);
>>>            if (ret) {
>>>                skb_unlink(skb, &priv->rx_queue);
>>>                usb_unanchor_urb(entry);
>>>                goto err;
>>>            }
>>> -        usb_free_urb(entry);
>>>        }
>>>        return ret;
>>>
>>> err:
>>> -    usb_free_urb(entry);
>>>        kfree_skb(skb);
>>>        usb_kill_anchored_urbs(&priv->anchored);
>>>        return ret;
>>> This part looks wrong - you free_urb(entry) then unanchor_urb(entry).
>> I do not see any problems here.
>> usb_free_urb() just decrements refcnt of the urb.
>> While usb_anchor_urb() and usb_unanchor_urb() increment and decrement it
>> as well.
>> So actual memory deallocation will happen in usb_unanchor_urb().
> If the routines work as you say, they probably are misnamed, and/or prototyped wrongly?
> Also, you are making assumptions about how they are implemented, and relying
> on the implementation details to be fixed for eternity.
>
> I am just saying,
>
> XXX_free(some_entity);
> if(condtion)
>       do_stuff(some_entity);
>
> looks wrong, and if that's intentional, those routines really shouldn't be named as such.
There is an alias for usb_free_urb() named usb_put_urb().
I will resend the patch with such substitution.

--
Alexey
