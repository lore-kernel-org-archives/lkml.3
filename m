Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbaKTAbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:31:18 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:59931 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaKTAbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:31:17 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411200059410.3909@nanos>
References: <20141118145234.GA7487@redhat.com> <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com> <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com> <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge> <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge> <alpine.DEB.2.11.1411200002330.3909@nanos>
 <CALCETrXyrk0VBbZy48nsUWnk82wFp6gpv_zw_F=3GKSDAR7T+Q@mail.gmail.com> <alpine.DEB.2.11.1411200059410.3909@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Nov 2014 16:30:55 -0800
Message-ID: <CALCETrXwjPKcCA6t=wjyKWZbREKFTF9E-n9eRa0C39R5O8Q0PQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 19, 2014 4:00 PM, "Thomas Gleixner" <tglx@linutronix.de> wrote:
>
> On Wed, 19 Nov 2014, Andy Lutomirski wrote:
> > On Wed, Nov 19, 2014 at 3:09 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > Sorry, I can't follow your argumentation here.
> > >
> > > pcpu_alloc()
> > >    ....
> > > area_found:
> > >    ....
> > >
> > >         /* clear the areas and return address relative to base address */
> > >         for_each_possible_cpu(cpu)
> > >                 memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
> > >
> > > How would that memset fail to establish the mapping, which is
> > > btw. already established via:
> > >
> > >      pcpu_populate_chunk()
> > >
> > > already before that memset?
> >
> > I think that this will map them into init_mm->pgd and
> > current->active_mm->pgd, but it won't necessarily map them into the
> > rest of the pgds.
>
> And why would mapping them into the kernel mapping, i.e. init_mm not
> be sufficient?

Because the kernel can run with any pgd loaded into cr3, and we rely
on vmalloc_fault to lazily populate pgds in all the non-init pgds as
needed.  But this only happens if the first TLB-missing reference to
the pgd in question with any given cr3 value happens from a safe
context.

This is why I think that the grsec kernels will crash on very large
memory systems.  They don't seem to get this right for the kernel
stack, and a page fault trying to access the stack is a big no-no.

--Andy

>
> We are talking about kernel memory and not some random user space
> mapping.
>
> Thanks,
>
>         tglx
