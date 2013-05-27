Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3E0FkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 01:40:04 -0400
Received: from ozlabs.org ([203.10.76.45]:34215 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab3E0FkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 01:40:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: BUG_ON in virtio-ring.c
In-Reply-To: <CAPM=9tzw8jEv8yoLr7ktjO2DHCDzA+mURmJ-DXby_nsWUUNoyg@mail.gmail.com>
References: <CAPM=9tyLrJ8VAdGCw_1guRS-ogCPE1Qp7faE_nrx_dAm2gvHLQ@mail.gmail.com> <87vc65p5a7.fsf@rustcorp.com.au> <CAPM=9tzw8jEv8yoLr7ktjO2DHCDzA+mURmJ-DXby_nsWUUNoyg@mail.gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 27 May 2013 15:08:25 +0930
Message-ID: <87li71oucu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied@gmail.com> writes:
>>> correct.
>>>
>>> If I have an indirect ring and I'm adding sgs to it and the host is
>>> delayed (say I've got a thread consuming things from the vring and its
>>> off doing something interesting),
>>> I'd really like to get ENOSPC back from virtqueue_add. However if the
>>> indirect addition fails due to free_sg being 0, we hit the BUG_ON
>>> before we ever get to the ENOSPC check.
>>
>> It is correct for the moment: drivers can't assume indirect buffer
>> support in the transport.
>>
>> BUT for a new device, we could say "this depends on indirect descriptor
>> support", put the appropriate check in the device init, and then remove
>> the BUG_ON().
>
> But if the transport has indirect buffer support, can it change its
> mind at runtime?

It's a layering violation.  The current rule is simple:

        A driver should never submit a buffer which can't fit in the
        ring.

This has the nice property that OOM (ie. indirect buffer alloction
fail) just slows things down, doesn't break things.

> In this case we have vq->indirect set, but the device has run out of
> free buffers,
> but it isn't a case that in+out would overflow it if it had free
> buffers since it would use
> an indirect and succeed.

OK, but when do you re-xmit?  What if the ring is empty, and you
submitted a buffer that needs indirect?  You won't get interrupted
again, because the device has consumed all the buffers.  You need to
have your own timer or something equally hackish.

> Getting -ENOSPC is definitely what should happen from what I can see,
> not a BUG_ON,
> I should get a BUG_ON only if the device reports no indirect support.

I think we should return -ENOMEM if we can't indirect because of failed
allocation and it doesn't fit in the ring, ie:

This:
	BUG_ON(total_sg > vq->vring.num);
	BUG_ON(total_sg == 0);

	if (vq->vq.num_free < total_sg) {
		pr_debug("Can't add buf len %i - avail = %i\n",
			 total_sg, vq->vq.num_free);
		/* FIXME: for historical reasons, we force a notify here if
		 * there are outgoing parts to the buffer.  Presumably the
		 * host should service the ring ASAP. */
		if (out_sgs)
			vq->notify(&vq->vq);
		END_USE(vq);
		return -ENOSPC;
	}

Becomes (untested):

	BUG_ON(total_sg == 0);

	if (vq->vq.num_free < total_sg) {
                if (total_sg > vq->vring.num) {
                        BUG_ON(!vq->indirect);
                       /* Return -ENOMEM only if we have nothing else to do */
                       if (vq->vq.num_free == vq->vring.num)
                               return -ENOMEM;
                }
		pr_debug("Can't add buf len %i - avail = %i\n",
			 total_sg, vq->vq.num_free);
		/* FIXME: for historical reasons, we force a notify here if
		 * there are outgoing parts to the buffer.  Presumably the
		 * host should service the ring ASAP. */
		if (out_sgs)
			vq->notify(&vq->vq);
		END_USE(vq);
		return -ENOSPC;
	}

Cheers,
Rusty.


