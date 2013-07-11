Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3GKQcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:32:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:42209 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab3GKQcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:32:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1045,1363158000"; 
   d="scan'208";a="368554540"
Date: Thu, 11 Jul 2013 09:30:50 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage with
 hcd_urb_list_lock
Message-ID: <20130711163050.GB5240@xanatos>
References: <51D85BDE.4000703@gmail.com>
 <Pine.LNX.4.44L0.1307061646560.29104-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1307061646560.29104-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 04:48:47PM -0400, Alan Stern wrote:
> On Sat, 6 Jul 2013, Maarten Lankhorst wrote:
> 
> > I didn't even know I still had lockdep on.
> > The following lockdep splat happened when I plugged in a usb bluetooth dongle, using 
> > the pre-rc1 3.11 kernel at HEAD b2c311075db
> > 
> > =================================
> > [ INFO: inconsistent lock state ]
> > 3.10.0+ #106 Not tainted
> > ---------------------------------
> > inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
> > irq/42-xhci_hcd/97 [HC0[0]:SC0[2]:HE1:SE0] takes:
> >  (hcd_urb_list_lock){?.....}, at: [<ffffffff8149440e>] usb_hcd_unlink_urb_from_ep+0x28/0x4e
> 
> > stack backtrace:
> > CPU: 1 PID: 97 Comm: irq/42-xhci_hcd Not tainted 3.10.0+ #106
> > Hardware name: Acer Aspire M3985/Aspire M3985, BIOS P01-A1 03/12/2012
> >  ffffffff8210c150 ffff88040834da48 ffffffff81691af4 0000000000000007
> >  ffff8804082e20b0 ffff88040834daa8 ffffffff8168cb10 0000000000000002
> >  ffff880400000001 ffff880400000000 ffffffff8100f4f7 ffff88040834dac4
> > Call Trace:
> >  [<ffffffff81691af4>] dump_stack+0x4f/0x84
> >  [<ffffffff8168cb10>] print_usage_bug+0x1f5/0x206
> >  [<ffffffff8100f4f7>] ? save_stack_trace+0x2f/0x50
> >  [<ffffffff810af30c>] mark_lock+0x276/0x2cf
> >  [<ffffffff810ae8cc>] ? check_usage_forwards+0x12f/0x12f
> >  [<ffffffff810af925>] __lock_acquire+0x5c0/0x1c2e
> >  [<ffffffff810b1e04>] ? mark_held_locks+0x6d/0x117
> >  [<ffffffff8168e8d4>] ? __slab_free+0x1c7/0x2ed
> >  [<ffffffff810b1f5a>] ? trace_hardirqs_on_caller+0xac/0x1bb
> >  [<ffffffff810b2076>] ? trace_hardirqs_on+0xd/0xf
> >  [<ffffffff8149440e>] ? usb_hcd_unlink_urb_from_ep+0x28/0x4e
> >  [<ffffffff810b1556>] lock_acquire+0x87/0x139
> >  [<ffffffff8149440e>] ? usb_hcd_unlink_urb_from_ep+0x28/0x4e
> >  [<ffffffff81698a1a>] _raw_spin_lock+0x3b/0x4a
> >  [<ffffffff8149440e>] ? usb_hcd_unlink_urb_from_ep+0x28/0x4e
> >  [<ffffffff8149440e>] usb_hcd_unlink_urb_from_ep+0x28/0x4e
> >  [<ffffffff814bf55a>] xhci_irq+0x5ac/0x143d
> >  [<ffffffff81699171>] ? _raw_spin_unlock_irq+0x3b/0x5d
> >  [<ffffffff8108386d>] ? finish_task_switch+0x7c/0x101
> >  [<ffffffff81083830>] ? finish_task_switch+0x3f/0x101
> >  [<ffffffff81697060>] ? __schedule+0x42a/0x885
> >  [<ffffffff810d7fdb>] ? irq_thread_fn+0x48/0x48
> >  [<ffffffff814c03fc>] xhci_msi_irq+0x11/0x15
> 
> It looks like xhci_msi_irq() needs to call local_irq_save() and 
> local_irq_restore().

Alan, does this only need to be called when MSI is enabled?
xhci_msi_irq() basically calls xhci_irq, which is called if MSI is
disabled and legacy PCI interrupts are used.

I'm trying to figure out whether to put the calls to local_irq_save()
and local_irq_restore() in xhci_msi_irq() or xhci_irq().

Sarah Sharp
