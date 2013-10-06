Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3JFBB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 21:01:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55085 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494Ab3JFBBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 21:01:55 -0400
X-Sasl-enc: 78DEEnhecpgzhnoeJqce96QFMRMf27laSpoQy/FH/iyv 1381021313
Message-ID: <5250B680.2080301@signal11.us>
Date: Sat, 05 Oct 2013 21:01:52 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexander Aring <alex.aring@gmail.com>
CC: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 6lowpan: Sync default hardware address of lowpan links
 to their wpan
References: <1381009080-15945-1-git-send-email-alan@signal11.us> <20131006002451.GA22623@omega>
In-Reply-To: <20131006002451.GA22623@omega>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2013 08:24 PM, Alexander Aring wrote:
> Hi Alan,
>
> On Sat, Oct 05, 2013 at 05:38:00PM -0400, Alan Ott wrote:
>> When a lowpan link to a wpan device is created, set the hardware address
>> of the lowpan link to that of the wpan device.
>>
>> Signed-off-by: Alan Ott<alan@signal11.us>
>> ---
>>   net/ieee802154/6lowpan.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
>> index c85e71e..fb89133 100644
>> --- a/net/ieee802154/6lowpan.c
>> +++ b/net/ieee802154/6lowpan.c
>> @@ -1386,6 +1386,9 @@ static int lowpan_newlink(struct net *src_net, struct net_device *dev,
>>   
>>   	entry->ldev = dev;
>>   
>> +	BUG_ON(IEEE802154_ADDR_LEN != dev->addr_len);
> So if somebody make a:
> "ip link add link $NOT_8BYTE_HWADDR_DEV name $NAME type lowpan"
>
> the kernel creates a BUG_ON? Okay it seems that case is very unusual but
> better is to return a errno so "maybe(I don't know it)" the userspace
> software will generate a error and the whole kernel doesn't crash.

That line checks the length of the address of the lowpan device, not the 
real device the lowpan device is attached to (and on second look, I 
don't like the Yoda code; didn't notice that before).

Further, running:
     ip link add link eth0 name lowpan0 type lowpan

like you suggest, crashes the kernel hard, with or without my patch. 
More stuff to fix....


>> +	memcpy(dev->dev_addr, real_dev->dev_addr, IEEE802154_ADDR_LEN);
> Is there one case where we read the dev->dev_addr? I saw a case when we
> set this [1], but I don't know why we need this. Did you detect some
> problems because this isn't the "real" hw addr?
>
> Other case is I am feeling uneasy when we have two netdev devices with
> the same hw addr.
> [1]https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/net/ieee802154/6lowpan.c?id=refs/tags/v3.12-rc3#n1102

In my testing, lowpan devices need a hardware address which is the same 
as the wpan, or else stuff like ping doesn't work at all. In all the 
examples I've ever seen, the lowpan's hardware address has been set 
manually.

What does your test setup look like that you don't have a hardware 
address for your lowpan device? Are you able to ping other Linux hosts?

Alan.

