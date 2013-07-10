Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3GJW7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:59:48 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46542 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab3GJW7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:59:46 -0400
Message-ID: <51DDE757.2080103@gmail.com>
Date: Thu, 11 Jul 2013 00:59:35 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Gerlando Falauto <gerlando.falauto@keymile.com>
CC: Jonas Gorski <jogo@openwrt.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mv643xx_eth: fix DT port device name
References: <1373229231-8838-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130707234341.0000721b@unknown> <20130708000540.00004b37@unknown> <51DD3773.1050408@keymile.com>
In-Reply-To: <51DD3773.1050408@keymile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 12:29 PM, Gerlando Falauto wrote:
> Hi Sebastian, Jonas,
>
> first of all thank you for your HUGE efforts in this area.
>
> On 07/08/2013 12:05 AM, Jonas Gorski wrote:
>> On Sun, 7 Jul 2013 23:43:41 +0200
>> Jonas Gorski <jogo@openwrt.org> wrote:
>>
>>> On Sun,  7 Jul 2013 22:33:51 +0200
>>> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>>>
>>>> Device tree support added to Marvell MV643xx ethernet driver registers
>>>> port devices from port device nodes found on the corresponding
>>>> controller
>>>> node. The current port device name will cause the second controller to
>>>> fail on registration because of two identical device names. This fixes
>>>> the issue by taking the device node's name also as port device name.
>>>>
>>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>>> Reported-by: Jonas Gorski <jogo@openwrt.org>
>>>> ---
>>>> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
>>>> Cc: Jonas Gorski <jogo@openwrt.org>
>>>> Cc: netdev@vger.kernel.org
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> ---
>>>>   drivers/net/ethernet/marvell/mv643xx_eth.c |    2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c
>>>> b/drivers/net/ethernet/marvell/mv643xx_eth.c
>>>> index 6495bea..1f3a03d 100644
>>>> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
>>>> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
>>>> @@ -2521,7 +2521,7 @@ static int
>>>> mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
>>>>           of_property_read_u32(pnp, "duplex", &ppd.duplex);
>>>>       }
>>>>
>>>> -    ppdev = platform_device_alloc(MV643XX_ETH_NAME, ppd.port_number);
>>>> +    ppdev = platform_device_alloc(pnp->name, ppd.port_number);
>>>>       if (!ppdev)
>>>>           return -ENOMEM;
>>>>       ppdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>>>
>>> This breaks ethernet completely, as there is no platform driver
>>> registered for pnp->name ("ethernetX-port"), only for MV643XX_ETH_NAME.
>>
>> Looking back at our conversation, this is my fault.
>> I actually did not change this part as you asked, but I saw the
>> alloc/del issue with port 0, then added the counter and also only
>> replaced the ppd.port_number in the alloc with it. I had completely
>> forgotten at that time to replace the device name; else I would
>> have caught it back then.
>>
>> I only caught it now because I tried your patch and wondered why there
>> wasn't anything registered, not because I saw the problem by review.
>>
>
> The way I understand it, you are "manually" creating platform devices
> off the port subnodes (which, incidentally, have a compatible =
> "marvell,kirkwood-eth-port" property), but matching with the driver is
> indeed performed by device name.
> Hence Sebastian's first patch breaks everything and Jonas' latest one
> fixes it. Is that correct? Is there any more work ongoing in this area?
>
> One more question: if my understanding above is correct, what's the
> reason for NOT having an of_device_id[] table, which looks like was
> present in Florian Fainelli's first proposal [1]?

Gerlando,

for the long run, I plan to break with controller/port device
separation. I haven't looked into netdev internals, but I guess
you can have more than one netdev per platform_device.

Using one device per controller will remove some temporal dependencies
of when which driver gets loaded (there will be only one) and also the
root cause of the issue fixed by Jonas.

But it is not on my top priority list, but after fixing MAC address
obliviousness, suspend/resume and initial port setup.

> I'm also willing to help testing your present/future kirkwood patches if
> you like. Please just put me on Cc:

I once put too many people on Cc and that caused ML rejects, but if I
remember it I will keep you posted.

Sebastian

