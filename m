Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaHOJKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:10:20 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:22187 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaHOJKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:10:18 -0400
Message-ID: <53EDCE6F.9000307@c-s.fr>
Date: Fri, 15 Aug 2014 11:10:07 +0200
From: christophe leroy <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Issue with commit 33c133cc7598e60976a phy: IRQ cannot be shared
References: <53EC57B9.8080903@c-s.fr> <53EC9783.3020809@cogentembedded.com>
In-Reply-To: <53EC9783.3020809@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Antivirus: avast! (VPS 140815-0, 15/08/2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 14/08/2014 13:03, Sergei Shtylyov a écrit :
> Hello.
>
> On 8/14/2014 10:31 AM, leroy christophe wrote:
>
>> I have an hardware with two ethernet interfaces, and with the two 
>> PHYs inside
>> the same component INTEL LXT973 which has only one interrupt.
>> I also have another hardware with two ethernet interfaces and two 
>> independant
>> PHYs. But the two PHYs are wired to the same interrupt.
>> This is working perfectly up to Linux 3.12.
>
>    Hm, I'm surprised it works. Are you sure you're getting interrupts 
> from both PHYs? Because if both Ethernet controllers are active 
> simultaneously, only the first registered PHY IRQ handler should get 
> all the interrupts.
Yes it works. Why should only the first one get the interrupts ? 
handle_irq_event_percpu() (from kernel/irq/handle.c, extract below) 
calls all handlers regardless of whether they answer IRQ_NONE or 
IRQ_HANDLED. The break applies to the switch(), not to the while(). So 
all handlers are called.

irqreturn_t
handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
{
     irqreturn_t retval = IRQ_NONE;
     unsigned int flags = 0, irq = desc->irq_data.irq;

     do {
[...]
         switch (res) {
         case IRQ_WAKE_THREAD:
[...]
         case IRQ_HANDLED:
             flags |= action->flags;
             break;

         default:
             break;
         }

         retval |= res;
         action = action->next;
     } while (action);

>
>> But since your commit, introduced in Linux 3.13, my interfaces don't 
>> work
>> anymore as the second PHYs can't register IRQ.
>
>    Strange too, the phylib should use polling in case request_irq() 
> fails.
Well, you are right, I didn't check closely enough, was assuming they 
didn't register due to the messages saying interrupt mismatch.
>
>> Reading the commit log, I can't really understand the reason for the 
>> change.
>
>    The shared IRQ handler should check for IRQ from its device and 
> return IRQ_NONE if there's no IRQ active; phy_interrupt() doesn't do 
> that (this is pushed to the workqueue).
Well, as seen above, this has no impact on whether other handlers are 
called or not.
>
>> Is it really worth it, and therefore how shall my case be handled ?
>
>    PHY IRQs are not necessary for the phylib state machine.
However, polling is less efficient than IRQs. It wastes CPU and link 
loss detection is slower.
>
>> Christophe
>
> WBR, Sergei
>
BR
Christophe

---
Ce courrier électronique ne contient aucun virus ou logiciel malveillant parce que la protection avast! Antivirus est active.
http://www.avast.com

