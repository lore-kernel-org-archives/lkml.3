Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3CXP73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:59:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44732 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab3CXP71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:59:27 -0400
Date: Sun, 24 Mar 2013 16:59:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
Message-ID: <20130324155924.GB4866@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Stephane Eranian <eranian@google.com>
References: <20130324115556.GA4866@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130324115556.GA4866@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 12:55:56PM +0100, Borislav Petkov wrote:
> Hi,
> 
> so I was tracing a small .c program like so:
> 
> $ ./perf record ~/test/asm
> 
> and here's what got spewed in dmesg. Kernel is plain -rc4. Any pending
> fixes in tip I should try?
> 
> [ 3700.194208] BUG: using smp_processor_id() in preemptible [00000000] code: asm/8333
> [ 3700.194226] caller is perf_event_task_ctx+0x55/0x140

Ok, here's the call stack I was able to reconstruct:

perf_event_exit_task()
|->perf_event_exit_task_context()
   |-> perf_event_task()
       |-> perf_event_task_event()
	   |-> perf_event_task_ctx()
	       |-> perf_event_task_match()
		   |-> event_filter_match()
		       |-> smp_processor_id() -> debug_smp_processor_id()

Now, my primitive thinking would presume that since we're on the
exit_task path, we're still on the same cpu so the check triggers
wrongly but I don't know for sure. Also, is there any possibility for
this code to be moved somewhere else, i.e. to another cpu, so that the
check actually is correct?

Hmm.

Adding Stephane who added that check in
fa66f07aa1f0950e1dc78b7ab39728b3f8aa77a1.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
