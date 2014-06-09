Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaFIIMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:12:07 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44527 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbaFIIME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:12:04 -0400
X-Sasl-enc: foq+wWgiG4z9xbNwvR5nizZcxVUBwM9ibBwOo63+dy6C 1402301522
Message-ID: <1402301519.2775.47.camel@perseus.fritz.box>
Subject: Re: [PATCH 2/2] fs: proc/stat: use usual seq_file ops rather than
 single_open
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Date: Mon, 09 Jun 2014 16:11:59 +0800
In-Reply-To: <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org>
References: <20140521122521.GB7471@osiris>
	 <20140521143229.GA32011@infradead.org> <20140528085841.GA4219@osiris>
	 <20140528090153.GC4219@osiris>
	 <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 15:37 -0700, Andrew Morton wrote:
> On Wed, 28 May 2014 11:01:53 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > Now, /proc/stat uses single_open() for showing information. This means
> > the all data will be gathered and buffered once to a (big) buf.
> > 
> > Now, /proc/stat shows stats per cpu and stats per IRQs. To get information
> > in once-shot, it allocates a big buffer (until KMALLOC_MAX_SIZE).
> > 
> > Eric Dumazet reported that the bufsize calculation doesn't take
> > the numner of IRQ into account and the information cannot be
> > got in one-shot. (By this, seq_read() will allocate buffer again
> > and read the whole data gain...)
> > 
> > This patch changes /proc/stat to use seq_open() rather than single_open()
> > and provides  ->start(), ->next(), ->stop(), ->show().
> > 
> > By this, /proc/stat will not need to take care of size of buffer.
> > 
> > [heiko.carstens@de.ibm.com]: This is the forward port of a patch
> > from KAMEZAWA Hiroyuki (https://lkml.org/lkml/2012/1/23/41).
> > I added a couple of simple changes like e.g. that the cpu iterator
> > handles 32 cpus in a batch to avoid lots of iterations.
> > 
> > With this patch it should not happen anymore that reading /proc/stat
> > fails because of a failing high order memory allocation.
> 
> So this deletes the problematic allocation which [1/2] kind-of fixed,
> yes?
> 
> I agree with Ian - there's a hotplugging race.  And [1/2] doesn't do
> anything to address the worst-case allocation size.  So I think we may
> as well do this all in a single patch.
> 
> Without having looked closely at the code I worry a bit about the
> effects.  /proc/pid/stat is a complex thing and its contents will vary
> in strange ways as the things it is reporting on undergo concurrent
> changes.  This patch will presumably replace one set of bizarre
> behaviour with a new set of bizarre behaviour and there may be
> unforseen consequences to established userspace.
> 
> So we're going to need a lot of testing and a lot of testing time to
> identify issues and weed them out.
> 
> So..  can we take this up for 3.16-rc1?  See if we can get some careful
> review done then and test it for a couple of months?
> 
> Meanwhile, the changelog looks a bit hastily thrown together - some
> smoothing would be nice, and perhaps some work spent identifying
> possible behavioural changes.  Timing changes, locking canges, effects
> of concurrent fork/exit activity etc?
> 

Umm ... I didn't expect this to turn into such a rant, apologies in
advance.
 
Certainly using the usual seq_file ops is desirable in the long run and
that change should be worked on by those that maintain this area of code
but, as Andrew says, it's too large a change to put in without
considerable testing.

Now the problem has been exposed by a change which sets the number of
CPUs to the maximum number the architecture (s390) can have, 256, when
no value has been specified and the kernel default configuration is used
rather than 32 when hotplug is not set or 64 when it is.

The allocation problem doesn't occur when the number of CPUs is set to
the previous default of 64, even for low end systems with 2 CPUs and 2G
RAM (like the one for which this problem was reported), but becomes a
problem when the number of CPUs is set to 256 on these systems.

Also, I believe the s390 maintainers are committed to keeping the the
default configured number of CPUs at 256.

So the actual problem is the heuristic used to calculate a initial
buffer size not accounting for a configured number of CPUs much greater
than the hardware can sensibly accommodate.

If we assume that the current implementation functions correctly when
the buffer overflows, ie. doubles the allocation size and restarts, then
an interim solution to the problem comes down to not much more than what
is in patch 1 above.

Looking at the current heuristic allocation sizes, without taking the
allocation for irqs into account we get:
cpus: 32      size: 5k
cpus: 64      size: 9k
cpus: 128     size: 17k
cpus: 256     size: 33k

I don't know how many irqs need to be accounted for or if that will make
a difference to my comments below. Someone else will need to comment on
that.

We know (from the order 4 allocation fail) that with 256 CPUs kmalloc()
is looking for a 64k slab chunk IIUC and on low memory systems will
frequently fail to get it.

And for the previous default of 64 CPUs kmalloc() would be looking for a
16k slab which we have no evidence it doesn't always get even on low end
systems.

So why even use a heuristic calculation, since it can be quite wasteful
anyway or, as in this case badly wrong, why not just allocate 8k or 16k
in the open every time knowing that if the actual number of CPUs is
large we can reasonably expect the system RAM to be correspondingly
large which should avoid allocation failures upon a read retry.

Comments please?

Ian

