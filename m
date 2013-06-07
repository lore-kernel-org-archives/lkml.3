Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3FGDCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 23:02:09 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34675 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3FGDCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 23:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VcQqZc+w9pud3oV4HB-BT1mdq04f=O2AtHZBXQ9fpCe0w@mail.gmail.com>
References: <1369988485-23176-1-git-send-email-wangxfdu@gmail.com>
	<CAHp75Veb+FK=5u_HBUp+KNT4__GjbSg1T-kq1tGebDq2pEJOBA@mail.gmail.com>
	<CACDNBm3WJ_U22uqKuVssV4ntATTHnz_8=pq9_qa33S+eKreKSA@mail.gmail.com>
	<CAHp75VfeVZRzyW0jKH=oVPPQv3=tmg214D9=tBs0j3_==20UZg@mail.gmail.com>
	<CACDNBm1mjtHcE+Mm_y55xq2VW_8DVq+-1537M_FnqocWRhafsg@mail.gmail.com>
	<CAHp75VcQqZc+w9pud3oV4HB-BT1mdq04f=O2AtHZBXQ9fpCe0w@mail.gmail.com>
Date: Fri, 7 Jun 2013 11:02:06 +0800
Message-ID: <CACDNBm2Q+9KTs-57N9Y7YYHZhzYvyJN+4XFxuwRsS-XoEGyhbQ@mail.gmail.com>
Subject: Re: [PATCH] dma: mmp_pdma: support for getting residual bytes
From: Xiang Wang <wangxfdu@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/6 Andy Shevchenko <andy.shevchenko@gmail.com>:
> On Thu, Jun 6, 2013 at 6:09 AM, Xiang Wang <wangxfdu@gmail.com> wrote:
>> 2013/6/3 Andy Shevchenko <andy.shevchenko@gmail.com>:
>>> On Mon, Jun 3, 2013 at 6:22 AM, Xiang Wang <wangxfdu@gmail.com> wrote:
>>>> 2013/5/31 Andy Shevchenko <andy.shevchenko@gmail.com>:
>>>>> On Fri, May 31, 2013 at 11:21 AM, Xiang Wang <wangxfdu@gmail.com> wrote:
>>>>>> In some of our drivers (e.g. UART) we may stop a running DMA
>>>>>> before it finishes. So we need to know how many bytes have
>>>>>> been transferred.
>
> []
>
>>>> Why I use a saved value (chan->bytes_residue)?
>>>> In current mmp pdma driver, a phy channel will be freed after the
>>>> transmission finishes (chan->phy is set to NULL). So we cannot get the
>>>> physical channel information after we call DMA_TERMINATE_ALL or DMA
>>>> finishes itself.
>>>
>>> I don't see any contradiction to workflow.
>>> So, If you call device_tx_status() when transfer is completed or
>>> aborted you will get 0 as a residue, which is correct.
>
>>>>>> @@ -637,7 +692,8 @@ static enum dma_status mmp_pdma_tx_status(struct dma_chan *dchan,
>>>>>>         unsigned long flags;
>>>>>>
>>>>>>         spin_lock_irqsave(&chan->desc_lock, flags);
>>>>>> -       ret = dma_cookie_status(dchan, cookie, txstate);
>>>>>> +       ret = chan->status;
>>>>>> +       dma_set_residue(txstate, chan->bytes_residue);
>>>>>>         spin_unlock_irqrestore(&chan->desc_lock, flags);
>>>>>
>>>>> Besides my patch which removes this spinlock I think the workflow
>>>>> should be something like
>>>>>
>>>>> status = dma_cookie_status()
>>>>> if status == DMA_SUCCESS or !txstate:
>>>>> return status
>>>>>
>>>>> dma_set_residue()
>>>>> return status
>>>>>
>>>>> Because there is no reason to return residue of successfully finished
>>>>> transfer. It should be 0.
>>>
>>>> There is one exception from my point of view. When we are receiving
>>>> data from peripheral devices, we usually start a DMA transaction with
>>>> a target length of 4K for example. When a timed-out event occurs in
>>>> peripheral device, it will notify DMA controller and DMA controller
>>>> will send out a End of Receive interrupt (Marvell specific?).
>>>
>>> Might be your hardware specifics, in our case we have got a timeout
>>> interrupt from uart controller.
>>>
>>>> In such situation, DMA status is also DMA_SUCCESS. But the residual
>>>> bytes is not 0 and the user must query it.
>>>
>>> Which sounds wrong approach.
>>>
>>> P.S. take a look at  drivers/tty/serial/8250/8250_dma.c
>
>> When peripheral device (e.g. UART) is using DMA controller, we should
>> have 2 solutions to deal with trailing bytes:
>
>> 1. Timeout interrupt from UART controller.
>> In this case, we usually pause DMA and read out data from DMA buffer
>> in uart irq handler.
>
> Hmm... When UART timeout occurs you have trailing bytes in the UART
> FIFO. Correct? What do you mean under "DMA buffer" ?
> I think you have to read bytes from UART FIFO.
I didn't described clearly. We have to deal with 2 kinds of data in
this situation: 1) The data that DMA has moved but not reached the
target length (So DMA interrupt is not sent out). This is what I mean
in "DMA buffer". When we receive Timeout Interrupt from UART
controller, we pause DMA and read out the data  2) The data in UART
FIFO.

>
>> 2. DMA controller handles trailing bytes for us.
>> This is the case I mentioned in my previous email. "When a timed-out
>> event occurs in peripheral device, it will notify DMA controller and
>> DMA controller will send out a End of Receive interrupt"
>> I think we should know how many residual bytes in this case even the
>> DMA status is DMA_SUCCESS.
>
> I'm still not convinced that you have implement such algorithm. Anyway,
> if I got it correctly you have something like "Receive FIFO Occupancy
> Register (FOR)" in UART. When you got timeout interrupt, you may get
> residue and value from FOR, sum them, program DMA to transfer the
> trailing bytes.
> What did I miss?
This case is another working mode of peripheral device (e.g. UART). If
we configure UART to work in this mode, the hardware(DMA controller
and UART controller) will deal with the trailing bytes for us.
The workflow is likely to be:
a. When timeout occurs in UART, it notifies DMA controller to move the
trailing bytes in UART FIFO. (software transparent)
b. After DMA finishes moving all bytes in UART FIFO, it will send out
an End Of Receive(EOR) interrupt.
So in this case, software sees an EOR interrupt from DMA controller
instead of an Timeout Interrupt from UART controller.
Actually Marvell PXA988 UART controller supports this mode and I've tested. :)
>
> --
> With Best Regards,
> Andy Shevchenko



--
Regards,
Xiang
