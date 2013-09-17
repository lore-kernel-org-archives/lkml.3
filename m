Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3IQPTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:19:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab3IQPTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:19:53 -0400
Message-ID: <523870FF.3030306@redhat.com>
Date: Tue, 17 Sep 2013 17:10:55 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RFC] Full syscall argument decode in "perf trace"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to figure out how to extend "perf trace".

Currently, it shows syscall names and arguments, and only them.
Meaning that syscalls such as open(2) are shown as:

    open(filename: 140736118412184, flags: 0, mode: 140736118403776) = 3

The problem is, of course, that user wants to see the filename
per se, not the address of its first byte.

To improve that, we need to fetch the pointed-to data.
There are two approaches to this: extending
"raw_syscalls:sys_{enter,exit}" tracepoint so that it returns this data,
or selectively stopping the traced process when it reaches the thacepoint.


First solution is attractive performance-wise, but requires a lot
of new code: *ALL* syscalls will need to know which arguments are pointers,
how large their pointed-to data structures are, and (remember
readv and friends!) some of pointed-to structures themselves
contain pointers which reference even more data.

If we want to go this way, do we want to encode all this knowledge in kernel?
If yes, how? If no, in what form userspace (perf trace) would configure
the tracepoint wrt which syscalls' arguments to copy to trace buffer?


The second solution is to pause traced process, let "perf trace" to fetch
its data (e.g. via process_vm_readv(2)) and unpause it.

The dead-simple approach ("pause on every sys_{enter,exit}") would be
no faster than strace. To make any sense, as a minimum the pausing needs
to be conditional: there is no need to stop on syscalls which do not
have indirect data (e.g. close(2), dup2(2)...).

Optimizing further, we can choose a few typical syscalls such as [f]stat(2),
write(2), and apply solution #1 ("dump data to trace buffer and don't pause")
to them.
For example, fstat(fd, &statbuf) does not need to stop on sys_enter at all,
and needs to only copy the fixed number of bytes of statbuf to trace buffer
on exit to avoid the need to pause.

If we want to go this way, how do you guys think this should be implemented?

IIUC tracepoints weren't meant to be able to influence execution,
the "pause the current process when tracepoint
is triggered" is a new feature. Does it look acceptable?
How to go about implementing it? Something like an ad-hoc extension field in
struct perf_event_attr to enable it?
Specifically, a new field or flag can enable this:
perf_event_open -> perf_event_alloc(... overflow_handler_which_conditionally_stops_current ...)

The "pausing", what it should be, exactly? In the ancient times, strace
chose to simply use SIGSTOP for similar needs, and it ended up interfering
with tracing real SIGSTOPs. I guess we don't want to repeat that. Then,
how? More specifically: when "perf trace" will read trace buffer and see
"process FOO paused in sys_exit from readv", how it should kick
process FOO to unpause it?

**end of brain dump**

Comments? Suggestions?
