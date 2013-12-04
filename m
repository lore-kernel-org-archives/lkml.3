Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3LDLa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:30:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037Ab3LDLaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:30:24 -0500
Date: Wed, 4 Dec 2013 12:30:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
	page directly
Message-ID: <20131204113024.GB26552@redhat.com>
References: <20131203184909.GA17571@redhat.com> <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com> <529E2F0C.8070405@zytor.com> <20131203200147.GB19083@redhat.com> <529E3D4C.9070403@zytor.com> <20131203203826.GA24812@redhat.com> <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com> <20131203205400.GA25735@redhat.com> <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com> <529E6DA3.5060705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529E6DA3.5060705@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, H. Peter Anvin wrote:
>
> On 12/03/2013 02:01 PM, Linus Torvalds wrote:
> > On Tue, Dec 3, 2013 at 12:54 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >>
> >> So do you think the patch I sent is wrong? Why?
> >
> > I think the TLB shootdown should guarantee that it's ok on other
> > CPU's, since that's basically what we do on mmap.
> >
>
> I think that is true for other CPUs; however, there are definitely CPUs
> out there (which Linux supports) for which you have to synchronize the I
> and D sides "manually" after writing code through memory, at least
> through the CPU.  That is at least one reason why MIPS has a
> cacheflush() system call, for example.

OK, probably (with or without the patch I sent) uprobe_write_opcode() needs
flush_icache_page(). Altough it is nop on x86 and powerpc (architectures
we currently support).

But I still can't understand your "There is no architecture-independent
way to make code globally visible". If this is true, then how, say,
do_swap_page() can work?

So I still think the patch should work (I'll add flush_icache_page).

> > But looking closer at this, I think I see why the old code did what it
> > did. I think it's breaking shared mmap pages on purpose rather than
> > dirtying them. Which is probably the right thing to do.
>
> In other words, treating them as MAP_PRIVATE?  Wouldn't it be better to
> throw an error if we can't honor the semantics of the mapping that we
> are using?

Yes, uprobes never writes to MAP_SHARED vmas.

Oleg.

