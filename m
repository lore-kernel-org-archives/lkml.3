Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3FXHds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:33:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48893 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3FXHdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:33:46 -0400
Date: Mon, 24 Jun 2013 09:33:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, netfilter@vger.kernel.org
Subject: Re: v3.10-rc7 oops soon after boot
Message-ID: <20130624073340.GA26787@pd.tnic>
References: <20130624064934.24201.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130624064934.24201.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like ulog_timer in net/ipv4/netfilter/ipt_ULOG.c, judging by
your config.

Adding some more people to CC.

On Mon, Jun 24, 2013 at 02:49:34AM -0400, George Spelvin wrote:
> Trying to upgrade from 3.9.4 to 3.10-rc7, I encountered the following
> persistent oops right around the time that init enters runlevel 2.
> The exact timing fluctuates slightly; it doesn't appear to be a particular
> init script triggering it.
> 
> Trying to boot single-user, it occurred immediately after printing
> the password prompt.
> 
> I need this machine to be up during the day, at least, so a full bisect
> would cost me a chunk of a night's sleep, which I'd prefer to avoid
> if anyone has any ideas for abbreviating the process.
> 
> It's a quad-core Phenom with 8 GB of ECC RAM, which has a long history
> of hardware stability.
> 
> The local patches are minor tweaks to device drivers (some linuxpps
> patches I'm working on, and some timeout modifications to the r8169
> driver), and were all in the previous kernel.
> 
> The following is transcribed by hand, but I double-checked the call
> trace and code.
> 
> 
> [ ok ] Cleaning up temporary files....
> [info] Setting console screen modes and fonts
> BUG: unable to handle kernel NULL pointer dereference at        (null)
> IP: [<ffffffff813b5556>] ulog_timer+0x7/0x39
> PGD 216a2b067 PUF 20d853067 PMD 0
> Oops: 0000 [#1] SMP
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc7-00025-g94f52f4 #24
> Hardware name: MICR_STAR INTERNATIONAL CO.,LTD MS-7376/MS-7376, BIOS V1.7 01/13/2009
> task: ffffffff815c7400 ti: ffffffff815b6000 task.ti: ffffffff815b6000
> RIP: 0010:[<ffffffff813b5556>]  [<ffffffff813b5556>] ulog_timer+0x7/0x39
> RSP: 0018:ffff88021fc03ec0  EFLAGS: 00010206
> RAX: dead000000200200 RBX: 0000000000000100 RCX: ffff8802168ff098
> RDX: ffff88021fc03f00 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffffff815b7fd8 R08: 0000000371f3fc33 R09: ffffffff817465c0
> R10: 0000000000000000 R11: 0000000000000020 R12: 0000000000000000
> R13: ffffffff813b554f R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:00000000f779e900
> CS: 0020 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000211f93000 CR4: 00000000000007f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Stack:
>  0000000000000100 ffffffff815b7fd8 ffffffff813b554f ffffffff81031f87
>  ffffffff817465c0 ffff8802168ff098 ffff88021fc03f00 ffffffff810321e9
>  ffff88021fc03f00 ffff88021fc03f00 0000000000000101 ffffffff815bb088
> Call Trace:
>  <IRQ>
>  [<ffffffff813b554f>] ? ulog_send+0x76/0x76
>  [<ffffffff81031f87>] ? call_timer_fn.isra.29+0x1c/0x6f
>  [<ffffffff810321e9>] ? run_timer_softirq+0x19a/0x1c2
>  [<ffffffff8102de41>] ? __do_softirq+0xb9/0x171
>  [<ffffffff8102dfb7>] ? irq_exit+0x3a/0x7a
>  [<ffffffff8101969f>] ? smp_apic_timer_interrupt+0x72/0x7e
>  [<ffffffff8142ae8a>] ? apic_timer_interrupt+0x6a/0x70
>  <EOI>
>  [<ffffffff81007d24>] ? default_idle+0x2/0x3
>  [<ffffffff81007e1c>] ? amd_e400_idle+0xa7/0xc1
>  [<ffffffff8104f79e>] ? cpu_startup_entry+0x9c/0xec
>  [<ffffffff8164eb91>] ? start_kernel+0x2bd/0x2c8
>  [<ffffffff8164e6f7>] ? repair_env_string+0x54/0x54
> Code: 80 0d 00 00 e8 47 ae f9 ff c7 03 00 00 00 00 48 c7 43 10 00 00 00 00 48 c7 43 08 00 00 00 00 5b 5d 41 5c c3 41 54 49 89 fc 55 53 <8b> 07 48 89 fb 48 c1 e0 02 49 29 c4 49 8d ac 24 88 0d 00 00 48
> RIP  [<ffffffff813b5556>] ulog_timer+0x7/0x39
>  RSP <ffff88021fc03ec0>
> CR2: 0000000000000000
> ---[ end trace 0673bd6b61636416 ]---
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
