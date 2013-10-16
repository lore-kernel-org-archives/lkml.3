Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762068Ab3JPUXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:23:40 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:46743 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761429Ab3JPUXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:23:38 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <CAD=FV=V4OPOjs=4cvXOomt1UnzUdw5VApkNAX2ERKZ46DC6_gg@mail.gmail.com>
References: <1381876762-10892-1-git-send-email-dianders@chromium.org>
	<1381876762-10892-3-git-send-email-dianders@chromium.org>
	<525E611A.6070708@imgtec.com>
	<CAD=FV=V4OPOjs=4cvXOomt1UnzUdw5VApkNAX2ERKZ46DC6_gg@mail.gmail.com>
Date: Wed, 16 Oct 2013 21:23:36 +0100
X-Google-Sender-Auth: 2cr8ometsPogoO6p5Wd7fbVCkjM
Message-ID: <CAAG0J98c6eA_c2McSvFcQUMUfPy-DgdHi7Te1tZqpT8XjjMQvw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: dw_mmc: Protect read-modify-write of INTMASK
 with a lock
From: James Hogan <james.hogan@imgtec.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Bing Zhao <bzhao@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 16 October 2013 17:43, Doug Anderson <dianders@chromium.org> wrote:
> On Wed, Oct 16, 2013 at 2:49 AM, James Hogan <james.hogan@imgtec.com> wrote:
>>> We can't just use the standard host->lock since that lock is not irq
>>> safe and mmc_signal_sdio_irq() (called from interrupt context) calls
>>> dw_mci_enable_sdio_irq().  Add a new irq-safe lock to protect INTMASK.
>>>
>>> An alternate solution to this is to punt mmc_signal_sdio_irq() to the
>>> tasklet and then protect INTMASK modifications by the standard host
>>> lock.  This seemed like a bit more of a high-latency change.
>>
>> A probably lighter-weight alternative to that alternative is to just
>> make the existing lock irq safe. Has this been considered?
>>
>> I'm not entirely convinced it's worth having a separate lock rather than
>> changing the existing one, but the patch still appears to be correct, so:
>> Reviewed-by: James Hogan <james.hogan@imgtec.com>
>
> I did look at that alternate solution and rejected it, but am happy to
> send that up if people think it's better.  Here's why I rejected it:
>
> 1. It looks like someone has gone through quite a bit of work to _not_
> grab the existing lock in the IRQ handler.  The IRQ handler always
> pushes all real work over to the tasklet.  I can only assume that they
> did this for some good reason and I'd hate to switch it without
> knowing for sure why.
>
> 2. We might have performance problems if we blindly changed the
> existing code to an IRQ-safe spinlock.  We hold the existing
> "host->lock" spinlock for the entire duration of
> dw_mci_tasklet_func().  That's a pretty intense chunk of code, full of
> nested loops (some with 500ms timeouts!), mdelay(20) calls to handle
> some errors, etc.  I say "might" because I think that the expected
> case is that code runs pretty quickly.  I ran some brief tests on one
> system and saw a worst case time of 170us and an common case time of
> ~10us.  Are we OK with having interrupts disabled for that long?  Are
> we OK with having the dw_mci interrupt handler potentially spin on a
> spinlock for that long?
>

Fair enough, I'm convinced now. That code did look pretty heavy when I
looked at it too.

>
> I don't think it would be terrible to look at reworking the way that
> dw_mmc handles interrupts, but that seems pretty major.

Yeh, I suppose at least the potentially large delays are all for
exceptional cases, so it's not a critical problem.

> BTW: is the cost of an extra lock actually that high?

I don't know tbh. In this case the spinlock usage doesn't appear to
actually overlap.

> ...or are you talking the cost in terms of code complexity?

In this case it'd only be a space and code complexity thing I think. I
suppose in some cases the benefit of finer-grained locking is probably
pretty marginal, but there's a good case for it here. It might be
worth renaming the lock to irq_lock or something like that so it's
clear it doesn't have to protect only for INTMASK in the future - up
to you.

Cheers
James
