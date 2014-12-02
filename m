Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbaLBF6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:58:35 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:49141 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaLBF6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:58:33 -0500
MIME-Version: 1.0
In-Reply-To: <20141202050406.GC953@thunk.org>
References: <20141202021912.GA29096@thunk.org>
	<20141201214104.32d3f10d@gandalf.local.home>
	<CAMEtUuzEg39N9ZALuq-u4X+oaNJGqL6G05UABSHYpejQ78Cp3Q@mail.gmail.com>
	<20141202050406.GC953@thunk.org>
Date: Mon, 1 Dec 2014 21:58:32 -0800
Message-ID: <CAMEtUuyyrUToWgczxdpj+SUEdr16NknQa_ZmWoGr8f261kyqmg@mail.gmail.com>
Subject: Re: Checking to see if a bit is _not_ set in a ftrace event filter
From: Alexei Starovoitov <ast@plumgrid.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 9:04 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Dec 01, 2014 at 07:52:11PM -0800, Alexei Starovoitov wrote:
>
>> It will change the workflow for folks who use 'echo expr > filter'
>> directly. trace-cmd -e -f can be made to work transparently
>> with new features.
>
> This will break a bunch of **really** useful scripts found at:

I didn't mean that new features will break old. All existing filters
will stay as-is.

>> One of the goals for eBPF+tracing is to minimize
>> additions of new tracepoints. Right now we already
>> have a ton of them. events/ext4.h is ~2500 lines.
>> Some of them look like hooks for in-production
>> debugging of a function at a time. Sort of like poor's man
>> kprobe/kretprobe.
>
> Well, except that kprobe and kretprobe can't give me the arguments
> passed into the function (unless you compile with full -g debugging
> info enabled and bloat the object files and compilation time by a
> factor of 10 --- which I can't stand and why I use ftrace instead of
> systemtap :-)

well, dwarf is only needed if you have > 6 function
arguments in x64, since x64 ABI promotes scalars
to 64-bit and passes first six args in registers, so it's
trivial to know where arguments are even without debug info.
Similar situation is on most 64-bit risc archs.
dwarf is needed when one wants to see a value of
local C variable somewhere in the middle of the function,
but it's not common and rarely works in practice, since
var-tracking is not easy for compilers.

Another reason people say that dwarf is 'must have'
is to access struct fields. The 'inode->i_state' dereference
would require stap to use dwarf to know the offset of 'i_state'.
For eBPF we don't need debug info in such case,
since C compiler does it for us.
We can just do 'offsetof(typeof(*inode), i_state)'
as part of eBPF C program and llvm will figure out
correct field offset during compile time of eBPF program.
(for this to work, one need to have matching kernel
headers).

> If eBPF can solve the ability to be able to get at the critical
> function variables ...

If 'critical' function variables are arguments or variables
accessible via pointer walking (like inode->i_sb->s_fs_info)
then eBPF with kernel headers will do the job.
(For arguments only no headers needed)

> But that's why I have the trace_func_enter() and trace_func_exit()
> calls; I need to be able to get do various run-time debugging without
> needing to recompile the kernel and without forcing all of my
> development builds to have full debug info.

Understood. Thanks for sharing!
