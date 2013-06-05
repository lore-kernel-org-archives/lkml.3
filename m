Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3FEDOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 23:14:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:54060 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab3FEDOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:14:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,803,1363158000"; 
   d="scan'208";a="344919911"
Date: Wed, 5 Jun 2013 11:14:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [hv] BUG: kernel freezes after [   13.356381] PCI: CLS 0 bytes,
 default 64
Message-ID: <20130605031447.GA15427@localhost>
References: <20130604141536.GA13324@localhost>
 <20130604224424.GB533@kroah.com>
 <e4b859d1ac994528ab04e1f5d6a335ae@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4b859d1ac994528ab04e1f5d6a335ae@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 11:36:23PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Tuesday, June 04, 2013 6:44 PM
> > To: Fengguang Wu
> > Cc: KY Srinivasan; devel@linuxdriverproject.org; Greg Kroah-Hartman; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [hv] BUG: kernel freezes after [ 13.356381] PCI: CLS 0 bytes, default
> > 64
> > 
> > On Tue, Jun 04, 2013 at 10:15:36PM +0800, Fengguang Wu wrote:
> > > Greetings,
> > >
> > > I got the below dmesg (kernel freezes at the end of it) and the first bad commit
> > is
> > >
> > > commit cf6a2eacbcb2593b5b91d0817915c4f0464bb534
> > > Author: K. Y. Srinivasan <kys@microsoft.com>
> > > Date:   Thu Dec 1 09:59:34 2011 -0800
> > >
> > >     drivers: hv: Don't OOPS when you cannot init vmbus
> > >
> > >     The hv vmbus driver was causing an OOPS since it was trying to register
> > drivers
> > >     on top of the bus even if initialization of the bus has failed for some
> > >     reason (such as the odd chance someone would run a hv enabled kernel in a
> > >     non-hv environment).
> > >
> > >     Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > >     Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > >     Cc: stable <stable@vger.kernel.org>
> > >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > >
> > > [   13.356381] PCI: CLS 0 bytes, default 64
> > 
> > Ick, not good.  K.Y., any reason why I shouldn't just revert this?
> 
> I have asked Wu for details. Examining the relevant VMBUS code, I cannot see
> how this patch could be responsible for the freeze. For what it is worth looking at dmesg, it appears that
> we are not running on a Hypervisor.

Oops sorry - it's found to be a wrong bisect: the parent commit will panic
and reboot (dmesg 1). The "first bad" commit fixes this which reveals the
one kernel freeze bug we are talking about (dmesg 2 and 3).

I'll teach the bisect script to double check for any bad dmesgs in the parent
commit, too. Sorry for the noises!

dmesg 1)

