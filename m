Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3CAFbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:31:33 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:37437 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3CAFbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:31:31 -0500
Date: Fri, 1 Mar 2013 11:01:23 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: linux-kernel@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: kprobing "hash_64.constprop.26" crashes the system, recursion
	through get_kprobe?
Message-ID: <20130301053123.GA30500@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <84ehg2jdny.fsf@sauna.l.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84ehg2jdny.fsf@sauna.l.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030105-3620-0000-0000-0000016C64D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:42:41AM +0200, Timo Juhani Lindfors wrote:
> 
> There is a long-standing problem in the systemtap community where
> accidentally kprobing a delicate function causes the system to crash:
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=604453
> http://sourceware.org/bugzilla/show_bug.cgi?id=2725
> https://bugzilla.redhat.com/show_bug.cgi?id=655904
> http://sourceware.org/bugzilla/show_bug.cgi?id=13659
> 
> The current solution is to mark these functions with __kprobes that
> places them to a separate kprobe-free section (from __kprobes_text_start
> to __kprobes_text_end). This has the nice side effect that also inlined
> copies of innocent functions can not be kprobed when they are called
> from functions marked with __kprobes.
> 
> Now, hash_64 is marked "inline" but this is only a hint for the
> compiler. On my Debian unstable system (Linux 3.7.3-1~experimental.1)
> hash_64 actually exists in six different places thanks to the GCC
> ipa-cp (interprocedural constant propagation) optimization:

I am unable to recreate this problem on a fedora system; hash_64 is
inlined AFAICS.

> crashes the system. I used the "xm dump-core" facility of xen to dump
> the memory of the domU and obtained the following bactrace using
> "crash vm.img /usr/lib/debug/boot/vmlinux-3.7-trunk-amd64" and
> "for bt":
> 
> PID: 3007   TASK: ffff88003b9bb840  CPU: 0   COMMAND: "insmod"
>  #0 [ffff88003db99998] __schedule at ffffffff813777f8
>  #1 [ffff88003db999a8] hash_64.constprop.26 at ffffffff81099909
>  #2 [ffff88003db999d0] get_kprobe at ffffffff8137c5bb
>  #3 [ffff88003db999e0] kprobe_exceptions_notify at ffffffff8137a3c1
>  #4 [ffff88003db99a40] notifier_call_chain at ffffffff8137b5a3
>  #5 [ffff88003db99a80] notify_die at ffffffff8137b60c
>  #6 [ffff88003db99ab0] do_int3 at ffffffff81378fa0
>  #7 [ffff88003db99ad0] xen_int3 at ffffffff8137887e
>     [exception RIP: hash_64.constprop.26+1]
>     RIP: ffffffff81099909  RSP: ffff88003db99b80  RFLAGS: 00000086
>     RAX: 0000000000000000  RBX: ffffffff81099908  RCX: 00000000ffffffff
>     RDX: ffff88003db99c38  RSI: 0000000000000002  RDI: ffffffff81099908
>     RBP: 0000000000000002   R8: 0000000000000000   R9: ffffffff81629b10
>     R10: 00000000000066a8  R11: ffffffffa016a000  R12: ffff88003f80dd90
>     R13: ffffffff81099908  R14: ffffffff81099909  R15: ffffffffa016a010
>     ORIG_RAX: ffffffffffffffff  CS: 10000e030  SS: e02b
>  #8 [ffff88003db99b80] get_kprobe at ffffffff8137c5bb
>  #9 [ffff88003db99b90] kprobe_exceptions_notify at ffffffff8137a3c1
> #10 [ffff88003db99bf0] notifier_call_chain at ffffffff8137b5a3
> #11 [ffff88003db99c30] notify_die at ffffffff8137b60c
> #12 [ffff88003db99c60] do_int3 at ffffffff81378fa0
> #13 [ffff88003db99c80] xen_int3 at ffffffff8137887e
>     [exception RIP: hash_64.constprop.26+1]
>     RIP: ffffffff81099909  RSP: ffff88003db99d30  RFLAGS: 00000246
>     RAX: 0000000000000000  RBX: ffffffff81099908  RCX: ffffffffa0000521
>     RDX: ffffffff81099908  RSI: ffffffff81099908  RDI: ffffffff81099908
>     RBP: ffff88003db99e10   R8: 000000000000140b   R9: ffffffff81099908
>     R10: 00000000000066a8  R11: ffffffffa016a000  R12: ffffffff81099908
>     R13: ffffffff81099903  R14: 0000000000000000  R15: ffffffffa016a010
>     ORIG_RAX: ffffffffffffffff  CS: e030  SS: e02b
> #14 [ffff88003db99d30] get_kprobe at ffffffff8137c5bb
> #15 [ffff88003db99d40] __recover_optprobed_insn at ffffffff8102d4d4
> #16 [ffff88003db99d70] recover_probed_instruction at ffffffff8102d479
> #17 [ffff88003db99d90] can_optimize at ffffffff8137a952
> #18 [ffff88003db99e50] arch_prepare_optimized_kprobe at ffffffff8137ab2c
> #19 [ffff88003db99ea0] alloc_aggr_kprobe.isra.17 at ffffffff8137bb9b
> #20 [ffff88003db99ec0] register_kprobe at ffffffff8137cf16
> #21 [ffff88003db99f00] init_module at ffffffffa000600d [testcase1]
> #22 [ffff88003db99f10] do_one_initcall at ffffffff810020b6
> #23 [ffff88003db99f40] sys_init_module at ffffffff81083c4f
> #24 [ffff88003db99f80] system_call_fastpath at ffffffff8137d6e9
>     RIP: 00007f4aef62414a  RSP: 00007fffbd2e9d08  RFLAGS: 00000202
>     RAX: 00000000000000af  RBX: ffffffff8137d6e9  RCX: 00007f4aef62048a
>     RDX: 00007f4aef8e3f68  RSI: 000000000002b833  RDI: 00007f4aefcca000
>     RBP: 00007f4af0a391a0   R8: 0000000000000003   R9: 0000000000000000
>     R10: 00007f4aef62048a  R11: 0000000000000202  R12: 00007f4aef8e3f68
>     R13: 00007f4af0a39270  R14: 00007f4af0a38090  R15: 0000000000000000
>     ORIG_RAX: 00000000000000af  CS: e033  SS: e02b
> 
> 
> It seems that the recursion occurs even before register_kprobe
> returns. I am not sure how this should be solved. Should we mark hash_64
> with __kprobes? Or perhaps with __attribute__((always_inline))?

This is a clear case of recursion. Either of the two options should fix
the problem.

Ananth

