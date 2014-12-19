Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaLSDtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 22:49:43 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:40386 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaLSDtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 22:49:42 -0500
MIME-Version: 1.0
In-Reply-To: <20141219024549.GB1671@redhat.com>
References: <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
	<CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
	<20141215055707.GA26225@redhat.com>
	<CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
	<1418918059.17358.6@mail.thefacebook.com>
	<20141218161230.GA6042@redhat.com>
	<20141219024549.GB1671@redhat.com>
Date: Thu, 18 Dec 2014 19:49:41 -0800
X-Google-Sender-Auth: h9IeHIbsbNwEZ3ASSBMsbZb9mvU
Message-ID: <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 6:45 PM, Dave Jones <davej@redhat.com> wrote:
>
> Example of the spew-o-rama below.

Hmm. Not only does it apparently stay up for you now, the traces seem
to be improving in quality.

There's a decided pattern of "copy_page_range()" and "zap_page_range()" here.

Now, what's *also* intriguing is how many "_raw_spin_lock_nested"
things there are in there. Which makes me suspect that you are
actually hitting some really nasty spinlock contention, and that your
22s lockups could be due to lock hold times going exponential.

So I don't think that it's the copy_page_range() itself that is
necessarily all that horribly expensive (although it's certainly not a
lightweight function), but the fact that you get contention on some
lock inside that loop, and when you have every single CPU hammering on
it things just go to hell in a handbasket.

And when spinlocks start getting  contention, *nested* spinlocks
really really hurt. And you've got all the spinlock debugging on etc,
don't you? Which just makes the locks really expensive, and much much
easier to start becoming contended (and there's *another* level of
nesting, because I think the lockdep stuff has its own locking
inside). So you have three levels of spinlock nesting, and the outer
one will be completely hammered.

So I think the locks you have are from copy_pte_range:

        dst_pte = pte_alloc_map_lock(dst_mm, dst_pmd, addr, &dst_ptl);
        if (!dst_pte)
                return -ENOMEM;
        src_pte = pte_offset_map(src_pmd, addr);
        src_ptl = pte_lockptr(src_mm, src_pmd);
        spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);

and we do have some mitigation in place for horrible horrible
contention (try to release every few entries, but with all CPU's
hammering on these locks, and things being slow due to all the
debugging, I think we may finally be hitting the right place here.

Also, you do have this:

  sched: RT throttling activated

so there's something going on with RT scheduling too. I'd consider all
the softlockups after that point suspect - the softlockup thread has
presumably used so much CPU spewing out the debug messages that things
aren't really working any more RT-wise.

Lookie here (the "soft lockup" grep is to skip all the cross-CPU
traces from other CPU's that weren't necessarily the problem case):

  [torvalds@i7 linux]$ grep -5 "soft lockup" ~/0.txt | grep RIP
   RIP: 0010:   lock_acquire+0xb4/0x120
   RIP: 0010:   lock_acquire+0xb4/0x120
   RIP: 0010:   generic_exec_single+0xee/0x1b0
   RIP: 0010:   lock_acquire+0xb4/0x120
   RIP: 0010:   lock_acquire+0xb4/0x120
   RIP: 0010:   lock_acquire+0xb4/0x120
   RIP: 0010:   lock_acquire+0xb4/0x120
   RIP: 0010:   lock_acquire+0xb4/0x120
   RIP: 0010:   lock_acquire+0xb4/0x120
   RIP: 0010:   shmem_write_end+0x65/0xf0
   RIP: 0010:   _raw_spin_unlock_irqrestore+0x38/0x60
   RIP: 0010:   copy_user_enhanced_fast_string+0x5/0x10
   RIP: 0010:   copy_user_enhanced_fast_string+0x5/0x10
   RIP: 0010:   __slab_alloc+0x52f/0x58f
   RIP: 0010:   map_id_up+0x9/0x80
   RIP: 0010:   cpuidle_enter_state+0x79/0x190
   RIP: 0010:   unmap_single_vma+0x7d9/0x900
   RIP: 0010:   cpuidle_enter_state+0x79/0x190

and notice the pattern? All those early RIP cases are the page table
locks for copy_page_range and that one TLB flush for zap_page_range..

So your printouts are finally starting to make sense. But I'm also
starting to suspect strongly that the problem is that with all your
lock debugging and other overheads (does this still have
DEBUG_PAGEALLOC?) you really are getting into a "real" softlockup
because things are scaling so horribly badly.

If you now disable spinlock debugging and lockdep, hopefully that page
table lock now doesn't always get hung up on the lockdep locking, so
it starts scaling much better, and maybe you'd not see this...

                    Linus
