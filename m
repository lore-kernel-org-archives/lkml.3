Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaJOS1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:27:41 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:65035 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaJOS1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:27:38 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 15 Oct 2014 14:34:10 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: 3.17 another perf_fuzzer lockup
In-Reply-To: <alpine.DEB.2.11.1410061151400.12313@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1410151418570.3151@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1410061130100.11293@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410061151400.12313@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, so it turns out that the oops I saw with memory corruption wasn't the 
bug I was tracking, but something that comes up sometimes when trying to 
run ftrace at the same time as fuzzing.  So we'll leave that for another 
day.

The 3.17+ lockup I am tracking still reproduces as of git from yesterday 
(even after the 3.18-rc perf_event merges).

I can use sysrq to get the stack trace, the one CPU is stuck in a call
to find_get_context().

An example backtrace:

[88200.300003]  <EOI>
[88200.300003]  [<ffffffff81114869>] ? ____cache_alloc+0x130/0x25b
[88200.300003]  [<ffffffff8107fb05>] ? __call_rcu.constprop.63+0x1bf/0x1cb
[88200.300003]  [<ffffffff8107fb2b>] kfree_call_rcu+0x1a/0x1c
[88200.300003]  [<ffffffff810cf84f>] put_ctx+0x51/0x55
[88200.300003]  [<ffffffff810d1840>] find_get_context+0x166/0x195
[88200.300003]  [<ffffffff810d5856>] SYSC_perf_event_open+0x47b/0x7f5
[88200.300003]  [<ffffffff810d5f55>] SyS_perf_event_open+0xe/0x10
[88200.300003]  [<ffffffff815362d6>] system_call_fastpath+0x16/0x1b

It looks like the
			else if (task->perf_event_ctxp[ctxn])
	                        err = -EAGAIN;

case is triggering non-stop in the retry path of 
find_get_context() and so the kernel gets stuck forever retrying.

I can drop some printks in if it will help debug.  I've tried running 
ftrace, but for whatever reason if I enable ftrace the bug won't trigger.

Vince


