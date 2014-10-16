Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaJPVTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:19:30 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:47935 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaJPVTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:19:17 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 16 Oct 2014 17:25:54 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: 3.17 another perf_fuzzer lockup
In-Reply-To: <alpine.DEB.2.11.1410151418570.3151@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1410161723220.9124@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1410061130100.11293@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410061151400.12313@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410151418570.3151@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014, Vince Weaver wrote:

> I can use sysrq to get the stack trace, the one CPU is stuck in a call
> to find_get_context().
> 
> An example backtrace:
> 
> [88200.300003]  <EOI>
> [88200.300003]  [<ffffffff81114869>] ? ____cache_alloc+0x130/0x25b
> [88200.300003]  [<ffffffff8107fb05>] ? __call_rcu.constprop.63+0x1bf/0x1cb
> [88200.300003]  [<ffffffff8107fb2b>] kfree_call_rcu+0x1a/0x1c
> [88200.300003]  [<ffffffff810cf84f>] put_ctx+0x51/0x55
> [88200.300003]  [<ffffffff810d1840>] find_get_context+0x166/0x195
> [88200.300003]  [<ffffffff810d5856>] SYSC_perf_event_open+0x47b/0x7f5
> [88200.300003]  [<ffffffff810d5f55>] SyS_perf_event_open+0xe/0x10
> [88200.300003]  [<ffffffff815362d6>] system_call_fastpath+0x16/0x1b
> 
> It looks like the
> 			else if (task->perf_event_ctxp[ctxn])
> 	                        err = -EAGAIN;

It is indeed stuck there, waiting for task->perf_event_ctxp[1] to get
set to zero, which never happens.

As far as I can tell it's when a Software event is being opened.

Still struggling through the code trying to figure out what's going on.

[ 7071.252607] VMW: task->perf_event_ctxp[1]=ffff8800cb12ec00, EAGAIN, ref=1
[ 7071.259439] VMW: type=1 config=8
[ 7071.262713] VMW: task->perf_event_ctxp[1]=ffff8800cb12ec00, EAGAIN, ref=1
[ 7071.269506] VMW: task->perf_event_ctxp[1]=ffff8800cb12ec00, EAGAIN, ref=1
[ 7071.276299] VMW: task->perf_event_ctxp[1]=ffff8800cb12ec00, EAGAIN, ref=1
[ 7071.283087] VMW: task->perf_event_ctxp[1]=ffff8800cb12ec00, EAGAIN, ref=1
[ 7071.289879] VMW: task->perf_event_ctxp[1]=ffff8800cb12ec00, EAGAIN, ref=1
[ 7071.296671] VMW: task->perf_event_ctxp[1]=ffff8800cb12ec00, EAGAIN, ref=1
[ 7071.303457] VMW: task->perf_event_ctxp[1]=ffff8800cb12ec00, EAGAIN, ref=1
[ 7071.310248] VMW: task->perf_event_ctxp[1]=ffff8800cb12ec00, EAGAIN, ref=1
[ 7071.317035] VMW: task->perf_event_ctxp[1]=ffff8800cb12ec00, EAGAIN, ref=1
[ 7076.256032] find_get_context: 7246310 callbacks suppressed

Vince
