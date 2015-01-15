Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbbAOESW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:18:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:49836 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751684AbbAOEST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:18:19 -0500
Message-Id: <20150115040923.755326391@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 14 Jan 2015 23:09:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        x86-ml <x86@kernel.org>
Subject: [RFC][PATCH 0/2] ftrace/jprobes/x86: Graph trace jprobes if fentry is used
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is built on top of the patches that disable function graph tracer
for jprobes:

  https://lkml.org/lkml/2015/1/14/631

This is actually the first solution I had to deal with jprobes and
function graph tracing, but as I thought the problem only happened
when kprobes used the ftrace infrastructure (fentry), I had a bit
more control of what was happening. But testing showed that the
issue also happens when kprobes does not use fentry, but uses the
breakpoint at the start of the function. Dealing with breakpoints
and simulating commands the breakpoint is on and trying to get
all that to work with function graph tracing was a bit too much,
so I punted (sorry for the American Football reference). I just
made a patch set that disabled function graph tracing on jprobes
all together and I'm pushing that to mainline and stable.

That said, in most cases today, people use x86_64 over i386 and have
newer gcc's that support fentry. That means for the majority of
use cases jprobes can still be traced and we do not need to limit
function graph tracing against them. I took my first solution
and placed it on top of the final solution where if fentry is
supported, we do not disable function graph tracing on jprobes
but instead use the added trampoline tricks to cover it.

The first patch allows for tracing of jprobes and the second patch
lets function graph tracing still trace the function that is being
probed.

Steven Rostedt (Red Hat) (2):
      ftrace/jprobes/x86: Allow jprobes to be graph traced if using fentry
      ftrace/jprobes/x86: Have function being probed be graph traced

----
 arch/x86/include/asm/ftrace.h    |  4 +++
 arch/x86/include/asm/kprobes.h   |  9 +++++
 arch/x86/kernel/kprobes/core.c   | 72 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/kprobes/ftrace.c | 14 ++++++++
 arch/x86/kernel/mcount_64.S      | 36 +++++++++++++++++++-
 5 files changed, 133 insertions(+), 2 deletions(-)
