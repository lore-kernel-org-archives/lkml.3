Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaE0T5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:57:53 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:47278 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaE0T5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:57:52 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 27 May 2014 16:02:02 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: fuzzer getting stuck with slow memory leak
In-Reply-To: <alpine.DEB.2.10.1405271549100.4124@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405271600380.4124@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405271327470.1839@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405271400240.4012@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405271549100.4124@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Vince Weaver wrote:

> OK, the problem is in:
> 
> 	kernel/events/core.c find_get_context()
> 
> retry:
> 	perf_lock_task_context() returns NULL.
> 	alloc_perf_context()
> 	task->perf_event_ctxp[ctxn] is *not* NULL
> 	err == EAGAIN so jump to retry
> 
> stuck forever leaking the memory being allocated by alloc_perf_context().
> 
> I'm not sure what this code should be doing, but it looks like we'll 
> always leak memory if the EAGAIN case is triggered?

And actually no leak at all, because "put_ctx()" really means "free ctx".
Is that some sort of kernel idiom?

It would also be nice if it were "perf_put_ctx()" although I guess you 
don't name functions just so they're easier to enable when using ftrace
wildcards.

Vince
