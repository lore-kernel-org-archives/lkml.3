Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbaE2Ld4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:33:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaE2Ldz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:33:55 -0400
Date: Thu, 29 May 2014 14:33:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] virtio_ring: unify direct/indirect code paths.
Message-ID: <20140529113317.GE30210@redhat.com>
References: <87oayh6s3s.fsf@rustcorp.com.au>
 <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au>
 <1401348405-18614-5-git-send-email-rusty@rustcorp.com.au>
 <20140529075256.GZ30445@twins.programming.kicks-ass.net>
 <87iooo7skp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iooo7skp.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 08:35:58PM +0930, Rusty Russell wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> > On Thu, May 29, 2014 at 04:56:45PM +0930, Rusty Russell wrote:
> >> Before:
> >> 	gcc 4.8.2: virtio_blk: stack used = 392
> >> 	gcc 4.6.4: virtio_blk: stack used = 480
> >> 
> >> After:
> >> 	gcc 4.8.2: virtio_blk: stack used = 408
> >> 	gcc 4.6.4: virtio_blk: stack used = 432
> >
> > Is it worth it to make the good compiler worse? People are going to use
> > the newer GCC more as time goes on anyhow.
> 
> No, but it's only 16 bytes of stack loss for a simplicity win:
> 
>  virtio_ring.c |  120 +++++++++++++++++++++-------------------------------------
>  1 file changed, 45 insertions(+), 75 deletions(-)
> 
> Cheers,
> Rusty.

I'm concerned that we are doing an extra descriptor walk now though.
And desc == &vq.desc at the end is kind of ugly too.

How about
		if (indirect)
                        vq->vring.desc[i].next = i + 1;
		else
                        i = vq->vring.desc[i].next;

or something like this?

