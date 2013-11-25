Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab3KYOb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:31:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab3KYObs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:31:48 -0500
Date: Mon, 25 Nov 2013 06:32:31 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Ma, Xindong" <xindong.ma@intel.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "ccross@google.com" <ccross@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>
Subject: Re: Add memory barrier when waiting on futex
Message-ID: <20131125143231.GB4003@kroah.com>
References: <3917C05D9F83184EAA45CE249FF1B1DD0252FAEA@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3917C05D9F83184EAA45CE249FF1B1DD0252FAEA@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 01:15:17PM +0000, Ma, Xindong wrote:
> We encountered following panic several times:
> [   74.671982] BUG: unable to handle kernel NULL pointer dereference at 00000008
> [   74.672101] IP: [<c129bb27>] wake_futex+0x47/0x80
> [   74.672185] *pdpt = 0000000010108001 *pde = 0000000000000000 
> [   74.672278] Oops: 0002 [#1] PREEMPT SMP 
> [   74.672403] Modules linked in: atomisp_css2400b0_v2 atomisp_css2400_v2 dfrgx bcm_bt_lpm videobuf_vmalloc videobuf_core hdmi_audio tngdisp bcm4335 kct_daemon(O) cfg80211
> [   74.672815] CPU: 0 PID: 1477 Comm: zygote Tainted: G        W  O 3.10.1-259934-g0bfb86e #1
> [   74.672855] Hardware name: Intel Corporation Merrifield/SALT BAY, BIOS 404 2013.10.09:15.29.48
> [   74.672894] task: d4c97220 ti: cfaa8000 task.ti: cfaa8000
> [   74.672933] EIP: 0060:[<c129bb27>] EFLAGS: 00210246 CPU: 0
> [   74.672975] EIP is at wake_futex+0x47/0x80
> [   74.673012] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
> [   74.673049] ESI: def4de5c EDI: ffffffff EBP: cfaa9eb4 ESP: cfaa9ea0
> [   74.673086]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   74.673123] CR0: 8005003b CR2: 00000008 CR3: 10109000 CR4: 001007f0
> [   74.673160] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   74.673196] DR6: ffff0ff0 DR7: 00000400
> [   74.673229] Stack:
> [   74.673260]  00000000 00000001 00000000 def4de5c c225eb50 cfaa9ee4 c129bc29 00000000
> [   74.673536]  00000000 7fffffff c225eb30 b4f38000 ec1a4b40 00000f90 7fffffff 00000001
> [   74.673814]  b4f38f90 cfaa9f58 c129da0b ffffffff ffffffff cfaa9f10 c195d835 00000001
> [   74.674092] Call Trace:
> [   74.674144]  [<c129bc29>] futex_wake+0xc9/0x110
> [   74.674195]  [<c129da0b>] do_futex+0xeb/0x950
> [   74.674246]  [<c195d835>] ? sub_preempt_count+0x55/0xe0
> [   74.674293]  [<c1275aee>] ? wake_up_new_task+0xee/0x190
> [   74.674341]  [<c195a31b>] ? _raw_spin_unlock_irqrestore+0x3b/0x70
> [   74.674388]  [<c1275aee>] ? wake_up_new_task+0xee/0x190
> [   74.674436]  [<c1241afc>] ? do_fork+0xec/0x350
> [   74.674484]  [<c129e30b>] SyS_futex+0x9b/0x140
> [   74.674533]  [<c1312298>] ? SyS_mprotect+0x188/0x1e0
> [   74.674582]  [<c195a718>] syscall_call+0x7/0xb
> 
> On smp systems, setting current task to q->task in queue_me() may
> not visible immediately to another cpu, some times this will
> cause panic in wake_futex(). Adding memory barrier to avoid this.
> 
> Signed-off-by: Leon Ma <xindong.ma@intel.com>
> Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
> ---
>  kernel/futex.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
