Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3IJVEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:04:44 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61105 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3IJVEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:04:41 -0400
MIME-Version: 1.0
In-Reply-To: <bug-60555-41252@https.bugzilla.kernel.org/>
References: <bug-60555-41252@https.bugzilla.kernel.org/>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 10 Sep 2013 15:04:20 -0600
Message-ID: <CAErSpo4BKuuo=kz9RLpZNwrM=HnV3Zt7qLeoUCywV6ESoO+=wQ@mail.gmail.com>
Subject: Re: [Bug 60555] New: Some amount of ifconfig cause load average
 increase and system freeze
To: onorua@gmail.com
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Thomas, e1000e driver folks, linux-pci, lkml]

On Mon, Jul 15, 2013 at 2:31 AM,  <bugzilla-daemon@bugzilla.kernel.org> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=60555
>
>             Bug ID: 60555
>            Summary: Some amount of ifconfig cause load average increase
>                     and system freeze
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 3.10.0
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: PCI
>           Assignee: drivers_pci@kernel-bugs.osdl.org
>           Reporter: onorua@gmail.com
>         Regression: No
>
> I've faced with the situation when system stopped to process any request.
> Further analysis showed that the load average was around 20, and was constantly
> increasing (the normal LA for this system is 0.3-1).

Thanks for the report; sorry it fell through the cracks.

Is this problem reproducible?  If so, can you try to reproduce it on
v3.11?  Can you please attach a complete dmesg log and "lspci -vv" (as
root) output to the bugzilla?

The BUG_ON you're hitting is here, but I don't know what it means:

    #ifdef CONFIG_GENERIC_HARDIRQS
                for (i = 0; i < nvec; i++)
                        BUG_ON(irq_has_action(entry->irq + i));
    #endif

> dmesg showed following:
> ================================
> kernel BUG at drivers/pci/msi.c:342!
> invalid opcode: 0000 [#1] PREEMPT SMP
> Modules linked in: btusb binfmt_misc uinput ipv6 uvcvideo videobuf2_vmalloc
> videobuf2_memops videobuf2_core snd_hda_codec_hdmi arc4 snd_hda_codec_conexant
> snd_hda_intel iwldvm snd_hda_codec mac80211 snd_hwdep thinkpad_acpi iwlwifi
> cfg80211 mperf coretemp kvm_intel kvm e1000e ptp pps_core
> CPU: 0 PID: 23655 Comm: ifconfig Not tainted 3.10.0 #1
> Hardware name: LENOVO 4290PW4/4290PW4, BIOS 8DET66WW (1.36 ) 10/22/2012
> task: ffff880362cadb00 ti: ffff8803935b0000 task.ti: ffff8803935b0000
> RIP: 0010:[<ffffffff8127308a>]  [<ffffffff8127308a>] free_msi_irqs+0x56/0x10a
> RSP: 0018:ffff8803935b1c80  EFLAGS: 00010282
> RAX: ffff8803a8dcb900 RBX: ffff880393653e00 RCX: 00000000fffffffa
> RDX: 0000000000000000 RSI: 000000000000002a RDI: 0000000000000000
> RBP: ffff8803935b1ca8 R08: ffff88040d400000 R09: 000000000000002c
> R10: 00000000000000c8 R11: ffff8803935b1c5c R12: ffff880407823000
> R13: ffff8804078236a8 R14: 0000000000000000 R15: 0000000000000001
> FS:  00007f537f15d700(0000) GS:ffff88041e200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004026d4 CR3: 00000003a8faf000 CR4: 00000000000407f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Stack:
>  ffff880407823000 ffff88040629c000 00000000fffffff0 ffff880407823098
>  0000000000000001 ffff8803935b1cc0 ffffffff81273a5f ffff88040629c800
>  ffff8803935b1cd8 ffffffffa00283dc ffff88040629c800 ffff8803935b1d00
> Call Trace:
>  [<ffffffff81273a5f>] pci_disable_msi+0x2c/0x46
>  [<ffffffffa00283dc>] e1000e_reset_interrupt_capability+0x4c/0x59 [e1000e]
>  [<ffffffffa00286cf>] e1000_request_irq+0x1f1/0x249 [e1000e]
>  [<ffffffffa002c45a>] e1000_open+0xde/0x440 [e1000e]
>  [<ffffffff814b7a76>] __dev_open+0x8b/0xd0
>  [<ffffffff814b7c9a>] __dev_change_flags+0xa4/0x126
>  [<ffffffff814b7d8a>] dev_change_flags+0x18/0x4c
>  [<ffffffff81504e85>] devinet_ioctl+0x25b/0x548
>  [<ffffffff8150632d>] inet_ioctl+0x81/0x9e
>  [<ffffffff814a24b0>] sock_do_ioctl+0x20/0x3d
>  [<ffffffff814a28d6>] sock_ioctl+0x1fd/0x207
>  [<ffffffff810f058d>] vfs_ioctl+0x18/0x34
>  [<ffffffff810f0d49>] do_vfs_ioctl+0x32f/0x3e4
>  [<ffffffff810eb690>] ? final_putname+0x2f/0x32
>  [<ffffffff810f0e50>] SyS_ioctl+0x52/0x7d
>  [<ffffffff81023c20>] ? do_page_fault+0x9/0xb
>  [<ffffffff8157a652>] system_call_fastpath+0x16/0x1b
> Code: 83 7b 0c 00 74 2f 8a 0b 41 bf 01 00 00 00 45 31 f6 d0 e9 83 e1 07 41 d3
> e7 8b 7b 0c 44 01 f7 e8 f1 93 e1 ff 48 83 78 58 00 74 02 <0f> 0b 41 ff c6 45 39
> fe 7c e4 48 8b 5b 10 48 83 eb 10 eb b8 4c
> RIP  [<ffffffff8127308a>] free_msi_irqs+0x56/0x10a
>  RSP <ffff8803935b1c80>
> ==================
>
> --
> You are receiving this mail because:
> You are watching the assignee of the bug.
