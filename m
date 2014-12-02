Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaLBFEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:04:14 -0500
Received: from imap.thunk.org ([74.207.234.97]:33559 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaLBFEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:04:12 -0500
Date: Tue, 2 Dec 2014 00:04:06 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Checking to see if a bit is _not_ set in a ftrace event filter
Message-ID: <20141202050406.GC953@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Alexei Starovoitov <ast@plumgrid.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20141202021912.GA29096@thunk.org>
 <20141201214104.32d3f10d@gandalf.local.home>
 <CAMEtUuzEg39N9ZALuq-u4X+oaNJGqL6G05UABSHYpejQ78Cp3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuzEg39N9ZALuq-u4X+oaNJGqL6G05UABSHYpejQ78Cp3Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 07:52:11PM -0800, Alexei Starovoitov wrote:
> Ted, I don't see 'writeback_mark_inode_dirty' event
> in the tree. Some new stuff?

Yep, see:

http://thread.gmane.org/gmane.comp.file-systems.ext4/47092

Except instead of the mini-script which I gave in the above URL, I
wanted to do additional filtering.  The current hack which I am using
instead of:

echo "flags == 2048" > events/writeback/writeback_mark_inode_dirty/filter

is:

echo "(flags == 2048) && (state < 2048)" > events/writeback/writeback_mark_inode_dirty/filter

... but this relies on the fact that all of the i_state bits that I
care about are at positions 1 << 10 and below.  i.e., it's a terrible
hack.

> What kind of post-filtering are you doing with this event?
> Just visually checking that trace is sane or the trace output
> is fed into other tools? Are you trying to aggregate or
> correlate multiple events (may be based on 'ino') ?

I plan to write some tools that agregate based on 'ino', but I haven't
yet.

> It will change the workflow for folks who use 'echo expr > filter'
> directly. trace-cmd -e -f can be made to work transparently
> with new features.

This will break a bunch of **really** useful scripts found at:

	https://github.com/brendangregg/perf-tools.git

OTOH, Brendan will probably will be able to rewrite them to take
advantage of the new interfaces, and I'm sure he'll appreciate the
power of being able to use eBPF.  :-)

> One of the goals for eBPF+tracing is to minimize
> additions of new tracepoints. Right now we already
> have a ton of them. events/ext4.h is ~2500 lines.
> Some of them look like hooks for in-production
> debugging of a function at a time. Sort of like poor's man
> kprobe/kretprobe.

Well, except that kprobe and kretprobe can't give me the arguments
passed into the function (unless you compile with full -g debugging
info enabled and bloat the object files and compilation time by a
factor of 10 --- which I can't stand and why I use ftrace instead of
systemtap :-)

> With eBPF we should be able to avoid adding
> trace_func_enter(), trace_func_exit() to so many func.

If eBPF can solve the ability to be able to get at the critical
function variables without making the compiled kernel take 10x the
disk space and time to compile (mostly due to the time to write out
the !@#!@?! bloated object files), that would be great.  My
understanding though is that this fundamentally requires improved
DWARF compression and structure information deduping, which the
systemtap folks promised would be coming in improved compiler
toolchains many years ago, but as far as I know has never
materialized.  :-(

But that's why I have the trace_func_enter() and trace_func_exit()
calls; I need to be able to get do various run-time debugging without
needing to recompile the kernel and without forcing all of my
development builds to have full debug info.

					- Ted
