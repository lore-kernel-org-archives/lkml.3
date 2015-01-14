Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbbANPnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:43:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:13625 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751280AbbANPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:43:31 -0500
Message-Id: <20150114153958.931152836@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 14 Jan 2015 10:39:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, vvs@sw.ru,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86-ml <x86@kernel.org>
Subject: [PATCH 0/3] ftrace/kprobes/x86: 
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Vasily Averin reported that combining jprobes with function tracing
resulted in a kernel crash.

I first thought this was related to the fentry code and wrote up a few
nice (albeit complex) patches that could handle it. But then during my
testing I discovered that it also affected non fentry code and i386.
I had to revert all my changes and just disable function graph tracing
before the jprobe is called, and re-enable it afterward. This seems
to be the easiest fix, although if fentry is enabled, we lose the
tracing of the function that was being probed. But since it would have
crashed otherwise, this solution is a major improvement.

While debugging this I also uncovered some other bugs in the function
graph trampoline logic. Nothing too major, but worthy enough to be fixed
now and sent to stable.

I can still use the patches I have done for fentry to let the probed
function be traced (as well as the jprobe handlers) if fentry is being
used. But that is something for the next merge window and not needed now.

Steven Rostedt (Red Hat) (3):
      ftrace: Fix updating of filters for shared global_ops filters
      ftrace: Check both notrace and filter for old hash
      ftrace/jprobes/x86: Fix conflict between jprobes and function graph tracing

----
 arch/x86/kernel/kprobes/core.c | 20 ++++++++++++----
 kernel/trace/ftrace.c          | 53 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 60 insertions(+), 13 deletions(-)
