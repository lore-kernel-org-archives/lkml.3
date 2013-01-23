Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3AWUel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:34:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3AWUee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:34:34 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=iGnaqPf3E_8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VALziabHa1QA:10 a=VwQbUJbxAAAA:8 a=xG-pfG5gSQSMnBJ5kLkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130123203002.957226869@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 23 Jan 2013 15:30:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/12 -next] [for linux-next] ftrace: Recursion protection and speed up
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change set replaces the function tracing recursion protection
with a context one, that keeps track of interrupts, NMIs, softirqs,
such that we do not need to disable interrupts and not miss any
events, as the old recursion protection had a race where interrupt
events could be dropped.

This also speeds up function tracing by 15% or more.

I'm posting these as a generic review of the changes I'll be pushing
into linux-next and will be pushing this for 3.9.

These patches have passed a series of tests I've run on few machines
with several different configs and such.

You can find the patches here. I'll add these to linux-next tomorrow.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 0b07436d95b5404134da4d661fd183eac863513e


Steven Rostedt (12):
      tracing: Remove trace.h header from trace_clock.c
      tracing: Fix race with max_tr and changing tracers
      tracing: Fix selftest function recursion accounting
      ftrace: Fix global function tracers that are not recursion safe
      ftrace: Fix function tracing recursion self test
      ftrace: Optimize the function tracer list loop
      ftrace: Add context level recursion bit checking
      tracing: Make the trace recursion bits into enums
      tracing: Avoid unnecessary multiple recursion checks
      ftrace: Use only the preempt version of function tracing
      ring-buffer: User context bit recursion checking
      ring-buffer: Remove trace.h from ring_buffer.c

----
 kernel/trace/ftrace.c          |   82 ++++++++++++++++---------
 kernel/trace/ring_buffer.c     |   88 ++++++++++++++++++--------
 kernel/trace/trace.c           |   29 ++++++---
 kernel/trace/trace.h           |  133 ++++++++++++++++++++++++++++++++++++----
 kernel/trace/trace_clock.c     |    2 -
 kernel/trace/trace_functions.c |   61 +++++-------------
 kernel/trace/trace_selftest.c  |   19 ++----
 7 files changed, 275 insertions(+), 139 deletions(-)
