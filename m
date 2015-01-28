Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448AbbA1Gg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:36:26 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:46615 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbbA1GgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:36:24 -0500
MIME-Version: 1.0
In-Reply-To: <tip-e2e64a932556cdfae455497dbe94a8db151fc9fa@git.kernel.org>
References: <20141219012206.4220.27491.stgit@jbrandeb-cp2.jf.intel.com>
	<tip-e2e64a932556cdfae455497dbe94a8db151fc9fa@git.kernel.org>
Date: Tue, 27 Jan 2015 22:36:23 -0800
X-Google-Sender-Auth: 651sjukFerkRowqeZPJPjB8NqMQ
Message-ID: <CAE9FiQWiUF4Rs4+f3q3nww1iNNbVSAZcZX5akYyQa=3Avf1fqg@mail.gmail.com>
Subject: Re: [tip:irq/core] genirq: Set initial affinity in irq_set_affinity_hint()
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 2:42 AM, tip-bot for Jesse Brandeburg
<tipbot@zytor.com> wrote:
> Commit-ID:  e2e64a932556cdfae455497dbe94a8db151fc9fa
> Gitweb:     http://git.kernel.org/tip/e2e64a932556cdfae455497dbe94a8db151fc9fa
> Author:     Jesse Brandeburg <jesse.brandeburg@intel.com>
> AuthorDate: Thu, 18 Dec 2014 17:22:06 -0800
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Fri, 23 Jan 2015 11:38:25 +0100
>
> genirq: Set initial affinity in irq_set_affinity_hint()
>
> Problem:
> The default behavior of the kernel is somewhat undesirable as all
> requested interrupts end up on CPU0 after registration.  A user can
> run irqbalance daemon, or can manually configure smp_affinity via the
> proc filesystem, but the default affinity of the interrupts for all
> devices is always CPU zero, this can cause performance problems or
> very heavy cpu use of only one core if not noticed and fixed by the
> user.
>
> Solution:
> Enable the setting of the initial affinity directly when the driver
> sets a hint.
>
> This enabling means that kernel drivers can include an initial
> affinity setting for the interrupt, instead of all interrupts starting
> out life on CPU0. Of course if irqbalance is still running then the
> interrupts will get moved as before.
>
> This function is currently called by drivers in block, crypto,
> infiniband, ethernet and scsi trees, but only a handful, so these will
> be the devices affected by this change.
>
> Tested on i40e, and default interrupts were spread across the CPUs
> according to the hint.

got:

