Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044Ab3EBVgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:36:16 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49243 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761662Ab3EBVgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1305022304370.2891@ionos>
References: <20130430212007.GB18598@redhat.com>
	<20130430213719.GA14988@redhat.com>
	<alpine.LFD.2.02.1305021234510.3972@ionos>
	<20130502154621.GA23990@redhat.com>
	<alpine.LFD.2.02.1305022152280.2891@ionos>
	<CAE9FiQXpV451xTzAJyNdC-+-oqF9v8Cy5evcNOHKFffERw2SwA@mail.gmail.com>
	<alpine.LFD.2.02.1305022304370.2891@ionos>
Date: Thu, 2 May 2013 14:36:14 -0700
X-Google-Sender-Auth: gc62IphO5nIVeCq7kmlOK1LqLo0
Message-ID: <CAE9FiQWFK_ropzW_qQLcNxLYyek8-PHGW-8SxfZJSijvdrss1A@mail.gmail.com>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 2:19 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Can you please apply the following debug patch and provide the output?
>
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index c6d6400..b4d9622 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -207,6 +207,8 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
>
>         if (unlikely(expires.tv64 < 0)) {
>                 WARN_ON_ONCE(1);
> +               printk_once(KERN_INFO "expires %llx, dev->next %llx\n",
> +                           expires.tv64, dev->next_event.tv64);
>                 return -ETIME;
>         }
>

[    3.450968] SMP alternatives: lockdep: fixing up alternatives
[    3.454454] ------------[ cut here ]------------
[    3.454470] WARNING: at kernel/time/clockevents.c:209
clockevents_program_event+0x3e/0x120()
[    3.454473] Modules linked in:
[    3.454479] CPU: 10 PID: 0 Comm: swapper/10 Not tainted
3.9.0-yh-08066-g1252014-dirty #1538
[    3.454481] Hardware name: Oracle Corporation  unknown       /
, BIOS 11016600    05/17/2011
[    3.454500]  0000000000000009 ffff88203e203ed8 ffffffff82091042
ffff88203e203f18
[    3.454518]  ffffffff81088990 ffff88203e203f08 ffff88203e20d000
80000000003d08ff
[    3.454526]  000000000000000a ffff881027557fd8 0000000000000000
ffff88203e203f28
[    3.454527] Call Trace:
[    3.454540]  <IRQ>  [<ffffffff82091042>] dump_stack+0x19/0x1b
[    3.454548]  [<ffffffff81088990>] warn_slowpath_common+0x70/0xa0
[    3.454552]  [<ffffffff810889da>] warn_slowpath_null+0x1a/0x20
[    3.454556]  [<ffffffff810e312e>] clockevents_program_event+0x3e/0x120
[    3.454560]  [<ffffffff810e360c>] tick_handle_periodic+0x4c/0x80
[    3.454566]  [<ffffffff820ae8cd>] smp_apic_timer_interrupt+0x8d/0xa3
[    3.454575]  [<ffffffff820adbef>] apic_timer_interrupt+0x6f/0x80
[    3.454583]  <EOI>  [<ffffffff810527f7>] ? default_idle+0x57/0xd0
[    3.454587]  [<ffffffff810527f5>] ? default_idle+0x55/0xd0
[    3.454591]  [<ffffffff81053078>] arch_cpu_idle+0x18/0x20
[    3.454595]  [<ffffffff810dbec5>] cpu_startup_entry+0x165/0x210
[    3.454603]  [<ffffffff8207f3cd>] start_secondary+0x1df/0x1e6
[    3.454626] ---[ end trace 2f2f1a2adee9c881 ]---
[    3.454628] expires 80000000003d08ff, dev->next 7fffffffffffffff
