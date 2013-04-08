Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965264Ab3DHOu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:50:26 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55841 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965236Ab3DHOuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:50:20 -0400
MIME-Version: 1.0
In-Reply-To: <1365431470.2733.16.camel@fedora>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	<1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	<20130404152808.GB15261@ab42.lan>
	<515E54BD.2090300@synopsys.com>
	<51602459.3040105@synopsys.com>
	<CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
	<51624591.4010303@synopsys.com>
	<CA+55aFyFWjpSVQM6M266tKrG_ZXJzZ-nYejpmXYQXbrr42mGPQ@mail.gmail.com>
	<1365428274.2609.160.camel@laptop>
	<1365431470.2733.16.camel@fedora>
Date: Mon, 8 Apr 2013 07:50:19 -0700
X-Google-Sender-Auth: uTmlnV_LID7vUkHGIs8AY-P2oqw
Message-ID: <CA+55aFx88-t_pm5hbxbrrhqm3_=+JQussO=zD1kT+05UVCAFCA@mail.gmail.com>
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for !PREEMPT_COUNT
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 7:31 AM, Steven Rostedt <srostedt@redhat.com> wrote:
>
> It requires gcc reordering the code to where a preempt can happen inside
> preempt_disable. And also put in a position where the preempt_disable
> code it gets added matters.
>
> Then if gcc does this, we need a page fault to occur with a get_user()
> operation, which in practice seldom happens as most get user operations
> are done on freshly modified memory.
>
> And then, it would require the page fault to cause a schedule. This is
> the most likely of the things needed to occur, but itself is not a
> problem.
>
> Then, the schedule would have to cause the data that is being protect by
> the preempt_disable() to be corrupted. Either by scheduling in another
> process that monkeys with the data. Or if it protects per-cpu data,
> scheduling to another CPU (for the SMP case only).
>
> If any of the above does not occur, then you wont see a bug.

Right. The gcc reordering is also hard to actually notice if it does
happen, so even testing the fix for this looks nontrivial.

Something like the appended (whitespace-damaged and TOTALLY UNTESTED)
might be sufficient, but..

Comments?

                  Linus

---
    diff --git a/include/linux/preempt.h b/include/linux/preempt.h
    index 5a710b9c578e..465df1c13386 100644
    --- a/include/linux/preempt.h
    +++ b/include/linux/preempt.h
    @@ -93,14 +93,17 @@ do { \

     #else /* !CONFIG_PREEMPT_COUNT */

    -#define preempt_disable() do { } while (0)
    -#define sched_preempt_enable_no_resched() do { } while (0)
    -#define preempt_enable_no_resched() do { } while (0)
    -#define preempt_enable() do { } while (0)
    -
    -#define preempt_disable_notrace() do { } while (0)
    -#define preempt_enable_no_resched_notrace() do { } while (0)
    -#define preempt_enable_notrace() do { } while (0)
    +/* This is only a barrier to other asms. Notably get_user/put_user */
    +#define asm_barrier() asm volatile("")
    +
    +#define preempt_disable() asm_barrier()
    +#define sched_preempt_enable_no_resched() asm_barrier()
    +#define preempt_enable_no_resched() asm_barrier()
    +#define preempt_enable() asm_barrier()
    +
    +#define preempt_disable_notrace() asm_barrier()
    +#define preempt_enable_no_resched_notrace() asm_barrier()
    +#define preempt_enable_notrace() asm_barrier()

     #endif /* CONFIG_PREEMPT_COUNT */
