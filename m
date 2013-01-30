Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab3A3V5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:57:05 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52114 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3A3V5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:57:03 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWdGCytVsNKK+gA7Sh-RKT-GPCHoRtPNfDw4_Hfh+ynyA@mail.gmail.com>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<1359399845-10568-9-git-send-email-fweisbec@gmail.com>
	<CA+icZUWdGCytVsNKK+gA7Sh-RKT-GPCHoRtPNfDw4_Hfh+ynyA@mail.gmail.com>
Date: Wed, 30 Jan 2013 22:57:01 +0100
Message-ID: <CA+icZUVBFa+QiWywAiEfnCwGUmXzkFo8vAO5sYefU5NJ98r8wg@mail.gmail.com>
Subject: Re: [PATCH 8/8] cputime: Safely read cputime of full dynticks CPUs
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 10:51 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Mon, Jan 28, 2013 at 8:04 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> While remotely reading the cputime of a task running in a
>> full dynticks CPU, the values stored in utime/stime fields
>> of struct task_struct may be stale. Its values may be those
>> of the last kernel <-> user transition time snapshot and
>> we need to add the tickless time spent since this snapshot.
>>
>> To fix this, flush the cputime of the dynticks CPUs on
>> kernel <-> user transition and record the time / context
>> where we did this. Then on top of this snapshot and the current
>> time, perform the fixup on the reader side from task_times()
>> accessors.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
>> Cc: Namhyung Kim <namhyung.kim@lge.com>
>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> [fixed kvm module related build errors]
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>>
>
> Can you explain a bit what is the difference between "3.8-rc4-nohz3"
> and "full-dynticks-cputime-for-mingo" patchsets?
>
> Does the latter need no more EXPORT_SYMBOL_GPL for vtime_guest_enter()
> and vtime_guest_exit() when CONFIG_KVM=m (see [1])?
>
> - Sedat -
>
> [1] https://lkml.org/lkml/2013/1/23/473

To answer my question by myself...

$ grep 'CONFIG_KVM=' linux/.config
CONFIG_KVM=m

$ grep kvm deb-pkg.log
  CC      arch/x86/kernel/kvm.o
  CC      arch/x86/kernel/kvmclock.o
  LD      arch/x86/kvm/built-in.o
  CC [M]  arch/x86/kvm/vmx.o
  CC [M]  arch/x86/kvm/../../../virt/kvm/kvm_main.o
  CC [M]  arch/x86/kvm/../../../virt/kvm/ioapic.o
  CC [M]  arch/x86/kvm/../../../virt/kvm/coalesced_mmio.o
  CC [M]  arch/x86/kvm/../../../virt/kvm/irq_comm.o
  CC [M]  arch/x86/kvm/../../../virt/kvm/eventfd.o
  CC [M]  arch/x86/kvm/../../../virt/kvm/assigned-dev.o
  CC [M]  arch/x86/kvm/../../../virt/kvm/iommu.o
  CC [M]  arch/x86/kvm/../../../virt/kvm/async_pf.o
  CC [M]  arch/x86/kvm/x86.o
  CC [M]  arch/x86/kvm/mmu.o
  CC [M]  arch/x86/kvm/emulate.o
  CC [M]  arch/x86/kvm/i8259.o
  CC [M]  arch/x86/kvm/irq.o
  CC [M]  arch/x86/kvm/lapic.o
  CC [M]  arch/x86/kvm/i8254.o
  CC [M]  arch/x86/kvm/cpuid.o
  CC [M]  arch/x86/kvm/pmu.o
  LD [M]  arch/x86/kvm/kvm.o
  LD [M]  arch/x86/kvm/kvm-intel.o
  CC      arch/x86/kvm/kvm-intel.mod.o
  CC      arch/x86/kvm/kvm.mod.o
  LD [M]  arch/x86/kvm/kvm-intel.ko
  LD [M]  arch/x86/kvm/kvm.ko
  INSTALL arch/x86/kvm/kvm-intel.ko
  INSTALL arch/x86/kvm/kvm.ko

...both EXPORT_SYMBOL_GPLs are no more needed!

- Sedat .
