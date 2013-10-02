Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3JBHGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 03:06:45 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62521 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3JBHGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 03:06:43 -0400
Date: Wed, 2 Oct 2013 00:06:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
        security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kthread: Make kthread_create() killable.
In-Reply-To: <201310012220.EIE35417.HFOQLFSFMJOtOV@I-love.SAKURA.ne.jp>
Message-ID: <alpine.DEB.2.02.1310012358140.20628@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1309251351001.27471@chino.kir.corp.google.com> <201309261159.BHB18780.OHLFQFMOOJSVtF@I-love.SAKURA.ne.jp> <alpine.DEB.2.02.1309261149050.10904@chino.kir.corp.google.com> <201309281618.JAG82364.VFMtSOOQOLFHJF@I-love.SAKURA.ne.jp>
 <alpine.DEB.2.02.1309301441270.28109@chino.kir.corp.google.com> <201310012220.EIE35417.HFOQLFSFMJOtOV@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013, Tetsuo Handa wrote:

> > Or, when the system doesn't respond for a long period of time you do 
> > sysrq+T and you find the TIF_MEMDIE bit set on a process that makes no 
> > progress exiting.
> 
> In enterprise systems, an operator is not always sitting in front of the server
> for pressing sysrq keys (nor kept ssh session for issuing sysrq via procfs).

We have a lot of machines and we collect netdumps from those that 
encounter soft lockups, I haven't seen _any_ examples of the oom killer 
stalling out because of wait_for_completion() in three years, period.

> Such reports in real world might be rare, but I care potential bugs which can
> affect availability of the server.
> 

If you have a reproducible testcase or an example from the kernel log that 
demonstrates this problem, please post it.

> If local unprivileged users can execute their own programs, they can easily
> freeze the server. Therefore, I test whether such freeze can happen using DoS
> attacking programs executed by local unprivileged users. I confirmed that
> request_module() can easily freeze the server and the request_module() case was
> fixed as CVE-2012-4398. I confirmed that kthread_create() can freeze the server
> (though not easy to trigger but can happen by chance) and posted a patch in
> this thread.
> 

Right, and that issue required an instrumented kernel to impose a five 
second delay for you to be able to test it.  I acked the patch.  I'm not 
against fixing issues as they arise, I'm against time-based oom kill 
mechanisms that (1) aren't guaranteed to solve the issue and (2) lead to 
unnecessary memory killing or machine panic.

> > process access to memory reserves does not allow it to exit in a short 
> > amount of time, then it must be waiting on another process that also 
> > cannot make forward process.
> 
> Yes. kthread_create(), do_coredump() and call_usermodehelper_keys() are
> examples of such cases which I think I can trigger deadlock using DoS attacking
> programs executed by local unprivileged users.
> 

I thought you had addressed the kthread_create() issue on 
security@kernel.org, is it possible to address the others?

> The chosen process was marked as TIF_MEMDIE because the process was consuming
> most memory, but it does not mean that the process marked as TIF_MEMDIE itself
> needs more memory. The process marked as TIF_MEMDIE may be simply waiting at
> kthread_create() etc. where other process which is not marked as TIF_MEMDIE
> depends on more memory.
> 
> Even if the process marked as TIF_MEMDIE is allowed to access reserved memory,
> the process which really wants memory may not be marked as TIF_MEMDIE.
> To be able to give the process which really wants memory chance to allocate
> memory, memory pool via kernel thread might help.
> 

That may or may not work depending on whether other processes are 
allocating memory or not, there's no guarantee that this pool of memory is 
available only to the process needing to make progress, so it's not a 100% 
solution and now we've allocated 1% of memory to a kthread needlessly in 
99.999% of users who will never see this issue.
