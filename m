Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3AOO7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:59:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab3AOO67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:58:59 -0500
Date: Tue, 15 Jan 2013 11:58:45 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [BUG] perf record: --uid=x fails
Message-ID: <20130115145845.GC8768@infradead.org>
References: <CABPqkBStWUyv_vwb9jgWe0hirMNe=J1g_V7z69piajr1pTPt=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBStWUyv_vwb9jgWe0hirMNe=J1g_V7z69piajr1pTPt=g@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 14, 2013 at 03:14:02PM +0100, Stephane Eranian escreveu:
> Hi,
> 
> I was trying to use the --uid option of perf record but it fails for
> me no matter
> what I tried. Looks like the goal of this option is to measure ALL the processes
> owned by the specified uid. Each process is measured in per-thread mode.
> 
> However for me it failed on all my attempts when running with 3.8.0-rc3 on
> Ubuntu Quantal.
> 
> $ perf record --uid=eranian sleep 4
> Error:
> Permission error - are you root?
> Consider tweaking /proc/sys/kernel/perf_event_paranoid:
>  -1 - Not paranoid at all
>   0 - Disallow raw tracepoint access for unpriv
>   1 - Disallow cpu events for unpriv
>   2 - Disallow kernel profiling for unpriv
> sleep: Terminated
> 
> You don't want to be root to run this command.  Should not require

But you have to due to the problem you noticed below.

> to measure the processes I own. So the error message is confusing
> here.

indeed
 
> After some debugging, I came to the conclusion that this command
> fails when it hits the sshd daemon:
> 
> eranian   2439  0.0  0.0 110424  1968 ?        S    15:07   0:00 sshd:
> eranian@pts/2
> root      2301  0.0  0.0 110424  4420 ?        Ss   15:07   0:00 sshd:
> eranian [priv]
> 
> I mean the sshd process owned by me. It is owned by me but I cannot attached
> an event to it. I get EACCES and I suspect it's because of missing
> ptrace privilege.
> The sshd binary is obviously not setuid. So there is something else preventing
> ptrace. In fact, even strace -p 2349 fails. Looked online and there
> were a couple
> of mentions to the Yama security model and the ptrace_scope sysctl
> control. I tried
> that and it did not help.
> 
> So looks to me that something is broken somewhere. If the kernel
> restrictions are
> normal, then I think perf record should warn that it has to skip the
> sshd process and
> continue with the other processes owned by me. That  seems more useful than the
> current situation. But I may be missing something here. If so please
> explain to me.

Right, I need to resume working on properly fixing this, I got
sidetracked when I got the same point as you in the above analysis :-\

Will try to recover the conversations I had about this.

- Arnaldo
