Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbaBFSrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:47:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:40941 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751352AbaBFSrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:47:41 -0500
Date: Thu, 6 Feb 2014 13:47:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Li Zefan <lizefan@huawei.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 4/4] perf/events: Use helper functions in event
 assignment to shrink macro size
Message-ID: <20140206134739.4d8b235d@gandalf.local.home>
In-Reply-To: <20140206181109.376046894@goodmis.org>
References: <20140206173910.029355947@goodmis.org>
	<20140206181109.376046894@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Feb 2014 12:39:14 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> The functions that assign the contents for the perf software events are
> defined by the TRACE_EVENT() macros. Each event has its own unique
> way to assign data to its buffer. When you have over 500 events,
> that means there's 500 functions assigning data uniquely for each
> event.
> 
> By making helper functions in the core kernel to do the work
> instead, we can shrink the size of the kernel down a bit.
> 
> With a kernel configured with 707 events, the change in size was:
> 
>    text    data     bss     dec     hex filename
> 12959102        1913504 9785344 24657950        178401e /tmp/vmlinux
> 12917629        1913568 9785344 24616541        1779e5d /tmp/vmlinux.patched
> 
> That's a total of 41473 bytes, which comes down to 82 bytes per event.
> 
> Note, most of the savings comes from moving the setup and final submit
> into helper functions, where the setup does the work and stores the
> data into a structure, and that structure is passed to the submit function,
> moving the setup of the parameters of perf_trace_buf_submit().
> 
> Link: http://lkml.kernel.org/r/20120810034708.589220175@goodmis.org
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>

Peter, Frederic,

Can you give an ack to this. Peter, you pretty much gave you ack before
except for one nit:

http://marc.info/?l=linux-kernel&m=134484533217124&w=2

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace_event.h    | 17 ++++++++++++++
>  include/trace/ftrace.h          | 33 ++++++++++----------------
>  kernel/trace/trace_event_perf.c | 51 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 80 insertions(+), 21 deletions(-)
> 

> +
> +/**
> + * perf_trace_event_submit - submit from perf sw event
> + * @pe: perf event structure that holds all the necessary data
> + *
> + * This is a helper function that removes a lot of the setting up of
> + * the function parameters to call perf_trace_buf_submit() from the
> + * inlined code. Using the perf event structure @pe to store the
> + * information passed from perf_trace_event_setup() keeps the overhead
> + * of building the function call paremeters out of the inlined functions.
> + */
> +void perf_trace_event_submit(struct perf_trace_event *pe)
> +{
> +	perf_trace_buf_submit(pe->entry, pe->entry_size, pe->rctx, pe->addr,
> +			      pe->count, &pe->regs, pe->head, pe->task);
> +}
> +EXPORT_SYMBOL_GPL(perf_trace_event_submit);
> +

You wanted the perf_trace_buf_submit() to go away. Now I could do that,
bu that would require all other users to use the new perf_trace_event
structure to pass in. The only reason I did that was because this
structure is set up in perf_trace_event_setup() which passes in only
the event_call and the pe structure. In the setup function, the pe
structure is assigned all the information required for
perf_trace_event_submit().

What this does is to remove the function parameter setup from the
inlined tracepoint callers, which is quite a lot!

This is what a perf tracepoint currently looks like:

