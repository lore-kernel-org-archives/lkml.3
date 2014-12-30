Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaL3Tot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 14:44:49 -0500
Received: from mail-bl2on0145.outbound.protection.outlook.com ([65.55.169.145]:53172
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751424AbaL3Tor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 14:44:47 -0500
X-Greylist: delayed 74368 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2014 14:44:46 EST
Message-ID: <1419968672.4961.4.camel@freescale.com>
Subject: Re: [PATCH] srcu: Isolate srcu sections using CONFIG_SRCU
From: Scott Wood <scottwood@freescale.com>
To: Pranith Kumar <bobby.prani@gmail.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "supporter:S390" <linux390@de.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
        Anton Blanchard <anton@samba.org>,
        Andy Fleming <afleming@freescale.com>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Daniel Walter <dwalter@google.com>,
        "Jens Freimann" <jfrei@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>
Date: Tue, 30 Dec 2014 13:44:32 -0600
In-Reply-To: <CAJhHMCDan+qaaZjVUucA-sUS8A3vSTYuVHg8XQv4rsHXxAzKLw@mail.gmail.com>
References: <1419700667-24888-1-git-send-email-bobby.prani@gmail.com>
	 <20141229110324.50f1339b@mschwide>
	 <CAJhHMCDan+qaaZjVUucA-sUS8A3vSTYuVHg8XQv4rsHXxAzKLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR05CA0068.namprd05.prod.outlook.com (10.141.20.38) To
 BY2PR0301MB0727.namprd03.prod.outlook.com (25.160.63.17)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0727;
X-Forefront-PRVS: 04410E544A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(51704005)(377424004)(199003)(24454002)(189002)(23676002)(64706001)(105586002)(68736005)(46102003)(89996001)(87976001)(103116003)(21056001)(19580405001)(40100003)(20776003)(47776003)(31966008)(99396003)(76176999)(50986999)(50466002)(86362001)(106356001)(97736003)(92566001)(77156002)(122386002)(33646002)(2950100001)(120916001)(62966003)(4396001)(107046002)(36756003)(42186005)(50226001)(19580395003)(101416001)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0727;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2014 19:44:39.5118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0727
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0678;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0678;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0678;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-29 at 23:32 -0500, Pranith Kumar wrote:
> On Mon, Dec 29, 2014 at 5:03 AM, Martin Schwidefsky
> <schwidefsky@de.ibm.com> wrote:
> > On Sat, 27 Dec 2014 12:17:43 -0500
> > Pranith Kumar <bobby.prani@gmail.com> wrote:
> >
> >> @@ -65,10 +65,13 @@
> >>  #include <asm/kexec.h>
> >>  #include <asm/mmu_context.h>
> >>  #include <asm/code-patching.h>
> >> -#include <asm/kvm_ppc.h>
> >>  #include <asm/hugetlb.h>
> >>  #include <asm/epapr_hcalls.h>
> >>
> >> +#if IS_ENABLED(CONFIG_KVM)
> >> +#include <asm/kvm_ppc.h>
> >> +#endif
> >> +
> >>  #ifdef DEBUG
> >>  #define DBG(fmt...) udbg_printf(fmt)
> >>  #else
> >
> > I always cringe when I see an include protected by an #ifdef.
> > Is this really necessary? All that is done in asm-offsets.c is
> > to calculate offsets, the code where the two offsets in question
> > are used (entry64.S) does have the #ifdef for CONFIG_KVM.
> 
> I agree that this is not the ideal way to do this. But, it has been
> the way things were already being done. If you see
> arch/powerpc/kernel/asm-offsets.c, there are quite some includes which
> are within ifdefs.

asm-offsets.c is unusual in that respect, and I think most of those
ifdefs could go away without breaking anything (head_booke.h is not a
normal header file, and kvm_book3s.h should just be removed as it will
be pulled in by kvm_ppc.h if applicable).

> I've considered other alternatives (though not in-depth) and found
> that they will require quite some refactoring. One simple idea is to
> move this #ifdef to within kvm_ppc.h. That should make the inclusion
> of this file a no-op in all the places where this is being included
> without KVM being enabled. But I am not 100% sure of that approach.
> 
> Any suggestions are welcome.

As I suggested elsewhere in the thread, why not be more fine-grained in
what you ifdef in the srcu header?  How will that require excessive
refactoring?

Or, just stick with the linker error.

I also wonder if this is worthwhile just to save around 2000 bytes.
What other core synchronization mechanisms are optional?  What
real-world configs will actually have this disabled?

-Scott


