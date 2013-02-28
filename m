Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3B1HBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 02:01:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab3B1HBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 02:01:13 -0500
Date: Thu, 28 Feb 2013 09:01:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 08/16] virtio_ring: virtqueue_add_outbuf /
 virtqueue_add_inbuf.
Message-ID: <20130228070124.GD4743@redhat.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
 <1361260594-601-9-git-send-email-rusty@rustcorp.com.au>
 <20130221170902.GA27097@redhat.com>
 <87sj4pfc61.fsf@rustcorp.com.au>
 <20130225213504.GC18167@redhat.com>
 <87lia9c9er.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lia9c9er.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 03:38:44PM +1030, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > On Fri, Feb 22, 2013 at 10:32:46AM +1030, Rusty Russell wrote:
> >> "Michael S. Tsirkin" <mst@redhat.com> writes:
> >> > On Tue, Feb 19, 2013 at 06:26:26PM +1030, Rusty Russell wrote:
> >> >> These are specialized versions of virtqueue_add_buf(), which cover
> >> >> over 50% of cases and are far clearer.
> >> >> 
> >> >> In particular, the scatterlists passed to these functions don't have
> >> >> to be clean (ie. we ignore end markers).
> >> >> 
> >> >> FIXME: I'm not sure about the unclean sglist bit.  I had a more
> >> >> ambitious one which conditionally ignored end markers in the iterator,
> >> >> but it was ugly and I suspect this is just as fast.  Maybe we should
> >> >> just fix all the drivers?
> >> >> 
> >> >> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> >> >
> >> > Looking at code, it seems that most users really have a single sg, in
> >> > low memory. So how about simply passing void * instead of sg? Whoever
> >> > has multiple sgs can use the rich interface.
> >> 
> >> Good point, let's do that:
> >> 1) Make virtqueue_add_outbuf()/inbuf() take a void * and len.
> >> 2) Transfer users across to use that.
> >> 3) Make everyone else use clean scatterlists with virtqueue_add_sgs[].
> >> 4) Remove virtqueue_add_bufs().
> >> 
> >> > Long term we might optimize this unrolling some loops, I think
> >> > I saw this giving a small performance gain for -net.
> >> 
> >> I *think* we could make virtqueue_add() an inline and implement an
> >> virtqueue_add_outsg() wrapper and gcc will eliminate the loops for us.
> >> But not sure it's worth the text bloat...
> >> 
> >> Cheers,
> >> Rusty.
> >
> > inline is mostly useless nowdays...  We can make it a static function and
> > let gcc decide.
> 
> I know I've said before that inline is the register keyword of the '90s.
> But not at -O2 with i686-linux-gnu-gcc-4.7 (Ubuntu/Linaro
> 4.7.2-2ubuntu1) 4.7.2.
> 
> Without the inline keywords, it doesn't inline virtqueue_add, and thus
> sg_next_chained and sg_next_add aren't inlined:
> 
> $ for i in `seq 50`; do /usr/bin/time --format=%U ./vringh_test --indirect --eventidx --parallel; done 2>&1 | stats --trim-outliers
> Using CPUS 0 and 3
> Guest: notified 39102-39145(39105), pinged 39060-39063(39063)
> Host: notified 39060-39063(39063), pinged 19551-19581(19553)
> 3.050000-3.220000(3.136875)
> 
> With inline:
> 
> $ for i in `seq 50`; do /usr/bin/time --format=%U ./vringh_test --indirect --eventidx --parallel; done 2>&1 | stats --trim-outliers
> Using CPUS 0 and 3
> Guest: notified 39084-39148(39099), pinged 39062-39063(39062)
> Host: notified 39062-39063(39062), pinged 19542-19574(19550)
> 2.940000-3.140000(3.014583)
> 
> Cheers,
> Rusty.

Cool and did it actually unroll all loops?
