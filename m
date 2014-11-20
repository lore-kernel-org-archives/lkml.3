Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaKTMXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:23:44 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:35259 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaKTMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:23:43 -0500
Date: Thu, 20 Nov 2014 07:23:39 -0500
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141120122339.GA14877@htj.dyndns.org>
References: <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge>
 <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge>
 <alpine.DEB.2.11.1411200002330.3909@nanos>
 <20141119235033.GE11386@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119235033.GE11386@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 20, 2014 at 12:50:36AM +0100, Frederic Weisbecker wrote:
> > Are we talking about different per cpu allocators here or am I missing
> > something completely non obvious?
> 
> That's the same allocator yeah. So if the whole memory is dereferenced,
> faults shouldn't happen indeed.
> 
> Maybe that was a bug a few years ago but not anymore.

It has been always like that tho.  Percpu memory given out is always
populated and cleared.

> Is it possible that, somehow, some part isn't zeroed by pcpu_alloc()?
> After all it's allocated with vzalloc() so that part could be skipped. The memset(0)

The vzalloc call is for the internal allocation bitmap not the actual
percpu memory area.  The actual address areas for percpu memory are
obtained using pcpu_get_vm_areas() call and later get populated using
map_kernel_range_noflush() (flush is performed after mapping is
complete).

Trying to remember what happens with vmalloc_fault().  Ah okay, so
when a new PUD gets created for vmalloc area, we don't go through all
PGDs and update them.  The PGD entries get faulted in lazily.  Percpu
memory allocator clearing or not clearing the allocated area doesn't
have anything to do with it.  The memory area is always fully
populated in the kernel page table.  It's just that the population
happened while a different PGD was active and this PGD hasn't been
populated with the new PUD yet.

So, yeap, vmalloc_fault() can always happen when accessing vmalloc
areas and the only way to avoid that would be removing lazy PGD
population - going through all PGDs and populating new PUDs
immediately.

Thanks.

-- 
tejun
