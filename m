Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3EPVeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:34:15 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53134 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3EPVeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:34:13 -0400
MIME-Version: 1.0
In-Reply-To: <5191B5C4.2020609@signal11.us>
References: <1368112788-25701-1-git-send-email-david@hauweele.net>
	<1368112788-25701-2-git-send-email-david@hauweele.net>
	<5191B5C4.2020609@signal11.us>
Date: Thu, 16 May 2013 23:34:11 +0200
X-Google-Sender-Auth: 6NJUX2P6rl88WqQon_xO4nJseq0
Message-ID: <CAO+c-UWi5UH-ZN5G0JiJCrCrScaYprKT7jLpFH0wEJecgoHgig@mail.gmail.com>
Subject: Re: [Linux-zigbee-devel] [PATCH 2/2] mrf24j40: Keep the interrupt
 line enabled
From: David Hauweele <david@hauweele.net>
To: Alan Ott <alan@signal11.us>
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have seen the interrupt line going low forever with heavy traffic.

The at86rf230 driver has two isr, one for edge-triggered and another
for level-triggered interrupt. The latter uses
disable_irq_nosync/enable_irq which makes sense for level-triggered
interrupt. Otherwise the interrupt would be triggered again and again
until the scheduled work read the status register.

However I don't see the use of disable_irq/enable_irq with an
edge-triggered interrupt. Perhaps I'm missing something. Though I
don't see any harm using it anyway. As you said the interrupt should
be delayed until enable_irq() is called. In particular when
CONFIG_HARDIRQS_SW_RESEND is set.

David

2013/5/14 Alan Ott <alan@signal11.us>:
> On 5/9/13 11:19 AM, David Hauweele wrote:
>>
>> Disabling the interrupt line could miss an IRQ and leave the line into a
>> low state hence locking the driver.
>>
>
> Have you observed this? My understanding is that the interrupt won't be lost
> but instead delayed until enable_irq() is called.
>
> I got this pattern from the other 802.15.4 drivers. Perhaps my understanding
> is wrong.
>
>
>
>> Signed-off-by: David Hauweele <david@hauweele.net>
>> ---
>>   drivers/net/ieee802154/mrf24j40.c |    7 +------
>>   1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ieee802154/mrf24j40.c
>> b/drivers/net/ieee802154/mrf24j40.c
>> index 1e3ddf3..6ef32f7 100644
>> --- a/drivers/net/ieee802154/mrf24j40.c
>> +++ b/drivers/net/ieee802154/mrf24j40.c
>> @@ -603,8 +603,6 @@ static irqreturn_t mrf24j40_isr(int irq, void *data)
>>   {
>>         struct mrf24j40 *devrec = data;
>>
>> -       disable_irq_nosync(irq);
>> -
>>         schedule_work(&devrec->irqwork);
>>
>>         return IRQ_HANDLED;
>> @@ -619,7 +617,7 @@ static void mrf24j40_isrwork(struct work_struct *work)
>>         /* Read the interrupt status */
>>         ret = read_short_reg(devrec, REG_INTSTAT, &intstat);
>>         if (ret)
>> -               goto out;
>> +               return;
>>
>>         /* Check for TX complete */
>>         if (intstat & 0x1)
>> @@ -628,9 +626,6 @@ static void mrf24j40_isrwork(struct work_struct *work)
>>         /* Check for Rx */
>>         if (intstat & 0x8)
>>                 schedule_work(&devrec->rxwork);
>> -
>> -out:
>> -       enable_irq(devrec->spi->irq);
>>   }
>>
>>   static void mrf24j40_rxwork(struct work_struct *work)
>>
>
