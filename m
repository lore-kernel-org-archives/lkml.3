Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaLPGaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:30:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:23465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaLPGaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:30:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,584,1413270000"; 
   d="scan'208";a="654657468"
Date: Mon, 15 Dec 2014 22:29:56 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [userns] BUG: unable to handle kernel NULL pointer
 dereference at (null)
Message-ID: <20141216062956.GB16776@wfg-t540p.sh.intel.com>
References: <1418613661.5745.164.camel@intel.com>
 <87iohcx1k1.fsf@x220.int.ebiederm.org>
 <1418694459.5745.198.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418694459.5745.198.camel@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 09:47:39AM +0800, Huang, Ying wrote:
> On Mon, 2014-12-15 at 11:31 -0600, Eric W. Biederman wrote:
> > Huang Ying <ying.huang@intel.com> writes:
> > 
> > > FYI, we noticed the below changes on
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
> > > commit bbea5f5532501fdd67f46442ba7b1122d7ff3123 
> > > ("userns: Add a knob to disable setgroups on a per user namespace basis")
> > 
> > Thank you.
> > 
> > I am quite puzzled by this failure.  There was an similar failure when
> > /proc/[pid]/setgroups was read (if I recall correctly).  I don't see how
> > that change could result at failures during open or failures during
> > boot.  I added a new file to proc which any reasonable system should
> > leave alone.  Are you by chance running trinity during boot?
> 
> Yes.  We are running trinity during boot.
> 
> > If the reproducer gave me any clue about which file that was opened or
> > which code path this happened on I would be bery interested.  If for no
> > other reason that to confirm that I have fixed the issue.
> 
> This is just boot test, with trinity running after kernel boot.
> 
> Fengguang, do you have more information?

The trinity runs like this

cd /tmp
/usr/local/bin/trinity -q -X -x get_robust_list -N 999999

Here are all the call traces. You can see some tracesys_phase2() in
some of the traces. It's a very reproducible error.

