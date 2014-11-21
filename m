Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaKUXES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 18:04:18 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:50130 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaKUXEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 18:04:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyzg=vJqRwh2CsK8WD-E5nRPjdiasMaTBx6qygQhDrGLA@mail.gmail.com>
References: <alpine.DEB.2.11.1411202204030.3950@nanos> <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
 <20141120233920.GC25393@htj.dyndns.org> <CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
 <20141121162742.GB15461@htj.dyndns.org> <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
 <CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
 <20141121170805.GD30603@home.goodmis.org> <CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
 <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
 <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
 <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
 <alpine.DEB.2.11.1411212049220.6439@nanos> <CA+55aFzvgxAMpP7kr9qrxyo82vSucQ5G+VByOgsgoyq6y5ExOA@mail.gmail.com>
 <alpine.DEB.2.11.1411212110320.6439@nanos> <CA+55aFyt6q7Ed-SS9GeN8jeUZu6yNM14EGyH_8rn8AF2Vv37hg@mail.gmail.com>
 <alpine.DEB.2.11.1411212207150.6439@nanos> <CA+55aFyzg=vJqRwh2CsK8WD-E5nRPjdiasMaTBx6qygQhDrGLA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 15:03:54 -0800
Message-ID: <CALCETrVGSQ6CTXAFkPTueb0FMJ8oBd2_R4zB5X9juDoun_kJvQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 2:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 21, 2014 at 1:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> I'm fine with that. I just think it's not horrid enough, but that can
>> be fixed easily :)
>
> Oh, I think it's plenty horrid.
>
> Anyway, here's an actual patch. As usual, it has seen absolutely no
> actual testing, but I did try to make sure it compiles and seems to do
> the right thing on:
>  - x86-32 no-PAE
>  - x86-32 no-PAE with PARAVIRT
>  - x86-32 PAE
>  - x86-64
>
> also, I just removed the noise that is "vmalloc_sync_all()", since
> it's just all garbage and nothing actually uses it. Yeah, it's used by
> "register_die_notifier()", which makes no sense what-so-ever.
> Whatever. It's gone.
>
> Can somebody actually *test* this? In particular, in any kind of real
> paravirt environment? Or, any comments even without testing?
>
> I *really* am not proud of the mess wrt the whole
>
>   #ifdef CONFIG_PARAVIRT
>   #ifdef CONFIG_X86_32
>     ...
>
> but I think that from a long-term perspective, we're actually better
> off with this kind of really ugly - but very explcit - hack that very
> clearly shows what is going on.
>
> The old code that actually "walked" the page tables was more
> "portable", but was somewhat misleading about what was actually going
> on.

At the risk of going deeper down the rabbit hole, I grepped for
pgd_list.  I found:

__set_pmd_pte in pageattr.c.  It appears to be completely incorrect.
Unless I've misunderstood, other than the very first line, it will
either do nothing at all or crash when it falls off the end of the
page tables that it's pointlessly trying to update.

sync_global_pgds: OK, I guess -- this is for hot-add of memory, right?
 But if we teach the context switch code to check that the kernel
stack is okay, that can be removed, I think.  (We absolutely MUST keep
the static per-cpu stuff populated everywhere before running user
code, but that's never in hot-added memory.)

xen_mm_pin_all and xen_mm_unpin_all: I have no clue.  I wonder how
that works with SHARED_KERNEL_PMD.

Anyone want to attack these?  It would be kind of nice to remove
pgd_list entirely.  (I realize that doing so precludes the use of
bloody enormous 512GB kernel pages, but any attempt to use *those* is
so completely screwed without a major reworking of all of this (or
perhaps stop_machine) that keeping pgd_list around just for that is
probably a mistake.)

--Andy
