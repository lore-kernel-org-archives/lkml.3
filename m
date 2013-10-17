Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3JQW1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:27:51 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:40188 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3JQW1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:27:49 -0400
MIME-Version: 1.0
In-Reply-To: <20131017220156.GB10651@twins.programming.kicks-ass.net>
References: <20131015154104.GA227855@redhat.com>
	<20131016105755.GX10651@twins.programming.kicks-ass.net>
	<20131016205227.GJ7456@tassilo.jf.intel.com>
	<20131016210319.GI10651@twins.programming.kicks-ass.net>
	<20131016230712.GC26785@twins.programming.kicks-ass.net>
	<20131017094145.GE3364@laptop.programming.kicks-ass.net>
	<20131017160034.GO227855@redhat.com>
	<20131017160439.GP227855@redhat.com>
	<20131017163039.GR10651@twins.programming.kicks-ass.net>
	<CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
	<20131017220156.GB10651@twins.programming.kicks-ass.net>
Date: Thu, 17 Oct 2013 15:27:48 -0700
X-Google-Sender-Auth: FOqHy3J5UXW9lt_m6rmr7TIm_Xw
Message-ID: <CA+55aFyCCdwF78dM1=Km=0wqtoyosp-ChyoJuBb1DdBvmGe2vA@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        dave.hansen@linux.intel.com, Stephane Eranian <eranian@google.com>,
        jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 3:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Oh wait,.. now that Steven fixed being able to take faults from NMI
> context; we could actually try copy_from_user_inatomic(). Being able to
> directly access userspace would make the whole deal a lot easier again.

Careful! There is one magic piece of state that you need to
save-and-restore if you do this, namely %cr2. Taking a page fault
always writes to %cr2, and we must *not* corrupt it in the NMI
handler.

Also, right now, it looks like we call notify_page_fault() in the
atomic page fault case, and that would be deadly from within an NMI.

But if you move the "in_atomic()" check earlier in __do_page_fault(),
you can *try* to do something like this:

  unsigned long
  copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
  {
        unsigned long cr2, flags,ret;

        if (__range_not_ok(from, n, TASK_SIZE))
                return 0;
        local_irq_save(flags);
        cr2 = read_cr2();
        ret = __copy_from_user_inatomic(to, from, n);
        /* Reading cr2 is likely much faster than writing it - but go
check this.. */
        if (cr2 != read_cr2())
                write_cr2(cr2);
        local_irq_restore(flags);
        return n - ret;
  }

or something close to that. But you absolutely *have* to save/restore
%cr2 (the above tries to avoid writing it if it didn't change,
somebody should check the timings on that to see whether it makes
sense or not).

             Linus