dmesg-vm-vp-quantal-x86_64-14:20141214024709:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    5.970508] init: Failed to create pty - disabling logging for job
[    5.973062] init: Failed to create pty - disabling logging for job
[    5.989614] init: Failed to create pty - disabling logging for job
[   16.365667] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.366010] IP: [<          (null)>]           (null)
[   16.366010] PGD 15ce4067 PUD 15d40067 PMD 0 
[   16.366010] Oops: 0010 [#1] SMP 
[   16.366010] Modules linked in:
[   16.366010] CPU: 0 PID: 308 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.366010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.366010] task: ffff880015d0bac0 ti: ffff88000006c000 task.ti: ffff88000006c000
[   16.366010] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.366010] RSP: 0018:ffff88000006fd80  EFLAGS: 00010246
[   16.366010] RAX: ffffffff818e4bc0 RBX: ffff88000006fe38 RCX: ffff8800149bb540
[   16.366010] RDX: 0000000000000000 RSI: ffff88000006fe38 RDI: ffff8800149bb540
[   16.366010] RBP: ffff88000006fe28 R08: 0000000000000000 R09: 0000000000000000
[   16.366010] R10: 0000000000000000 R11: ffff8800149bb540 R12: ffff880015939400
[   16.366010] R13: ffff88000006fde8 R14: 0000000000000000 R15: 0000000000000041
[   16.366010] FS:  00007f38e5814700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   16.366010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.366010] CR2: 0000000000000000 CR3: 00000000163c5000 CR4: 00000000000006f0
[   16.366010] DR0: 00000000021223d8 DR1: 0000000000000000 DR2: 0000000000000000
[   16.366010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000090602
[   16.366010] Stack:
[   16.366010]  ffffffff811f05c8 ffff8800121df000 ffff880015d0bac0 ffff880015d0bac0
[   16.366010]  ffff8800149bb540 ffff88000006ff24 ffff8800121df000 ffff880015d0bac0
[   16.366010]  ffff880015d0bac0 00000000df9a5ea7 0000000000000000 ffff880006b9f160
[   16.366010] Call Trace:
[   16.366010]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.366010]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.366010]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.366010]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.366010]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.366010]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   16.366010] Code:  Bad RIP value.
[   16.366010] RIP  [<          (null)>]           (null)
[   16.366010]  RSP <ffff88000006fd80>
[   16.366010] CR2: 0000000000000000
[   16.448360] ---[ end trace 28f4ad5b31699327 ]---
[   16.449384] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-16:20141214033109:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    5.751305] init: Failed to create pty - disabling logging for job
[    5.754282] init: Failed to create pty - disabling logging for job
[    5.770351] init: Failed to create pty - disabling logging for job
[   16.202720] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.203063] IP: [<          (null)>]           (null)
[   16.203063] PGD 158b6067 PUD 158ab067 PMD 0 
[   16.203063] Oops: 0010 [#1] SMP 
[   16.203063] Modules linked in:
[   16.203063] CPU: 1 PID: 308 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.203063] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.203063] task: ffff880016240000 ti: ffff880015fa4000 task.ti: ffff880015fa4000
[   16.203063] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.203063] RSP: 0018:ffff880015fa7d80  EFLAGS: 00010246
[   16.203063] RAX: ffffffff818e4bc0 RBX: ffff880015fa7e38 RCX: ffff8800150690c0
[   16.203063] RDX: 0000000000000000 RSI: ffff880015fa7e38 RDI: ffff8800150690c0
[   16.203063] RBP: ffff880015fa7e28 R08: 0000000000000000 R09: 0000000000000000
[   16.203063] R10: 0000000000000000 R11: ffff8800150690c0 R12: ffff8800158a2000
[   16.203063] R13: ffff880015fa7de8 R14: 0000000000000000 R15: 0000000000000041
[   16.203063] FS:  00007fcdce504700(0000) GS:ffff880013700000(0000) knlGS:0000000000000000
[   16.203063] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.203063] CR2: 0000000000000000 CR3: 00000000158be000 CR4: 00000000000006e0
[   16.203063] Stack:
[   16.203063]  ffffffff811f05c8 ffff880015e9c000 ffff880016240000 ffff880016240000
[   16.203063]  ffff8800150690c0 ffff880015fa7f24 ffff880015e9c000 ffff880016240000
[   16.203063]  ffff880016240000 00000000df9a5ea7 0000000000000000 ffff8800132ada20
[   16.203063] Call Trace:
[   16.203063]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.203063]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.203063]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.203063]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.203063]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.203063]  [<ffffffff8189811c>] tracesys_phase2+0xd4/0xd9
[   16.203063] Code:  Bad RIP value.
[   16.203063] RIP  [<          (null)>]           (null)
[   16.203063]  RSP <ffff880015fa7d80>
[   16.203063] CR2: 0000000000000000
[   16.245441] ---[ end trace 14420411ec238145 ]---
[   16.246517] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-19:20141214025008:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.768087] init: Failed to create pty - disabling logging for job
[    6.770899] init: Failed to create pty - disabling logging for job
[    6.772441] init: Failed to create pty - disabling logging for job
[   17.951867] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   17.952303] IP: [<          (null)>]           (null)
[   17.952303] PGD 15fb4067 PUD 15fb5067 PMD 0 
[   17.952303] Oops: 0010 [#1] SMP 
[   17.952303] Modules linked in:
[   17.952303] CPU: 0 PID: 303 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   17.952303] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   17.952303] task: ffff880012215820 ti: ffff880015efc000 task.ti: ffff880015efc000
[   17.952303] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   17.952303] RSP: 0018:ffff880015effd80  EFLAGS: 00010246
[   17.952303] RAX: ffffffff818e4bc0 RBX: ffff880015effe38 RCX: ffff8800077a09c0
[   17.952303] RDX: 0000000000000000 RSI: ffff880015effe38 RDI: ffff8800077a09c0
[   17.952303] RBP: ffff880015effe28 R08: 0000000000000000 R09: 0000000000000000
[   17.952303] R10: 0000000000000000 R11: ffff8800077a09c0 R12: ffff880016167100
[   17.952303] R13: ffff880015effde8 R14: 0000000000000000 R15: 0000000000000041
[   17.952303] FS:  00007fdf3a9e6700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   17.952303] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.952303] CR2: 0000000000000000 CR3: 0000000015fb3000 CR4: 00000000000006f0
[   17.952303] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   17.952303] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000070602
[   17.952303] Stack:
[   17.952303]  ffffffff811f05c8 0000000000000000 ffff880012215820 ffff880012215820
[   17.952303]  ffff8800077a09c0 ffff880015efff24 ffff88001217c000 ffff880012215820
[   17.952303]  ffff880012215820 0000000000000041 0000000000000000 ffff8800120ae2a0
[   17.952303] Call Trace:
[   17.952303]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   17.952303]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   17.952303]  [<ffffffff811f2695>] ? do_filp_open+0x5/0xb0
[   17.952303]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   17.952303]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   17.952303]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   17.952303] Code:  Bad RIP value.
[   17.952303] RIP  [<          (null)>]           (null)
[   17.952303]  RSP <ffff880015effd80>
[   17.952303] CR2: 0000000000000000
[   18.011433] ---[ end trace 56f4587452fd03b0 ]---
[   18.012567] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-1:20141214024819:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    5.631605] init: Failed to create pty - disabling logging for job
[    5.642401] init: Failed to create pty - disabling logging for job
[    5.643942] init: Failed to create pty - disabling logging for job
[   15.844678] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   15.845011] IP: [<          (null)>]           (null)
[   15.845011] PGD 15c23067 PUD 15c27067 PMD 0 
[   15.845011] Oops: 0010 [#1] SMP 
[   15.845011] Modules linked in:
[   15.845011] CPU: 1 PID: 307 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   15.845011] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   15.845011] task: ffff880016370000 ti: ffff880015c38000 task.ti: ffff880015c38000
[   15.845011] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   15.845011] RSP: 0018:ffff880015c3bd80  EFLAGS: 00010246
[   15.845011] RAX: ffffffff818e4bc0 RBX: ffff880015c3be38 RCX: ffff880000867180
[   15.845011] RDX: 0000000000000000 RSI: ffff880015c3be38 RDI: ffff880000867180
[   15.845011] RBP: ffff880015c3be28 R08: 0000000000000000 R09: 0000000000000000
[   15.845011] R10: 0000000000000000 R11: ffff880000867180 R12: ffff880000101400
[   15.845011] R13: ffff880015c3bde8 R14: 0000000000000000 R15: 0000000000000041
[   15.845011] FS:  00007f1807951700(0000) GS:ffff880013700000(0000) knlGS:0000000000000000
[   15.845011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.845011] CR2: 0000000000000000 CR3: 0000000015c1e000 CR4: 00000000000006e0
[   15.845011] DR0: 0000000001636000 DR1: 0000000000000000 DR2: 0000000000000000
[   15.845011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000602
[   15.845011] Stack:
[   15.845011]  ffffffff811f05c8 ffff880015900000 ffff880016370000 ffff880016370000
[   15.845011]  ffff880000867180 ffff880015c3bf24 ffff880015900000 ffff880016370000
[   15.845011]  ffff880016370000 00000000df9a5ea7 0000000000000000 ffff88000c358660
[   15.845011] Call Trace:
[   15.845011]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   15.845011]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   15.845011]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   15.845011]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   15.845011]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   15.845011]  [<ffffffff8189811c>] tracesys_phase2+0xd4/0xd9
[   15.845011] Code:  Bad RIP value.
[   15.845011] RIP  [<          (null)>]           (null)
[   15.845011]  RSP <ffff880015c3bd80>
[   15.845011] CR2: 0000000000000000
[   15.887793] ---[ end trace 76e70094c2dd541a ]---
[   15.888876] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-1:20141214033529:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.058024] init: Failed to create pty - disabling logging for job
[    6.061505] init: Failed to create pty - disabling logging for job
[    6.064106] init: Failed to create pty - disabling logging for job
[   16.329968] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.330010] IP: [<          (null)>]           (null)
[   16.330010] PGD 15f47067 PUD 158c9067 PMD 0 
[   16.330010] Oops: 0010 [#1] SMP 
[   16.330010] Modules linked in:
[   16.330010] CPU: 0 PID: 305 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.330010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.330010] task: ffff880015969d60 ti: ffff880015f7c000 task.ti: ffff880015f7c000
[   16.330010] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.330010] RSP: 0018:ffff880015f7fd80  EFLAGS: 00010246
[   16.330010] RAX: ffffffff818e4bc0 RBX: ffff880015f7fe38 RCX: ffff880007690300
[   16.330010] RDX: 0000000000000000 RSI: ffff880015f7fe38 RDI: ffff880007690300
[   16.330010] RBP: ffff880015f7fe28 R08: 0000000000000000 R09: 0000000000000000
[   16.330010] R10: 0000000000000000 R11: ffff880007690300 R12: ffff880016307700
[   16.330010] R13: ffff880015f7fde8 R14: 0000000000000000 R15: 0000000000000041
[   16.330010] FS:  00007ffb3195e700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   16.330010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.330010] CR2: 0000000000000000 CR3: 000000001588c000 CR4: 00000000000006f0
[   16.330010] DR0: 0000000001bd2000 DR1: 0000000001bcf000 DR2: 0000000000000000
[   16.330010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000093060a
[   16.330010] Stack:
[   16.330010]  ffffffff811f05c8 ffff880015a74000 ffff880015969d60 ffff880015969d60
[   16.330010]  ffff880007690300 ffff880015f7ff24 ffff880015a74000 ffff880015969d60
[   16.330010]  ffff880015969d60 00000000df9a5ea7 0000000000000000 ffff8800132adb60
[   16.330010] Call Trace:
[   16.330010]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.330010]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.330010]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.330010]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.330010]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.330010]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   16.330010] Code:  Bad RIP value.
[   16.330010] RIP  [<          (null)>]           (null)
[   16.330010]  RSP <ffff880015f7fd80>
[   16.330010] CR2: 0000000000000000
[   16.373984] ---[ end trace 9465043c62830d0f ]---
[   16.375032] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-24:20141214025008:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.858967] init: Failed to create pty - disabling logging for job
[    6.861771] init: Failed to create pty - disabling logging for job
[    6.878125] init: Failed to create pty - disabling logging for job
[   17.259548] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   17.260011] IP: [<          (null)>]           (null)
[   17.260011] PGD 15d08067 PUD 1616c067 PMD 0 
[   17.260011] Oops: 0010 [#1] SMP 
[   17.260011] Modules linked in:
[   17.260011] CPU: 0 PID: 308 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   17.260011] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   17.260011] task: ffff880006bc3ac0 ti: ffff8800162cc000 task.ti: ffff8800162cc000
[   17.260011] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   17.260011] RSP: 0018:ffff8800162cfd80  EFLAGS: 00010246
[   17.260011] RAX: ffffffff818e4bc0 RBX: ffff8800162cfe38 RCX: ffff880015133b40
[   17.260011] RDX: 0000000000000000 RSI: ffff8800162cfe38 RDI: ffff880015133b40
[   17.260011] RBP: ffff8800162cfe28 R08: 0000000000000000 R09: 0000000000000000
[   17.260011] R10: 0000000000000000 R11: ffff880015133b40 R12: ffff880015c5bd00
[   17.260011] R13: ffff8800162cfde8 R14: 0000000000000000 R15: 0000000000000041
[   17.260011] FS:  00007f1a789c0700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   17.260011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.260011] CR2: 0000000000000000 CR3: 0000000015c27000 CR4: 00000000000006f0
[   17.260011] Stack:
[   17.260011]  ffffffff811f05c8 ffff880016074000 ffff880006bc3ac0 ffff880006bc3ac0
[   17.260011]  ffff880015133b40 ffff8800162cff24 ffff880016074000 ffff880006bc3ac0
[   17.260011]  ffff880006bc3ac0 00000000df9a5ea7 0000000000000000 ffff8800132adde0
[   17.260011] Call Trace:
[   17.260011]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   17.260011]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   17.260011]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   17.260011]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   17.260011]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   17.260011]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   17.260011] Code:  Bad RIP value.
[   17.260011] RIP  [<          (null)>]           (null)
[   17.260011]  RSP <ffff8800162cfd80>
[   17.260011] CR2: 0000000000000000
[   17.340477] ---[ end trace fff3fb7e761775c5 ]---
[   17.341518] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-26:20141214033529:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    5.466074] init: Failed to create pty - disabling logging for job
[    5.469044] init: Failed to create pty - disabling logging for job
[    5.470728] init: Failed to create pty - disabling logging for job
[   16.091232] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.092010] IP: [<          (null)>]           (null)
[   16.092010] PGD 15e45067 PUD 15f3d067 PMD 0 
[   16.092010] Oops: 0010 [#1] SMP 
[   16.092010] Modules linked in:
[   16.092010] CPU: 1 PID: 300 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.092010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.092010] task: ffff880015861d60 ti: ffff880015fcc000 task.ti: ffff880015fcc000
[   16.092010] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.092010] RSP: 0018:ffff880015fcfd80  EFLAGS: 00010246
[   16.092010] RAX: ffffffff818e4bc0 RBX: ffff880015fcfe38 RCX: ffff8800154b5240
[   16.092010] RDX: 0000000000000000 RSI: ffff880015fcfe38 RDI: ffff8800154b5240
[   16.092010] RBP: ffff880015fcfe28 R08: 0000000000000000 R09: 0000000000000000
[   16.092010] R10: 0000000000000000 R11: ffff8800154b5240 R12: ffff880015f73600
[   16.092010] R13: ffff880015fcfde8 R14: 0000000000000000 R15: 0000000000000041
[   16.092010] FS:  00007fcd9c389700(0000) GS:ffff880013700000(0000) knlGS:0000000000000000
[   16.092010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.092010] CR2: 0000000000000000 CR3: 0000000015e44000 CR4: 00000000000006e0
[   16.092010] Stack:
[   16.092010]  ffffffff811f05c8 ffff880015cac000 ffff880015861d60 ffff880015861d60
[   16.092010]  ffff8800154b5240 ffff880015fcff24 ffff880015cac000 ffff880015861d60
[   16.092010]  ffff880015861d60 00000000df9a5ea7 0000000000000000 ffff8800120aea20
[   16.092010] Call Trace:
[   16.092010]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.092010]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.092010]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.092010]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.092010]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.092010]  [<ffffffff8189811c>] tracesys_phase2+0xd4/0xd9
[   16.092010] Code:  Bad RIP value.
[   16.092010] RIP  [<          (null)>]           (null)
[   16.092010]  RSP <ffff880015fcfd80>
[   16.092010] CR2: 0000000000000000
[   16.129733] ---[ end trace ca1748ffb7fe87ef ]---
[   16.130787] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-29:20141214024819:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.808902] init: Failed to create pty - disabling logging for job
[    6.813071] init: Failed to create pty - disabling logging for job
[    6.817142] init: Failed to create pty - disabling logging for job
[   17.077958] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   17.078010] IP: [<          (null)>]           (null)
[   17.078010] PGD 15f6d067 PUD 15809067 PMD 0 
[   17.078010] Oops: 0010 [#1] SMP 
[   17.078010] Modules linked in:
[   17.078010] CPU: 0 PID: 305 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   17.078010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   17.078010] task: ffff880015898000 ti: ffff880015e6c000 task.ti: ffff880015e6c000
[   17.078010] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   17.078010] RSP: 0018:ffff880015e6fd80  EFLAGS: 00010246
[   17.078010] RAX: ffffffff818e4bc0 RBX: ffff880015e6fe38 RCX: ffff880014fd3300
[   17.078010] RDX: 0000000000000000 RSI: ffff880015e6fe38 RDI: ffff880014fd3300
[   17.078010] RBP: ffff880015e6fe28 R08: 0000000000000000 R09: 0000000000000000
[   17.078010] R10: 0000000000000000 R11: ffff880014fd3300 R12: ffff880015f4d500
[   17.078010] R13: ffff880015e6fde8 R14: 0000000000000000 R15: 0000000000000041
[   17.078010] FS:  00007fdc2ae0a700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   17.078010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.078010] CR2: 0000000000000000 CR3: 0000000015f66000 CR4: 00000000000006f0
[   17.078010] DR0: 0000000002322000 DR1: 0000000000000000 DR2: 0000000000000000
[   17.078010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000070602
[   17.078010] Stack:
[   17.078010]  ffffffff811f05c8 ffff880015f13000 ffff880015898000 ffff880015898000
[   17.078010]  ffff880014fd3300 ffff880015e6ff24 ffff880015f13000 ffff880015898000
[   17.078010]  ffff880015898000 00000000df9a5ea7 0000000000000000 ffff8800120ae2a0
[   17.078010] Call Trace:
[   17.078010]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   17.078010]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   17.078010]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   17.078010]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   17.078010]  [<ffffffff81023601>] ? syscall_trace_leave+0x141/0x160
[   17.078010]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   17.078010]  [<ffffffff8189811c>] tracesys_phase2+0xd4/0xd9
[   17.078010] Code:  Bad RIP value.
[   17.078010] RIP  [<          (null)>]           (null)
[   17.078010]  RSP <ffff880015e6fd80>
[   17.078010] CR2: 0000000000000000
[   17.165544] ---[ end trace 8e40e1c234b95083 ]---
[   17.166609] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-31:20141214032559:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    5.704870] init: Failed to create pty - disabling logging for job
[    5.708675] init: Failed to create pty - disabling logging for job
[    5.724615] init: Failed to create pty - disabling logging for job
[   16.310442] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.311010] IP: [<          (null)>]           (null)
[   16.311010] PGD 1596b067 PUD 15d3d067 PMD 0 
[   16.311010] Oops: 0010 [#1] SMP 
[   16.311010] Modules linked in:
[   16.311010] CPU: 1 PID: 306 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.311010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.311010] task: ffff8800159b9d60 ti: ffff880015f88000 task.ti: ffff880015f88000
[   16.311010] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.311010] RSP: 0018:ffff880015f8bd80  EFLAGS: 00010246
[   16.311010] RAX: ffffffff818e4bc0 RBX: ffff880015f8be38 RCX: ffff880015144e40
[   16.311010] RDX: 0000000000000000 RSI: ffff880015f8be38 RDI: ffff880015144e40
[   16.311010] RBP: ffff880015f8be28 R08: 0000000000000000 R09: 0000000000000000
[   16.311010] R10: 0000000000000000 R11: ffff880015144e40 R12: ffff880015ee9500
[   16.311010] R13: ffff880015f8bde8 R14: 0000000000000000 R15: 0000000000000041
[   16.311010] FS:  00007f58b6a60700(0000) GS:ffff880013700000(0000) knlGS:0000000000000000
[   16.311010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.311010] CR2: 0000000000000000 CR3: 000000001596a000 CR4: 00000000000006e0
[   16.311010] Stack:
[   16.311010]  ffffffff811f05c8 ffff8800160b6000 ffff8800159b9d60 ffff8800159b9d60
[   16.311010]  ffff880015144e40 ffff880015f8bf24 ffff8800160b6000 ffff8800159b9d60
[   16.311010]  ffff8800159b9d60 00000000df9a5ea7 0000000000000000 ffff880006be2160
[   16.311010] Call Trace:
[   16.311010]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.311010]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.311010]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.311010]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.311010]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.311010]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   16.311010] Code:  Bad RIP value.
[   16.311010] RIP  [<          (null)>]           (null)
[   16.311010]  RSP <ffff880015f8bd80>
[   16.311010] CR2: 0000000000000000
[   16.381192] ---[ end trace 8c3feb71e8ea2655 ]---
[   16.382231] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-31:20141214033029:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.450234] init: Failed to create pty - disabling logging for job
[    6.453664] init: Failed to create pty - disabling logging for job
[    6.469702] init: Failed to create pty - disabling logging for job
[   16.930317] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.931011] IP: [<          (null)>]           (null)
[   16.931011] PGD 15fec067 PUD 15803067 PMD 0 
[   16.931011] Oops: 0010 [#1] SMP 
[   16.931011] Modules linked in:
[   16.931011] CPU: 1 PID: 307 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.931011] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.931011] task: ffff880015909d60 ti: ffff880015ff4000 task.ti: ffff880015ff4000
[   16.931011] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.931011] RSP: 0018:ffff880015ff7d80  EFLAGS: 00010246
[   16.931011] RAX: ffffffff818e4bc0 RBX: ffff880015ff7e38 RCX: ffff88001551c9c0
[   16.931011] RDX: 0000000000000000 RSI: ffff880015ff7e38 RDI: ffff88001551c9c0
[   16.931011] RBP: ffff880015ff7e28 R08: 0000000000000000 R09: 0000000000000000
[   16.931011] R10: 0000000000000000 R11: ffff88001551c9c0 R12: ffff880015f8dd00
[   16.931011] R13: ffff880015ff7de8 R14: 0000000000000000 R15: 0000000000000041
[   16.931011] FS:  00007f501f68c700(0000) GS:ffff880013700000(0000) knlGS:0000000000000000
[   16.931011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.931011] CR2: 0000000000000000 CR3: 0000000015801000 CR4: 00000000000006e0
[   16.931011] Stack:
[   16.931011]  ffffffff811f05c8 ffff88001600c000 ffff880015909d60 ffff880015909d60
[   16.931011]  ffff88001551c9c0 ffff880015ff7f24 ffff88001600c000 ffff880015909d60
[   16.931011]  ffff880015909d60 00000000df9a5ea7 0000000000000000 ffff880006b70660
[   16.931011] Call Trace:
[   16.931011]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.931011]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.931011]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.931011]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.931011]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.931011]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   16.931011] Code:  Bad RIP value.
[   16.931011] RIP  [<          (null)>]           (null)
[   16.931011]  RSP <ffff880015ff7d80>
[   16.931011] CR2: 0000000000000000
[   17.008876] ---[ end trace 01cd9056a842de7f ]---
[   17.009908] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-39:20141214033013:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.655939] init: Failed to create pty - disabling logging for job
[    6.661698] init: Failed to create pty - disabling logging for job
[    6.664540] init: Failed to create pty - disabling logging for job
[   16.932487] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.933010] IP: [<          (null)>]           (null)
[   16.933010] PGD 15c74067 PUD 15c77067 PMD 0 
[   16.933010] Oops: 0010 [#1] SMP 
[   16.933010] Modules linked in:
[   16.933010] CPU: 0 PID: 303 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.933010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.933010] task: ffff880015e8bac0 ti: ffff880015fa4000 task.ti: ffff880015fa4000
[   16.933010] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.933010] RSP: 0018:ffff880015fa7d80  EFLAGS: 00010246
[   16.933010] RAX: ffffffff818e4bc0 RBX: ffff880015fa7e38 RCX: ffff88000769f900
[   16.933010] RDX: 0000000000000000 RSI: ffff880015fa7e38 RDI: ffff88000769f900
[   16.933010] RBP: ffff880015fa7e28 R08: 0000000000000000 R09: 0000000000000000
[   16.933010] R10: 0000000000000000 R11: ffff88000769f900 R12: ffff880015f4f000
[   16.933010] R13: ffff880015fa7de8 R14: 0000000000000000 R15: 0000000000000041
[   16.933010] FS:  00007f3c4527e700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   16.933010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.933010] CR2: 0000000000000000 CR3: 0000000016329000 CR4: 00000000000006f0
[   16.933010] Stack:
[   16.933010]  ffffffff811f05c8 ffff88001607f000 ffff880015e8bac0 ffff880015e8bac0
[   16.933010]  ffff88000769f900 ffff880015fa7f24 ffff88001607f000 ffff880015e8bac0
[   16.933010]  ffff880015e8bac0 00000000df9a5ea7 0000000000000000 ffff880006b567a0
[   16.933010] Call Trace:
[   16.933010]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.933010]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.933010]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.933010]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.933010]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.933010]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   16.933010] Code:  Bad RIP value.
[   16.933010] RIP  [<          (null)>]           (null)
[   16.933010]  RSP <ffff880015fa7d80>
[   16.933010] CR2: 0000000000000000
[   17.012016] ---[ end trace f91c817cf87ba603 ]---
[   17.013061] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-47:20141214025007:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.491143] init: Failed to create pty - disabling logging for job
[    6.506682] init: Failed to create pty - disabling logging for job
[    6.510775] init: Failed to create pty - disabling logging for job
[   16.658121] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.659009] IP: [<          (null)>]           (null)
[   16.659009] PGD 163df067 PUD 15d74067 PMD 0 
[   16.659009] Oops: 0010 [#1] SMP 
[   16.659009] Modules linked in:
[   16.659009] CPU: 0 PID: 311 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.659009] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.659009] task: ffff88001636bac0 ti: ffff880015cb4000 task.ti: ffff880015cb4000
[   16.659009] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.659009] RSP: 0018:ffff880015cb7d80  EFLAGS: 00010246
[   16.659009] RAX: ffffffff818e4bc0 RBX: ffff880015cb7e38 RCX: ffff880000875b40
[   16.659009] RDX: 0000000000000000 RSI: ffff880015cb7e38 RDI: ffff880000875b40
[   16.659009] RBP: ffff880015cb7e28 R08: 0000000000000000 R09: 0000000000000000
[   16.659009] R10: 0000000000000000 R11: ffff880000875b40 R12: ffff880015e9b400
[   16.659009] R13: ffff880015cb7de8 R14: 0000000000000000 R15: 0000000000000041
[   16.659009] FS:  00007fbe4035a700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   16.659009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.659009] CR2: 0000000000000000 CR3: 00000000163dd000 CR4: 00000000000006f0
[   16.659009] DR0: 0000000001024000 DR1: 0000000001029000 DR2: 000000000102c000
[   16.659009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000d11062a
[   16.659009] Stack:
[   16.659009]  ffffffff811f05c8 ffff880006b2e000 ffff88001636bac0 ffff88001636bac0
[   16.659009]  ffff880000875b40 ffff880015cb7f24 ffff880006b2e000 ffff88001636bac0
[   16.659009]  ffff88001636bac0 00000000df9a5ea7 0000000000000000 ffff880006bb12a0
[   16.659009] Call Trace:
[   16.659009]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.659009]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.659009]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.659009]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.659009]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.659009]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   16.659009] Code:  Bad RIP value.
[   16.659009] RIP  [<          (null)>]           (null)
[   16.659009]  RSP <ffff880015cb7d80>
[   16.659009] CR2: 0000000000000000
[   16.699211] ---[ end trace 8ffa2e01e71e8d49 ]---
[   16.700233] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-49:20141214025002:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.796316] init: Failed to create pty - disabling logging for job
[    6.809977] init: Failed to create pty - disabling logging for job
[    6.823556] init: Failed to create pty - disabling logging for job
[   17.173311] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   17.174008] IP: [<          (null)>]           (null)
[   17.175033] PGD 15809067 PUD 15cd4067 PMD 0 
[   17.175033] Oops: 0010 [#1] SMP 
[   17.175033] Modules linked in:
[   17.175033] CPU: 0 PID: 309 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   17.175033] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   17.175033] task: ffff880015f91d60 ti: ffff880015c10000 task.ti: ffff880015c10000
[   17.175033] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   17.175033] RSP: 0018:ffff880015c13d80  EFLAGS: 00010246
[   17.175033] RAX: ffffffff818e4bc0 RBX: ffff880015c13e38 RCX: ffff880007799180
[   17.175033] RDX: 0000000000000000 RSI: ffff880015c13e38 RDI: ffff880007799180
[   17.175033] RBP: ffff880015c13e28 R08: 0000000000000000 R09: 0000000000000000
[   17.175033] R10: 0000000000000000 R11: ffff880007799180 R12: ffff880015f99800
[   17.175033] R13: ffff880015c13de8 R14: 0000000000000000 R15: 0000000000000041
[   17.175033] FS:  00007fb070200700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   17.175033] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.175033] CR2: 0000000000000000 CR3: 0000000015cfa000 CR4: 00000000000006f0
[   17.175033] Stack:
[   17.175033]  ffffffff811f05c8 ffff880015e3c000 ffff880015f91d60 ffff880015f91d60
[   17.175033]  ffff880007799180 ffff880015c13f24 ffff880015e3c000 ffff880015f91d60
[   17.175033]  ffff880015f91d60 00000000df9a5ea7 0000000000000000 ffff8800132adb60
[   17.175033] Call Trace:
[   17.175033]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   17.175033]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   17.175033]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   17.175033]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   17.175033]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   17.175033]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   17.175033] Code:  Bad RIP value.
[   17.175033] RIP  [<          (null)>]           (null)
[   17.175033]  RSP <ffff880015c13d80>
[   17.175033] CR2: 0000000000000000
[   17.252089] ---[ end trace 1dec5ff4ec44bbcc ]---
[   17.253137] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-4:20141214033023:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.975264] init: Failed to create pty - disabling logging for job
[    6.978446] init: Failed to create pty - disabling logging for job
[    6.985517] init: Failed to create pty - disabling logging for job
[   17.249737] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   17.250009] IP: [<          (null)>]           (null)
[   17.250009] PGD 161e4067 PUD 15cc6067 PMD 0 
[   17.250009] Oops: 0010 [#1] SMP 
[   17.250009] Modules linked in:
[   17.250009] CPU: 0 PID: 308 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   17.250009] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   17.250009] task: ffff880006bc3ac0 ti: ffff880015e28000 task.ti: ffff880015e28000
[   17.250009] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   17.250009] RSP: 0018:ffff880015e2bd80  EFLAGS: 00010246
[   17.250009] RAX: ffffffff818e4bc0 RBX: ffff880015e2be38 RCX: ffff88001521d240
[   17.250009] RDX: 0000000000000000 RSI: ffff880015e2be38 RDI: ffff88001521d240
[   17.250009] RBP: ffff880015e2be28 R08: 0000000000000000 R09: 0000000000000000
[   17.250009] R10: 0000000000000000 R11: ffff88001521d240 R12: ffff88001592c500
[   17.250009] R13: ffff880015e2bde8 R14: 0000000000000000 R15: 0000000000000041
[   17.250009] FS:  00007f2c72064700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   17.250009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.250009] CR2: 0000000000000000 CR3: 000000001621b000 CR4: 00000000000006f0
[   17.250009] Stack:
[   17.250009]  ffffffff811f05c8 ffff880015862000 ffff880006bc3ac0 ffff880006bc3ac0
[   17.250009]  ffff88001521d240 ffff880015e2bf24 ffff880015862000 ffff880006bc3ac0
[   17.250009]  ffff880006bc3ac0 00000000df9a5ea7 0000000000000000 ffff8800160c4020
[   17.250009] Call Trace:
[   17.250009]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   17.250009]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   17.250009]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   17.250009]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   17.250009]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   17.250009]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   17.250009] Code:  Bad RIP value.
[   17.250009] RIP  [<          (null)>]           (null)
[   17.250009]  RSP <ffff880015e2bd80>
[   17.250009] CR2: 0000000000000000
[   17.324928] ---[ end trace 96b496c9a2dcf6d9 ]---
[   17.329019] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-54:20141214025007:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.560158] init: Failed to create pty - disabling logging for job
[    6.563720] init: Failed to create pty - disabling logging for job
[    6.590405] init: Failed to create pty - disabling logging for job
[   16.880927] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.881012] IP: [<          (null)>]           (null)
[   16.881012] PGD 15eab067 PUD 15e2d067 PMD 0 
[   16.881012] Oops: 0010 [#1] SMP 
[   16.881012] Modules linked in:
[   16.881012] CPU: 0 PID: 306 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.881012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.881012] task: ffff880015f99d60 ti: ffff880015dd4000 task.ti: ffff880015dd4000
[   16.881012] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.881012] RSP: 0018:ffff880015dd7d80  EFLAGS: 00010246
[   16.881012] RAX: ffffffff818e4bc0 RBX: ffff880015dd7e38 RCX: ffff880007788180
[   16.881012] RDX: 0000000000000000 RSI: ffff880015dd7e38 RDI: ffff880007788180
[   16.881012] RBP: ffff880015dd7e28 R08: 0000000000000000 R09: 0000000000000000
[   16.881012] R10: 0000000000000000 R11: ffff880007788180 R12: ffff880015f5cb00
[   16.881012] R13: ffff880015dd7de8 R14: 0000000000000000 R15: 0000000000000041
[   16.881012] FS:  00007f0323992700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   16.881012] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.881012] CR2: 0000000000000000 CR3: 00000000158a4000 CR4: 00000000000006f0
[   16.881012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.881012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000010602
[   16.881012] Stack:
[   16.881012]  ffffffff811f05c8 ffff88000011e000 ffff880015f99d60 ffff880015f99d60
[   16.881012]  ffff880007788180 ffff880015dd7f24 ffff88000011e000 ffff880015f99d60
[   16.881012]  ffff880015f99d60 00000000df9a5ea7 0000000000000000 ffff880012396520
[   16.881012] Call Trace:
[   16.881012]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.881012]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.881012]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.881012]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.881012]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.881012]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   16.881012] Code:  Bad RIP value.
[   16.881012] RIP  [<          (null)>]           (null)
[   16.881012]  RSP <ffff880015dd7d80>
[   16.881012] CR2: 0000000000000000
[   16.921833] ---[ end trace b390f2880a9827df ]---
[   16.922874] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-58:20141214024722:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.232767] init: Failed to create pty - disabling logging for job
[    6.237350] init: Failed to create pty - disabling logging for job
[    6.239002] init: Failed to create pty - disabling logging for job
[   16.527366] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.528013] IP: [<          (null)>]           (null)
[   16.528013] PGD 162ec067 PUD 15d7c067 PMD 0 
[   16.528013] Oops: 0010 [#1] SMP 
[   16.528013] Modules linked in:
[   16.528013] CPU: 0 PID: 308 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.528013] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.528013] task: ffff880015930000 ti: ffff880015dcc000 task.ti: ffff880015dcc000
[   16.528013] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.528013] RSP: 0018:ffff880015dcfd80  EFLAGS: 00010246
[   16.528013] RAX: ffffffff818e4bc0 RBX: ffff880015dcfe38 RCX: ffff880014e8f480
[   16.528013] RDX: 0000000000000000 RSI: ffff880015dcfe38 RDI: ffff880014e8f480
[   16.528013] RBP: ffff880015dcfe28 R08: 0000000000000000 R09: 0000000000000000
[   16.528013] R10: 0000000000000000 R11: ffff880014e8f480 R12: ffff880000056700
[   16.528013] R13: ffff880015dcfde8 R14: 0000000000000000 R15: 0000000000000041
[   16.528013] FS:  00007f9d02352700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   16.528013] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.528013] CR2: 0000000000000000 CR3: 00000000162f3000 CR4: 00000000000006f0
[   16.528013] DR0: 0000000000000000 DR1: 0000000000f35600 DR2: 0000000000000000
[   16.528013] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000009d060a
[   16.528013] Stack:
[   16.528013]  ffffffff811f05c8 ffff8800159fe000 ffff880015930000 ffff880015930000
[   16.528013]  ffff880014e8f480 ffff880015dcff24 ffff8800159fe000 ffff880015930000
[   16.528013]  ffff880015930000 00000000df9a5ea7 0000000000000000 ffff8800132ada20
[   16.528013] Call Trace:
[   16.528013]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.528013]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.528013]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.528013]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.528013]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.528013]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   16.528013] Code:  Bad RIP value.
[   16.528013] RIP  [<          (null)>]           (null)
[   16.528013]  RSP <ffff880015dcfd80>
[   16.528013] CR2: 0000000000000000
[   16.571805] ---[ end trace 48fed84bb0ccfa9e ]---
[   16.572878] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-63:20141214033059:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.709763] init: Failed to create pty - disabling logging for job
[    6.713229] init: Failed to create pty - disabling logging for job
[    6.716028] init: Failed to create pty - disabling logging for job
[   17.258203] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   17.259057] IP: [<          (null)>]           (null)
[   17.259057] PGD 16247067 PUD 15dc4067 PMD 0 
[   17.259057] Oops: 0010 [#1] SMP 
[   17.259057] Modules linked in:
[   17.259057] CPU: 0 PID: 299 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   17.259057] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   17.259057] task: ffff8800162bd820 ti: ffff880015d5c000 task.ti: ffff880015d5c000
[   17.259057] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   17.259057] RSP: 0018:ffff880015d5fd80  EFLAGS: 00010246
[   17.259057] RAX: ffffffff818e4bc0 RBX: ffff880015d5fe38 RCX: ffff880007688240
[   17.259057] RDX: 0000000000000000 RSI: ffff880015d5fe38 RDI: ffff880007688240
[   17.259057] RBP: ffff880015d5fe28 R08: 0000000000000000 R09: 0000000000000000
[   17.259057] R10: 0000000000000000 R11: ffff880007688240 R12: ffff880015e17000
[   17.259057] R13: ffff880015d5fde8 R14: 0000000000000000 R15: 0000000000000041
[   17.259057] FS:  00007ff449088700(0000) GS:ffff880013600000(0000) knlGS:0000000000000000
[   17.259057] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.259057] CR2: 0000000000000000 CR3: 0000000015dc1000 CR4: 00000000000006f0
[   17.259057] Stack:
[   17.259057]  ffffffff811f05c8 ffff88000007a000 ffff8800162bd820 ffff8800162bd820
[   17.259057]  ffff880007688240 ffff880015d5ff24 ffff88000007a000 ffff8800162bd820
[   17.259057]  ffff8800162bd820 00000000df9a5ea7 0000000000000000 ffff8800132adb60
[   17.259057] Call Trace:
[   17.259057]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   17.259057]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   17.259057]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   17.259057]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   17.259057]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   17.259057]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   17.259057] Code:  Bad RIP value.
[   17.259057] RIP  [<          (null)>]           (null)
[   17.259057]  RSP <ffff880015d5fd80>
[   17.259057] CR2: 0000000000000000
[   17.330274] ---[ end trace c0ab0bf6411ddf05 ]---
[   17.331366] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-64:20141214024833:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.285399] init: Failed to create pty - disabling logging for job
[    6.302316] init: Failed to create pty - disabling logging for job
[    6.305044] init: Failed to create pty - disabling logging for job
[   16.650038] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.651010] IP: [<          (null)>]           (null)
[   16.651010] PGD 1621a067 PUD 15e02067 PMD 0 
[   16.651010] Oops: 0010 [#1] SMP 
[   16.651010] Modules linked in:
[   16.651010] CPU: 1 PID: 301 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.651010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.651010] task: ffff880000115820 ti: ffff880016324000 task.ti: ffff880016324000
[   16.651010] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.651010] RSP: 0018:ffff880016327d80  EFLAGS: 00010246
[   16.651010] RAX: ffffffff818e4bc0 RBX: ffff880016327e38 RCX: ffff880000852000
[   16.651010] RDX: 0000000000000000 RSI: ffff880016327e38 RDI: ffff880000852000
[   16.651010] RBP: ffff880016327e28 R08: 0000000000000000 R09: 0000000000000000
[   16.651010] R10: 0000000000000000 R11: ffff880000852000 R12: ffff8800162b3a00
[   16.651010] R13: ffff880016327de8 R14: 0000000000000000 R15: 0000000000000041
[   16.651010] FS:  00007f0b9332e700(0000) GS:ffff880013700000(0000) knlGS:0000000000000000
[   16.651010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.651010] CR2: 0000000000000000 CR3: 0000000015d80000 CR4: 00000000000006e0
[   16.651010] DR0: ffffffffff302243 DR1: 0000000000000000 DR2: 0000000000000000
[   16.651010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000602
[   16.651010] Stack:
[   16.651010]  ffffffff811f05c8 ffff880015de7000 ffff880000115820 ffff880000115820
[   16.651010]  ffff880000852000 ffff880016327f24 ffff880015de7000 ffff880000115820
[   16.651010]  ffff880000115820 00000000df9a5ea7 0000000000000000 ffff8800160cb020
[   16.651010] Call Trace:
[   16.651010]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.651010]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.651010]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.651010]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.651010]  [<ffffffff81023601>] ? syscall_trace_leave+0x141/0x160
[   16.651010]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.651010]  [<ffffffff8189811c>] tracesys_phase2+0xd4/0xd9
[   16.651010] Code:  Bad RIP value.
[   16.651010] RIP  [<          (null)>]           (null)
[   16.651010]  RSP <ffff880016327d80>
[   16.651010] CR2: 0000000000000000
[   16.700053] ---[ end trace e7ef9944434589ac ]---
[   16.701101] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-64:20141214033500:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    5.834905] init: Failed to create pty - disabling logging for job
[    5.836322] init: Failed to create pty - disabling logging for job
[    5.851603] init: Failed to create pty - disabling logging for job
[   16.220230] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   16.221010] IP: [<          (null)>]           (null)
[   16.221010] PGD 16233067 PUD 163af067 PMD 0 
[   16.221010] Oops: 0010 [#1] SMP 
[   16.221010] Modules linked in:
[   16.221010] CPU: 1 PID: 304 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   16.221010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.221010] task: ffff880015c79d60 ti: ffff8800163a0000 task.ti: ffff8800163a0000
[   16.221010] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   16.221010] RSP: 0018:ffff8800163a3d80  EFLAGS: 00010246
[   16.221010] RAX: ffffffff818e4bc0 RBX: ffff8800163a3e38 RCX: ffff880014ce8780
[   16.221010] RDX: 0000000000000000 RSI: ffff8800163a3e38 RDI: ffff880014ce8780
[   16.221010] RBP: ffff8800163a3e28 R08: 0000000000000000 R09: 0000000000000000
[   16.221010] R10: 0000000000000000 R11: ffff880014ce8780 R12: ffff880015931a00
[   16.221010] R13: ffff8800163a3de8 R14: 0000000000000000 R15: 0000000000000041
[   16.221010] FS:  00007f71e4ac4700(0000) GS:ffff880013700000(0000) knlGS:0000000000000000
[   16.221010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.221010] CR2: 0000000000000000 CR3: 0000000016375000 CR4: 00000000000006e0
[   16.221010] DR0: 0000000000e8a000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.221010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000010602
[   16.221010] Stack:
[   16.221010]  ffffffff811f05c8 ffff880015e68000 ffff880015c79d60 ffff880015c79d60
[   16.221010]  ffff880014ce8780 ffff8800163a3f24 ffff880015e68000 ffff880015c79d60
[   16.221010]  ffff880015c79d60 00000000df9a5ea7 0000000000000000 ffff8800132adb60
[   16.221010] Call Trace:
[   16.221010]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   16.221010]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   16.221010]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   16.221010]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   16.221010]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   16.221010]  [<ffffffff8189811c>] tracesys_phase2+0xd4/0xd9
[   16.221010] Code:  Bad RIP value.
[   16.221010] RIP  [<          (null)>]           (null)
[   16.221010]  RSP <ffff8800163a3d80>
[   16.221010] CR2: 0000000000000000
[   16.305333] ---[ end trace fb88f84422403b3e ]---
[   16.306354] Kernel panic - not syncing: Fatal exception

