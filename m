Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab3DGJuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 05:50:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51062 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075Ab3DGJud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 05:50:33 -0400
Date: Sun, 7 Apr 2013 11:50:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, dhillf@gmail.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel BUG at kernel/smpboot.c:134!
Message-ID: <20130407095025.GA31307@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
	Dave Jones <davej@redhat.com>, dhillf@gmail.com,
	Peter Zijlstra <peterz@infradead.org>
References: <515F457E.5050505@sr71.net>
 <515FCAC6.8090806@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1304061019000.21884@ionos>
 <alpine.LFD.2.02.1304071119100.21884@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1304071119100.21884@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 11:20:10AM +0200, Thomas Gleixner wrote:
> And it's even more bogus because the cpu to which we would bind in
> kthread_create_on_cpu() is not yet online.

In case you guys are wondering about reproducibility, I saw the same
BUG_ON yesterday on a 32-bit atom smp qemu guest too (don't ask why?
:-))

And yes, this was without kvm (software emulation only in qemu).

[    0.395000] ------------[ cut here ]------------
[    0.395000] kernel BUG at kernel/smpboot.c:134!
[    0.395000] invalid opcode: 0000 [#1] PREEMPT SMP 
[    0.395000] Modules linked in:
[    0.395000] Pid: 13, comm: ksoftirqd/1 Not tainted 3.9.0-rc5+ #31 Bochs Bochs
[    0.395000] EIP: 0060:[<c106542c>] EFLAGS: 00000202 CPU: 0
[    0.395000] EIP is at smpboot_thread_fn+0x20c/0x260
[    0.395000] EAX: 00000000 EBX: f60ba430 ECX: 00000000 EDX: 00000001
[    0.395000] ESI: f60024f0 EDI: c1736480 EBP: f60c1f24 ESP: f60c1f04
[    0.395000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.395000] CR0: 8005003b CR2: ffe17000 CR3: 01943000 CR4: 000006e0
[    0.395000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.395000] DR6: 00000000 DR7: 00000000
[    0.395000] Process ksoftirqd/1 (pid: 13, ti=f60c0000 task=f60ba430 task.ti=f60c0000)
[    0.395000] Stack:
[    0.395000]  f60ba430 00000001 00000000 f60c1f24 c105c49d f6083e7c f60024f0 c1065220
[    0.395000]  f60c1fac c105c745 00000001 00000001 f60024f0 00000000 c1510303 dead4ead
[    0.395000]  ffffffff ffffffff c1b510ac c1c28450 00000000 c167e791 00000000 c151744f
[    0.395000] Call Trace:
[    0.395000]  [<c105c49d>] ? __kthread_parkme+0x2d/0x70
[    0.395000]  [<c1065220>] ? lg_lock_init+0x20/0x20
[    0.395000]  [<c105c745>] kthread+0x95/0xa0
[    0.395000]  [<c1510303>] ? dump_pagetable+0xa/0x101
[    0.395000]  [<c151744f>] ? wait_for_common+0xcf/0x110
[    0.395000]  [<c1060000>] ? __remove_hrtimer+0x90/0xa0
[    0.395000]  [<c151a477>] ret_from_kernel_thread+0x1b/0x28
[    0.395000]  [<c105c6b0>] ? __init_kthread_worker+0x60/0x60
[    0.395000] Code: 0f a3 02 19 d2 85 d2 0f 95 c2 0f b6 d2 ff d1 89 f0 e8 69 25 0b 00 8d 64 24 14 31 c0 5b 5e 5f 5d c3 e8 d9 2b 4b 00 e9 68 
fe ff ff <0f> 0b 66 90 e8 cb 2b 4b 00 e9 ac fe ff ff 8d b6 00 00 00 00 e8
[    0.395000] EIP: [<c106542c>] smpboot_thread_fn+0x20c/0x260 SS:ESP 0068:f60c1f04
[    0.403466] ---[ end trace f5696bc4e08aa88f ]---

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
