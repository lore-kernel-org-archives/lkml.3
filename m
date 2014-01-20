Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaATTfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:35:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:55929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaATTfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:35:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,691,1384329600"; 
   d="scan'208";a="441841991"
Date: Mon, 20 Jan 2014 11:35:10 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [BUGREPORT] Linux USB 3.0
Message-ID: <20140120193510.GC5545@xanatos>
References: <CA+O4pCJAL_Dqrt0mF5rbErBXbLTALx8Rrs1+vB3JmT=+rT0jCg@mail.gmail.com>
 <CA+O4pC+bHC1Bo4ERSfos8fL+FdnwXTTu_EE=rfd9eFkY7432Jg@mail.gmail.com>
 <CA+O4pCJ5xUQwRem3rvZbvv7K8BEnMW983Qq_vR0tVzwAwmVS6A@mail.gmail.com>
 <CA+O4pCJ9dFuwrcVF2b5MsreUb4NJX8t6664i3XHM9CYrdN7VzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+O4pCJ9dFuwrcVF2b5MsreUb4NJX8t6664i3XHM9CYrdN7VzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

I'm the xHCI driver maintainer, and it helps to Cc me on USB 3.0 bug
reports.

On Sat, Dec 28, 2013 at 07:24:20AM +0100, Markus Rechberger wrote:
> just received following log snippset:

Please state which kernel version you (or your customer) is running.
You've reported issues with several different kernel versions, so which
kernel are you running for this particular snippet?

> Dec 27 23:23:50 solist kernel: [   36.118245] xhci_hcd 0000:00:14.0: ERROR Transfer event TRB DMA ptr

These messages might be harmless.  The 3.0 kernel contains a fix for
Intel Panther Point xHCI hosts that suppresses those messages, commit
ad808333d8201d53075a11bc8dd83b81f3d68f0b "Intel xhci: Ignore spurious
successful event."

A later commit extends that to all xHCI 1.0 hosts, commit
07f3cb7c28bf3f4dd80bfb136cf45810c46ac474 "usb: host: xhci: Enable
XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0"  That was
queued for 3.11 and marked to be backported into stable kernels as old
as 3.0.

> the previous bug report of that user:
> https://bugzilla.kernel.org/show_bug.cgi?id=65021 xhci: complete USB freeze

Hmm, Greg didn't assign that bug to me, so I missed it, sorry.

> On Fri, Dec 27, 2013 at 8:59 PM, Markus Rechberger <mrechberger@gmail.com> wrote:
> > Seems like DH87RL was working with 3.2.0-55-generic-pae unfortunately
> > we don't have such a board for testing and customer patience is
> > limited to bisect the kernel.
> >
> > Does anyone have a clue what modification could have killed USB 3.0
> > support within those releases?
> > It does not seem to be SG support.

3.2 was the kernel where the Intel EHCI to xHCI port switchover code
went in.  Without that code, all ports will remain under the EHCI host,
and USB 3.0 devices will work at USB 2.0 speeds.  I suspect the USB
device triggers an issue with the xHCI driver, and 3.2 only works
because the device is on an EHCI port without the switchover code.

> > On Fri, Dec 27, 2013 at 6:18 PM, Markus Rechberger <mrechberger@gmail.com> wrote:
> >> I just got another USB 3.0 bugreport, the entire system crashed. That
> >> particular customer already filed a bugreport in November 2013 that
> >> his system is in a bad state when using some USB 2.0 media devices
> >> which even have opensource drivers built into the kernel.
> >>
> >> USB 3.0 support with Linux seems to be a disaster with Linux 3.6.12.
> >> The affected board is an Intel DH87RL board.

Why are they running 3.6.12 in particular?  That's not a supported
stable kernel.

> >> On Wed, Dec 25, 2013 at 8:18 AM, Markus Rechberger
> >> <mrechberger@gmail.com> wrote:
> >>> A customer using a device with USBDEVFS is reporting following
> >>> backtrace (it seems to be a rather generic issue related to linux usb
> >>> 3.0 in general):
> >>> According to him this problem is reproducible as soon as he starts the
> >>> data transfer, is there anything known about that?
> >>>
> >>> He is using 3.12.0-031200-generic

So at this point you've reported three separate bugs, all with the same
symptom, but different kernel versions?  Are these all from the same bug
reporter, or a different bug reporter?

You've got me seriously confused right now.  Please keep one bug report
to one mail thread, and get the original bug reporter to start that
thread.  If this is from one bug reporter, please state the current
kernel they are running, and send dmesg showing the issue with
CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING turned on (you may
also need to turn on CONFIG_DYNAMIC_DEBUG in later kernels).  Please
attach the dmesg as a file, since your mail client line-wraps.

