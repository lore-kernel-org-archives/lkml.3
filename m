Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaAPOSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:18:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38609 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaAPOSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:18:08 -0500
Date: Thu, 16 Jan 2014 15:17:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
Message-ID: <20140116141743.GT31570@twins.programming.kicks-ass.net>
References: <52D64676.4040000@linaro.org>
 <20140115120418.GD31570@twins.programming.kicks-ass.net>
 <52D7E343.40909@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D7E343.40909@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 02:48:51PM +0100, Daniel Lezcano wrote:
> 3570  sched_getparam(3570, { 0 })       = 0
> 3570  sched_getscheduler(3570)          = 0 (SCHED_OTHER)
> 3570  sched_get_priority_min(SCHED_OTHER) = 0
> 3570  sched_get_priority_max(SCHED_OTHER) = 0
> 3571  sched_get_priority_min(SCHED_OTHER) = 0
> 3571  sched_get_priority_max(SCHED_OTHER) = 0
> 3571  sched_get_priority_min(SCHED_OTHER) = 0
> 3571  sched_get_priority_max(SCHED_OTHER) = 0
> 3571  sched_setscheduler(3572, SCHED_OTHER, { 0 } <unfinished ...>
> 3571  <... sched_setscheduler resumed> ) = 0
> 3571  sched_get_priority_min(SCHED_OTHER <unfinished ...>
> 3571  <... sched_get_priority_min resumed> ) = 0
> 3571  sched_get_priority_max(SCHED_OTHER <unfinished ...>
> 3571  <... sched_get_priority_max resumed> ) = 0
> 3571  sched_setscheduler(3573, SCHED_OTHER, { 0 } <unfinished ...>
> 3571  <... sched_setscheduler resumed> ) = -1 EPERM (Operation not
> permitted)
> 3571  sched_get_priority_min(SCHED_OTHER <unfinished ...>
> 3571  <... sched_get_priority_min resumed> ) = 0
> 3571  sched_get_priority_max(SCHED_OTHER <unfinished ...>
> 3571  <... sched_get_priority_max resumed> ) = 0
> 3571  sched_setscheduler(3574, SCHED_OTHER, { 0 } <unfinished ...>
> 3571  <... sched_setscheduler resumed> ) = -1 EPERM (Operation not
> permitted)
> 
> The same strace but on a kernel which does not hang. The calls to
> sched_setscheduler do not fail.
> 
> 3292  sched_getparam(3292, { 0 })       = 0
> 3292  sched_getscheduler(3292)          = 0 (SCHED_OTHER)
> 3292  sched_get_priority_min(SCHED_OTHER) = 0
> 3292  sched_get_priority_max(SCHED_OTHER) = 0
> 3293  sched_get_priority_min(SCHED_OTHER) = 0
> 3293  sched_get_priority_max(SCHED_OTHER) = 0
> 3293  sched_get_priority_min(SCHED_OTHER) = 0
> 3293  sched_get_priority_max(SCHED_OTHER) = 0
> 3293  sched_setscheduler(3294, SCHED_OTHER, { 0 } <unfinished ...>
> 3293  <... sched_setscheduler resumed> ) = 0
> 3293  sched_get_priority_min(SCHED_OTHER <unfinished ...>
> 3293  <... sched_get_priority_min resumed> ) = 0
> 3293  sched_get_priority_max(SCHED_OTHER <unfinished ...>
> 3293  <... sched_get_priority_max resumed> ) = 0
> 3293  sched_setscheduler(3295, SCHED_OTHER, { 0 } <unfinished ...>
> 3293  <... sched_setscheduler resumed> ) = 0
> 3293  sched_get_priority_min(SCHED_OTHER <unfinished ...>
> 3293  <... sched_get_priority_min resumed> ) = 0
> 3293  sched_get_priority_max(SCHED_OTHER <unfinished ...>
> 3293  <... sched_get_priority_max resumed> ) = 0
> 3293  sched_setscheduler(3296, SCHED_OTHER, { 0 } <unfinished ...>
> 3293  <... sched_setscheduler resumed> ) = 0
> 
> The EPERM error comes from kernel/sched/core.c:3303
> 
> ...
> 		if (fair_policy(policy)) {
> 			if (!can_nice(p, attr->sched_nice))
> 				return -EPERM;
> 		}
> ...
> 
> 
> But I don't know why this is leading to block a process or making rsyslogd
> being not woken up by a packet coming in the af_unix socket.

Could you test with a fresh tip/master, Ingo just pushed out a stack of
fixes, in particularly:

e3de300d1212b ("sched: Preserve the nice level over sched_setscheduler() and sched_setparam() calls")
39fd8fd22b322 ("sched: Fix up scheduler syscall LTP fails")

Could have affected things.

Meanwhile I'll try and better read what the above says.

Thanks!
