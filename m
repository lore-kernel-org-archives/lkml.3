Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbbA2HFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:05:16 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:59048 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbbA2HFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:05:13 -0500
MIME-Version: 1.0
From: Alexei Starovoitov <ast@plumgrid.com>
Date: Wed, 28 Jan 2015 23:04:52 -0800
Message-ID: <CAMEtUuzSDYYWneoTy9=AmMa9=x4owWbWsXod=Do54+yj4Je3=Q@mail.gmail.com>
Subject: Re: [PATCH v2 linux-trace 1/8] tracing: attach eBPF programs to
 tracepoints and syscalls
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:41 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>
> I think it's not a problem of bpf.  An user process can be killed
> anytime while it enabed events without bpf.  The only thing it should
> care is the auto-unload IMHO.

ok. I think it does indeed make sense to decouple the logic.
We can add 'auto_enable' file to achieve desired Ctrl-C behavior.
While the 'auto_enable' file is open the event will be enabled
and writes to 'enable' file will be ignored.
As soon as file closes, the event is auto-disabled.
Then user space will use 'bpf' file to attach/auto-unload
and 'auto_enable' file together.
Seem there would be a use for such 'auto_enable'
without bpf as well.

> I'm okay for not calling bpf program in NMI but not for disabling events.
>
> Suppose an user was collecting an event (including in NMI) and then
> [s]he also wanted to run a bpf program.  So [s]he wrote a program
> always return 1.  But after attaching the program, it didn't record
> the event in NMI..  Isn't that a problem?

ok, I think 'if (in_nmi()) return 1;' will work then, right?
Or you're thinking something else ?

> Right.  I think bpf programs belong to a user process but events are
> global resource.  Maybe you also need to consider attaching bpf
> program via perf (ioctl?) interface..

yes. I did. Please see my reply to Masami.
ioctl only works for tracepoints.
