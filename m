Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbbA2Gj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:39:57 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:59357 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbbA2Gjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:39:55 -0500
MIME-Version: 1.0
From: Alexei Starovoitov <ast@plumgrid.com>
Date: Wed, 28 Jan 2015 22:39:34 -0800
Message-ID: <CAMEtUuywGh9p9yQdeJJiKRdpZhmgJdQYWgf3W3U0uSTXkjF_uA@mail.gmail.com>
Subject: Re: [PATCH v2 linux-trace 1/8] tracing: attach eBPF programs to
 tracepoints and syscalls
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 9:39 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
>
> Maybe, would we need a reference counter for each event? :)

when we would want multiple users to attach different programs
to the same event, then yes.
Right now I'd rather have things simple.

> Actually, ftrace event is not similar to perf-event which ktap
> is based on, ftrace event interface is always exported via
> debugfs, this means users can share the event for different
> usage.

yes.I've been thinking to extend perf_event ioctl to attach programs,
but right now it's only supporting tracepoints and kprobe
seems not trivial to add.
So I went for tracefs style of attaching for now.

> One possible other solution is to add a instance-lock interface
> for each ftrace instance and lock it by bpf. Then, other users
> can not enable/disable the events in the instance.

the user space can synchronize itself via flock. kernel doesn't
need to arbitrate. If one user process attached a program
that auto-enabled an event and another process did
'echo 0 > enable', it's fine. I think it's a feature instead of a bug.
Both users are root anyway.

The more we talk about it, the more I like a new 'bpf' file
approach within tracefs (that I've mentioned in cover letter)
with auto-enable/disable logic to make it clear that
it's different from traditional global 'filter' file.
