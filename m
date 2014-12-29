Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaL2XUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:20:52 -0500
Received: from mail-by2on0140.outbound.protection.outlook.com ([207.46.100.140]:7233
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752107AbaL2XUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:20:51 -0500
Message-ID: <1419894305.4961.2.camel@freescale.com>
Subject: Re: [PATCH] srcu: Isolate srcu sections using CONFIG_SRCU
From: Scott Wood <scottwood@freescale.com>
To: Pranith Kumar <bobby.prani@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "supporter:S390" <linux390@de.ibm.com>,
        "Lai Jiangshan" <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Anton Blanchard <anton@samba.org>,
        "Andy Fleming" <afleming@freescale.com>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Daniel Walter <dwalter@google.com>,
        Jens Freimann <jfrei@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>
Date: Mon, 29 Dec 2014 17:05:05 -0600
In-Reply-To: <1419700667-24888-1-git-send-email-bobby.prani@gmail.com>
References: <1419700667-24888-1-git-send-email-bobby.prani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR05CA0062.namprd05.prod.outlook.com (10.141.20.32) To
 DM2PR0301MB0735.namprd03.prod.outlook.com (25.160.97.143)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0735;
X-Forefront-PRVS: 0440AC9990
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(24454002)(377424004)(4396001)(46102003)(64706001)(97736003)(36756003)(103116003)(20776003)(106356001)(42186005)(105586002)(107046002)(50226001)(47776003)(62966003)(76176999)(101416001)(87976001)(92566001)(33646002)(23676002)(89996001)(122386002)(77156002)(110136001)(120916001)(31966008)(21056001)(2950100001)(68736005)(40100003)(99396003)(86362001)(50986999)(50466002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0735;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 23:05:12.4274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0735
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-12-27 at 12:17 -0500, Pranith Kumar wrote:
> Isolate the SRCU functions and data structures within CONFIG_SRCU so that there
> is a compile time failure if srcu is used when not enabled. This was decided to
> be better than waiting until link time for a failure to occur.

Yes, false positives and extra ifdefs are so much better. :-P

Why not just ifdef the functions/macros, and leave the types alone?  If
you're worried about direct access to struct members, you could even
ifdef the members away while leaving the struct itself.  It is not
normal practice in Linux to need ifdefs around #includes.

> There are places which include kvm headers and utilize kvm data structures
> without checking if KVM is enabled. In two such archs(s390, ppc64), the current
> patch makes the uses of KVM conditional on KVM being enabled. The other option,
> which is to enable KVM unconditionally seemed a bit too much as we could easily
> figure out KVM only parts and enclose them in ifdefs.

Maybe not so easy (mpc85xx_smp_defconfig with NOTIFY stuff turned off so
that SRCU gets deselected):

In file included from /home/scott/fsl/git/linux/upstream/arch/powerpc/include/asm/kvm_ppc.h:30:0,
                 from /home/scott/fsl/git/linux/upstream/arch/powerpc/kernel/smp.c:39:
/home/scott/fsl/git/linux/upstream/include/linux/kvm_host.h:366:21: error: field 'srcu' has incomplete type
/home/scott/fsl/git/linux/upstream/include/linux/kvm_host.h:367:21: error: field 'irq_srcu' has incomplete type
/home/scott/fsl/git/linux/upstream/scripts/Makefile.build:257: recipe for target 'arch/powerpc/kernel/smp.o' failed
make[2]: *** [arch/powerpc/kernel/smp.o] Error 1
/home/scott/fsl/git/linux/upstream/Makefile:955: recipe for target 'arch/powerpc/kernel' failed
make[1]: *** [arch/powerpc/kernel] Error 2
make[1]: *** Waiting for unfinished jobs....

Are you sure KVM is the only SRCU user so impacted?  It's also likely
that new such problems get introduced, because most people are going to
have SRCU enabled and thus not notice the breakage they're adding.

There's also at least one place that needs to be fixed, that currently
expects to get other headers indirectly via srcu.h:

/home/scott/fsl/git/linux/upstream/lib/assoc_array.c: In function 'assoc_array_apply_edit':
/home/scott/fsl/git/linux/upstream/lib/assoc_array.c:1425:2: error: implicit declaration of function 'call_rcu' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
/home/scott/fsl/git/linux/upstream/scripts/Makefile.build:257: recipe for target 'lib/assoc_array.o' failed

-Scott


