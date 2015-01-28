Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbbA1Bmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:42:45 -0500
Received: from smtprelay0113.hostedemail.com ([216.40.44.113]:55142 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933624AbbA1Bmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:42:42 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2692:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:3874:4605:5007:6120:6261:7514:7875:7903:9040:9121:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12663:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rail85_3481a08e4ca23
X-Filterd-Recvd-Size: 2243
Date: Tue, 27 Jan 2015 20:42:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 2/4] sched: Use traced preempt count operations to
 toggle PREEMPT_ACTIVE
Message-ID: <20150127204239.3d3bc2e4@gandalf.local.home>
In-Reply-To: <1422404652-29067-3-git-send-email-fweisbec@gmail.com>
References: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
	<1422404652-29067-3-git-send-email-fweisbec@gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 01:24:10 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> d1f74e20b5b064a130cd0743a256c2d3cfe84010 turned PREEMPT_ACTIVE modifiers
> to use raw untraced preempt count operations. Meanwhile this prevents
> from debugging and tracing preemption disabled if we pull that
> responsibility to schedule() callers (see following patches).
> 
> Is there anything we can do about that?
> 

I'm trying to understand how you solved the recursion issue with
preempt_schedule()?

Here's what happens:

preempt_schedule()
  preempt_count_add() -> gets traced by function tracer
     function_trace_call()
         preempt_disable_notrace()
         [...]
         preempt_enable_notrace() -> sees NEED_RESCHED set
             preempt_schedule()
                preempt_count_add() -> gets traced
                   function_trace_call()
                       preempt_disable_notrace()
                       preempt_enable_notrace() -> sees NEED_RESCHED set

                          [etc etc until BOOM!]

Perhaps if you can find a way to clear NEED_RECHED before disabling
preemption, then it would work. But I don't see that in the patch
series.

-- Steve

