Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaIKMWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:22:42 -0400
Received: from mail-bn1on0144.outbound.protection.outlook.com ([157.56.110.144]:53088
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754271AbaIKMWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:22:40 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 08:22:40 EDT
From: Dexuan Cui <decui@microsoft.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>
CC: KY Srinivasan <kys@microsoft.com>
Subject: page fault in mem_cgroup_page_lruvec() due to memory hot-add
Thread-Topic: page fault in mem_cgroup_page_lruvec() due to memory hot-add
Thread-Index: Ac/NtHCekGW+JEAwTwikIP9woKg07A==
Date: Thu, 11 Sep 2014 12:07:13 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C99B0031@SINEX14MBXC418.southpacific.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(479174003)(199003)(53754006)(189002)(41574002)(20776003)(575784001)(92726001)(80022001)(84676001)(77982001)(97756001)(46406003)(229853001)(26826002)(23726002)(81342001)(85852003)(2656002)(76482001)(55846006)(92566001)(86362001)(83072002)(4396001)(50986999)(107046002)(64706001)(81542001)(46102001)(86612001)(47776003)(54356999)(21056001)(99396002)(77096002)(50466002)(95666004)(87936001)(85306004)(33656002)(74662001)(106466001)(16796002)(81156004)(31966008)(69596002)(79102001)(90102001)(74502001)(44976005)(83322001)(19580395003)(6806004)(68736004)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0660;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

When I try to run Ubuntu 14.10 guest (the nightly build with the kernel
version 3.16.0-12-generic) on hyper-v, occasionally, I get the below
panic(see the end of the mail) suddenly.
(I suppose it's likely the upstream kernel has the issue too)

When the panic happens, I'm running a memory stress program to test the
balloon driver drivers/hv/hv_balloon.c, which can hot-add memory to the guest
by invoking memory_add_physaddr_to_nid() and add_memory(), if the feature
"Dynamic Memory" is enabled.

The issue here is: the memory hot-add seems successful, but occasionally
the page fault can happen and crash the whole guest.

It looks the crash only happens to the guest in the SMP guest case. I never
get the crash when the guest is configured with 1 vCPU.

Sometimes it's very difficult to reproduce the crash while sometimes it's
relatively easy.

Can anybody please shed some light?

Thanks!

-- Dexuan

[   99.211382] BUG: unable to handle kernel paging request at 0000000000c0b608
[   99.215308] IP: [<ffffffff811d2e9c>] mem_cgroup_page_lruvec+0x2c/0xa0
[   99.215308] PGD 37544067 PUD 393c2067 PMD 0
[   99.215308] Oops: 0000 [#1] SMP
[   99.215308] Modules linked in: bnep rfcomm bluetooth 6lowpan_iphc joydev hid_generic crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd hyperv_keyboard hv_balloon hid_hyperv hid serio_raw i2c_piix4 mac_hid parport_pc ppdev lp parport hv_netvsc hv_utils hv_storvsc psmouse hv_vmbus pata_acpi floppy
[   99.215308] CPU: 3 PID: 1919 Comm: stressapptest Not tainted 3.16.0-12-generic #18-Ubuntu
[   99.215308] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   99.215308] task: ffff880034282880 ti: ffff8800415f8000 task.ti: ffff8800415f8000
[   99.215308] RIP: 0010:[<ffffffff811d2e9c>]  [<ffffffff811d2e9c>] mem_cgroup_page_lruvec+0x2c/0xa0
[   99.215308] RSP: 0000:ffff8800415fbc58  EFLAGS: 00010006
[   99.215308] RAX: 0000000000c0b600 RBX: ffff88003ffebf80 RCX: ffff88003ffea300
[   99.215308] RDX: 02ffff00000d0001 RSI: ffff88003ffebf80 RDI: ffffea000302d800
[   99.215308] RBP: ffff8800415fbc68 R08: 0000000000000008 R09: 0000000000000004
[   99.215308] R10: 00000000ffffffff R11: ffff880033ffd400 R12: ffffea000302d800
[   99.215308] R13: ffffea000302d800 R14: ffff88003b4703c0 R15: 0000000000000202
[   99.215308] FS:  00007fb0075fa700(0000) GS:ffff88003b460000(0000) knlGS:0000000000000000
[   99.215308] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   99.215308] CR2: 0000000000c0b608 CR3: 00000000389b4000 CR4: 00000000000006e0
[   99.215308] Stack:
[   99.215308]  ffff88003ffebf80 0000000000000002 ffff8800415fbcc0 ffffffff81178604
[   99.215308]  0000000000000000 ffffffff81177bf0 0000000000000296 ffff8800415fbc90
[   99.215308]  0000000000000003 000000000004b5d8 00000000000200da ffff880036db6480
[   99.215308] Call Trace:
[   99.215308]  [<ffffffff81178604>] pagevec_lru_move_fn+0xc4/0x130
[   99.215308]  [<ffffffff81177bf0>] ? __activate_page+0x1e0/0x1e0
[   99.215308]  [<ffffffff81178b7e>] lru_add_drain_cpu+0xce/0xe0
[   99.215308]  [<ffffffff81178c96>] lru_add_drain+0x16/0x20
[   99.215308]  [<ffffffff811aa2e6>] swapin_readahead+0x126/0x1a0
[   99.215308]  [<ffffffff81198c17>] handle_mm_fault+0xc87/0xf90
[   99.215308]  [<ffffffff8105ce42>] __do_page_fault+0x1c2/0x580
[   99.215308]  [<ffffffff810a9d18>] ? __enqueue_entity+0x78/0x80
[   99.215308]  [<ffffffff810ae8c4>] ? update_curr+0xf4/0x180
[   99.215308]  [<ffffffff810ab3f8>] ? pick_next_entity+0x88/0x180
[   99.215308]  [<ffffffff810b3b8e>] ? pick_next_task_fair+0x57e/0x8d0
[   99.215308]  [<ffffffff810a84e8>] ? sched_clock_cpu+0x88/0xb0
[   99.215308]  [<ffffffff8105d231>] do_page_fault+0x31/0x70
[   99.215308]  [<ffffffff81782908>] page_fault+0x28/0x30
[   99.215308] Code: 66 66 66 90 8b 15 15 2a b5 00 55 48 8d 86 48 05 00 00 48 89 e5 41 54 53 85 d2 48 89 f3 75 56 49 89 fc e8 18 44 00 00 49 8b 14 24 <48> 8b 48 08 83 e2 20 75 1b 48 8b 10 83 e2 02 75 13 48 8b 15 54
[   99.215308] RIP  [<ffffffff811d2e9c>] mem_cgroup_page_lruvec+0x2c/0xa0
[   99.215308]  RSP <ffff8800415fbc58>
[   99.215308] CR2: 0000000000c0b608
[   99.215308] ---[ end trace 24db5f2378e898cb ]---


