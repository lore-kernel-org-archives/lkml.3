Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3APMzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:55:54 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:43841 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3APMzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:55:53 -0500
MIME-Version: 1.0
In-Reply-To: <20130115145845.GC8768@infradead.org>
References: <CABPqkBStWUyv_vwb9jgWe0hirMNe=J1g_V7z69piajr1pTPt=g@mail.gmail.com>
	<20130115145845.GC8768@infradead.org>
Date: Wed, 16 Jan 2013 13:55:52 +0100
Message-ID: <CABPqkBRmhiB9cm=dBFp1FkBtPjE=L-sEWTQQbYYBu6RPTz3j7g@mail.gmail.com>
Subject: Re: [BUG] perf record: --uid=x fails
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 3:58 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
>
> Em Mon, Jan 14, 2013 at 03:14:02PM +0100, Stephane Eranian escreveu:
> > Hi,
> >
> > I was trying to use the --uid option of perf record but it fails for
> > me no matter
> > what I tried. Looks like the goal of this option is to measure ALL the processes
> > owned by the specified uid. Each process is measured in per-thread mode.
> >
> > However for me it failed on all my attempts when running with 3.8.0-rc3 on
> > Ubuntu Quantal.
> >
> > $ perf record --uid=eranian sleep 4
> > Error:
> > Permission error - are you root?
> > Consider tweaking /proc/sys/kernel/perf_event_paranoid:
> >  -1 - Not paranoid at all
> >   0 - Disallow raw tracepoint access for unpriv
> >   1 - Disallow cpu events for unpriv
> >   2 - Disallow kernel profiling for unpriv
> > sleep: Terminated
> >
> > You don't want to be root to run this command.  Should not require
>
> But you have to due to the problem you noticed below.
>
> > to measure the processes I own. So the error message is confusing
> > here.
>
> indeed
>
> > After some debugging, I came to the conclusion that this command
> > fails when it hits the sshd daemon:
> >
> > eranian   2439  0.0  0.0 110424  1968 ?        S    15:07   0:00 sshd:
> > eranian@pts/2
> > root      2301  0.0  0.0 110424  4420 ?        Ss   15:07   0:00 sshd:
> > eranian [priv]
> >
> > I mean the sshd process owned by me. It is owned by me but I cannot attached
> > an event to it. I get EACCES and I suspect it's because of missing
> > ptrace privilege.
> > The sshd binary is obviously not setuid. So there is something else preventing
> > ptrace. In fact, even strace -p 2349 fails. Looked online and there
> > were a couple
> > of mentions to the Yama security model and the ptrace_scope sysctl
> > control. I tried
> > that and it did not help.
> >
> > So looks to me that something is broken somewhere. If the kernel
> > restrictions are
> > normal, then I think perf record should warn that it has to skip the
> > sshd process and
> > continue with the other processes owned by me. That  seems more useful than the
> > current situation. But I may be missing something here. If so please
> > explain to me.
>
> Right, I need to resume working on properly fixing this, I got
> sidetracked when I got the same point as you in the above analysis :-\
>
> Will try to recover the conversations I had about this.
>
What I don't understand is how it could have ever worked?
Or maybe I ran into this just because I use ssh to connect to my machine.

>
> - Arnaldo
