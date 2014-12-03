Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbaLCACP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:02:15 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:53077 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaLCACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:02:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141202121415.GA20127@thunk.org>
References: <20141202021912.GA29096@thunk.org>
	<20141201214104.32d3f10d@gandalf.local.home>
	<CAMEtUuzEg39N9ZALuq-u4X+oaNJGqL6G05UABSHYpejQ78Cp3Q@mail.gmail.com>
	<20141202050406.GC953@thunk.org>
	<CAMEtUuyyrUToWgczxdpj+SUEdr16NknQa_ZmWoGr8f261kyqmg@mail.gmail.com>
	<20141202121415.GA20127@thunk.org>
Date: Tue, 2 Dec 2014 16:02:13 -0800
Message-ID: <CAMEtUuw-H23AskH_k=TxRW04-OfgkgjQC_nvfuYH3NVc1o6kJA@mail.gmail.com>
Subject: Re: Checking to see if a bit is _not_ set in a ftrace event filter
From: Alexei Starovoitov <ast@plumgrid.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 4:14 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Well, if eBPF can get more information without DWARF, that's great.
> I'll use whatever I can get, so long as I can do it without DWARF.  :-)

eBPF is just an engine. Anyone can develop a userspace bits that
will use debug info and/or their favorite language (stap, ktap, dtrace
or any other) when right hooks are in place on the kernel side.
I'm focusing on restricted C as a way to program it and
environments without debug info.

> recompile, which is a win.  (But since I also do a lot of debug runs
> using 32-bit kernels, it would be nice to have things that worked
> there as well, which is why in general I'll add tracepoints once I
> find that it might be useful to trace a particular function.)

Understood. i386 is difficult, since arg passing is using
combination of registers(eax,edx,ecx) and stack in
non-obvious way, so some trick is needed to get it right
without debug info. I'm still trying to solve this one.
That's for programs attached to kprobes.
Programs that attach to tracepoints will see arguments
in a normal way on all archs.
Anyway, one step at a time. Easy things first.

As one of the crazy things for the future I was thinking
about mini-tracepoints. Instead of generating full
ftrace_raw_* bodies, generate minimal stubs
to collect tracepoint arguments only and invoke programs.
In other words move responsibility of TP_STRUCT__entry,
TP_fast_assign and TP_printk into the bpf program.
On x64 all we need is single stub for all mini-tracepoints.
For 32-bit archs all mini-tracepoint stubs will be different
to accomodate 32/64-bit argument passing.
That will save quite a bit from .text and hopefully more
people will enable such tracepoints in production.
