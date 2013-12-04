Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3LDBLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:11:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:57598 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754677Ab3LDBLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:11:36 -0500
Date: Tue, 3 Dec 2013 20:11:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC PATCH tip 4/5] use BPF in tracing filters
Message-ID: <20131203201133.52934a02@gandalf.local.home>
In-Reply-To: <529E7BEC.70509@hitachi.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<1386044930-15149-5-git-send-email-ast@plumgrid.com>
	<529E7BEC.70509@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Dec 2013 09:48:44 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/12/03 13:28), Alexei Starovoitov wrote:
> > Such filters can be written in C and allow safe read-only access to
> > any kernel data structure.
> > Like systemtap but with safety guaranteed by kernel.
> > 
> > The user can do:
> > cat bpf_program > /sys/kernel/debug/tracing/.../filter
> > if tracing event is either static or dynamic via kprobe_events.
> > 
> > The program can be anything as long as bpf_check() can verify its safety.
> > For example, the user can create kprobe_event on dst_discard()
> > and use logically following code inside BPF filter:
> >       skb = (struct sk_buff *)ctx->regs.di;
> >       dev = bpf_load_pointer(&skb->dev);
> > to access 'struct net_device'
> > Since its prototype is 'int dst_discard(struct sk_buff *skb);'
> > 'skb' pointer is in 'rdi' register on x86_64
> > bpf_load_pointer() will try to fetch 'dev' field of 'sk_buff'
> > structure and will suppress page-fault if pointer is incorrect.
> 
> Hmm, I doubt it is a good way to integrate with ftrace.
> I prefer to use this for replacing current ftrace filter,

I'm not sure how we can do that. Especially since the bpf is very arch
specific, and the current filters work for all archs.

> fetch functions and actions. In that case, we can continue
> to use current interface but much faster to trace.
> Also, we can see what filter/arguments/actions are set
> on each event.

There's also the problem that the current filters work with the results
of what is written to the buffer, not what is passed in by the trace
point, as that isn't even displayed to the user.

For example, sched_switch gets passed struct task_struct *prev, and
*next, from that we save prev_comm, prev_pid, prev_prio, prev_state,
next_comm, next_prio and next_state. These are expressed to the user
by the format file of the event:

	field:char prev_comm[32];	offset:16;
	size:16;	signed:1; field:pid_t prev_pid;
	offset:32;	size:4;	signed:1; field:int
	prev_prio;	offset:36;	size:4;	signed:1;
	field:long prev_state;	offset:40;	size:8;
	signed:1; field:char next_comm[32];	offset:48;
	size:16;	signed:1; field:pid_t next_pid;
	offset:64;	size:4;	signed:1; field:int
	next_prio;	offset:68;	size:4; signed:1;

And the filters can check "next_prio > 10" and what not. The bpf
program needs to access next->prio. There's nothing that shows the user
what is passed to the tracepoint, and from that, what structure member
to use from there. The user would be required to look at the source
code of the given kernel. A requirement not needed by the current
implementation.

Also, there's results that can not be trivially converted. Taking a
quick look at some TRACE_EVENT() structures, I found bcache_bio that
has this:

        TP_fast_assign(
                __entry->dev            = bio->bi_bdev->bd_dev;
                __entry->sector         = bio->bi_sector;
                __entry->nr_sector      = bio->bi_size >> 9;
                blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
        ),

Where the blk_fill_rwbs() updates the status of the entry->rwbs based
on the bi_rw field. A filter must remain backward compatible to
something like:

	rwbs == "w"  or rwbs =~ '*w*'


Now maybe we can make the filter code use some of the bpf if possible,
but to get the result, it still needs to write to the ring buffer, and
discard it if it is incorrect. Which will not make it any faster than
the original trace, but perhaps faster than the trace + current filter.

The speed up that was shown was because we were processing the
parameters of the trace point and not the result. That currently
requires the user to have full access to the source of the kernel they
are tracing.

-- Steve