0000000000000b44 <perf_trace_sched_pi_setprio>:
     b44:	55                   	push   %rbp
     b45:	48 89 e5             	mov    %rsp,%rbp
     b48:	41 56                	push   %r14
     b4a:	41 89 d6             	mov    %edx,%r14d
     b4d:	41 55                	push   %r13
     b4f:	49 89 fd             	mov    %rdi,%r13
     b52:	41 54                	push   %r12
     b54:	49 89 f4             	mov    %rsi,%r12
     b57:	53                   	push   %rbx
     b58:	48 81 ec c0 00 00 00 	sub    $0xc0,%rsp
     b5f:	48 8b 9f 80 00 00 00 	mov    0x80(%rdi),%rbx
     b66:	e8 00 00 00 00       	callq  b6b <perf_trace_sched_pi_setprio+0x27>
			b67: R_X86_64_PC32	debug_smp_processor_id-0x4
     b6b:	89 c0                	mov    %eax,%eax
     b6d:	48 03 1c c5 00 00 00 	add    0x0(,%rax,8),%rbx
     b74:	00 
			b71: R_X86_64_32S	__per_cpu_offset
     b75:	48 83 3b 00          	cmpq   $0x0,(%rbx)
     b79:	0f 84 92 00 00 00    	je     c11 <perf_trace_sched_pi_setprio+0xcd>
     b7f:	48 8d bd 38 ff ff ff 	lea    -0xc8(%rbp),%rdi
     b86:	e8 ab fe ff ff       	callq  a36 <perf_fetch_caller_regs>
     b8b:	41 8b 75 40          	mov    0x40(%r13),%esi
     b8f:	48 8d 8d 34 ff ff ff 	lea    -0xcc(%rbp),%rcx
     b96:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
     b9d:	bf 24 00 00 00       	mov    $0x24,%edi
     ba2:	81 e6 ff ff 00 00    	and    $0xffff,%esi
     ba8:	e8 00 00 00 00       	callq  bad <perf_trace_sched_pi_setprio+0x69>
			ba9: R_X86_64_PC32	perf_trace_buf_prepare-0x4
     bad:	48 85 c0             	test   %rax,%rax
     bb0:	74 5f                	je     c11 <perf_trace_sched_pi_setprio+0xcd>
     bb2:	49 8b 94 24 b0 04 00 	mov    0x4b0(%r12),%rdx
     bb9:	00 
     bba:	4c 8d 85 38 ff ff ff 	lea    -0xc8(%rbp),%r8
     bc1:	49 89 d9             	mov    %rbx,%r9
     bc4:	b9 24 00 00 00       	mov    $0x24,%ecx
     bc9:	be 01 00 00 00       	mov    $0x1,%esi
     bce:	31 ff                	xor    %edi,%edi
     bd0:	48 89 50 08          	mov    %rdx,0x8(%rax)
     bd4:	49 8b 94 24 b8 04 00 	mov    0x4b8(%r12),%rdx
     bdb:	00 
     bdc:	48 89 50 10          	mov    %rdx,0x10(%rax)
     be0:	41 8b 94 24 0c 03 00 	mov    0x30c(%r12),%edx
     be7:	00 
     be8:	89 50 18             	mov    %edx,0x18(%rax)
     beb:	41 8b 54 24 50       	mov    0x50(%r12),%edx
     bf0:	44 89 70 20          	mov    %r14d,0x20(%rax)
     bf4:	89 50 1c             	mov    %edx,0x1c(%rax)
     bf7:	8b 95 34 ff ff ff    	mov    -0xcc(%rbp),%edx
     bfd:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
     c04:	00 00 
     c06:	89 14 24             	mov    %edx,(%rsp)
     c09:	48 89 c2             	mov    %rax,%rdx
     c0c:	e8 00 00 00 00       	callq  c11 <perf_trace_sched_pi_setprio+0xcd>
			c0d: R_X86_64_PC32	perf_tp_event-0x4
     c11:	48 81 c4 c0 00 00 00 	add    $0xc0,%rsp
     c18:	5b                   	pop    %rbx
     c19:	41 5c                	pop    %r12
     c1b:	41 5d                	pop    %r13
     c1d:	41 5e                	pop    %r14
     c1f:	5d                   	pop    %rbp
     c20:	c3                   	retq   


This is what it looks like after this patch:

0000000000000ab1 <perf_trace_sched_pi_setprio>:
     ab1:	55                   	push   %rbp
     ab2:	48 89 e5             	mov    %rsp,%rbp
     ab5:	41 54                	push   %r12
     ab7:	41 89 d4             	mov    %edx,%r12d
     aba:	53                   	push   %rbx
     abb:	48 89 f3             	mov    %rsi,%rbx
     abe:	48 8d b5 08 ff ff ff 	lea    -0xf8(%rbp),%rsi
     ac5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
     acc:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
     ad3:	00 
     ad4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%rbp)
     adb:	c7 45 e0 24 00 00 00 	movl   $0x24,-0x20(%rbp)
     ae2:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
     ae9:	00 
     aea:	48 c7 45 d8 01 00 00 	movq   $0x1,-0x28(%rbp)
     af1:	00 
     af2:	e8 00 00 00 00       	callq  af7 <perf_trace_sched_pi_setprio+0x46>
			af3: R_X86_64_PC32	perf_trace_event_setup-0x4
     af7:	48 85 c0             	test   %rax,%rax
     afa:	74 35                	je     b31 <perf_trace_sched_pi_setprio+0x80>
     afc:	48 8b 93 b0 04 00 00 	mov    0x4b0(%rbx),%rdx
     b03:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
     b0a:	48 89 50 08          	mov    %rdx,0x8(%rax)
     b0e:	48 8b 93 b8 04 00 00 	mov    0x4b8(%rbx),%rdx
     b15:	48 89 50 10          	mov    %rdx,0x10(%rax)
     b19:	8b 93 0c 03 00 00    	mov    0x30c(%rbx),%edx
     b1f:	89 50 18             	mov    %edx,0x18(%rax)
     b22:	8b 53 50             	mov    0x50(%rbx),%edx
     b25:	44 89 60 20          	mov    %r12d,0x20(%rax)
     b29:	89 50 1c             	mov    %edx,0x1c(%rax)
     b2c:	e8 00 00 00 00       	callq  b31 <perf_trace_sched_pi_setprio+0x80>
			b2d: R_X86_64_PC32	perf_trace_event_submit-0x4
     b31:	48 81 c4 f0 00 00 00 	add    $0xf0,%rsp
     b38:	5b                   	pop    %rbx
     b39:	41 5c                	pop    %r12
     b3b:	5d                   	pop    %rbp
     b3c:	c3                   	retq   


Thus, it's not really just a wrapper function, but a function that is
paired with the tracepoint setup version.

-- Steve
