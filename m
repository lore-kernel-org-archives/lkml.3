Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaJKANI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 20:13:08 -0400
Received: from mail-bn1bn0108.outbound.protection.outlook.com ([157.56.110.108]:15797
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751314AbaJKANF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 20:13:05 -0400
X-Greylist: delayed 1121 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2014 20:13:04 EDT
From: Long Li <longli@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>, David Miller <davem@davemloft.net>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net 1/1] hyperv: Fix a bug in netvsc_send()
Thread-Topic: [PATCH net 1/1] hyperv: Fix a bug in netvsc_send()
Thread-Index: AQHP4LqXSzhzQOY9SUC8nws4UsmIr5wiQ3WAgAWF5YCAAjppkA==
Date: Fri, 10 Oct 2014 23:39:00 +0000
Message-ID: <96f3d4f6b90a461686b23f64aedcb4fc@BL2PR03MB132.namprd03.prod.outlook.com>
References: <1412530971-29897-1-git-send-email-kys@microsoft.com>
 <20141005.211129.632749242463744635.davem@davemloft.net>
 <20141009133200.GA17134@sucs.org>
In-Reply-To: <20141009133200.GA17134@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e0:ee43::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB130;UriScan:;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(51704005)(377454003)(479174003)(189002)(24454002)(199003)(105586002)(19580395003)(107046002)(80022003)(20776003)(99286002)(95666004)(19580405001)(64706001)(50986999)(76176999)(106116001)(74316001)(40100003)(106356001)(46102003)(108616004)(15975445006)(86612001)(54356999)(85306004)(31966008)(76482002)(575784001)(86362001)(101416001)(87936001)(122556002)(2656002)(85852003)(21056001)(33646002)(4396001)(77096002)(97736003)(92566001)(15395725005)(99396003)(76576001)(120916001)(15202345003)(3826002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB130;H:BL2PR03MB132.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB097;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Sitsofe. Can you provide more details on the test setup?

The kernel trace shows that skb->mac_header=0xffff (which means not yet set, it's in RCX: 000000000000ffff).


-----Original Message-----
From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On Behalf Of Sitsofe Wheeler
Sent: Thursday, October 09, 2014 6:32 AM
To: David Miller
Cc: olaf@aepfle.de; netdev@vger.kernel.org; jasowang@redhat.com; linux-kernel@vger.kernel.org; apw@canonical.com; devel@linuxdriverproject.org
Subject: Re: [PATCH net 1/1] hyperv: Fix a bug in netvsc_send()

On Sun, Oct 05, 2014 at 09:11:29PM -0400, David Miller wrote:
> From: "K. Y. Srinivasan" <kys@microsoft.com>
> Date: Sun,  5 Oct 2014 10:42:51 -0700
> 
> > After the packet is successfully sent, we should not touch the 
> > packet as it may have been freed. This patch is based on the work 
> > done by Long Li <longli@microsoft.com>.
> > 
> > David, please queue this up for stable.

With 3.17.0 g782d59c (which should include this patch) I'm still seeing the following:

Oct 09 13:14:51 a network[428]: Bringing up interface eth0:
Oct 09 13:14:51 a dhclient[538]: DHCPREQUEST on eth0 to 255.255.255.255 port 67 (xid=0x1dd33078) Oct 09 13:14:51 a dhclient[538]: DHCPACK from 10.x.x.x (xid=0x1dd33078) Oct 09 13:14:55 a kernel: BUG: unable to handle kernel paging request at ffff8800ed2e72e3 Oct 09 13:14:55 a kernel: IP: [<ffffffff814ede1d>] netvsc_select_queue+0x3d/0x150 Oct 09 13:14:55 a kernel: PGD 2db5067 PUD 2075be067 PMD 207454067 PTE 80000000ed2e7060 Oct 09 13:14:55 a kernel: Oops: 0000 [#1] SMP DEBUG_PAGEALLOC Oct 09 13:14:55 a kernel: CPU: 6 PID: 566 Comm: arping Not tainted 3.17.0.x86_64-05585-g782d59c #147 Oct 09 13:14:55 a kernel: Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012 Oct 09 13:14:55 a kernel: task: ffff8801f978b9f0 ti: ffff8801f3b84000 task.ti: ffff8801f3b84000 Oct 09 13:14:55 a kernel: RIP: 0010:[<ffffffff814ede1d>]  [<ffffffff814ede1d>] netvsc_select_queue+0x3d/0x150 Oct 09 13:14:55 a kernel: RSP: 0018:ffff8801f3b87c60  EFLAGS: 00010202 Oct 09 13:14:55 a kernel: RAX: 0000000000000000 RBX: ffff8800f13e8000 RCX: 000000000000ffff Oct 09 13:14:55 a kernel: RDX: ffff8800ed2d72d8 RSI: ffff8801fabca1c0 RDI: ffff8800f13e8000 Oct 09 13:14:55 a kernel: RBP: ffff8801f3b87c88 R08: 000000000000002a R09: 0000000000000000 Oct 09 13:14:55 a kernel: R10: ffff8801f83b3f60 R11: 0000000000000008 R12: ffff8801fabca1c0 Oct 09 13:14:55 a kernel: R13: 0000000000000000 R14: ffff8800ed359bd8 R15: ffff8801fabca1c0 Oct 09 13:14:55 a kernel: FS:  00007f943a5c9740(0000) GS:ffff880206cc0000(0000) knlGS:0000000000000000 Oct 09 13:14:55 a kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 Oct 09 13:14:55 a kernel: CR2: ffff8800ed2e72e3 CR3: 00000001f3957000 CR4: 00000000000406e0 Oct 09 13:14:55 a kernel: Stack:
Oct 09 13:14:55 a kernel:  ffffffff816a0221 ffff8800f13e8000 000000000000001c 0000000000000000 Oct 09 13:14:55 a kernel:  ffff8800ed359bd8 ffff8801f3b87d48 ffffffff816a3fce ffff8801f3b87cb0 Oct 09 13:14:55 a kernel:  ffffffff816c34a7 0000000000000001 ffff8801f3b87db8 000000000000001c Oct 09 13:14:55 a kernel: Call Trace:
Oct 09 13:14:55 a kernel:  [<ffffffff816a0221>] ? packet_pick_tx_queue+0x31/0xa0 Oct 09 13:14:55 a kernel:  [<ffffffff816a3fce>] packet_sendmsg+0xc6e/0xe30 Oct 09 13:14:55 a kernel:  [<ffffffff816c34a7>] ? _raw_spin_unlock+0x27/0x40 Oct 09 13:14:55 a kernel:  [<ffffffff81091bba>] ? prepare_creds+0x3a/0x170 Oct 09 13:14:55 a kernel:  [<ffffffff815d2e08>] sock_sendmsg+0x88/0xb0 Oct 09 13:14:55 a kernel:  [<ffffffff81188f83>] ? might_fault+0xa3/0xb0 Oct 09 13:14:55 a kernel:  [<ffffffff81188f3a>] ? might_fault+0x5a/0xb0 Oct 09 13:14:55 a kernel:  [<ffffffff815d2f3e>] SYSC_sendto+0x10e/0x150 Oct 09 13:14:55 a kernel:  [<ffffffff81188f3a>] ? might_fault+0x5a/0xb0 Oct 09 13:14:55 a kernel:  [<ffffffff816c41d5>] ? sysret_check+0x22/0x5d Oct 09 13:14:55 a kernel:  [<ffffffff810ba3fd>] ? trace_hardirqs_on_caller+0x17d/0x210
Oct 09 13:14:55 a kernel:  [<ffffffff813a20ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f Oct 09 13:14:55 a kernel:  [<ffffffff815d3f1e>] SyS_sendto+0xe/0x10 Oct 09 13:14:55 a kernel:  [<ffffffff816c41a9>] system_call_fastpath+0x16/0x1b Oct 09 13:14:55 a kernel: Code: 00 4d 85 d2 0f 84 1c 01 00 00 44 8b 9f 8c 03 00 00 31 c0 41 83 fb 01 0f 86 1b 01 00 00 0f b7 8e b6 00 00 00 Oct 09 13:14:55 a kernel: RIP  [<ffffffff814ede1d>] netvsc_select_queue+0x3d/0x150 Oct 09 13:14:55 a kernel:  RSP <ffff8801f3b87c60> Oct 09 13:14:55 a kernel: CR2: ffff8800ed2e72e3 Oct 09 13:14:55 a kernel: ---[ end trace e52f922dd7435e0d ]---

Was the above meant to have been fixed by the patch "[PATCH 1/1]
Drivers: net: hyperv: Cleanup  netvsc_change_mtu ()" from
https://lkml.org/lkml/2014/8/29/369 ? If so will that patch be resent?

--
Sitsofe | http://sucs.org/~sits/
_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
