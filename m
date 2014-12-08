Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaLHE2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 23:28:36 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:47134 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaLHE2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 23:28:35 -0500
MIME-Version: 1.0
In-Reply-To: <1418009221-12719-1-git-send-email-anton@samba.org>
References: <1418009221-12719-1-git-send-email-anton@samba.org>
Date: Sun, 7 Dec 2014 20:28:34 -0800
X-Google-Sender-Auth: 9h0-JSSSkT9DodUDzPTnc78mMuM
Message-ID: <CA+55aFw6gMN5VxONPo9xtJA_+p2iLArSaK-m_4vDL+L07Z6vuA@mail.gmail.com>
Subject: Re: [PATCH] kthread: kthread_bind fails to enforce CPU affinity
 (fixes kernel BUG at kernel/smpboot.c:134!)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Blanchard <anton@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, yuyang.du@intel.com,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Daniel J Blueman <daniel@numascale.com>, subbaram@codeaurora.org,
        Brian Norris <computersforpeace@gmail.com>, sp@datera.io,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2014 at 7:27 PM, Anton Blanchard <anton@samba.org> wrote:
>
> Since we cannot call set_task_cpu (the task is in a sleeping state),
> just do an explicit set of task_thread_info(p)->cpu.

Scheduler people: is this sufficient and ok?

The __set_task_cpu() function does various other things too:

        set_task_rq(p, cpu);
  #ifdef CONFIG_SMP
        /*
         * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
         * successfuly executed on another CPU. We must ensure that updates of
         * per-task data have been completed by this moment.
         */
        smp_wmb();
        task_thread_info(p)->cpu = cpu;
        p->wake_cpu = cpu;
  #endif

which makes me worry about just setting the thread_info->cpu value.
That set_task_rq() initializes various group scheduling things, an
dthat whole "wake_cpu" thing seems relevant too.

I'm not saying the patch is wrong, I just want confirmation/ack for
it. Although to be honest, I'd rather see this come in through the
scheduler tree anyway.

Hmm? This seems to go back to 2.6.33 if that "Fixes" line is accurate,
so it's been around forever (almost exactly five years). Comments?

                    Linus
