Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3GFSDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 14:03:16 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:64903 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab3GFSDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 14:03:13 -0400
Message-ID: <51D85BDE.4000703@gmail.com>
Date: Sat, 06 Jul 2013 20:03:10 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage with hcd_urb_list_lock
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't even know I still had lockdep on.
The following lockdep splat happened when I plugged in a usb bluetooth dongle, using 
the pre-rc1 3.11 kernel at HEAD b2c311075db

=================================
[ INFO: inconsistent lock state ]
3.10.0+ #106 Not tainted
---------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
irq/42-xhci_hcd/97 [HC0[0]:SC0[2]:HE1:SE0] takes:
 (hcd_urb_list_lock){?.....}, at: [<ffffffff8149440e>] usb_hcd_unlink_urb_from_ep+0x28/0x4e
{IN-HARDIRQ-W} state was registered at:
  [<ffffffff810afbc6>] __lock_acquire+0x861/0x1c2e
  [<ffffffff810b1556>] lock_acquire+0x87/0x139
  [<ffffffff81698a1a>] _raw_spin_lock+0x3b/0x4a
  [<ffffffff8149440e>] usb_hcd_unlink_urb_from_ep+0x28/0x4e
  [<ffffffff814a65f1>] ehci_urb_done+0x5b/0x9c
  [<ffffffff814a8e18>] qh_completions+0x311/0x3ca
  [<ffffffff814aa613>] ehci_handle_intr_unlinks+0xad/0x143
  [<ffffffff814a7098>] ehci_hrtimer_func+0x6b/0xbd
  [<ffffffff8107cfc8>] __run_hrtimer+0x61/0x1f9
  [<ffffffff8107d7ca>] hrtimer_interrupt+0x10a/0x253
  [<ffffffff810256c0>] local_apic_timer_interrupt+0x38/0x5e
  [<ffffffff81025ab5>] smp_apic_timer_interrupt+0x46/0x5b
  [<ffffffff816a152f>] apic_timer_interrupt+0x6f/0x80
irq event stamp: 224
hardirqs last  enabled at (224): [<ffffffff8168e8d4>] __slab_free+0x1c7/0x2ed
hardirqs last disabled at (223): [<ffffffff8168e846>] __slab_free+0x139/0x2ed
softirqs last  enabled at (206): [<ffffffff810d8024>] irq_forced_thread_fn+0x49/0x5a
softirqs last disabled at (212): [<ffffffff810d7fff>] irq_forced_thread_fn+0x24/0x5a

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(hcd_urb_list_lock);
  <Interrupt>
    lock(hcd_urb_list_lock);

 *** DEADLOCK ***

1 lock held by irq/42-xhci_hcd/97:
 #0:  (&(&xhci->lock)->rlock){+.-...}, at: [<ffffffff814befdd>] xhci_irq+0x2f/0x143d

stack backtrace:
CPU: 1 PID: 97 Comm: irq/42-xhci_hcd Not tainted 3.10.0+ #106
Hardware name: Acer Aspire M3985/Aspire M3985, BIOS P01-A1 03/12/2012
 ffffffff8210c150 ffff88040834da48 ffffffff81691af4 0000000000000007
 ffff8804082e20b0 ffff88040834daa8 ffffffff8168cb10 0000000000000002
 ffff880400000001 ffff880400000000 ffffffff8100f4f7 ffff88040834dac4
Call Trace:
 [<ffffffff81691af4>] dump_stack+0x4f/0x84
 [<ffffffff8168cb10>] print_usage_bug+0x1f5/0x206
 [<ffffffff8100f4f7>] ? save_stack_trace+0x2f/0x50
 [<ffffffff810af30c>] mark_lock+0x276/0x2cf
 [<ffffffff810ae8cc>] ? check_usage_forwards+0x12f/0x12f
 [<ffffffff810af925>] __lock_acquire+0x5c0/0x1c2e
 [<ffffffff810b1e04>] ? mark_held_locks+0x6d/0x117
 [<ffffffff8168e8d4>] ? __slab_free+0x1c7/0x2ed
 [<ffffffff810b1f5a>] ? trace_hardirqs_on_caller+0xac/0x1bb
 [<ffffffff810b2076>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8149440e>] ? usb_hcd_unlink_urb_from_ep+0x28/0x4e
 [<ffffffff810b1556>] lock_acquire+0x87/0x139
 [<ffffffff8149440e>] ? usb_hcd_unlink_urb_from_ep+0x28/0x4e
 [<ffffffff81698a1a>] _raw_spin_lock+0x3b/0x4a
 [<ffffffff8149440e>] ? usb_hcd_unlink_urb_from_ep+0x28/0x4e
 [<ffffffff8149440e>] usb_hcd_unlink_urb_from_ep+0x28/0x4e
 [<ffffffff814bf55a>] xhci_irq+0x5ac/0x143d
 [<ffffffff81699171>] ? _raw_spin_unlock_irq+0x3b/0x5d
 [<ffffffff8108386d>] ? finish_task_switch+0x7c/0x101
 [<ffffffff81083830>] ? finish_task_switch+0x3f/0x101
 [<ffffffff81697060>] ? __schedule+0x42a/0x885
 [<ffffffff810d7fdb>] ? irq_thread_fn+0x48/0x48
 [<ffffffff814c03fc>] xhci_msi_irq+0x11/0x15
 [<ffffffff810d8009>] irq_forced_thread_fn+0x2e/0x5a
 [<ffffffff810d7d36>] irq_thread+0x10e/0x131
 [<ffffffff810d7ee3>] ? irq_finalize_oneshot.part.33+0xe0/0xe0
 [<ffffffff810d7c28>] ? wake_threads_waitq+0x44/0x44
 [<ffffffff81079b61>] kthread+0xea/0xef
 [<ffffffff81079a77>] ? flush_kthread_work+0x19c/0x19c
 [<ffffffff816a082c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81079a77>] ? flush_kthread_work+0x19c/0x19c

