Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaE0U4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:56:02 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:65227 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaE0U4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:56:01 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 27 May 2014 17:00:07 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: fuzzer getting stuck with slow memory leak
In-Reply-To: <alpine.DEB.2.10.1405271600380.4124@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405271658170.4525@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405271327470.1839@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405271400240.4012@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405271549100.4124@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405271600380.4124@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Vince Weaver wrote:

> On Tue, 27 May 2014, Vince Weaver wrote:
> 
> > OK, the problem is in:
> > 
> > 	kernel/events/core.c find_get_context()
> > 
> > retry:
> > 	perf_lock_task_context() returns NULL.
> > 	alloc_perf_context()
> > 	task->perf_event_ctxp[ctxn] is *not* NULL
> > 	err == EAGAIN so jump to retry
> > 

so after sticking some trace_printk()s in the code, it turns out
that for the software PMU

perf_lock_task_context() returns NULL beause 
	!atomic_inc_not_zero(&ctx->refcount)
is zero, but
	task->perf_event_ctxp[ctxn] still has a value.

And since those conditions never change it just loops forever, stuck.

I'm not sure how the reference count is getting messed up.
This is reproducible so if there's anything useful I can turn on
tracing-wise let me know.

Vince
