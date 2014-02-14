Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaBNOrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:47:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55045 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbaBNOrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:47:10 -0500
Date: Fri, 14 Feb 2014 15:47:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
Message-ID: <20140214144700.GC26356@pd.tnic>
References: <20140212103713.GE3545@laptop.programming.kicks-ass.net>
 <20140212104017.GA5121@pd.tnic>
 <52FB5669.7090506@canonical.com>
 <20140212115412.GW27965@twins.programming.kicks-ass.net>
 <52FCFA23.4060701@canonical.com>
 <20140213173852.GH6835@laptop.programming.kicks-ass.net>
 <52FD090C.7010408@canonical.com>
 <20140213182605.GC14089@laptop.programming.kicks-ass.net>
 <20140214133428.GB26356@pd.tnic>
 <52FE2709.3050505@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52FE2709.3050505@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 03:24:09PM +0100, Stefan Bader wrote:
> Actually, this code just makes so much more sense if I let objdump do
> relocation info...

Ok, we're pretty sure you have an MFENCE there in resched_task but can
you confirm it please.

First, does /proc/cpuinfo have the "sse2" string? It should but nowadays
I don't trust anything.

Then, can you boot that kernel in qemu with the -gdb flag so that it
starts the gdb stub, here's the manpage about it:

       -gdb dev
           Wait for gdb connection on device dev. Typical connections will likely be
           TCP-based, but also UDP, pseudo TTY, or even stdio are reasonable use case.
           The latter is allowing to start QEMU from within gdb and establish the
           connection via a pipe:

                   (gdb) target remote | exec qemu-system-i386 -gdb stdio ...

       -s  Shorthand for -gdb tcp::1234, i.e. open a gdbserver on TCP port 1234.

then boot the guest and when it is up, do

$ gdb ./vmlinux
$ target remote localhost:1234

and type in the prompt

$ (gdb) x/50i resched_task

It gives here:

(gdb) x/50i resched_task
   0xffffffff810836f0 <resched_task>:   data32 data32 data32 xchg %ax,%ax
   0xffffffff810836f5 <resched_task+5>: push   %rbp
   0xffffffff810836f6 <resched_task+6>: mov    0x85e123(%rip),%r10d        # 0xffffffff818e1820 <debug_locks>
   0xffffffff810836fd <resched_task+13>:        mov    %rsp,%rbp
   0xffffffff81083700 <resched_task+16>:        push   %r12
   0xffffffff81083702 <resched_task+18>:        test   %r10d,%r10d
   0xffffffff81083705 <resched_task+21>:        push   %rbx
   0xffffffff81083706 <resched_task+22>:        mov    %rdi,%rbx
   0xffffffff81083709 <resched_task+25>:        jne    0xffffffff81083760 <resched_task+112>
   0xffffffff8108370b <resched_task+27>:        mov    0x8(%rbx),%rax
   0xffffffff8108370f <resched_task+31>:        mov    0x10(%rax),%rdx
   0xffffffff81083713 <resched_task+35>:        and    $0x8,%edx
   0xffffffff81083716 <resched_task+38>:        jne    0xffffffff8108373c <resched_task+76>
   0xffffffff81083718 <resched_task+40>:        lock orb $0x8,0x10(%rax)
   0xffffffff8108371d <resched_task+45>:        mov    0x8(%rbx),%rax
   0xffffffff81083721 <resched_task+49>:        mov    0x18(%rax),%r12d
   0xffffffff81083725 <resched_task+53>:        callq  0xffffffff812d8fc0 <debug_smp_processor_id>
   0xffffffff8108372a <resched_task+58>:        cmp    %r12d,%eax
   0xffffffff8108372d <resched_task+61>:        je     0xffffffff810837a0 <resched_task+176>
   0xffffffff8108372f <resched_task+63>:        mfence
   						^^^^^^
I want to make sure the smp_mb() is really replaced with an MFENCE there.

Thanks!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
