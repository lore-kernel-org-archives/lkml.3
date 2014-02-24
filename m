Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBXL4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:56:11 -0500
Received: from ns2.fox-it.com ([178.250.144.131]:13203 "EHLO ns2.fox-it.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbaBXL4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:56:09 -0500
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2014 06:56:09 EST
Date: Mon, 24 Feb 2014 12:47:25 +0100
From: Jasper Spaans <spaans@fox-it.com>
To: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>
Subject: kernel panic 3.11.7 in kmem_cache_alloc+0x66/0x150
Message-ID: <20140224114725.GA31065@spaans-e6500>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Last weekend one of our machines showed some interesting behaviour, where
processes seemed to be crashing randomly. Further inspection showed that
all the oopses in syslog were on core #12, and had
kmem_cache_alloc+0x66/0x150 as the RIP, except for the second one, which had
kmem_cache_alloc_trace+0x6a/0x140 .

The first oops was:

Feb 23 15:20:07 snarfer kernel: [2092158.564705] BUG: unable to handle kernel paging request at 0000000100000000
Feb 23 15:20:07 snarfer kernel: [2092158.572025] IP: [<ffffffff811987f6>] kmem_cache_alloc+0x66/0x150
Feb 23 15:20:07 snarfer kernel: [2092158.578339] PGD 1f00913067 PUD 0 
Feb 23 15:20:07 snarfer kernel: [2092158.582011] Oops: 0000 [#1] SMP 
Feb 23 15:20:07 snarfer kernel: [2092158.585587] Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd sunrpc iptable_filter ip_tables x_tables ext2 snd_pcm psmouse snd_timer snd soundcore joydev snd_page_alloc tpm_tis gpio_ich pcspkr serio_raw hid_generic dcdbas mac_hid i7core_edac lpc_ich edac_core wmi acpi_power_meter dm_crypt usbhid hid ses enclosure ixgbe dca ptp pps_core megaraid_sas mdio bnx2 [last unloaded: ipmi_si]
Feb 23 15:20:07 snarfer kernel: [2092158.633613] CPU: 12 PID: 5587 Comm: if_eth3 Not tainted 3.11.7 #13
Feb 23 15:20:07 snarfer kernel: [2092158.640043] Hardware name: Dell Inc. PowerEdge R510/XXXXXX, BIOS 1.11.0 07/23/2012
Feb 23 15:20:07 snarfer kernel: [2092158.649109] task: ffff880969282ee0 ti: ffff880f0241e000 task.ti: ffff880f0241e000
Feb 23 15:20:07 snarfer kernel: [2092158.656837] RIP: 0010:[<ffffffff811987f6>]  [<ffffffff811987f6>] kmem_cache_alloc+0x66/0x150
Feb 23 15:20:07 snarfer kernel: [2092158.665596] RSP: 0018:ffff880f0241fe88  EFLAGS: 00010206
Feb 23 15:20:07 snarfer kernel: [2092158.671144] RAX: 0000000000000000 RBX: ffffffffffffffea RCX: 0000000002076761
Feb 23 15:20:07 snarfer kernel: [2092158.678530] RDX: 0000000002076760 RSI: 00000000000000d0 RDI: 0000000000017380
Feb 23 15:20:07 snarfer kernel: [2092158.685915] RBP: ffff880f0241fed8 R08: ffff88203fcd7380 R09: 0000000000000000
Feb 23 15:20:07 snarfer kernel: [2092158.693295] R10: 0000000000000002 R11: 0000000000000246 R12: ffff881fff003800
Feb 23 15:20:07 snarfer kernel: [2092158.700678] R13: 0000000100000000 R14: ffffffff8108ef26 R15: 00000000000000d0
Feb 23 15:20:07 snarfer kernel: [2092158.708065] FS:  0000000000000000(0000) GS:ffff88203fcc0000(0000) knlGS:0000000000000000
Feb 23 15:20:07 snarfer kernel: [2092158.716407] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb 23 15:20:07 snarfer kernel: [2092158.722385] CR2: 0000000100000000 CR3: 0000001f846a3000 CR4: 00000000000007e0
Feb 23 15:20:07 snarfer kernel: [2092158.729766] Stack:
Feb 23 15:20:07 snarfer kernel: [2092158.732013]  ffff880f0241fec0 000000005309bdae ffff881fe6648058 000000000000920c
Feb 23 15:20:07 snarfer kernel: [2092158.739885]  0000000000000000 ffffffffffffffea ffff880969282ee0 00007f89f198e5b8
Feb 23 15:20:07 snarfer kernel: [2092158.747748]  000000000000920c 00000000ffffff9c ffff880f0241fef8 ffffffff8108ef26
Feb 23 15:20:07 snarfer kernel: [2092158.755613] Call Trace:
Feb 23 15:20:07 snarfer kernel: [2092158.758302]  [<ffffffff8108ef26>] prepare_creds+0x26/0x1a0
Feb 23 15:20:07 snarfer kernel: [2092158.764026]  [<ffffffff811ae6e4>] SyS_faccessat+0x34/0x220
Feb 23 15:20:07 snarfer kernel: [2092158.769746]  [<ffffffff811ae8e8>] SyS_access+0x18/0x20
Feb 23 15:20:07 snarfer kernel: [2092158.775124]  [<ffffffff8170f69d>] system_call_fastpath+0x1a/0x1f
Feb 23 15:20:07 snarfer kernel: [2092158.781364] Code: dc 00 00 49 8b 50 08 49 83 78 10 00 4d 8b 28 0f 84 e1 00 00 00 4d 85 ed 0f 84 d8 00 00 00 49 63 44 24 20 49 8b 3c 24 48 8d 4a 01 <49> 8b 5c 05 00 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84 c0 74 b7 49 
Feb 23 15:20:07 snarfer kernel: [2092158.804128] RIP  [<ffffffff811987f6>] kmem_cache_alloc+0x66/0x150
Feb 23 15:20:07 snarfer kernel: [2092158.810516]  RSP <ffff880f0241fe88>
Feb 23 15:20:07 snarfer kernel: [2092158.814235] CR2: 0000000100000000
Feb 23 15:20:07 snarfer kernel: [2092158.817866] ---[ end trace f2f9ccfb04094fec ]---

followed by:

Feb 23 15:20:07 snarfer kernel: [2092158.874628] BUG: unable to handle kernel paging request at 0000000100000000
Feb 23 15:20:07 snarfer kernel: [2092158.881981] IP: [<ffffffff8119764a>] kmem_cache_alloc_trace+0x6a/0x140
Feb 23 15:20:07 snarfer kernel: [2092158.888812] PGD 1f5dec3067 PUD 0 
Feb 23 15:20:07 snarfer kernel: [2092158.892477] Oops: 0000 [#2] SMP 
Feb 23 15:20:07 snarfer kernel: [2092158.896067] Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd sunrpc iptable_filter ip_tables x_tables ext2 snd_pcm psmouse snd_timer snd soundcore joydev snd_page_alloc tpm_tis gpio_ich pcspkr serio_raw hid_generic dcdbas mac_hid i7core_edac lpc_ich edac_core wmi acpi_power_meter dm_crypt usbhid hid ses enclosure ixgbe dca ptp pps_core megaraid_sas mdio bnx2 [last unloaded: ipmi_si]
Feb 23 15:20:07 snarfer kernel: [2092158.943929] CPU: 12 PID: 5099 Comm: munin-node Tainted: G      D      3.11.7 #13
Feb 23 15:20:07 snarfer kernel: [2092158.951600] Hardware name: Dell Inc. PowerEdge R510/XXXXXX, BIOS 1.11.0 07/23/2012
Feb 23 15:20:07 snarfer kernel: [2092158.959417] task: ffff88169b690000 ti: ffff88007cb96000 task.ti: ffff88007cb96000
Feb 23 15:20:07 snarfer kernel: [2092158.967147] RIP: 0010:[<ffffffff8119764a>]  [<ffffffff8119764a>] kmem_cache_alloc_trace+0x6a/0x140
Feb 23 15:20:07 snarfer kernel: [2092158.976419] RSP: 0018:ffff88007cb97e38  EFLAGS: 00010206
Feb 23 15:20:07 snarfer kernel: [2092158.981965] RAX: 0000000000000000 RBX: ffff881ffee81d40 RCX: 0000000002076761
Feb 23 15:20:07 snarfer kernel: [2092158.989372] RDX: 0000000002076760 RSI: 00000000000080d0 RDI: 0000000000017380
Feb 23 15:20:07 snarfer kernel: [2092158.996754] RBP: ffff88007cb97e88 R08: ffff88203fcd7380 R09: 0000000000000000
Feb 23 15:20:07 snarfer kernel: [2092159.004137] R10: 0000000001b627a8 R11: 0000000000000246 R12: ffff881fff003800
Feb 23 15:20:07 snarfer kernel: [2092159.011540] R13: 0000000100000000 R14: ffffffff811b9154 R15: 00000000000080d0
Feb 23 15:20:07 snarfer kernel: [2092159.018923] FS:  00007fce4d00a700(0000) GS:ffff88203fcc0000(0000) knlGS:0000000000000000
Feb 23 15:20:07 snarfer kernel: [2092159.027274] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb 23 15:20:07 snarfer kernel: [2092159.033252] CR2: 0000000100000000 CR3: 0000001fd047e000 CR4: 00000000000007e0
Feb 23 15:20:07 snarfer kernel: [2092159.040634] Stack:
Feb 23 15:20:07 snarfer kernel: [2092159.042903]  ffffffff811c969f ffff88007cb97f40 0000000000000088 00000000ffffffe9
Feb 23 15:20:07 snarfer kernel: [2092159.050793]  ffff881ffee81d40 ffff881ffee81d40 ffff88007cb97f40 00000000ffffffe9
Feb 23 15:20:07 snarfer kernel: [2092159.058694]  0000000000000000 000000000217af80 ffff88007cb97ea8 ffffffff811b9154
Feb 23 15:20:07 snarfer kernel: [2092159.066637] Call Trace:
Feb 23 15:20:07 snarfer kernel: [2092159.069325]  [<ffffffff811c969f>] ? inode_init_always+0xff/0x1c0
Feb 23 15:20:07 snarfer kernel: [2092159.075571]  [<ffffffff811b9154>] alloc_pipe_info+0x24/0xb0
Feb 23 15:20:07 snarfer kernel: [2092159.081383]  [<ffffffff811b96fc>] create_pipe_files+0x4c/0x210
Feb 23 15:20:07 snarfer kernel: [2092159.087451]  [<ffffffff810751df>] ? recalc_sigpending+0x1f/0x60
Feb 23 15:20:07 snarfer kernel: [2092159.093664]  [<ffffffff811b9902>] __do_pipe_flags+0x42/0xf0
Feb 23 15:20:07 snarfer kernel: [2092159.099473]  [<ffffffff811b9a20>] SyS_pipe2+0x20/0xa0
Feb 23 15:20:07 snarfer kernel: [2092159.104762]  [<ffffffff81707018>] ? page_fault+0x28/0x30
Feb 23 15:20:07 snarfer kernel: [2092159.110310]  [<ffffffff811b9ab0>] SyS_pipe+0x10/0x20
Feb 23 15:20:07 snarfer kernel: [2092159.115514]  [<ffffffff8170f69d>] system_call_fastpath+0x1a/0x1f
Feb 23 15:20:07 snarfer kernel: [2092159.121751] Code: dc 00 00 49 8b 50 08 49 83 78 10 00 4d 8b 28 0f 84 cd 00 00 00 4d 85 ed 0f 84 c4 00 00 00 49 63 44 24 20 49 8b 3c 24 48 8d 4a 01 <49> 8b 5c 05 00 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84 c0 74 b7 49 
Feb 23 15:20:07 snarfer kernel: [2092159.145020] RIP  [<ffffffff8119764a>] kmem_cache_alloc_trace+0x6a/0x140
Feb 23 15:20:07 snarfer kernel: [2092159.151966]  RSP <ffff88007cb97e38>
Feb 23 15:20:07 snarfer kernel: [2092159.155714] CR2: 0000000100000000
Feb 23 15:20:07 snarfer kernel: [2092159.159328] ---[ end trace f2f9ccfb04094fed ]---

and a flood of similar oopses, on CPU 12, like:

Feb 23 15:20:08 snarfer kernel: [2092159.261931] BUG: unable to handle kernel paging request at 0000000100000000
Feb 23 15:20:08 snarfer kernel: [2092159.269260] IP: [<ffffffff811987f6>] kmem_cache_alloc+0x66/0x150
Feb 23 15:20:08 snarfer kernel: [2092159.275573] PGD fdaaba067 PUD 0 
Feb 23 15:20:08 snarfer kernel: [2092159.279152] Oops: 0000 [#3] SMP 
Feb 23 15:20:08 snarfer kernel: [2092159.282763] Modules linked in: ipmi_si mpt2sas scsi_transport_sas raid_class mptctl mptbase ipmi_devintf ipmi_msghandler dell_rbu rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd sunrpc iptable_filter ip_tables x_tables ext2 snd_pcm psmouse snd_timer snd soundcore joydev snd_page_alloc tpm_tis gpio_ich pcspkr serio_raw hid_generic dcdbas mac_hid i7core_edac lpc_ich edac_core wmi acpi_power_meter dm_crypt usbhid hid ses enclosure ixgbe dca ptp pps_core megaraid_sas mdio bnx2 [last unloaded: ipmi_si]
Feb 23 15:20:08 snarfer kernel: [2092159.330633] CPU: 12 PID: 3916 Comm: connection_mult Tainted: G      D      3.11.7 #13
Feb 23 15:20:08 snarfer kernel: [2092159.338708] Hardware name: Dell Inc. PowerEdge R510/XXXXXX, BIOS 1.11.0 07/23/2012
Feb 23 15:20:08 snarfer kernel: [2092159.346527] task: ffff880fe731ddc0 ti: ffff880fdaa86000 task.ti: ffff880fdaa86000
Feb 23 15:20:08 snarfer kernel: [2092159.354275] RIP: 0010:[<ffffffff811987f6>]  [<ffffffff811987f6>] kmem_cache_alloc+0x66/0x150
Feb 23 15:20:08 snarfer kernel: [2092159.363024] RSP: 0018:ffff880fdaa87a98  EFLAGS: 00010206
Feb 23 15:20:08 snarfer kernel: [2092159.368569] RAX: 0000000000000000 RBX: ffff881fe840dba0 RCX: 0000000002076761
Feb 23 15:20:08 snarfer kernel: [2092159.375952] RDX: 0000000002076760 RSI: 0000000000011200 RDI: 0000000000017380
Feb 23 15:20:08 snarfer kernel: [2092159.383334] RBP: ffff880fdaa87ae8 R08: ffff88203fcd7380 R09: 0000000000000000
Feb 23 15:20:08 snarfer kernel: [2092159.390731] R10: 0000000000000001 R11: 0000000000000000 R12: ffff881fff003800
Feb 23 15:20:08 snarfer kernel: [2092159.398111] R13: 0000000100000000 R14: ffffffff81148855 R15: 0000000000011200
Feb 23 15:20:08 snarfer kernel: [2092159.405493] FS:  00007f5aa9ede820(0000) GS:ffff88203fcc0000(0000) knlGS:0000000000000000
Feb 23 15:20:08 snarfer kernel: [2092159.413829] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb 23 15:20:08 snarfer kernel: [2092159.419805] CR2: 0000000100000000 CR3: 0000000fe594f000 CR4: 00000000000007e0
Feb 23 15:20:08 snarfer kernel: [2092159.427186] Stack:
Feb 23 15:20:08 snarfer kernel: [2092159.429430]  ffff8811e20e12f8 ffff880fdaa86000 0000000000000010 0000000000000021
Feb 23 15:20:08 snarfer kernel: [2092159.437330]  ffff881fd228f2d8 ffff881fe840dba0 0000000000011210 ffff881fe840dbd0
Feb 23 15:20:08 snarfer kernel: [2092159.445217]  ffff880fdaa87b38 ffff880fe731ddc0 ffff880fdaa87af8 ffffffff81148855
Feb 23 15:20:08 snarfer kernel: [2092159.453099] Call Trace:
Feb 23 15:20:08 snarfer kernel: [2092159.455787]  [<ffffffff81148855>] mempool_alloc_slab+0x15/0x20
Feb 23 15:20:08 snarfer kernel: [2092159.461899]  [<ffffffff811489bb>] mempool_alloc+0x5b/0x160
Feb 23 15:20:08 snarfer kernel: [2092159.467651]  [<ffffffff813406da>] ? generic_make_request+0xca/0x100
Feb 23 15:20:08 snarfer kernel: [2092159.474155]  [<ffffffff811e63db>] bio_alloc_bioset+0x10b/0x1d0
Feb 23 15:20:08 snarfer kernel: [2092159.480254]  [<ffffffff81256187>] ext4_bio_write_page+0x297/0x310
Feb 23 15:20:08 snarfer kernel: [2092159.486584]  [<ffffffff8124d055>] mpage_submit_page+0x65/0x90
Feb 23 15:20:08 snarfer kernel: [2092159.492566]  [<ffffffff8124d70f>] mpage_map_and_submit_buffers+0x15f/0x260
Feb 23 15:20:08 snarfer kernel: [2092159.499677]  [<ffffffff8125449b>] ext4_writepages+0x67b/0xc60
Feb 23 15:20:08 snarfer kernel: [2092159.505666]  [<ffffffff811d9553>] ? __mark_inode_dirty+0x53/0x2d0
Feb 23 15:20:08 snarfer kernel: [2092159.511998]  [<ffffffff8159f682>] ? dm_any_congested+0x52/0x60
Feb 23 15:20:08 snarfer kernel: [2092159.518073]  [<ffffffff815a34d4>] ? dm_table_any_congested+0x74/0x140
Feb 23 15:20:08 snarfer kernel: [2092159.524756]  [<ffffffff81152010>] do_writepages+0x20/0x40
Feb 23 15:20:08 snarfer kernel: [2092159.530395]  [<ffffffff811471c9>] __filemap_fdatawrite_range+0x59/0x60
Feb 23 15:20:08 snarfer kernel: [2092159.537158]  [<ffffffff8114a04c>] SyS_fadvise64_64+0x25c/0x270
Feb 23 15:20:08 snarfer kernel: [2092159.543228]  [<ffffffff8114a06e>] SyS_fadvise64+0xe/0x10
Feb 23 15:20:08 snarfer kernel: [2092159.548777]  [<ffffffff8170f69d>] system_call_fastpath+0x1a/0x1f
Feb 23 15:20:08 snarfer kernel: [2092159.555012] Code: dc 00 00 49 8b 50 08 49 83 78 10 00 4d 8b 28 0f 84 e1 00 00 00 4d 85 ed 0f 84 d8 00 00 00 49 63 44 24 20 49 8b 3c 24 48 8d 4a 01 <49> 8b 5c 05 00 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84 c0 74 b7 49 
Feb 23 15:20:08 snarfer kernel: [2092159.577716] RIP  [<ffffffff811987f6>] kmem_cache_alloc+0x66/0x150
Feb 23 15:20:08 snarfer kernel: [2092159.584104]  RSP <ffff880fdaa87a98>
Feb 23 15:20:08 snarfer kernel: [2092159.587822] CR2: 0000000100000000
Feb 23 15:20:08 snarfer kernel: [2092159.591484] ---[ end trace f2f9ccfb04094fee ]---

This machine contains two hexacore xeons running with HT enabled, so 24
cores in total, and has 128 GB of RAM, and all NUMA stuff has been disabled
in the bios (so this machine behaves as one big machine). It's running a
vanilla 3.11.7 , can provide you with the config if needed.

This looks to me like it's the same as the problem described in
https://lkml.org/lkml/headers/2013/11/30/153 , are there any things to try
besides upgrading to a 3.13 ?
(This is the second machine on which we have seen this..)

Regards,
Jasper
-- 
 /\____/\   ir. Jasper Spaans
 \   (_)/   Fox-IT
  \    X    T: +31-15-2847999
   \  / \   M: +31-6-41588725
    \/      KvK Haaglanden 27301624
