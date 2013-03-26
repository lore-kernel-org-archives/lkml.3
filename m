Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab3CZSfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:35:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45521 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3CZSe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:34:58 -0400
Date: Tue, 26 Mar 2013 19:34:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
Message-ID: <20130326183452.GC27518@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20130324115556.GA4866@pd.tnic>
 <20130324155924.GB4866@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130324155924.GB4866@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 04:59:24PM +0100, Borislav Petkov wrote:
> On Sun, Mar 24, 2013 at 12:55:56PM +0100, Borislav Petkov wrote:
> > Hi,
> > 
> > so I was tracing a small .c program like so:
> > 
> > $ ./perf record ~/test/asm
> > 
> > and here's what got spewed in dmesg. Kernel is plain -rc4. Any pending
> > fixes in tip I should try?
> > 
> > [ 3700.194208] BUG: using smp_processor_id() in preemptible [00000000] code: asm/8333
> > [ 3700.194226] caller is perf_event_task_ctx+0x55/0x140
> 
> Ok, here's the call stack I was able to reconstruct:
> 
> perf_event_exit_task()
> |->perf_event_exit_task_context()
>    |-> perf_event_task()
>        |-> perf_event_task_event()
> 	   |-> perf_event_task_ctx()
> 	       |-> perf_event_task_match()
> 		   |-> event_filter_match()
> 		       |-> smp_processor_id() -> debug_smp_processor_id()

Ok, jolsa just rootcaused it: It is caused by
d610d98b5de6860feb21539726e9af7c9094151c calling perf_event_task_ctx()
outside of the preempt-safe protection.

There's a straightforward fix below, what to people think?

--
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b4a55d41efc..f3bb3384a106 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4455,8 +4455,11 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 next:
 		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
+
+	preempt_disable();
 	if (task_event->task_ctx)
 		perf_event_task_ctx(task_event->task_ctx, task_event);
+	preempt_enable();
 
 	rcu_read_unlock();
 }


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
