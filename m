Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3DLLyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:54:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56989 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab3DLLyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:54:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: konrad.wilk@oracle.com
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/paravirt] x86-64, gdt: Store/ load GDT for ACPI S3 or hibernate/resume path is not needed.
Date: Fri, 12 Apr 2013 14:02:01 +0200
Message-ID: <4054620.GA2vTd0F6g@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <tip-e7a5cd063c7b4c58417f674821d63f5eb6747e37@git.kernel.org>
References: <1365194544-14648-2-git-send-email-konrad.wilk@oracle.com> <tip-e7a5cd063c7b4c58417f674821d63f5eb6747e37@git.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 11, 2013 03:59:11 PM tip-bot for Konrad Rzeszutek Wilk wrote:
> Commit-ID:  e7a5cd063c7b4c58417f674821d63f5eb6747e37
> Gitweb:     http://git.kernel.org/tip/e7a5cd063c7b4c58417f674821d63f5eb6747e37
> Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> AuthorDate: Fri, 5 Apr 2013 16:42:21 -0400
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 11 Apr 2013 15:39:38 -0700
> 
> x86-64, gdt: Store/load GDT for ACPI S3 or hibernate/resume path is not needed.
> 
> During the ACPI S3 resume path the trampoline code handles it already.
> 
> During the ACPI S3 suspend phase (acpi_suspend_lowlevel) we set:
> early_gdt_descr.address = (..)get_cpu_gdt_table(smp_processor_id());
> 
> which is then used during the resume path and has the same exact
> value as what the store/load_gdt do with the saved_context
> (which is saved/restored via save/restore_processor_state()).
> 
> The flow during resume is complex and for 64-bit kernels we use three GDTs
> - one early bootstrap GDT (wakeup_igdt) that we load to workaround
> broken BIOSes, an early Protected Mode to Long Mode transition one
> (tr_gdt), and the final one - early_gdt_descr (which points to the real GDT).
> 
> The early ('wakeup_gdt') is loaded in 'trampoline_start' for working
> around broken BIOSes, and then when we end up in Protected Mode in the
> startup_32 (in trampoline_64.s, not head_32.s) we use the 'tr_gdt'
> (still in trampoline_64.s). This 'tr_gdt' has a a 32-bit code segment,
> 64-bit code segment with L=1, and a 32-bit data segment.
> 
> Once we have transitioned from Protected Mode to Long Mode we then
> set the GDT to 'early_gdt_desc' and then via an iretq emerge in
> wakeup_long64 (set via 'initial_code' variable in acpi_suspend_lowlevel).
> 
> In the wakeup_long64 we end up restoring the %rip (which is set to
> 'resume_point') and jump there.
> 
> In 'resume_point' we call 'restore_processor_state' which does
> the load_gdt on the saved context. This load_gdt is redundant as the
> GDT loaded via early_gdt_desc is the same.
> 
> Here is the call-chain:
>  wakeup_start
>    |- lgdtl wakeup_gdt [the work-around broken BIOSes]
>    |
>    \-- trampoline_start (trampoline_64.S)
>          |- lgdtl tr_gdt
>          |
>          \-- startup_32 (trampoline_64.S)
>                |
>                \-- startup_64 (trampoline_64.S)
>                       |
>                       \-- secondary_startup_64
>                                |- lgdtl early_gdt_desc
>                                | ...
>                                |- movq initial_code(%rip), %eax
>                                |-.. lretq
>                                \-- wakeup_64
>                                      |-- other registers are reloaded
>                                      |-- call restore_processor_state
> 
> The hibernate path is much simpler. During the saving of the hibernation
> image we call save_processor_state() and save the contents of that along
> with the rest of the kernel in the hibernation image destination.
> We save the EIP of 'restore_registers' (restore_jump_address) and cr3
> (restore_cr3).
> 
> During hibernate resume, the 'restore_registers' (via the
> 'restore_jump_address) in hibernate_asm_64.S is invoked which restores
> the contents of most registers. Naturally the resume path benefits from
> already being in 64-bit mode, so it does not have to load the GDT.
> 
> It only reloads the cr3 (from restore_cr3) and continues on. Note that
> the restoration of the restore image page-tables is done prior to this.
> 
> After the 'restore_registers' it returns and we end up called
> restore_processor_state() - where we reload the GDT. The reload of
> the GDT is not needed as bootup kernel has already loaded the GDT which
> is at the same physical location as the the restored kernel.

I'm not sure if this particular statement is actually correct.  It is correct
on 32-bit, but here it is not necessary for the bootup kernel to be the same
as the image one.  Different kernel version may be used for that even (at
least theoretically).  So the question is, and I'm quite unsure about the
answer, if the GDT of from the bootup kernel is really *guaranteed* to be
at the same location (given that those kernels may be really different).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
