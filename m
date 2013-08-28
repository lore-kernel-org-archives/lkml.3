Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab3H1Wdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:33:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab3H1Wdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:33:47 -0400
Date: Wed, 28 Aug 2013 15:33:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, eparis@redhat.com,
        rgb@redhat.com
Subject: Re: [RFC] audit: avoid soft lockup in audit_log_start()
Message-Id: <20130828153345.55631b3b3f6f8940ef1b7614@linux-foundation.org>
In-Reply-To: <20130828182114.6b67ea90@redhat.com>
References: <20130828182114.6b67ea90@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 18:21:14 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:

> I'm getting the following soft lockup:
> 
> CPU: 6 PID: 2278 Comm: killall5 Tainted: GF            3.11.0-rc7+ #1
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>  0000000000000099 ffff88011fd83de8 ffffffff815324df 0000000000002800
>  ffffffff817d48f9 ffff88011fd83e68 ffffffff8152e669 ffff88011fd83e68
>  ffffffff00000008 ffff88011fd83e78 ffff88011fd83e18 0000004081dac040
> Call Trace:
>  <IRQ>  [<ffffffff815324df>] dump_stack+0x46/0x58
>  [<ffffffff8152e669>] panic+0xbb/0x1c4
>  [<ffffffff810d03c3>] watchdog_timer_fn+0x163/0x170
>  [<ffffffff8106c691>] __run_hrtimer+0x81/0x1c0
>  [<ffffffff810d0260>] ? watchdog+0x30/0x30
>  [<ffffffff8106cea7>] hrtimer_interrupt+0x107/0x240
>  [<ffffffff8102f61b>] local_apic_timer_interrupt+0x3b/0x60
>  [<ffffffff81542465>] smp_apic_timer_interrupt+0x45/0x60
>  [<ffffffff8154124a>] apic_timer_interrupt+0x6a/0x70
>  <EOI>  [<ffffffff810c2f5f>] ? audit_log_start+0xbf/0x430
>  [<ffffffff810c2fe7>] ? audit_log_start+0x147/0x430
>  [<ffffffff81079030>] ? try_to_wake_up+0x2a0/0x2a0
>  [<ffffffff810c86be>] audit_log_exit+0x6ae/0xc30
>  [<ffffffff81188662>] ? __alloc_fd+0x42/0x100
>  [<ffffffff810c98e7>] __audit_syscall_exit+0x257/0x2b0
>  [<ffffffff81540794>] sysret_audit+0x17/0x21
> 
> The reproducer is somewhat unusual:
> 
>  1. Install RHEL6.5 (maybe a similar older user-space will do)
>  2. Boot the just installed system
>  3. In this first boot you'll meet the firstboot script, which
>     will do some setup and (depending on your answers) it will
>     reboot the machine
>  4. During that first reboot the system hangs while terminating
>     all processes:
> 
>        Sending all processes the TERM signal...
> 
>     It's when the soft lockup above happens. And yes, I managed
>     to get this with latest upstream kernel (HEAD fa8218def1b1)
> 
> I'm reproducing it on a VM, but the first report was on bare-metal.
> 
> This is what is happening:
> 
>  1. audit_log_start() is called
>  2. As we have SKBs waiting in audit_skb_queue and all conditions
>     evaluate to true, we sleep in wait_for_auditd()
>  3. Go to 2, until sleep_time gets negative and audit_log_start()
>     just busy-waits
> 
> Now, *why* this is happening is a mistery to me. I tried debugging
> it, but all I could find is that at some point the kauditd thread
> never wakes up after having called schedule(). I even tried waking
> it up before calling wait_for_auditd(), but it didn't.

Odd.  If kauditd_thread() is stuck in schedule() in state
TASK_INTERRUPTIBLE then a wake_up(kauditd_task) should get it running
again, unless scheduler-related data structures are screwed up.

Are you really sure that kauditd is stuck in schedule() and doesn't
come out?

