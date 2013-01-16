Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab3APKQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:16:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758446Ab3APKQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:16:46 -0500
Date: Wed, 16 Jan 2013 11:16:44 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
Message-ID: <20130116101644.GA29162@quack.suse.cz>
References: <1358272714-23375-1-git-send-email-jack@suse.cz>
 <20130115233742.e8571f92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115233742.e8571f92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-01-13 23:37:42, Andrew Morton wrote:
> On Tue, 15 Jan 2013 18:58:34 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > A CPU can be caught in console_unlock() for a long time (tens of seconds are
> > reported by our customers) when other CPUs are using printk heavily and serial
> > console makes printing slow.  This triggers softlockup warnings because
> > interrupts are disabled for the whole time console_unlock() runs (e.g.
> > vprintk() calls console_unlock() with interrupts disabled).
> 
> It should trigger the NMI watchdog in that case?
  Yes. I see soft lockup reports like:
BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u:126:791]
Modules linked in: sd_mod crc_t10dif usbhid hid uhci_hcd ehci_hcd thermal usbcore usb_common bfa scsi_transport_fc scsi_tgt processor thermal_sys hwmon dm_snapshot dm_mod ata_generic ata_piix libata hpsa cciss scsi_mod
Supported: Yes

Pid: 791, comm: kworker/u:126 Not tainted 3.0.13-0.9-pae #1 HP ProLiant DL380 G7
EIP: 0060:[<c027ceda>] EFLAGS: 00000202 CPU: 0
EIP is at smp_call_function_many+0x1aa/0x220
EAX: 00000292 EBX: f3006780 ECX: 00000004 EDX: 00000080
ESI: f3006798 EDI: 00000003 EBP: c08696b4 ESP: eeed7e68
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kworker/u:126 (pid: 791, ti=eeed6000 task=eeed4f60 task.ti=eeed6000)
Stack:
 00000080 01000000 00000000 c034bbd0 00000000 c034bbd0 f0c03850 ef5c7400
 c027cf6e 00000001 00000000 c027cf9b 00000000 f0c03840 f0c03850 ef5c7400
 c0351e55 00000001 ef5c743c 00000000 ef5c7400 f0c03840 ef5c7460 f1041c05
Call Trace:
 [<c027cf6e>] smp_call_function+0x1e/0x30
 [<c027cf9b>] on_each_cpu+0x1b/0x50
 [<c0351e55>] __blkdev_put+0x165/0x1a0
 [<c03db6f2>] register_disk+0x142/0x150
 [<c03db7e9>] add_disk+0xe9/0x160
 [<f823f166>] sd_probe_async+0xf6/0x1c0 [sd_mod]
 [<c026e0ff>] async_run_entry_fn+0x5f/0x160
 [<c026062c>] process_one_work+0x13c/0x2d0
 [<c0262e87>] worker_thread+0x127/0x370
 [<c0266764>] kthread+0x74/0x80
 [<c05ce126>] kernel_thread_helper+0x6/0xd
Code: e8 3c 9d 34 00 0f ae f0 89 f6 89 f0 ff 15 04 1e 83 c0
80 7c 24 07 00 0f 84 bf fe ff ff f6 43 10 01 0f 84 b5 fe ff ff 66 90 f3 90
<f6> 43 10 01 66 90 75 f6 83 c4 10 5b 5e 5f 5d c3 8d b6 00 00 00 
 
  Note that this is with our SLE11-SP2 kernel but printk code upstream is
the same upstream in this regard.

> > We fix the issue by printing at most 1 KB of messages (unless we are in an
> > early boot stage or oops is happening) in one console_unlock() call. The rest
> > of the buffer will be printed either by further callers to printk() or by a
> > queued work.
> 
> Complex.  Did you try just putting a touch_nmi_watchdog() in the loop?
  I didn't try that. I suppose touch_nmi_watchdog() +
rcu_cpu_stall_reset() would make the messages go away (yes, RCU eventually
freaks out as well). But is it really sane that we keep single CPU busy,
unusable for anything else, for such a long time? There can be no RCU
callbacks processed, no IPIs are processed (which is what triggers
softlockup reports), etc.

I agree that if we silence all the warnings, everything will eventually
hang waiting for the stalled CPU, that will finish the printing and things
start from the beginning (we tried silencing RCU with rcu_cpu_stall_reset()
and that makes the machine boot eventually). But it seems like papering
over a real problem?  
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
