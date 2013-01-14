Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab3ANOOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:14:05 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60742 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab3ANOOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:14:03 -0500
MIME-Version: 1.0
Date: Mon, 14 Jan 2013 15:14:02 +0100
Message-ID: <CABPqkBStWUyv_vwb9jgWe0hirMNe=J1g_V7z69piajr1pTPt=g@mail.gmail.com>
Subject: [BUG] perf record: --uid=x fails
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was trying to use the --uid option of perf record but it fails for
me no matter
what I tried. Looks like the goal of this option is to measure ALL the processes
owned by the specified uid. Each process is measured in per-thread mode.

However for me it failed on all my attempts when running with 3.8.0-rc3 on
Ubuntu Quantal.

$ perf record --uid=eranian sleep 4
Error:
Permission error - are you root?
Consider tweaking /proc/sys/kernel/perf_event_paranoid:
 -1 - Not paranoid at all
  0 - Disallow raw tracepoint access for unpriv
  1 - Disallow cpu events for unpriv
  2 - Disallow kernel profiling for unpriv
sleep: Terminated

You don't want to be root to run this command.  Should not require
to measure the processes I own. So the error message is confusing
here.

After some debugging, I came to the conclusion that this command
fails when it hits the sshd daemon:

eranian   2439  0.0  0.0 110424  1968 ?        S    15:07   0:00 sshd:
eranian@pts/2
root      2301  0.0  0.0 110424  4420 ?        Ss   15:07   0:00 sshd:
eranian [priv]

I mean the sshd process owned by me. It is owned by me but I cannot attached
an event to it. I get EACCES and I suspect it's because of missing
ptrace privilege.
The sshd binary is obviously not setuid. So there is something else preventing
ptrace. In fact, even strace -p 2349 fails. Looked online and there
were a couple
of mentions to the Yama security model and the ptrace_scope sysctl
control. I tried
that and it did not help.

So looks to me that something is broken somewhere. If the kernel
restrictions are
normal, then I think perf record should warn that it has to skip the
sshd process and
continue with the other processes owned by me. That  seems more useful than the
current situation. But I may be missing something here. If so please
explain to me.

Thanks.