dmesg-vm-vp-quantal-x86_64-6:20141214033028:x86_64-rhel:3.18.0-rc6-00015-gbbea5f5:1

[    6.615834] init: Failed to create pty - disabling logging for job
[    6.622355] init: Failed to create pty - disabling logging for job
[    6.629827] init: Failed to create pty - disabling logging for job
[   17.240710] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   17.241010] IP: [<          (null)>]           (null)
[   17.241010] PGD 15ca3067 PUD 163fe067 PMD 0 
[   17.241010] Oops: 0010 [#1] SMP 
[   17.241010] Modules linked in:
[   17.241010] CPU: 1 PID: 308 Comm: trinity-main Not tainted 3.18.0-rc6-00015-gbbea5f5 #1
[   17.241010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   17.241010] task: ffff880015e05820 ti: ffff8800161b4000 task.ti: ffff8800161b4000
[   17.241010] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[   17.241010] RSP: 0018:ffff8800161b7d80  EFLAGS: 00010246
[   17.241010] RAX: ffffffff818e4bc0 RBX: ffff8800161b7e38 RCX: ffff880014f75a80
[   17.241010] RDX: 0000000000000000 RSI: ffff8800161b7e38 RDI: ffff880014f75a80
[   17.241010] RBP: ffff8800161b7e28 R08: 0000000000000000 R09: 0000000000000000
[   17.241010] R10: 0000000000000000 R11: ffff880014f75a80 R12: ffff880015c00700
[   17.241010] R13: ffff8800161b7de8 R14: 0000000000000000 R15: 0000000000000041
[   17.241010] FS:  00007ff3dd10e700(0000) GS:ffff880013700000(0000) knlGS:0000000000000000
[   17.241010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.241010] CR2: 0000000000000000 CR3: 0000000015da0000 CR4: 00000000000006e0
[   17.241010] Stack:
[   17.241010]  ffffffff811f05c8 ffff88001629a000 ffff880015e05820 ffff880015e05820
[   17.241010]  ffff880014f75a80 ffff8800161b7f24 ffff88001629a000 ffff880015e05820
[   17.241010]  ffff880015e05820 00000000df9a5ea7 0000000000000000 ffff8800132ada20
[   17.241010] Call Trace:
[   17.241010]  [<ffffffff811f05c8>] ? path_openat+0x538/0x680
[   17.241010]  [<ffffffff811f26ca>] do_filp_open+0x3a/0xb0
[   17.241010]  [<ffffffff811ff947>] ? __alloc_fd+0xa7/0x130
[   17.241010]  [<ffffffff811df5ec>] do_sys_open+0x12c/0x220
[   17.241010]  [<ffffffff811df6fe>] SyS_open+0x1e/0x20
[   17.241010]  [<ffffffff81897f29>] system_call_fastpath+0x12/0x17
[   17.241010] Code:  Bad RIP value.
[   17.241010] RIP  [<          (null)>]           (null)
[   17.241010]  RSP <ffff8800161b7d80>
[   17.241010] CR2: 0000000000000000
[   17.314686] ---[ end trace bf8864177e72cff3 ]---
[   17.315724] Kernel panic - not syncing: Fatal exception

Thanks,
Fengguang
