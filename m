Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbaKSXuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:50:40 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64000 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbaKSXuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:50:39 -0500
Date: Thu, 20 Nov 2014 00:50:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119235033.GE11386@lerouge>
References: <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge>
 <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge>
 <alpine.DEB.2.11.1411200002330.3909@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411200002330.3909@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 12:09:22AM +0100, Thomas Gleixner wrote:
> On Wed, 19 Nov 2014, Frederic Weisbecker wrote:
> 
> > On Wed, Nov 19, 2014 at 10:56:26PM +0100, Thomas Gleixner wrote:
> > > On Wed, 19 Nov 2014, Frederic Weisbecker wrote:
> > > > I got a report lately involving context tracking. Not sure if it's
> > > > the same here but the issue was that context tracking uses per cpu data
> > > > and per cpu allocation use vmalloc and vmalloc'ed area can fault due to
> > > > lazy paging.
> > > 
> > > This is complete nonsense. pcpu allocations are populated right
> > > away. Otherwise no single line of kernel code which uses dynamically
> > > allocated per cpu storage would be safe.
> > 
> > Note this isn't faulting because part of the allocation is
> > swapped. No it's all reserved in the physical memory, but it's a
> > lazy allocation.  Part of it isn't yet addressed in the
> > P[UGM?]D. That's what vmalloc_fault() is for.
> 
> Sorry, I can't follow your argumentation here.
> 
> pcpu_alloc()
>    ....
> area_found:
>    ....
> 
>         /* clear the areas and return address relative to base address */
>         for_each_possible_cpu(cpu)
>                 memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
> 
> How would that memset fail to establish the mapping, which is
> btw. already established via:
> 
>      pcpu_populate_chunk()
>   
> already before that memset?   	    
>  
> Are we talking about different per cpu allocators here or am I missing
> something completely non obvious?

That's the same allocator yeah. So if the whole memory is dereferenced,
faults shouldn't happen indeed.

Maybe that was a bug a few years ago but not anymore.

I'm surprised because I got a report from Dave that very much suggested
a vmalloc fault. See the discussion "Deadlock in vtime_account_user() vs itself across a page fault":

http://marc.info/?l=linux-kernel&m=141047612120263&w=2

Is it possible that, somehow, some part isn't zeroed by pcpu_alloc()?
After all it's allocated with vzalloc() so that part could be skipped. The memset(0)
is passed the whole size though so it looks like the whole is dereferenced.

(cc'ing Tejun just in case).

Now if faults on percpu memory don't happen anymore, perhaps we are accessing some
other vmalloc'ed area. In the above report from Dave, the fault happened somewhere
in account_user_time().

> 
> Thanks,
> 
> 	tglx
