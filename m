Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbaBFQFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:05:10 -0500
Received: from plane.gmane.org ([80.91.229.3]:55464 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbaBFQFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:05:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: kmemleak or crc32_le  bug?
Date: Thu, 06 Feb 2014 17:04:49 +0100
Message-ID: <52F3B2A1.4080702@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Vegard Nossum <vegardno@ifi.uio.no>, Pekka Enberg <penberg@kernel.org>
X-Gmane-NNTP-Posting-Host: router1.itwm.fhg.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm frequently getting 

UG: unable to handle kernel paging request at ffff880f87550dc0
IP: [<ffffffff813016d0>] crc32_le+0x30/0x110

called from kmemleak, see bottom of the message.


schubert@wheezy@fsdevel2 linux-stable>addr2line -e vmlinux -i -a ffffffff813016d0
0xffffffff813016d0
/home/schubert/src/linux/linux-stable/lib/crc32.c:129
/home/schubert/src/linux/linux-stable/lib/crc32.c:247
/home/schubert/src/linux/linux-stable/lib/crc32.c:265

129: unlikely, refers to "u32 q" in crc32_body

247: crc = crc32_body(crc, p, len, tab);

Also doesn't seem to be very likely.

265:

u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
{
        return crc32_le_generic(crc, p, len,
                        (const u32 (*)[256])crc32table_le, CRCPOLY_LE);
}

Doesn't seem anything could fail here either.

schubert@fsdevel2 linux-stable>addr2line -e vmlinux -i -a ffffffff811cdff9
0xffffffff811cdff9
/home/schubert/src/linux/linux-stable/mm/kmemleak.c:1350

kmemleak_scan() +1350

	list_for_each_entry_rcu(object, &object_list, object_list) {
		spin_lock_irqsave(&object->lock, flags);
		if (color_white(object) && (object->flags & OBJECT_ALLOCATED)
1350:		    && update_checksum(object) && get_object(object)) {


With the "Cannot allocate a kmemleak_object structure" messages, 
somehow looks like object is not proper initialized, but update_checksum()
checks for that. Hmm, I'm not sure about kmemcheck_shadow_lookup(), 
especially about

> 	if (!virt_addr_valid(address))
> 		return NULL;

So is the test 

> 	shadow = kmemcheck_shadow_lookup(addr);
> 	if (!shadow)
> 		return true;

right here? Shouldn't that be 'return false'?



Thanks,
Bernd


kmemleak: Cannot allocate a kmemleak_object structure
kmemleak: Kernel memory leak detector disabled
kmemleak: Cannot allocate a kmemleak_object structure
BUG: unable to handle kernel paging request at ffff880f87550dc0
IP: [<ffffffff813016d0>] crc32_le+0x30/0x110
PGD 103f370067 PUD 10350e7067 PMD 10350ac067 PTE 8000000f87550060
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: fhgfs(O) fhgfs_client_opentk(O) parport_pc ppdev lp parport uinput nfsd auth_rpcgss dm_mod mlx4_ib ib_umad rdma_ucm rdma_cm ib_addr iw_cm ib_uverbs ib_ipoib ib_cm ib_sa ib_mad ib_core iTCO_wdt gpio_ich iTCO_vendor_support dcdbas mgag200 snd_pcm snd_page_alloc ttm snd_timer drm_kms_helper syscopyarea snd sysfillrect ipmi_si soundcore sysimgblt ipmi_msghandler pcspkr sb_edac edac_core joydev shpchp lpc_ich wmi acpi_power_meter ipv6 fuse nfsv4 nfsv3 nfs_acl nfs lockd sunrpc fscache sg sd_mod crc_t10dif crct10dif_common ahci libahci mlx4_core tg3 mpt2sas hwmon raid_class ptp scsi_transport_sas pps_core [last unloaded: fhgfs_client_opentk]
CPU: 24 PID: 230 Comm: kmemleak Tainted: G           O 3.13.1-dbg-00001-gf9a023f #66
Hardware name: Dell Inc. PowerEdge R720/08RW36, BIOS 2.1.3 11/20/2013
task: ffff8807db75a790 ti: ffff8807d2f76000 task.ti: ffff8807d2f76000
RIP: 0010:[<ffffffff813016d0>]  [<ffffffff813016d0>] crc32_le+0x30/0x110
RSP: 0018:ffff8807d2f77db0  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff880f833cb408 RCX: 0000000000000001
RDX: 0000000000000046 RSI: ffff880f87550dc0 RDI: ffff880f87550dbc
RBP: ffff8807d2f77db8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: ffff880f87550dbc R12: 0000000000000286
R13: 0000000000000000 R14: 0000000001040000 R15: 0000000000000400
FS:  0000000000000000(0000) GS:ffff88081e600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff880f87550dc0 CR3: 000000103dc0c000 CR4: 00000000001407e0
Stack:
 ffff880f833cb408 ffff8807d2f77e18 ffffffff811cdff9 ffffffff811cdf51
 ffffffff81a3d984 ffff880700000009 ffff880f833cb458 00000000000927c0
 00000000000927c0 0000000000000000 ffffffff811ce5a0 0000000000000000
Call Trace:
 [<ffffffff811cdff9>] kmemleak_scan+0x399/0x590
 [<ffffffff811cdf51>] ? kmemleak_scan+0x2f1/0x590
 [<ffffffff811ce5a0>] ? kmemleak_write+0x3b0/0x3b0
 [<ffffffff811ce603>] kmemleak_scan_thread+0x63/0xd0
 [<ffffffff81090306>] kthread+0xf6/0x110
 [<ffffffff81090210>] ? kthread_create_on_node+0x250/0x250
 [<ffffffff8167a58c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81090210>] ? kthread_create_on_node+0x250/0x250
Code: 89 f8 48 89 e5 53 0f 85 cd 00 00 00 49 89 d2 48 c1 ea 03 4c 8d 5e fc 41 83 e2 07 48 85 d2 0f 84 81 00 00 00 4c 89 df 45 31 c0 90 <8b> 5f 04 48 83 c7 08 49 83 c0 01 8b 0f 31 c3 89 d8 44 0f b6 cb 
RIP  [<ffffffff813016d0>] crc32_le+0x30/0x110
 RSP <ffff8807d2f77db0>
CR2: ffff880f87550dc0
---[ end trace 71bec186f2a04a6f ]---
BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:20
in_atomic(): 1, irqs_disabled(): 1, pid: 230, name: kmemleak
INFO: lockdep is turned off.

