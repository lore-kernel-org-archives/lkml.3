Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab3LKOTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:19:18 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:34839 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3LKOTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:19:17 -0500
Date: Wed, 11 Dec 2013 11:19:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 14/71] perf tools: Add cpu to struct thread
Message-ID: <20131211141908.GC1458@ghostprotocols.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-15-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386765443-26966-15-git-send-email-alexander.shishkin@linux.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 11, 2013 at 02:36:26PM +0200, Alexander Shishkin escreveu:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> Tools may wish to track on which cpu a thread
> is running.  Add 'cpu' to struct thread for
> that purpose.  Also add machine functions to
> get / set the cpu for a tid.
> 
> This will be used to determine the cpu when
> decoding a per-thread Instruction Trace.
> 
> 
> +++ b/tools/perf/util/machine.c
> @@ -1412,3 +1412,29 @@ pid_t machine__get_thread_pid(struct machine *machine, pid_t tid)
>  
>  	return thread->pid_;
>  }
> +
> +int machine__get_thread_cpu(struct machine *machine, pid_t tid, pid_t *pid)
> +{
> +	struct thread *thread = machine__find_thread(machine, tid);
> +
> +	if (!thread)
> +		return -1;
> +
> +	if (pid)
> +		*pid = thread->pid_;
> +
> +	return thread->cpu;
> +}

What is the problem with:

	struct thread *thread = machine__find_thread(machine, tid);
	pid_t pid = thread->pid_;
	int cpu = thread->cpu;

In your case you'll have:

	int pid;
	int cpu = machine__get_thread_cpu(machine, tid, &pid);

Which is slightly more compact, but then we end up with a function that
from its name should just get a 'cpu' but also asks for the pid.

I think it is better to just use what we have (machine__find_thread),
have a 'thread' variable and then use any of its members, directly.

- ARnaldo
