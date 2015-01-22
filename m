Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbbAVBtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:49:36 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:45958 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbAVBt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:49:29 -0500
MIME-Version: 1.0
From: Alexei Starovoitov <ast@plumgrid.com>
Date: Wed, 21 Jan 2015 17:49:08 -0800
Message-ID: <CAMEtUux8v2LDtLcgpT9hCvJgnrCwT2fkzsSvAPFSuEUx+itxyQ@mail.gmail.com>
Subject: Re: [PATCH tip 0/9] tracing: attach eBPF programs to tracepoints/syscalls/kprobe
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 5:03 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>
> AFAIK a trigger can be fired before allocating a ring buffer if it
> doesn't use the event record (i.e. has filter) or ->post_trigger bit
> set (stacktrace).  Please see ftrace_trigger_soft_disabled().

yes, but such trigger has no arguments, so I would have to hack
ftrace_trigger_soft_disabled() to pass 'ctx' further down
and through all pointer dereferences and list walking.
Also there is no return value, so I have to add it as well
similar to post-triggers.
that's quite a bit of overhead that I would like to avoid.

Actually now I'm thinking to move condition
if (ftrace_file->flags & TRACE_EVENT_FL_BPF)
before ftrace_trigger_soft_disabled() check.
So programs always run first and if they return non-zero
then all standard processing will follow.
May be return value from the program can influence triggers.
That will nicely replace bpf_dump_stack()...the program
will return ETT_STACKTRACE constant to trigger dump.

> This also makes it keeping events in the soft-disabled state.

I was never able to figure out the use case for soft-disabled state.
Probably historical before static_key was done.
