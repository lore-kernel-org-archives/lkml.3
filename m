Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaCaEKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 00:10:23 -0400
Received: from [216.32.181.181] ([216.32.181.181]:8416 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbaCaEKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 00:10:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
Message-ID: <5338EA57.1000509@freescale.com>
Date: Mon, 31 Mar 2014 12:08:55 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Vinod Koul <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <scottwood@freescale.com>,
        <LeoLi@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] DMA: Freescale: use spin_lock_bh instead of spin_lock_irqsave
References: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com> <1389851246-8564-7-git-send-email-hongbo.zhang@freescale.com> <1395817294.6569.2.camel@vkoul-udesk3> <533517C1.8080208@freescale.com> <20140329134528.GQ1976@intel.com>
In-Reply-To: <20140329134528.GQ1976@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/29/2014 09:45 PM, Vinod Koul wrote:
> On Fri, Mar 28, 2014 at 02:33:37PM +0800, Hongbo Zhang wrote:
>> On 03/26/2014 03:01 PM, Vinod Koul wrote:
>>> On Thu, 2014-01-16 at 13:47 +0800, hongbo.zhang@freescale.com wrote:
>>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>>
>>>> The usage of spin_lock_irqsave() is a stronger locking mechanism than is
>>>> required throughout the driver. The minimum locking required should be used
>>>> instead. Interrupts will be turned off and context will be saved, it is
>>>> unnecessary to use irqsave.
>>>>
>>>> This patch changes all instances of spin_lock_irqsave() to spin_lock_bh(). All
>>>> manipulation of protected fields is done using tasklet context or weaker, which
>>>> makes spin_lock_bh() the correct choice.
>>>>
>
>>>>   /**
>>>> @@ -1124,11 +1120,10 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
>>>>   static void dma_do_tasklet(unsigned long data)
>>>>   {
>>>>   	struct fsldma_chan *chan = (struct fsldma_chan *)data;
>>>> -	unsigned long flags;
>>>>   	chan_dbg(chan, "tasklet entry\n");
>>>> -	spin_lock_irqsave(&chan->desc_lock, flags);
>>>> +	spin_lock_bh(&chan->desc_lock);
>>> okay here is the problem :(
>>>
>>> You moved to _bh variant. So if you grab the lock in rest of the code
>>> and irq gets triggered then here we will be spinning to grab the lock.
>>> So effectively you made right locking solution into deadlock situation!
>> If the rest code grabs lock by spin_lock_bh(), and if irq raised,
>> the tasklet could not be executed because it has been disabled by
>> the _bh variant function.
> yes if you are accessing resources only in tasklet and rest of the code, then
> _bh variant works well. The problem here is usage in irq handler
>

The name dma_do_tasklet may mislead, it is tasklet handler, not irq 
handler, not a trigger to load tasklet.
the irq handler is fsldma_chan_irq, and I don't use lock in it.

If it is the problem, I would like to change dma_do_tasklet to 
dma_tasklet to eliminate misleading.



