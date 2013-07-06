Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3GFUsu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 16:48:50 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39719 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751997Ab3GFUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 16:48:48 -0400
Date: Sat, 6 Jul 2013 16:48:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage with
 hcd_urb_list_lock
In-Reply-To: <51D85BDE.4000703@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1307061646560.29104-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jul 2013, Maarten Lankhorst wrote:

> I didn't even know I still had lockdep on.
> The following lockdep splat happened when I plugged in a usb bluetooth dongle, using 
> the pre-rc1 3.11 kernel at HEAD b2c311075db
> 
> =================================
> [ INFO: inconsistent lock state ]
> 3.10.0+ #106 Not tainted
> ---------------------------------
> inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
> irq/42-xhci_hcd/97 [HC0[0]:SC0[2]:HE1:SE0] takes:
>  (hcd_urb_list_lock){?.....}, at: [<ffffffff8149440e>] usb_hcd_unlink_urb_from_ep+0x28/0x4e

> stack backtrace:
> CPU: 1 PID: 97 Comm: irq/42-xhci_hcd Not tainted 3.10.0+ #106
> Hardware name: Acer Aspire M3985/Aspire M3985, BIOS P01-A1 03/12/2012
>  ffffffff8210c150 ffff88040834da48 ffffffff81691af4 0000000000000007
>  ffff8804082e20b0 ffff88040834daa8 ffffffff8168cb10 0000000000000002
>  ffff880400000001 ffff880400000000 ffffffff8100f4f7 ffff88040834dac4
> Call Trace:
>  [<ffffffff81691af4>] dump_stack+0x4f/0x84
>  [<ffffffff8168cb10>] print_usage_bug+0x1f5/0x206
>  [<ffffffff8100f4f7>] ? save_stack_trace+0x2f/0x50
>  [<ffffffff810af30c>] mark_lock+0x276/0x2cf
>  [<ffffffff810ae8cc>] ? check_usage_forwards+0x12f/0x12f
>  [<ffffffff810af925>] __lock_acquire+0x5c0/0x1c2e
>  [<ffffffff810b1e04>] ? mark_held_locks+0x6d/0x117
>  [<ffffffff8168e8d4>] ? __slab_free+0x1c7/0x2ed
>  [<ffffffff810b1f5a>] ? trace_hardirqs_on_caller+0xac/0x1bb
>  [<ffffffff810b2076>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff8149440e>] ? usb_hcd_unlink_urb_from_ep+0x28/0x4e
>  [<ffffffff810b1556>] lock_acquire+0x87/0x139
>  [<ffffffff8149440e>] ? usb_hcd_unlink_urb_from_ep+0x28/0x4e
>  [<ffffffff81698a1a>] _raw_spin_lock+0x3b/0x4a
>  [<ffffffff8149440e>] ? usb_hcd_unlink_urb_from_ep+0x28/0x4e
>  [<ffffffff8149440e>] usb_hcd_unlink_urb_from_ep+0x28/0x4e
>  [<ffffffff814bf55a>] xhci_irq+0x5ac/0x143d
>  [<ffffffff81699171>] ? _raw_spin_unlock_irq+0x3b/0x5d
>  [<ffffffff8108386d>] ? finish_task_switch+0x7c/0x101
>  [<ffffffff81083830>] ? finish_task_switch+0x3f/0x101
>  [<ffffffff81697060>] ? __schedule+0x42a/0x885
>  [<ffffffff810d7fdb>] ? irq_thread_fn+0x48/0x48
>  [<ffffffff814c03fc>] xhci_msi_irq+0x11/0x15

It looks like xhci_msi_irq() needs to call local_irq_save() and 
local_irq_restore().

Alan Stern

