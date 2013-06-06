Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab3FFDJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 23:09:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57369 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3FFDJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 23:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VfeVZRzyW0jKH=oVPPQv3=tmg214D9=tBs0j3_==20UZg@mail.gmail.com>
References: <1369988485-23176-1-git-send-email-wangxfdu@gmail.com>
	<CAHp75Veb+FK=5u_HBUp+KNT4__GjbSg1T-kq1tGebDq2pEJOBA@mail.gmail.com>
	<CACDNBm3WJ_U22uqKuVssV4ntATTHnz_8=pq9_qa33S+eKreKSA@mail.gmail.com>
	<CAHp75VfeVZRzyW0jKH=oVPPQv3=tmg214D9=tBs0j3_==20UZg@mail.gmail.com>
Date: Thu, 6 Jun 2013 11:09:17 +0800
Message-ID: <CACDNBm1mjtHcE+Mm_y55xq2VW_8DVq+-1537M_FnqocWRhafsg@mail.gmail.com>
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

2013/6/3 Andy Shevchenko <andy.shevchenko@gmail.com>:
> On Mon, Jun 3, 2013 at 6:22 AM, Xiang Wang <wangxfdu@gmail.com> wrote:
>> 2013/5/31 Andy Shevchenko <andy.shevchenko@gmail.com>:
>>> On Fri, May 31, 2013 at 11:21 AM, Xiang Wang <wangxfdu@gmail.com> wrote:
>>>> In some of our drivers (e.g. UART) we may stop a running DMA
>>>> before it finishes. So we need to know how many bytes have
>>>> been transferred.
>>>
>>> Couple of comments below.
>>>
>>>> --- a/drivers/dma/mmp_pdma.c
>>>> +++ b/drivers/dma/mmp_pdma.c
>>>
>>>> @@ -589,7 +638,13 @@ static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
>>>>                 mmp_pdma_free_desc_list(chan, &chan->chain_pending);
>>>>                 mmp_pdma_free_desc_list(chan, &chan->chain_running);
>>>>                 spin_unlock_irqrestore(&chan->desc_lock, flags);
>>>> -               chan->idle = true;
>>>> +               chan->status = DMA_SUCCESS;
>>>> +               chan->bytes_residue = 0;
>>>> +               break;
>>>> +       case DMA_PAUSE:
>>>> +               disable_chan(chan->phy);
>>>> +               chan->status = DMA_PAUSED;
>>>> +               chan->bytes_residue = mmp_pdma_get_bytes_residue(chan);
>>>
>>> Does it mean user has to do DMA_PAUSE first to get more or less
>>> accurate residue?
>>> Logically that sound correct, but in general we may allow user to get
>>> approximate residue value of on going transfer.
>
>> Your comment makes sense. But if the user is allowed to query the
>> residue value in real-time, we cannot just return a saved value to
>> him.
>
> Right.
>
>> Why I use a saved value (chan->bytes_residue)?
>> In current mmp pdma driver, a phy channel will be freed after the
>> transmission finishes (chan->phy is set to NULL). So we cannot get the
>> physical channel information after we call DMA_TERMINATE_ALL or DMA
>> finishes itself.
>
> I don't see any contradiction to workflow.
> So, If you call device_tx_status() when transfer is completed or
> aborted you will get 0 as a residue, which is correct.
>
>> That is to say, when the use queries the channel information at these
>> points, the chan->phy is usually NULL.
>
>>>> @@ -637,7 +692,8 @@ static enum dma_status mmp_pdma_tx_status(struct dma_chan *dchan,
>>>>         unsigned long flags;
>>>>
>>>>         spin_lock_irqsave(&chan->desc_lock, flags);
>>>> -       ret = dma_cookie_status(dchan, cookie, txstate);
>>>> +       ret = chan->status;
>>>> +       dma_set_residue(txstate, chan->bytes_residue);
>>>>         spin_unlock_irqrestore(&chan->desc_lock, flags);
>>>
>>> Besides my patch which removes this spinlock I think the workflow
>>> should be something like
>>>
>>> status = dma_cookie_status()
>>> if status == DMA_SUCCESS or !txstate:
>>> return status
>>>
>>> dma_set_residue()
>>> return status
>>>
>>> Because there is no reason to return residue of successfully finished
>>> transfer. It should be 0.
>
>> There is one exception from my point of view. When we are receiving
>> data from peripheral devices, we usually start a DMA transaction with
>> a target length of 4K for example. When a timed-out event occurs in
>> peripheral device, it will notify DMA controller and DMA controller
>> will send out a End of Receive interrupt (Marvell specific?).
>
> Might be your hardware specifics, in our case we have got a timeout
> interrupt from uart controller.
>
>> In such situation, DMA status is also DMA_SUCCESS. But the residual
>> bytes is not 0 and the user must query it.
>
> Which sounds wrong approach.
>
> P.S. take a look at  drivers/tty/serial/8250/8250_dma.c
Hi, Andy
When peripheral device (e.g. UART) is using DMA controller, we should
have 2 solutions to deal with trailing bytes:
1. Timeout interrupt from UART controller.
In this case, we usually pause DMA and read out data from DMA buffer
in uart irq handler.
2. DMA controller handles trailing bytes for us.
This is the case I mentioned in my previous email. "When a timed-out
event occurs in peripheral device, it will notify DMA controller and
DMA controller will send out a End of Receive interrupt"
I think we should know how many residual bytes in this case even the
DMA status is DMA_SUCCESS.

Thanks!
>
> --
> With Best Regards,
> Andy Shevchenko



--
Regards,
Xiang
