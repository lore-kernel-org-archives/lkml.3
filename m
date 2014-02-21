Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaBUSBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 13:01:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:45408 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754909AbaBUSBL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 13:01:11 -0500
Date: Fri, 21 Feb 2014 13:01:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 0/4] x86: Fix ftrace recovery when code modification
 failed
Message-ID: <20140221130102.31253ad2@gandalf.local.home>
In-Reply-To: <20140221163351.GA1833@pathway.suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
	<20140220232308.3709bd83@gandalf.local.home>
	<20140221163351.GA1833@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 17:33:52 +0100
Petr Mládek <pmladek@suse.cz> wrote:
 
> Yes, it works but I would still do few more changes:
> 
>      + run_sync() also in ftrace_modify_code() in the recovery
>        part; I would solve this by moving the "out" label.

Sounds good.

> 
>      + print some warning in update_ftrace_func() when
>        ftrace_modify_code() fails; otherwise, the error
>        is silently ignored

The error is passed down to the callers. Any warning should happen
there. We can move that up to the generic code. Otherwise, this is a
x86 only fix, and we leave all the other archs broken.

ftrace_modify_all_code() looks to be where the warnings should be. And
yes, any warning should also call ftrace_bug(). That can be done via a
FTRACE_WARN_ON().

> 
>      + BUG when the breakpoint cannot be removed; the system
>        silently crash anyway because the breakpoint will not
>        be handled
> 
> I wonder if we should call FTRACE_WARN_ON_ONCE that calls
> "ftrace_kill" when update_ftrace_func() fails.

Don't need the _ONCE() version. Something like this (I'll let you make
the patch ;-)

	int ret = 0;

	if (update)
		ret = ftrace_update_ftrace_func(ftrace_ops_list_func);
	if (ret)
		goto out;

	if (command & FTRACE_UPDATE_CALLS)
		ret = ftrace_replace_code(1);
	else if (command & FTRACE_DISABLE_CALLS)
		ret = ftrace_replace_code(0);

	if (ret)
		goto out;

	if (update && ftrace_trace_function != ftrace_ops_list_func) {
		function_trace_op = set_function_trace_op;
		smp_wmb();
		/* If irqs are disabled, we are in stop machine */
		if (!irqs_disabled())
			smp_call_function(ftrace_sync_ipi, NULL, 1);
		ret = ftrace_update_ftrace_func(ftrace_trace_function);
	}

	if (ret)
		goto out;

	if (command & FTRACE_START_FUNC_RET)
		ret = ftrace_enable_ftrace_graph_caller();
	else if (command & FTRACE_STOP_FUNC_RET)
		ret = ftrace_disable_ftrace_graph_caller();

out:
	FTRACE_WARN_ON(ret);

Or if you want to keep where it failed, just replace the if (ret) goto
out, with:

	if (FTRACE_WARN_ON(ret))
		return;

That may actually be better.

I've already added my patch. I'll push it up to my ftrace/urgent branch
at

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

And you can write a patch based on that.

Thanks!

-- Steve

