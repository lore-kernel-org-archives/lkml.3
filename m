Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3FDQyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:54:33 -0400
Received: from mailhub.stratus.com ([134.111.1.17]:43749 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3FDQyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:54:31 -0400
Date: Tue, 4 Jun 2013 12:50:31 -0400 (EDT)
From: Joe Lawrence <joe.lawrence@stratus.com>
X-X-Sender: jlaw@jlaw-desktop.mno.stratus.com
To: Joe Lawrence <joe.lawrence@stratus.com>
cc: Rusty Russell <rusty@rustcorp.com.au>,
        Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until
 we've removed all exposure.
In-Reply-To: <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com>
Message-ID: <alpine.DEB.2.02.1306041243320.19072@jlaw-desktop.mno.stratus.com>
References: <51A8E884.1080009@candelatech.com> <87ehclumhr.fsf@rustcorp.com.au> <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com>
 <51ACBD6A.1030304@candelatech.com> <51ACC60B.8090504@candelatech.com> <87d2s2to4z.fsf@rustcorp.com.au> <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Jun 2013 16:54:10.0954 (UTC) FILETIME=[22C836A0:01CE6144]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, Joe Lawrence wrote:

> Hi Rusty,
> 
> See my 3.9 stack traces below, which may or may not be what Ben had
> been seeing.  If you like, I can try a similar loop as the one you were
> testing in the other email.  

With a modified version of your module load/unload loop (only needed 
insmod as the module initialization routine returns -EINVAL to mimic 
mgag200 with incorrect modeset value).  This crashed right out of the 
chute on 3.9.4 ... still running OK with 3.9 + commit 944a1fa "module: 
don't unlink the module until we've removed all exposure".

-- Joe

test_mod.c :

#include <linux/module.h>
#include <linux/delay.h>

MODULE_LICENSE("GPL");

static int test_mod_init(void) { return -EINVAL; }
static void test_mod_exit(void) {}

module_init(test_mod_init);
module_exit(test_mod_exit);


from the console log :

test_mod: module verification failed: signature and/or required key missing - tainting kernel
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xd4/0x100()
Hardware name: ftServer 6400
sysfs: cannot create duplicate filename '/module/test_mod'
Modules linked in: test_mod(OF+) ebtable_nat nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 bonding xt_conntrack nf_conntrack ib_iser rdma_cm ebtable_filter ib_addr ebtables iw_cm ib_cm ib_sa ib_mad ip6table_filter ib_core ip6_tables iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_multipath coretemp crc32c_intel ghash_clmulni_intel pcspkr ixgbe joydev mdio igb ptp pps_core dca vhost_net tun macvtap macvlan uinput raid1 sd_mod i2c_algo_bit drm_kms_helper ttm drm usb_storage mpt2sas raid_class scsi_transport_sas i2c_core
Pid: 8466, comm: insmod Tainted: GF          O 3.9.4 #1
Call Trace:
 [<ffffffff8106159f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81061696>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81319895>] ? strlcat+0x65/0x90
 [<ffffffff81222784>] sysfs_add_one+0xd4/0x100
 [<ffffffff812229a8>] create_dir+0x78/0xd0
 [<ffffffff81222cf6>] sysfs_create_dir+0x86/0xe0
 [<ffffffff813135a8>] kobject_add_internal+0xa8/0x270
 [<ffffffff81313ad3>] kobject_init_and_add+0x63/0x90
 [<ffffffff810c9f9d>] load_module+0x12dd/0x2890
 [<ffffffff81331690>] ? ddebug_proc_open+0xc0/0xc0
 [<ffffffff810cb63a>] sys_init_module+0xea/0x140
 [<ffffffff81681119>] system_call_fastpath+0x16/0x1b
---[ end trace 54bd469258bec620 ]---
------------[ cut here ]------------
WARNING: at lib/kobject.c:196 kobject_add_internal+0x204/0x270()
Hardware name: ftServer 6400
kobject_add_internal failed for test_mod with -EEXIST, don't try to register things with the same name in the same directory.
Modules linked in: test_mod(OF+) ebtable_nat nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 bonding xt_conntrack nf_conntrack ib_iser rdma_cm ebtable_filter ib_addr ebtables iw_cm ib_cm ib_sa ib_mad ip6table_filter ib_core ip6_tables iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_multipath coretemp crc32c_intel ghash_clmulni_intel pcspkr ixgbe joydev mdio igb ptp pps_core dca vhost_net tun macvtap macvlan uinput raid1 sd_mod i2c_algo_bit drm_kms_helper ttm drm usb_storage mpt2sas raid_class scsi_transport_sas i2c_core
Pid: 8466, comm: insmod Tainted: GF       W  O 3.9.4 #1
Call Trace:
 [<ffffffff8106159f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81061696>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81313704>] kobject_add_internal+0x204/0x270
 [<ffffffff81313ad3>] kobject_init_and_add+0x63/0x90
 [<ffffffff810c9f9d>] load_module+0x12dd/0x2890
 [<ffffffff81331690>] ? ddebug_proc_open+0xc0/0xc0
 [<ffffffff810cb63a>] sys_init_module+0xea/0x140
 [<ffffffff81681119>] system_call_fastpath+0x16/0x1b
---[ end trace 54bd469258bec621 ]---
test_mod: module is already loaded
test_mod: module is already loaded
BUG: unable to handle kernel paging request at ffffffffa02ed08c
IP: [<ffffffff81313491>] kobject_put+0x11/0x60
PGD 1c0f067 PUD 1c10063 PMD 84dd68067 PTE 0
Oops: 0000 [#1] SMP 
Modules linked in: test_mod(OF+) ebtable_nat nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 bonding xt_conntrack nf_conntrack ib_iser rdma_cm ebtable_filter ib_addr ebtables iw_cm ib_cm ib_sa ib_mad ip6table_filter ib_core ip6_tables iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_multipath coretemp crc32c_intel ghash_clmulni_intel pcspkr ixgbe joydev mdio igb ptp pps_core dca vhost_net tun macvtap macvlan uinput raid1 sd_mod i2c_algo_bit drm_kms_helper ttm drm usb_storage mpt2sas raid_class scsi_transport_sas i2c_core
CPU 25 
Pid: 8551, comm: insmod Tainted: GF       W  O 3.9.4 #1 Stratus ftServer 6400/G7LAZ
RIP: 0010:[<ffffffff81313491>]  [<ffffffff81313491>] kobject_put+0x11/0x60
RSP: 0018:ffff881050b95d58  EFLAGS: 00010286
RAX: 0000000000000022 RBX: ffffffffa02ed050 RCX: ffff88107fd2fba8
RDX: 0000000000000000 RSI: ffff88107fd2df58 RDI: ffffffffa02ed050
RBP: ffff881050b95d68 R08: ffffffff81ce2080 R09: 00000000000007c6
R10: 0000000000000000 R11: 00000000000007c5 R12: ffffffffa02ed050
R13: ffffffffffffffea R14: ffffffffa035c000 R15: ffffffffa035c018
FS:  00007fd0768a3740(0000) GS:ffff88107fd20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa02ed08c CR3: 0000001050bd7000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process insmod (pid: 8551, threadinfo ffff881050b94000, task ffff88105169c9e0)
Stack:
 00000000ffff8000 ffff881050b95ee8 ffff881050b95ed8 ffffffff810cb541
 ffffffff81331690 ffffc90017037fff ffffc90017038000 ffffffff00000002
 ffffc900170220e0 ffffc90000000003 ffffffffa02c1270 00000000000002a0
Call Trace:
 [<ffffffff810cb541>] load_module+0x2881/0x2890
 [<ffffffff81331690>] ? ddebug_proc_open+0xc0/0xc0
 [<ffffffff810cb63a>] sys_init_module+0xea/0x140
 [<ffffffff81681119>] system_call_fastpath+0x16/0x1b
Code: 01 00 e9 10 ff ff ff 0f 1f 00 55 48 83 ef 38 48 89 e5 e8 43 fe ff ff 5d c3 90 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 1a <f6> 47 3c 01 74 21 f0 83 6b 38 01 0f 94 c0 84 c0 74 08 48 89 df 
RIP  [<ffffffff81313491>] kobject_put+0x11/0x60
 RSP <ffff881050b95d58>
CR2: ffffffffa02ed08c
