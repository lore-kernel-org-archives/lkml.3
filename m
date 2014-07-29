Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaG2Mb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:31:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaG2Mb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:31:57 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v4 0/3] ring-buffer/ftrace: Race when writing and swapping cpu buffer in parallel
Date: Tue, 29 Jul 2014 14:31:40 +0200
Message-Id: <1406637103-15435-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I ended with these changes after changing my mind few times and hopefully
better understanding the aspects of preemption, interrupts, locking, and
scheduling.

1st patch fixes the race in ring_buffer_swap_cpu(). It is the one from previous
versions. I have only added checks for irqs_disabled() as suggested by Steven.

2nd patch should be easy. It only makes sure that we are on the same CPU
when handling the critical timings.

3rd patch was the most problematic for me. It creates two variants
of smp_call_function_single() that could be called either with or without
disabled interrupts. It is what Steven suggested but I wonder if it could
be done more elegant way. I am in somewhat strange mode after the twins were
born on Thursday.

Petr Mladek (3):
  ring-buffer: Race when writing and swapping cpu buffer in parallel
  trace: process entire stop_critical_timing() on the same CPU
  trace: Allow to call update_max_tr_single() from another CPU

 kernel/trace/ring_buffer.c   | 115 ++++++++++++++++++++++++++++++-------------
 kernel/trace/trace.c         |  60 +++++++++++++++++++---
 kernel/trace/trace.h         |   1 +
 kernel/trace/trace_irqsoff.c |  17 +++++--
 4 files changed, 146 insertions(+), 47 deletions(-)

-- 
1.8.4

