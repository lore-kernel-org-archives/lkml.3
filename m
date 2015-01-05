Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbbAEOrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:47:19 -0500
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:28420
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754011AbbAEOrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:47:18 -0500
Message-ID: <54AA9C4D.3000001@freescale.com>
Date: Mon, 5 Jan 2015 16:14:37 +0200
From: Purcareata Bogdan <b43198@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC] PPC: MPIC: necessary readback after EOI?
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.166.1]
X-ClientProxiedBy: AM3PR03CA033.eurprd03.prod.outlook.com (10.141.191.161) To
 BN1PR03MB187.namprd03.prod.outlook.com (10.255.200.149)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=B43198@freescale.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR03MB187;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR03MB187;
X-Forefront-PRVS: 0447DB1C71
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(189002)(199003)(80316001)(77096005)(68736005)(15975445007)(107046002)(2351001)(66066001)(65956001)(65806001)(50466002)(77156002)(62966003)(19580395003)(105586002)(36756003)(106356001)(33656002)(42186005)(110136001)(229853001)(23676002)(120916001)(122386002)(54356999)(50986999)(40100003)(21056001)(92566001)(4396001)(97736003)(101416001)(46102003)(47776003)(64706001)(20776003)(99396003)(31966008)(65816999)(87266999)(83506001)(86362001)(87976001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB187;H:[10.171.74.27];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB187;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 14:14:52.6760 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR03MB187
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While doing some performance testing of a KVM guest on a PPC platform, I 
noticed that there's a read of the CPU_WHOAMI register after each MPIC 
EOI [1]. This has been present since the initial implementation of the 
MPIC driver [2]. In a KVM virtualized environment, this results in an 
additional kvm_exit.

Is the read back necessary? Is it used to provide some sort of 
synchronization mechanism, making sure that nothing else is executed 
until the EOI write is finished? I eliminated the mpic_cpu_read call and 
run the kernel on hardware and noticed no anomaly, however I am not sure 
of all the implications and race conditions it might lead to.

I was curious why the mpic_cpu_read(MPIC_INFO(CPU_WHOAMI)) was there in 
the first place and if it's still needed. If it's still required, I 
guess a better approach is to eliminate the call only if the kernel is 
running on the KVM guest side, where the MPIC is emulated and no longer 
requires a readback.

Thank you,
Bogdan P.

[1] http://lxr.free-electrons.com/source/arch/powerpc/sysdev/mpic.c#L659
[2] https://lkml.org/lkml/2004/10/22/483
