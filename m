Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaE0TsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:48:10 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:46967 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaE0TsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:48:08 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 27 May 2014 15:52:19 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: fuzzer getting stuck with slow memory leak
In-Reply-To: <alpine.DEB.2.10.1405271400240.4012@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405271549100.4124@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405271327470.1839@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405271400240.4012@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Vince Weaver wrote:

>      perf_fuzzer-2989  [001]  1994.514398: sys_enter:		NR 298 (699f28, bad, 0, ffffffff, 2, 7fff361a3360)
>      perf_fuzzer-2989  [001]  1994.514399: bprint:		SYSC_perf_event_open: VMW: perf_event_open type=1 config=8 period=0 pid=2989 cpu=0 group=-1 flags=2
>      perf_fuzzer-2989  [001]  1994.514400: kmalloc:		(T.1267+0xe) call_site=ffffffff810d027d ptr=0xffff880119d1f400 bytes_req=936 bytes_alloc=1024 gfp_flags=GFP_KERNEL|GFP_ZERO
>      perf_fuzzer-2989  [001]  1994.514401: kmalloc:		(T.1267+0xe) call_site=ffffffff810d027d ptr=0xffff8800cbbbd000 bytes_req=2064 bytes_alloc=4096 gfp_flags=GFP_KERNEL|GFP_ZERO
>      perf_fuzzer-2989  [001]  1994.514401: kmalloc:     	(T.1267+0xe) call_site=ffffffff810d027d ptr=0xffff880119fcd000 bytes_req=2064 bytes_alloc=4096 gfp_flags=GFP_KERNEL|GFP_ZERO
>      perf_fuzzer-2989  [001]  1994.514402: kmalloc:		(T.1267+0xe) call_site=ffffffff810d027d ptr=0xffff8800c9344400 bytes_req=216 bytes_alloc=256 gfp_flags=GFP_KERNEL|GFP_ZERO
> 	(repeat forever)

OK, the problem is in:

	kernel/events/core.c find_get_context()

retry:
	perf_lock_task_context() returns NULL.
	alloc_perf_context()
	task->perf_event_ctxp[ctxn] is *not* NULL
	err == EAGAIN so jump to retry

stuck forever leaking the memory being allocated by alloc_perf_context().

I'm not sure what this code should be doing, but it looks like we'll 
always leak memory if the EAGAIN case is triggered?

Vince