[   37.952944] ixgbe 0000:60:00.0 eth0: NIC Link is Up 1 Gbps, Flow
Control: None
[   37.977308] Sending DHCP requests .
[   38.495744] ixgbe 0000:60:00.1 eth1: NIC Link is Up 1 Gbps, Flow
Control: None
[   38.828424] ixgbe 0000:70:00.0 eth2: NIC Link is Up 1 Gbps, Flow
Control: None
[   39.733559] DHCP/BOOTP: Ignoring delayed packet
[   40.662056] ixgbe 0000:70:00.1 eth3: NIC Link is Up 1 Gbps, Flow
Control: None
[   40.735128] DHCP/BOOTP: Ignoring delayed packet
[   41.959359] ., OK
[   42.071498] IP-Config: Got DHCP answer from 10.129.253.1, my
address is 10.129.253.184
[   42.081388] ixgbe 0000:60:00.1: removed PHC on eth1
[   42.515741] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[   42.524510] IP: [<ffffffff81568410>] __bitmap_intersects+0x10/0x80
[   42.531432] PGD 0
[   42.533687] Oops: 0000 [#1] SMP
[   42.537310] Modules linked in:
[   42.540736] CPU: 22 PID: 1 Comm: swapper/0 Tainted: G        W
3.19.0-rc6-yh-01797-g7c88af2 #11
[   42.561913] task: ffff88ff621f0000 ti: ffff883f626c4000 task.ti:
ffff883f626c4000
[   42.570270] RIP: 0010:[<ffffffff81568410>]  [<ffffffff81568410>]
__bitmap_intersects+0x10/0x80
[   42.579899] RSP: 0000:ffff883f626c7ab8  EFLAGS: 00010002
[   42.585820] RAX: ffff887f5a97a380 RBX: ffff887f61f98000 RCX: ffffffff8167f360
[   42.593794] RDX: 0000000000000090 RSI: ffffffff82e48e80 RDI: 0000000000000000
[   42.601761] RBP: ffff883f626c7ab8 R08: 0000000000000001 R09: 0000000000000001
[   42.609728] R10: 0000000000000002 R11: ffffffff8284c7ab R12: 0000000000000000
[   42.617695] R13: 00000000000000d9 R14: ffff887f5a97a380 R15: 0000000000000292
[   42.625662] FS:  0000000000000000(0000) GS:ffff887f7be00000(0000)
knlGS:0000000000000000
[   42.634699] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.641113] CR2: 0000000000000000 CR3: 0000000005c1a000 CR4: 00000000001407e0
[   42.649082] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   42.657049] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   42.665014] Stack:
[   42.667258]  ffff883f626c7b18 ffffffff8167f39d ffff88ff621f0000
ffff887f61f980a8
[   42.675553]  ffff883f626c7b28 0000000000000046 00000000626c7b38
ffff887f61f98000
[   42.683848]  0000000000000000 0000000000000000 0000000000000000
0000000000000292
[   42.692145] Call Trace:
[   42.694883]  [<ffffffff8167f39d>] intel_ioapic_set_affinity+0x3d/0x1b0
[   42.702171]  [<ffffffff8167fa50>] set_remapped_irq_affinity+0x20/0x30
[   42.709377]  [<ffffffff81105fdc>] irq_do_set_affinity+0x1c/0x60
[   42.715986]  [<ffffffff81106157>] irq_set_affinity_locked+0x37/0xf0
[   42.722982]  [<ffffffff8110625a>] __irq_set_affinity+0x4a/0x80
[   42.729492]  [<ffffffff811062db>] irq_set_affinity_hint+0x4b/0x70
[   42.736309]  [<ffffffff81be95de>] ixgbe_free_irq+0x8e/0xe0
[   42.742441]  [<ffffffff81bf06c6>] ixgbe_close_suspend+0x26/0x40
[   42.749049]  [<ffffffff81bf0712>] ixgbe_close+0x32/0xd0
[   42.754898]  [<ffffffff81f3b4a5>] __dev_close_many+0xb5/0xe0
[   42.761215]  [<ffffffff81f3b663>] __dev_close+0x33/0x50
[   42.767056]  [<ffffffff81f43a31>] __dev_change_flags+0xc1/0x160
[   42.773669]  [<ffffffff81f4f4d7>] ? rtnl_lock+0x17/0x20
[   42.779492]  [<ffffffff81f43af9>] dev_change_flags+0x29/0x60
[   42.785811]  [<ffffffff830953e4>] ic_close_devs+0x2e/0x48
[   42.791839]  [<ffffffff830966a4>] ip_auto_config+0xe67/0xef4
[   42.798171]  [<ffffffff8100031d>] ? do_one_initcall+0xdd/0x1e0
[   42.804690]  [<ffffffff810ede46>] ? trace_hardirqs_on_caller+0x16/0x260
[   42.812076]  [<ffffffff810ee09d>] ? trace_hardirqs_on+0xd/0x10
[   42.818589]  [<ffffffff8309583d>] ? root_nfs_parse_addr+0xbf/0xbf
[   42.825391]  [<ffffffff81000323>] do_one_initcall+0xe3/0x1e0
[   42.831720]  [<ffffffff8302d1e9>] kernel_init_freeable+0x1d5/0x26c
[   42.838620]  [<ffffffff8302c844>] ? do_early_param+0x8c/0x8c
[   42.844940]  [<ffffffff820639c0>] ? rest_init+0xc0/0xc0
[   42.850775]  [<ffffffff820639ce>] kernel_init+0xe/0x100
[   42.856624]  [<ffffffff820854ac>] ret_from_fork+0x7c/0xb0
[   42.862651]  [<ffffffff820639c0>] ? rest_init+0xc0/0xc0
[   42.868486] Code: 4a 23 04 d6 48 f7 d2 48 21 d0 4a 89 04 d7 49 09
c1 31 c0 4d 85 c9 0f 95 c0 5d c3 41 89 d2 55 41 c1 ea 06 45 85 d2 48
89 e5 74 2e <48> 8b 07 48 85 06 75 60 31 c0 45 31 c9 eb 14 90 4c 8b 44
06 08
[   42.890269] RIP  [<ffffffff81568410>] __bitmap_intersects+0x10/0x80
[   42.897277]  RSP <ffff883f626c7ab8>
[   42.901168] CR2: 0000000000000000
[   42.904871] ---[ end trace 856d5615c8414b29 ]---

there are lots of irq_set_affinity_hint(irq, NULL);

git grep -A 1 irq_set_affinity_hint | grep NULL | wc -l
26

You may need to add check ...in irq_set_affinity_hint()

Thanks

Yinghai
