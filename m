Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3FZU4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:56:43 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:42241 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3FZU4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:56:41 -0400
Date: Wed, 26 Jun 2013 23:56:37 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: rientjes@google.com, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: THP bug and crash on sparc64 3.8
In-Reply-To: <20130220.163423.1512055704917729172.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1302210734150.29243@math.ut.ee>
References: <20130219.144608.1425049879680985441.davem@davemloft.net> <20130220.014137.1184382041985855584.davem@davemloft.net> <alpine.SOC.1.00.1302201437190.20165@math.ut.ee> <20130220.163423.1512055704917729172.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, I think this patch will fix the problem, at least it fixes
> "git gc" crashes for me on UltraSPARC-IIIi:

Continuing an old stability thread after THP fix.

I had the following unfinished mail from February about my E420R:

-------------------
$ while true; do date; cp -a linux test; cd test; git gc; cd; rm -rf 
test; done
Thu Feb 21 00:32:10 EET 2013
error: failed to validate delta base reference at offset 78408555 from 
.git/objects/pack/pack-4c0e924040c6a404d9c5d71f7c9c4e416c225ae2.pack
error: failed to read object e255357764f92afcafafbd4879b222b8c752065a at 
offset 78408531 from 
.git/objects/pack/pack-4c0e924040c6a404d9c5d71f7c9c4e416c225ae2.pack
Timeout, server not responding.

So it still hangs on first git gc here, in addition it tells about an 
error that wasn't there before. So my sparc64 build have THP off for 
now.
---------------

I retested it with v3.10-rc7-24-g1e876e3 on the same E420R and it still 
still hangs the machine:

$ while true; do date; cp -a linux test; cd test; git gc; cd; rm -rf test; done
Wed Jun 26 18:05:15 EEST 2013
fatal: Unable to create '/home/mroos/test/.git/refs/heads/master.lock': 
File exists.

If no other git process is currently running, this probably means a
git process crashed in this repository earlier. Make sure no other git
process is running and remove the file manually to continue.
error: failed to run reflog
Wed Jun 26 18:12:04 EEST 2013
Counting objects: 124736
Timeout, server not responding.


Dmesg of that time:

