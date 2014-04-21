Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaDULyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:54:50 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:54374 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaDULyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:54:46 -0400
Message-ID: <53550702.80807@cogentembedded.com>
Date: Mon, 21 Apr 2014 15:54:42 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Li, ZhenHua" <zhen-hual@hp.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jiri Pirko <jiri@resnulli.us>,
        stephen hemminger <stephen@networkplumber.org>,
        Jerry Chu <hkchu@google.com>, Sathya Perla <sathya.perla@emulex.com>,
        Subbu Seetharaman <subbu.seetharaman@emulex.com>,
        Ajit Khaparde <ajit.khaparde@emulex.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: Add rtnl_lock for netif_device_attach/detach
References: <1397632082-18453-1-git-send-email-zhen-hual@hp.com> <5351767E.6000404@cogentembedded.com> <5354BAEE.9000005@hp.com>
In-Reply-To: <5354BAEE.9000005@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-04-2014 10:30, Li, ZhenHua wrote:

> The comment is trying to explain why add a lock here.

    I can read, thanks. :-)
    I was wondering about the kernel-doc comment style you've used; AFAIK, 
it's only good for documenting functions and data structures. The normal 
multi-line comment style in the networking code is this:

/* bla
  * bla
  */

>>> From: "Li, Zhen-Hua" <zhen-hual@hp.com>

>>> As netif_running is called in netif_device_attach/detach. There should be
>>> rtnl_lock/unlock called, to avoid dev stat change during netif_device_attach
>>> and detach being called.
>>> I checked NIC some drivers,  some of them have netif_device_attach/detach
>>> called between rtnl_lock/unlock, while some drivers do not.

>>> This patch is tring to find a generic way to fix this for all NIC drivers.

>>> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
>>> ---
>>>   net/core/dev.c |   18 ++++++++++++++++++
>>>   1 file changed, 18 insertions(+)

>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index 5b3042e..795bbc5 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -2190,10 +2190,19 @@ EXPORT_SYMBOL(__dev_kfree_skb_any);
>>>    */
>>>   void netif_device_detach(struct net_device *dev)
>>>   {
>>> +    /**

>>   Hm, why kernel-doc style comment here?

>>> +     * As netif_running is called , rtnl_lock and unlock are needed to

    Space before comma not needed.

>>> +     * avoid __LINK_STATE_START bit changes during this function call.
>>> +     */
>>> +    int need_unlock;
>>> +
>>> +    need_unlock = rtnl_trylock();
>>>       if (test_and_clear_bit(__LINK_STATE_PRESENT, &dev->state) &&
>>>           netif_running(dev)) {
>>>           netif_tx_stop_all_queues(dev);
>>>       }
>>> +    if (need_unlock)
>>> +        rtnl_unlock();
>>>   }
>>>   EXPORT_SYMBOL(netif_device_detach);
>>>
>>> @@ -2205,11 +2214,20 @@ EXPORT_SYMBOL(netif_device_detach);
>>>    */
>>>   void netif_device_attach(struct net_device *dev)
>>>   {
>>> +    /**

>>   ... and here?

>>> +     * As netif_running is called , rtnl_lock and unlock are needed to

    Space before comma not needed.

>>> +     * avoid __LINK_STATE_START bit changes during this function call.
>>> +     */

WBR, Sergei