[   46.712057] Initializing Realtek PCIE storage driver...
[   46.718895] hv_vmbus: registering driver storvsc
[   46.721199] ------------[ cut here ]------------
[   46.725102] kernel BUG at /c/wfg/linux-mmotm/drivers/base/driver.c:227!
[   46.725102] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[   46.725102] CPU 0
[   46.725102] Modules linked in:
[   46.725102]
[   46.725102] Pid: 1, comm: swapper Not tainted 3.2.0-rc1-00032-gd2554f5 #5 Bochs Bochs
[   46.725102] RIP: 0010:[<ffffffff819479b9>]  [<ffffffff819479b9>] driver_register+0x24/0x116
[   46.725102] RSP: 0018:ffff88001e3d7e60  EFLAGS: 00010246
[   46.725102] RAX: ffffffff8412bb40 RBX: ffffffff84118440 RCX: 0000000021c921c8
[   46.725102] RDX: 0000000000000000 RSI: ffffffff82d50b77 RDI: ffffffff84118440
[   46.725102] RBP: ffff88001e3d7ea0 R08: 0000000000000002 R09: ffffffff84f219b0
[   46.725102] R10: ffff88001e3d7fd8 R11: 0000000012250d00 R12: 0000000000000000
[   46.725102] R13: ffffffff83ad69d3 R14: 0000000000000000 R15: 0000000000000000
[   46.725102] FS:  0000000000000000(0000) GS:ffff88001f200000(0000) knlGS:0000000000000000
[   46.725102] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   46.725102] CR2: 00000000ffffffff CR3: 0000000003e0e000 CR4: 00000000000006f0
[   46.725102] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   46.725102] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   46.725102] Process swapper (pid: 1, threadinfo ffff88001e3d6000, task ffff88001e3d8040)
[   46.725102] Stack:
[   46.725102]  ffff88001e3d7eb0 ffff88001e3d7e70 ffff88001e3d7e80 ffffffff84118420
[   46.725102]  0000000000000000 ffffffff83ad69d3 0000000000000000 0000000000000000
[   46.725102]  ffff88001e3d7ed0 ffffffff8279ff08 ffffffff83e69268 ffffffff845ca850
[   46.725102] Call Trace:
[   46.725102]  [<ffffffff8279ff08>] __vmbus_driver_register+0x4a/0x5c
[   46.725102]  [<ffffffff844571fd>] ? rtsx_init+0x29/0x29
[   46.725102]  [<ffffffff84457232>] storvsc_drv_init+0x35/0x3f
[   46.725102]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[   46.725102]  [<ffffffff843dec92>] kernel_init+0xce/0x148
[   46.725102]  [<ffffffff82d59a44>] kernel_thread_helper+0x4/0x10
[   46.725102]  [<ffffffff82d50fb4>] ? retint_restore_args+0x13/0x13
[   46.725102]  [<ffffffff843debc4>] ? start_kernel+0x3fa/0x3fa
[   46.725102]  [<ffffffff82d59a40>] ? gs_change+0x13/0x13
[   46.725102] Code: 5c 41 5d 41 5e 5d c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 66 66 66 66 90 48 8b 47 08 48 89 fb 4
8 83 78 68 00 75 02 <0f> 0b 48 83 78 30 00 74 07 48 83 7f 30 00 75 1c 48 83 78 38 00
[   46.725102] RIP  [<ffffffff819479b9>] driver_register+0x24/0x116
[   46.725102]  RSP <ffff88001e3d7e60>
[   46.966780] ---[ end trace 3dd4b4c5cfb57f3a ]---
[   46.973158] swapper used greatest stack depth: 3688 bytes left
[   47.005973] Kernel panic - not syncing: Attempted to kill init!
[   47.008702] Pid: 1, comm: swapper Tainted: G      D      3.2.0-rc1-00032-gd2554f5 #5
[   47.014326] Call Trace:
[   47.015625]  [<ffffffff82d0218c>] panic+0xa0/0x1b3
[   47.022083]  [<ffffffff82d503b2>] ? _raw_write_unlock_irq+0x2e/0x47
[   47.026970]  [<ffffffff810a0e69>] do_exit+0x9b/0x797
[   47.041007]  [<ffffffff8109f124>] ? kmsg_dump+0x86/0x12e
[   47.043343]  [<ffffffff82d51c53>] oops_end+0xaf/0xb8
[   47.056684]  [<ffffffff81048eb4>] die+0x5a/0x66
[   47.063927]  [<ffffffff82d51781>] do_trap+0x11a/0x129
[   47.148336]  [<ffffffff81046b52>] do_invalid_op+0x98/0xa1
[   47.150775]  [<ffffffff819479b9>] ? driver_register+0x24/0x116
[   47.171468]  [<ffffffff810cc02b>] ? trace_hardirqs_off_caller+0x3f/0x9e
[   47.186517]  [<ffffffff81671f6d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   47.197010]  [<ffffffff82d50fe4>] ? restore_args+0x30/0x30
[   47.199568]  [<ffffffff82d598bb>] invalid_op+0x1b/0x20
[   47.220202]  [<ffffffff82d50b77>] ? _raw_spin_unlock_irqrestore+0x3e/0x61
[   47.223015]  [<ffffffff819479b9>] ? driver_register+0x24/0x116
[   47.238554]  [<ffffffff8279ff08>] __vmbus_driver_register+0x4a/0x5c
[   47.252987]  [<ffffffff844571fd>] ? rtsx_init+0x29/0x29
[   47.255383]  [<ffffffff84457232>] storvsc_drv_init+0x35/0x3f
[   47.284949]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[   47.293599]  [<ffffffff843dec92>] kernel_init+0xce/0x148
[   47.295865]  [<ffffffff82d59a44>] kernel_thread_helper+0x4/0x10
[   47.308746]  [<ffffffff82d50fb4>] ? retint_restore_args+0x13/0x13
[   47.322365]  [<ffffffff843debc4>] ? start_kernel+0x3fa/0x3fa
[   47.324743]  [<ffffffff82d59a40>] ? gs_change+0x13/0x13
[   47.341145] Rebooting in 10 seconds..

dmesg 2)

[  102.384974] VFS: Mounted root (nfs filesystem) on device 0:16.
[  102.386750] debug: unmapping init memory ffffffff84208000..ffffffff845ee000
[  102.390166] Write protecting the kernel read-only data: 47104k
[  102.398549] debug: unmapping init memory ffff880002d65000..ffff880002e00000
[  102.400722] debug: unmapping init memory ffff880003c15000..ffff880003e00000
[  103.108549] modprobe used greatest stack depth: 3352 bytes left
[  105.511184] S02mountkernfs. used greatest stack depth: 3264 bytes left
[  110.928107] eth0: no IPv6 routers present
[  111.393157] cdrom_id used greatest stack depth: 2944 bytes left

BUG: kernel freezed

dmesg 3)

[  108.880449] VFS: Mounted root (nfs filesystem) on device 0:16.
[  108.883544] debug: unmapping init memory ffffffff84208000..ffffffff845ee000
[  108.902348] Write protecting the kernel read-only data: 47104k
[  108.912389] debug: unmapping init memory ffff880002d65000..ffff880002e00000
[  108.926343] debug: unmapping init memory ffff880003c15000..ffff880003e00000
[  109.872198] modprobe used greatest stack depth: 3352 bytes left
[  113.101880] create_static_n used greatest stack depth: 3312 bytes left
[  116.634463] scsi_id used greatest stack depth: 2912 bytes left
[  116.955018] eth0: no IPv6 routers present
[ 8538.332146] hrtimer: interrupt took 13301848 ns

BUG: kernel freezed

Thanks,
Fengguang
