Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaJGPq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:46:58 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:57059 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaJGPq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:46:56 -0400
MIME-Version: 1.0
In-Reply-To: <87li71oucu.fsf@rustcorp.com.au>
References: <CAPM=9tyLrJ8VAdGCw_1guRS-ogCPE1Qp7faE_nrx_dAm2gvHLQ@mail.gmail.com>
	<87vc65p5a7.fsf@rustcorp.com.au>
	<CAPM=9tzw8jEv8yoLr7ktjO2DHCDzA+mURmJ-DXby_nsWUUNoyg@mail.gmail.com>
	<87li71oucu.fsf@rustcorp.com.au>
Date: Tue, 7 Oct 2014 17:46:56 +0200
X-Google-Sender-Auth: aTWUCoa-xnaCmBuELQ7Cp8eDFDc
Message-ID: <CAAts5mM_+Mj=vjWyJc8wZCvZehfK5dZxeA0Y9eowHwFDiWxo9Q@mail.gmail.com>
Subject: Re: BUG_ON in virtio-ring.c
From: Alexey Lapitsky <lex.public@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm hitting this bug with both ext4 and btrfs.

Here's an example of the backtrace:
https://gist.github.com/vzctl/e888a821333979120932

I tried raising this BUG only for direct ring and it solved the problem:

 -       BUG_ON(total_sg > vq->vring.num);
+       BUG_ON(total_sg > vq->vring.num && !vq->indirect);

Shall I submit the patch or is a more elaborate fix required?

--

Alexey



On Mon, May 27, 2013 at 7:38 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Dave Airlie <airlied@gmail.com> writes:
>>>> correct.
>>>>
>>>> If I have an indirect ring and I'm adding sgs to it and the host is
>>>> delayed (say I've got a thread consuming things from the vring and its
>>>> off doing something interesting),
>>>> I'd really like to get ENOSPC back from virtqueue_add. However if the
>>>> indirect addition fails due to free_sg being 0, we hit the BUG_ON
>>>> before we ever get to the ENOSPC check.
>>>
>>> It is correct for the moment: drivers can't assume indirect buffer
>>> support in the transport.
>>>
>>> BUT for a new device, we could say "this depends on indirect descriptor
>>> support", put the appropriate check in the device init, and then remove
>>> the BUG_ON().
>>
>> But if the transport has indirect buffer support, can it change its
>> mind at runtime?
>
> It's a layering violation.  The current rule is simple:
>
>         A driver should never submit a buffer which can't fit in the
>         ring.
>
> This has the nice property that OOM (ie. indirect buffer alloction
> fail) just slows things down, doesn't break things.
>
>> In this case we have vq->indirect set, but the device has run out of
>> free buffers,
>> but it isn't a case that in+out would overflow it if it had free
>> buffers since it would use
>> an indirect and succeed.
>
> OK, but when do you re-xmit?  What if the ring is empty, and you
> submitted a buffer that needs indirect?  You won't get interrupted
> again, because the device has consumed all the buffers.  You need to
> have your own timer or something equally hackish.
>
>> Getting -ENOSPC is definitely what should happen from what I can see,
>> not a BUG_ON,
>> I should get a BUG_ON only if the device reports no indirect support.
>
> I think we should return -ENOMEM if we can't indirect because of failed
> allocation and it doesn't fit in the ring, ie:
>
> This:
>         BUG_ON(total_sg > vq->vring.num);
>         BUG_ON(total_sg == 0);
>
>         if (vq->vq.num_free < total_sg) {
>                 pr_debug("Can't add buf len %i - avail = %i\n",
>                          total_sg, vq->vq.num_free);
>                 /* FIXME: for historical reasons, we force a notify here if
>                  * there are outgoing parts to the buffer.  Presumably the
>                  * host should service the ring ASAP. */
>                 if (out_sgs)
>                         vq->notify(&vq->vq);
>                 END_USE(vq);
>                 return -ENOSPC;
>         }
>
> Becomes (untested):
>
>         BUG_ON(total_sg == 0);
>
>         if (vq->vq.num_free < total_sg) {
>                 if (total_sg > vq->vring.num) {
>                         BUG_ON(!vq->indirect);
>                        /* Return -ENOMEM only if we have nothing else to do */
>                        if (vq->vq.num_free == vq->vring.num)
>                                return -ENOMEM;
>                 }
>                 pr_debug("Can't add buf len %i - avail = %i\n",
>                          total_sg, vq->vq.num_free);
>                 /* FIXME: for historical reasons, we force a notify here if
>                  * there are outgoing parts to the buffer.  Presumably the
>                  * host should service the ring ASAP. */
>                 if (out_sgs)
>                         vq->notify(&vq->vq);
>                 END_USE(vq);
>                 return -ENOSPC;
>         }
>
> Cheers,
> Rusty.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
