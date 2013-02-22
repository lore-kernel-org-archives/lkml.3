Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab3BYVaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 16:30:21 -0500
Received: from ozlabs.org ([203.10.76.45]:37510 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab3BYVaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 16:30:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 08/16] virtio_ring: virtqueue_add_outbuf / virtqueue_add_inbuf.
In-Reply-To: <20130221170902.GA27097@redhat.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-9-git-send-email-rusty@rustcorp.com.au> <20130221170902.GA27097@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 22 Feb 2013 10:32:46 +1030
Message-ID: <87sj4pfc61.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Tue, Feb 19, 2013 at 06:26:26PM +1030, Rusty Russell wrote:
>> These are specialized versions of virtqueue_add_buf(), which cover
>> over 50% of cases and are far clearer.
>> 
>> In particular, the scatterlists passed to these functions don't have
>> to be clean (ie. we ignore end markers).
>> 
>> FIXME: I'm not sure about the unclean sglist bit.  I had a more
>> ambitious one which conditionally ignored end markers in the iterator,
>> but it was ugly and I suspect this is just as fast.  Maybe we should
>> just fix all the drivers?
>> 
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Looking at code, it seems that most users really have a single sg, in
> low memory. So how about simply passing void * instead of sg? Whoever
> has multiple sgs can use the rich interface.

Good point, let's do that:
1) Make virtqueue_add_outbuf()/inbuf() take a void * and len.
2) Transfer users across to use that.
3) Make everyone else use clean scatterlists with virtqueue_add_sgs[].
4) Remove virtqueue_add_bufs().

> Long term we might optimize this unrolling some loops, I think
> I saw this giving a small performance gain for -net.

I *think* we could make virtqueue_add() an inline and implement an
virtqueue_add_outsg() wrapper and gcc will eliminate the loops for us.
But not sure it's worth the text bloat...

Cheers,
Rusty.
