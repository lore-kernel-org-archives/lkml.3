Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3LCE3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 23:29:09 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63923 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab3LCE25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 23:28:57 -0500
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH tip 0/5] tracing filters with BPF
Date: Mon,  2 Dec 2013 20:28:45 -0800
Message-Id: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

the following set of patches adds BPF support to trace filters.

Trace filters can be written in C and allow safe read-only access to any
kernel data structure. Like systemtap but with safety guaranteed by kernel.

The user can do:
cat bpf_program > /sys/kernel/debug/tracing/.../filter
if tracing event is either static or dynamic via kprobe_events.

The filter program may look like:
void filter(struct bpf_context *ctx)
{
        char devname[4] = "eth5";
        struct net_device *dev;
        struct sk_buff *skb = 0;

        dev = (struct net_device *)ctx->regs.si;
        if (bpf_memcmp(dev->name, devname, 4) == 0) {
                char fmt[] = "skb %p dev %p eth5\n";
                bpf_trace_printk(fmt, skb, dev, 0, 0);
        }
}

The kernel will do static analysis of bpf program to make sure that it cannot
crash the kernel (doesn't have loops, valid memory/register accesses, etc).
Then kernel will map bpf instructions to x86 instructions and let it
run in the place of trace filter.

To demonstrate performance I did a synthetic test:
        dev = init_net.loopback_dev;
        do_gettimeofday(&start_tv);
        for (i = 0; i < 1000000; i++) {
                struct sk_buff *skb;
                skb = netdev_alloc_skb(dev, 128);
                kfree_skb(skb);
        }
        do_gettimeofday(&end_tv);
        time = end_tv.tv_sec - start_tv.tv_sec;
        time *= USEC_PER_SEC;
        time += (long long)((long)end_tv.tv_usec - (long)start_tv.tv_usec);

        printk("1M skb alloc/free %lld (usecs)\n", time);

no tracing
[   33.450966] 1M skb alloc/free 145179 (usecs)

echo 1 > enable
[   97.186379] 1M skb alloc/free 240419 (usecs)
(tracing slows down kfree_skb() due to event_buffer_lock/buffer_unlock_commit)

echo 'name==eth5' > filter
[  139.644161] 1M skb alloc/free 302552 (usecs)
(running filter_match_preds() for every skb and discarding
event_buffer is even slower)

cat bpf_prog > filter
[  171.150566] 1M skb alloc/free 199463 (usecs)
(JITed bpf program is safely checking dev->name == eth5 and discarding)

echo 0 > enable
[  258.073593] 1M skb alloc/free 144919 (usecs)
(tracing is disabled, performance is back to original)

The C program compiled into BPF and then JITed into x86 is faster than
filter_match_preds() approach (199-145 msec vs 302-145 msec)

tracing+bpf is a tool for safe read-only access to variables without recompiling
the kernel and without affecting running programs.

BPF filters can be written manually (see tools/bpf/trace/filter_ex1.c)
or better compiled from restricted C via GCC or LLVM

Q: What is the difference between existing BPF and extended BPF?
A:
Existing BPF insn from uapi/linux/filter.h
struct sock_filter {
        __u16   code;   /* Actual filter code */
        __u8    jt;     /* Jump true */
        __u8    jf;     /* Jump false */
        __u32   k;      /* Generic multiuse field */
};

Extended BPF insn from linux/bpf.h
struct bpf_insn {
        __u8    code;    /* opcode */
        __u8    a_reg:4; /* dest register*/
        __u8    x_reg:4; /* source register */
        __s16   off;     /* signed offset */
        __s32   imm;     /* signed immediate constant */
};

opcode encoding is the same between old BPF and extended BPF.
Original BPF has two 32-bit registers.
Extended BPF has ten 64-bit registers.
That is the main difference.

Old BPF was using jt/jf fields for jump-insn only.
New BPF combines them into generic 'off' field for jump and non-jump insns.
k==imm field has the same meaning.

Thanks

Alexei Starovoitov (5):
  Extended BPF core framework
  Extended BPF JIT for x86-64
  Extended BPF (64-bit BPF) design document
  use BPF in tracing filters
  tracing filter examples in BPF

 Documentation/bpf_jit.txt            |  204 +++++++
 arch/x86/Kconfig                     |    1 +
 arch/x86/net/Makefile                |    1 +
 arch/x86/net/bpf64_jit_comp.c        |  625 ++++++++++++++++++++
 arch/x86/net/bpf_jit_comp.c          |   23 +-
 arch/x86/net/bpf_jit_comp.h          |   35 ++
 include/linux/bpf.h                  |  149 +++++
 include/linux/bpf_jit.h              |  129 +++++
 include/linux/ftrace_event.h         |    3 +
 include/trace/bpf_trace.h            |   27 +
 include/trace/ftrace.h               |   14 +
 kernel/Makefile                      |    1 +
 kernel/bpf_jit/Makefile              |    3 +
 kernel/bpf_jit/bpf_check.c           | 1054 ++++++++++++++++++++++++++++++++++
 kernel/bpf_jit/bpf_run.c             |  452 +++++++++++++++
 kernel/trace/Kconfig                 |    1 +
 kernel/trace/Makefile                |    1 +
 kernel/trace/bpf_trace_callbacks.c   |  191 ++++++
 kernel/trace/trace.c                 |    7 +
 kernel/trace/trace.h                 |   11 +-
 kernel/trace/trace_events.c          |    9 +-
 kernel/trace/trace_events_filter.c   |   61 +-
 kernel/trace/trace_kprobe.c          |    6 +
 lib/Kconfig.debug                    |   15 +
 tools/bpf/llvm/README.txt            |    6 +
 tools/bpf/trace/Makefile             |   34 ++
 tools/bpf/trace/README.txt           |   15 +
 tools/bpf/trace/filter_ex1.c         |   52 ++
 tools/bpf/trace/filter_ex1_orig.c    |   23 +
 tools/bpf/trace/filter_ex2.c         |   74 +++
 tools/bpf/trace/filter_ex2_orig.c    |   47 ++
 tools/bpf/trace/trace_filter_check.c |   82 +++
 32 files changed, 3332 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/bpf_jit.txt
 create mode 100644 arch/x86/net/bpf64_jit_comp.c
 create mode 100644 arch/x86/net/bpf_jit_comp.h
 create mode 100644 include/linux/bpf.h
 create mode 100644 include/linux/bpf_jit.h
 create mode 100644 include/trace/bpf_trace.h
 create mode 100644 kernel/bpf_jit/Makefile
 create mode 100644 kernel/bpf_jit/bpf_check.c
 create mode 100644 kernel/bpf_jit/bpf_run.c
 create mode 100644 kernel/trace/bpf_trace_callbacks.c
 create mode 100644 tools/bpf/llvm/README.txt
 create mode 100644 tools/bpf/trace/Makefile
 create mode 100644 tools/bpf/trace/README.txt
 create mode 100644 tools/bpf/trace/filter_ex1.c
 create mode 100644 tools/bpf/trace/filter_ex1_orig.c
 create mode 100644 tools/bpf/trace/filter_ex2.c
 create mode 100644 tools/bpf/trace/filter_ex2_orig.c
 create mode 100644 tools/bpf/trace/trace_filter_check.c

-- 
1.7.9.5