> >>> Dec 24 14:22:39 homenas kernel: [ 1469.818460] xhci_hcd 0000:0f:00.0: ERROR Transfer event TRB DMA ptr not part of current TD
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] xhci_hcd 0000:0f:00.0: ERROR Transfer event TRB DMA ptr not part of current TD
> >>> Dec 24 14:30:39 homenas kernel: last message repeated 16 times
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] xhci_hcd 0000:0f:00.0: WARN Successful completion on short TX
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] xhci_hcd 0000:0f:00.0: WARN Successful completion on short TX
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] xhci_hcd 0000:0f:00.0: URB transfer length is wrong, xHC issue? req. len = 46080, act. len = 1382400
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] IP: [] finish_td+0x13f/0x250
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] PGD 0
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] Oops: 0000 [#1] SMP
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] Modules linked in:
> >>> videodev pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF)
> >>> vboxdrv(OF) dm_crypt snd_hda_codec_ca0132 snd_hda_intel snd_hda_codec
> >>> snd_hwdep snd_pcm snd_seq_midi dm_multipath psmouse scsi_dh
> >>> snd_rawmidi serio_raw sb_edac snd_seq_midi_event edac_core snd_seq
> >>> snd_timer snd_seq_device lpc_ich snd bnep rfcomm soundcore
> >>> snd_page_alloc bluetooth mei_me mei mac_hid ppdev nfsd w83627ehf
> >>> hwmon_vid nfs_acl auth_rpcgss coretemp nfs fscache lockd lp parport
> >>> sunrpc raid10 raid456 async_pq async_xor async_memcpy
> >>> async_raid6_recov async_tx raid0 multipath linear btrfs raid6_pq xor
> >>> libcrc32c osst st raid1 tg3 mptsas firewire_ohci ptp mxm_wmi
> >>> firewire_core ahci mptscsih pps_core crc_itu_t libahci mpt2sas mptbase
> >>> wmi scsi_transport_sas raid_class [last unloaded: vmnet]
> >>>
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] CPU: 0 PID: 0 Comm: swapper/0 Tainted: GF                 O 3.12.0-031200-generic #201311031935
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X79 Extreme9, BIOS P3.30 01/28/2013
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] task: ffffffff81c144a0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] RIP: 0010:[]  [] finish_td+0x13f/0x250

It would help if your client could reproduce this oops on their machine,
and then run markup_oops.pl to find out exactly where the driver is
oopsing.  I suspect it has to do with the bad completion length in the
line above, but it could be unrelated.

> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] RSP: 0018:ffff88102fc03ca8  EFLAGS: 00010046
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] RAX: ffff880f865d2b10 RBX: ffff880f865d2b00 RCX: 0000000000000006
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] RDX: ffff880f865d2b10 RSI: 0000000000000007 RDI: 0000000000000046
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] RBP: ffff88102fc03d08 R08: 000000000000000a R09: 0000000000000000
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] R10: 00000000000006fd R11: 00000000000006fc R12: ffff880fd2de0000
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] R13: ffff880fd32b1780 R14: 0000000000000000 R15: ffff880fd5c5f000
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] FS: 0000000000000000(0000) GS:ffff88102fc00000(0000) knlGS:0000000000000000
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] CR2: 0000000000000004 CR3: 0000000001c0d000 CR4: 00000000000407f0
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] Stack:
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  ffff88102fc03ce8 ffff880fd0bc8000 ffff88102fc03d00 ffff880fd268d1a0
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  ffff88102fc03df4 0000000100000002 ffff880fd32b1780 ffff880f865d2b00
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  ffff880fd268d1a0 ffff880fd5c5f000 ffff880fd2de0000 ffff880fd2c497b0
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450] Call Trace:
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] process_bulk_intr_td+0x116/0x2d0
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] handle_tx_event+0x656/0xb50
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] ? __queue_work+0x3b0/0x3c0
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] ? call_timer_fn+0x46/0x160
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] xhci_handle_event+0x1db/0x2a0
> >>> Dec 24 14:30:39 homenas kernel: [ 1469.822450]  [] ?  run_timer_softirq+0x1b2/0x300
> >>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] xhci_irq+0x120/0x1f0
> >>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] xhci_msi_irq+0x11/0x20
> >>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] handle_irq_event_percpu+0x5d/0x210
> >>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] handle_irq_event+0x48/0x70
> >>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] ?  native_apic_msr_eoi_write+0x14/0x20
> >>> Dec 24 14:30:39 homenas kernel: [ 1470.312076]  [] handle_edge_irq+0x77/0x110

Sarah Sharp
