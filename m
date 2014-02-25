Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaBYOrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:47:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44043 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaBYOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:47:08 -0500
Date: Tue, 25 Feb 2014 15:46:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: laijs@cn.fujitsu.com, akpm@linux-foundation.org, joe@perches.com,
        keescook@chromium.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
        tglx@linutronix.de
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
Message-ID: <20140225144643.GU9987@twins.programming.kicks-ass.net>
References: <20140207180647.5944fe3d.akpm@linux-foundation.org>
 <201402092327.JAD12489.QOLSFVMHJtFOOF@I-love.SAKURA.ne.jp>
 <201402102243.IEJ52676.JOFVMOQFOFSLtH@I-love.SAKURA.ne.jp>
 <201402172027.BFH81210.FJtOQOMLHFSVOF@I-love.SAKURA.ne.jp>
 <530BF6B4.3040206@cn.fujitsu.com>
 <201402252154.HAE13049.QFFSMVOFOOtLJH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201402252154.HAE13049.QFFSMVOFOOtLJH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 09:54:01PM +0900, Tetsuo Handa wrote:
> Lai Jiangshan wrote:
> > CC scheduler people.
> > 
> > I can't figure out what we get with this patch.
> > 
> OK. Welcome to this thread. I'll explain you what is going on.
> 
> Current problem:
> 
>   printk("%s\n", task->comm) is racy because "%s" format specifier assumes that
>   the corresponding argument does not change between strnlen() and the for loop
>   at string() in lib/vsnprintf.c . If task->comm was "Hello Linux" until
>   strnlen() and becomes "Penguin" before the for loop, "%s" will emit
>   "Penguin\0nux" (note the unexpected '\0' byte and the garbage bytes).

I would have actually expected it to stop emitting chars at \0. But
sure. Couldn't care less though; that's what you get, we all know this,
we've all been through this discussion several times. Get over it
already.

One of the last threads on this is:

  https://lkml.org/lkml/2011/5/17/516

>   Likewise, audit_log_untrustedstring(ab, current->comm) is racy.
>   If task->comm was "Hello Linux" until audit_string_contains_control() in
>   audit_log_n_untrustedstring() returns false, and becomes "Penguin" before
>   memcpy() in audit_log_n_string() is called, memcpy() will emit "Penguin\0nux"
>   into the audit log, which results in loss of information (e.g. SELinux
>   context) due to the unexpected '\0' byte.

I expect the audit people don't like this? Also, how do audit and the
LSM crap things interact? I thought they were both different piles of
ignorable goo?

See there's not actually a problem statement here at all, so you can't
go about proposing solutions quite yet.

> Proposed solution:
> 
>   To fix abovementioned problem, I proposed commcpy() and "%pT" format
>   specifier which does
> 
>     char tmp[16];
>     memcpy(tmp, task->comm, 16);
>     tmp[15] = '\0';
>     sprintf(buf, "%s", tmp);
> 
>   instead of
> 
>     sprintf(buf, "%s", task->comm);
> 
>   .

How about you do what you're supposed to do when you want a reliable
->comm and use get_task_comm()?