[  839.867911] INFO: task jbd2/sda2-8:423 blocked for more than 120 seconds.
[ 5050.800668] eth0: Happy Meal out of receive descriptors, packet dropped.
[ 5073.340907] BUG: soft lockup - CPU#1 stuck for 21s! [in:imklog:2014]
[ 5073.415999] Modules linked in: ipv6 loop sg sr_mod cdrom sunhme
[ 5073.486773] irq event stamp: 34554
[ 5073.527403] hardirqs last  enabled at (34553): [<0000000000404b5c>] rtrap_xcall+0x18/0x20
[ 5073.625311] hardirqs last disabled at (34554): [<0000000000426b68>] valid_addr_bitmap_patch+0xb0/0x248
[ 5073.736751] softirqs last  enabled at (34552): [<0000000000463760>] __do_softirq+0x160/0x1c0
[ 5073.837766] softirqs last disabled at (34549): [<0000000000463998>] irq_exit+0xb8/0xe0
[ 5073.932546] CPU: 1 PID: 2014 Comm: in:imklog Not tainted 3.10.0-rc7-00024-g1e876e3 #28
[ 5074.027328] task: fffff800fc9f0000 ti: fffff800f9158000 task.ti: fffff800f9158000
[ 5074.116890] TSTATE: 0000008011001604 TPC: 00000000004a5eac TNPC: 00000000004a5eb0 Y: 00000000    Not tainted
[ 5074.234585] TPC: <__getnstimeofday+0x8c/0xe0>
[ 5074.286615] g0: 00000000009d9bc0 g1: b9fbeeb85129dfd4 g2: 000000012cb747e8 g3: 000000003b9ac9ff
[ 5074.390790] g4: fffff800fc9f0000 g5: fffff800fcf70000 g6: fffff800f9158000 g7: ffffffffc4653600
[ 5074.494935] o0: 0000021152427eab o1: 00000000008b6c00 o2: 000000000044cdd4 o3: 00000000009b9800
[ 5074.599075] o4: fffff800fc9f0000 o5: 000000000000000e sp: fffff800f915b3c1 ret_pc: 00000000004a5e54
[ 5074.707391] RPC: <__getnstimeofday+0x34/0xe0>
[ 5074.759426] l0: 0000000000000000 l1: 0000000000000000 l2: 00000000009b9800 l3: fffff800fc9f0000
[ 5074.863604] l4: 0000000000000001 l5: 0000000000000000 l6: 18e1600000000000 l7: 0000000000c57a20
[ 5074.967745] i0: fffff800f915bdd0 i1: 0000000000000001 i2: 000000000002cc1c i3: 00000000009df5f0
[ 5075.071890] i4: 000000000092e1c0 i5: 0000000051cb0d01 i6: fffff800f915b471 i7: 00000000004a65a4
[ 5075.176037] I7: <getnstimeofday+0x4/0x40>
[ 5075.223900] Call Trace:
[ 5075.253062]  [00000000004a65a4] getnstimeofday+0x4/0x40
[ 5075.315556]  [00000000004a6644] do_gettimeofday+0x4/0x40
[ 5075.379088]  [00000000004c2dec] compat_sys_gettimeofday+0xc/0xa0
[ 5075.450955]  [00000000004061b4] linux_sparc_syscall32+0x34/0x40
[ 5135.322238] [sched_delayed] sched: RT throttling activated
[ 5157.337289] BUG: soft lockup - CPU#1 stuck for 21s! [in:imklog:2014]
[ 5157.412439] Modules linked in: ipv6 loop sg sr_mod cdrom sunhme
[ 5157.483231] irq event stamp: 157214
[ 5157.524902] hardirqs last  enabled at (157213): [<0000000000404b5c>] rtrap_xcall+0x18/0x20
[ 5157.623854] hardirqs last disabled at (157214): [<0000000000426b68>] valid_addr_bitmap_patch+0xb0/0x248
[ 5157.736334] softirqs last  enabled at (157212): [<0000000000463760>] __do_softirq+0x160/0x1c0
[ 5157.838391] softirqs last disabled at (157209): [<0000000000463998>] irq_exit+0xb8/0xe0
[ 5157.934207] CPU: 1 PID: 2014 Comm: in:imklog Not tainted 3.10.0-rc7-00024-g1e876e3 #28
[ 5158.028991] task: fffff800fc9f0000 ti: fffff800f9158000 task.ti: fffff800f9158000
[ 5158.118557] TSTATE: 0000008911001604 TPC: 00000000004a5eb0 TNPC: 00000000004a5eb4 Y: 00000000    Not tainted
[ 5158.236246] TPC: <__getnstimeofday+0x90/0xe0>
[ 5158.288280] g0: 0000000000000000 g1: bbbafdffdee3516c g2: 0000000125372ce9 g3: 000000003b9ac9ff
[ 5158.392457] g4: fffff800fc9f0000 g5: fffff800fcf70000 g6: fffff800f9158000 g7: ffffffffc4653600
[ 5158.496601] o0: 0000021a2f73187e o1: 00000000f6cc2920 o2: 0000000000000000 o3: 0000000000000000
[ 5158.600744] o4: 00000000f6cc2923 o5: 0000000000000006 sp: fffff800f915b3c1 ret_pc: 00000000004a5e54
[ 5158.709055] RPC: <__getnstimeofday+0x34/0xe0>
[ 5158.761090] l0: 0000000000000000 l1: 0000000000000000 l2: 0000000000000000 l3: 0000000000000000
[ 5158.865266] l4: 0000000000000000 l5: 0000000000000000 l6: 0000000000000000 l7: 00000000f7558000
[ 5158.969411] i0: fffff800f915bdd0 i1: 00000000000aae59 i2: 000000000002cc1c i3: 00000000009df5f0
[ 5159.073556] i4: 000000000092e1c0 i5: 0000000051cb0d01 i6: fffff800f915b471 i7: 00000000004a65a4
[ 5159.177699] I7: <getnstimeofday+0x4/0x40>
[ 5159.225564] Call Trace:
[ 5159.254726]  [00000000004a65a4] getnstimeofday+0x4/0x40
[ 5159.317222]  [00000000004a6644] do_gettimeofday+0x4/0x40
[ 5159.380753]  [00000000004c2dec] compat_sys_gettimeofday+0xc/0xa0
[ 5159.452617]  [00000000004061b4] linux_sparc_syscall32+0x34/0x40
[ 5240.640594] BUG: soft lockup - CPU#3 stuck for 3588s! [getty:2409]
[ 5240.713631] Modules linked in: ipv6 loop sg sr_mod cdrom sunhme
[ 5240.784408] irq event stamp: 1020474
[ 5240.827120] hardirqs last  enabled at (1020473): [<0000000000404b5c>] rtrap_xcall+0x18/0x20
[ 5240.927111] hardirqs last disabled at (1020474): [<0000000000426b68>] valid_addr_bitmap_patch+0xb0/0x248
[ 5241.040632] softirqs last  enabled at (1019504): [<0000000000463760>] __do_softirq+0x160/0x1c0
[ 5241.143728] softirqs last disabled at (1019501): [<0000000000463998>] irq_exit+0xb8/0xe0
[ 5241.240590] CPU: 3 PID: 2409 Comm: getty Not tainted 3.10.0-rc7-00024-g1e876e3 #28
[ 5241.331209] task: fffff800f9330ea0 ti: fffff800fbeb0000 task.ti: fffff800fbeb0000
[ 5241.420772] TSTATE: 0000009911001607 TPC: 00000000004b423c TNPC: 00000000004b4240 Y: 0000223f    Not tainted
[ 5241.538465] TPC: <lock_acquire+0x5c/0x80>
[ 5241.586331] g0: 0000000000000000 g1: 0000000000000002 g2: 0000000000aff800 g3: 000000000000000c
[ 5241.690504] g4: fffff800f9330ea0 g5: fffff800fd170000 g6: fffff800fbeb0000 g7: 0011400000000000
[ 5241.794650] o0: 0000000000000001 o1: fffff800f9331470 o2: 00000000011ec9c0 o3: 0000000000cabb10
[ 5241.898793] o4: 0000000000000000 o5: 000000000063631d sp: fffff800fbeb3241 ret_pc: 00000000004b422c
[ 5242.007104] RPC: <lock_acquire+0x4c/0x80>
[ 5242.054976] l0: 0000000000000000 l1: 0000000000038df0 l2: 00000000009b9800 l3: fffff800f9330ea0
[ 5242.159151] l4: 0000000000000001 l5: 0000000000000000 l6: 0088280000000000 l7: 0000000000c57a20
[ 5242.263293] i0: fffff800fbb10500 i1: 0000000000000000 i2: 0000000000000000 i3: 0000000000000000
[ 5242.367437] i4: 0000000000000002 i5: 0000000000000000 i6: fffff800fbeb3311 i7: 00000000007d5448
[ 5242.471595] I7: <_raw_spin_lock+0x28/0x40>
[ 5242.520492] Call Trace:
[ 5242.549657]  [00000000007d5448] _raw_spin_lock+0x28/0x40
[ 5242.613200]  [0000000000502804] handle_pte_fault+0xc4/0x7c0
[ 5242.679847]  [0000000000503f18] handle_mm_fault+0x1b8/0x2a0
[ 5242.746512]  [000000000044c228] do_sparc64_fault+0x308/0x820
[ 5242.814195]  [0000000000407aec] sparc64_realfault_common+0x10/0x20
[ 5296.803419] eth0: Happy Meal out of receive descriptors, packet dropped.
[ 5296.970869] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5297.067349] sd 0:0:0:0: [sda] ABORT operation started
[ 5297.067875] jbd2/sda2-8     W 00000000007d4808  6856   423      2 0x03000000
[ 5297.067881] Call Trace:
[ 5297.067915]  [00000000007d475c] schedule+0x1c/0x80
[ 5297.067929]  [00000000007d4808] io_schedule+0x48/0x80
[ 5297.067953]  [000000000055a364] sleep_on_buffer+0x4/0x20
[ 5297.067967]  [00000000007d1ddc] __wait_on_bit+0x7c/0xe0
[ 5297.067980]  [00000000007d1e84] out_of_line_wait_on_bit+0x44/0x60
[ 5297.067993]  [000000000055a340] __wait_on_buffer+0x20/0x40
[ 5297.068018]  [00000000005e3f78] jbd2_journal_commit_transaction+0x778/0x1720
[ 5297.068035]  [00000000005e7d78] kjournald2+0xb8/0x260
[ 5297.068055]  [0000000000482de8] kthread+0x88/0xa0
[ 5297.068079]  [00000000004060c4] ret_from_syscall+0x1c/0x2c
[ 5297.068086]  [0000000000000000]           (null)
[ 5297.068093] no locks held by jbd2/sda2-8/423.
[ 5297.997058] sd 0:0:0:0: ABORT operation failed.
[ 5298.050643] sd 0:0:0:0: [sda] DEVICE RESET operation started
[ 5298.118320] sd 0:0:0:0: DEVICE RESET operation complete.
[ 5298.118491] scsi target0:0:0: control msgout:
[ 5298.118499]  c.
[ 5298.118581] scsi target0:0:0: has been reset

-- 
Meelis Roos (mroos@linux.ee)
