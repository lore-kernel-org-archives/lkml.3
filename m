Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbaFKP1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:27:48 -0400
Received: from imap.thunk.org ([74.207.234.97]:33574 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbaFKP1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:27:47 -0400
Date: Wed, 11 Jun 2014 11:27:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140611152742.GC27151@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <20140519211719.GA14563@logfs.org>
 <20140610161401.GC12104@thunk.org>
 <20140611001009.GA24626@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140611001009.GA24626@logfs.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 08:10:09PM -0400, Jörn Engel wrote:
> > I'm also concerned about how much overhead this might eat up.  I've
> > already had someone who was benchmarking a high performance storage
> > array where the increased interrupt latency before adding something
> > like this was something he noticed, and kvetched to me about.  The
> > pt_regs structure is going to be larger than the fast_pool (which is
> > only 16 bytes), and we're going to be doing it once every jiffy, which
> > means between 100 and 1000 times per second.
> 
> Would that someone be me? ;)
> 
> The reason I prefer doing it once every jiffy is that it doesn't
> change with interrupt load.  You get 10k interrupts per second?
> You pay once per jiffy.  100k interrupts per second?  Pay once per
> jiffy.

No, actually, it was someone who was worried about tail latency.  So
even if the average overhead was small, if once a jiffy we had a much
larger time spent in the interrupt handler, that's something that
would a big concern for someone who was worried about big storage
array performance.

I'd be happier if we used fast_mix() and mixed the registers into the
fast pool.  That's much lighter weight than using mix_pool_bytes(),
which involves many more memory accesses, MUCH higher probably of
cache line bouncing between CPU's, etc.

And there has been some proposals that I've been looking at to make
fast_mix to be use even less overhead, so if we use fast_mix, any
changes we make to improve that will help here too.

> What I like about my approach is quite the opposite.  The only thing
> an architecture maintainer can mess up is not saving registers on
> interrupts.  And if they mess that one up, they are very likely to
> notice.

What probably makes sense is to make the defaults use pt_regs, but
make it be overrideable by the architecture maintainer.  For example,
if the CPU has RDRAND or RDSEED, it probably doesn't make sense to
worry about mixing in the registers.  So we could make the default be
to mix in the entire set of registers, and if someone complains about
the overhead on their system, and they have a better way of harvesting
high quality entropy, then they can use that instead of trying to rely
on the registers.

It's unlikely that someone is going to be attaching a multi-million
dollar RAID array or a PCIe attached flash device on a MIPS or m68k
platform, after all.  :-)

							- Ted
