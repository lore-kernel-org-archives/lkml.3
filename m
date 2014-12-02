Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbaLBDwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 22:52:14 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:63891 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbaLBDwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 22:52:13 -0500
MIME-Version: 1.0
In-Reply-To: <20141201214104.32d3f10d@gandalf.local.home>
References: <20141202021912.GA29096@thunk.org>
	<20141201214104.32d3f10d@gandalf.local.home>
Date: Mon, 1 Dec 2014 19:52:11 -0800
Message-ID: <CAMEtUuzEg39N9ZALuq-u4X+oaNJGqL6G05UABSHYpejQ78Cp3Q@mail.gmail.com>
Subject: Re: Checking to see if a bit is _not_ set in a ftrace event filter
From: Alexei Starovoitov <ast@plumgrid.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 6:41 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 1 Dec 2014 21:19:12 -0500
> Theodore Ts'o <tytso@mit.edu> wrote:
>
>> I was trying to do something like this:
>>
>> filter="events/writeback/writeback_mark_inode_dirty/filter"
>> echo "(flags & 2048) && ((state & 2048) == 0)" > $filter
>>
>> ... but that doesn't work.
>>
>> This works:
>>
>> echo "flags & 2048" > $filter
>>
>> But the problem is this:
>>
>> echo "(state & 2048) == 0" > $filter
>>
>> The simplest patch to add this would be add a new filter_ops so we
>> could do this:
>>
>> echo "(state !& 2048)" > $filter
>>
>> ... but that's pretty ugly.  But adding more general expression
>> parsing in the ftrace event filter code would be non-trivial, and if
>> we start trying to make things like "!(state & 2048)" or "(state &
>> 2048) == 0", then at some point some crazy person might request
>> supporting something like this: "(state ^ flags) == 2048".  :-)
>>
>> So I guess the main question I want to ask is your opinion about
>> whether a patch that adds support for the operator "!&" is too ugly to
>> live?
>>
>
> Yeah, I don't want to add some bastardization compare that we'll be
> stuck with till the end of time. Either we modify the tree walk to
> handle values (it shouldn't be too difficult, but it wont be trivial),
> or we wait till eBPF is up and running as the trace filter replacement
> and that should be able to handle this much better.

yeah. teaching tree walk to do (state & 2048) == 0 is not trivial,
since it doesn't have a concept of value of expression.
Doing !(state & 2048) is probably a bit easier, since there
are hacks for 'not' already.
Another alternative is, of course, to wait little bit for
eBPF+tracing to land ;) All the core pieces
(verifier, bpf syscall, maps) are in net-next already,
so in the next dev cycle we can get tracing bits
reviewed/tested/merged without cross-tree conflicts.
All parsing and code generation will be done by user space,
so all complex expression will be supported.
It will change the workflow for folks who use 'echo expr > filter'
directly. trace-cmd -e -f can be made to work transparently
with new features.
Ted, I don't see 'writeback_mark_inode_dirty' event
in the tree. Some new stuff?
What kind of post-filtering are you doing with this event?
Just visually checking that trace is sane or the trace output
is fed into other tools? Are you trying to aggregate or
correlate multiple events (may be based on 'ino') ?
One of the goals for eBPF+tracing is to minimize
additions of new tracepoints. Right now we already
have a ton of them. events/ext4.h is ~2500 lines.
Some of them look like hooks for in-production
debugging of a function at a time. Sort of like poor's man
kprobe/kretprobe.
With eBPF we should be able to avoid adding
trace_func_enter(), trace_func_exit() to so many func.
