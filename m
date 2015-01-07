Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbbAGC5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:57:12 -0500
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:11168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758465AbbAGC5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:57:08 -0500
Message-ID: <1420599417.4961.48.camel@freescale.com>
Subject: Re: [RFC] PPC: MPIC: necessary readback after EOI?
From: Scott Wood <scottwood@freescale.com>
To: Andreas Mohr <andi@lisas.de>
CC: Purcareata Bogdan <b43198@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <benh@kernel.crashing.org>
Date: Tue, 6 Jan 2015 20:56:57 -0600
In-Reply-To: <20150105184322.GA30255@rhlx01.hs-esslingen.de>
References: <20150105174616.GA3159@rhlx01.hs-esslingen.de>
	 <1420481454.4961.16.camel@freescale.com>
	 <20150105184322.GA30255@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR05CA0074.namprd05.prod.outlook.com (10.141.20.44) To
 BY2PR0301MB0727.namprd03.prod.outlook.com (25.160.63.17)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0727;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0727;
X-Forefront-PRVS: 044968D9E1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(57704003)(189002)(199003)(24454002)(377424004)(92566001)(31966008)(106356001)(107046002)(122386002)(21056001)(89996001)(40100003)(62966003)(120916001)(46102003)(77156002)(2950100001)(101416001)(50466002)(97736003)(86362001)(76176999)(551934003)(103116003)(64706001)(50986999)(20776003)(47776003)(50226001)(87976001)(68736005)(23676002)(36756003)(99396003)(19580395003)(42186005)(4396001)(105586002)(110136001)(33646002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0727;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0727;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2015 02:57:04.0290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0727
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0725;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 19:43 +0100, Andreas Mohr wrote:
> [CC related ppl]
> 
> On Mon, Jan 05, 2015 at 12:10:54PM -0600, Scott Wood wrote:
> > On Mon, 2015-01-05 at 18:46 +0100, Andreas Mohr wrote:
> > > Hi,
> > > 
> > > > I was curious why the mpic_cpu_read(MPIC_INFO(CPU_WHOAMI)) was there in
> > > > the first place and if it's still needed. If it's still required, I
> > > > guess a better approach is to eliminate the call only if the kernel is
> > > > running on the KVM guest side, where the MPIC is emulated and no longer
> > > > requires a readback.
> > > 
> > > "Why not?"
> > > 
> > > A mechanism being "emulated"/"virtual" or not
> > > may not necessarily be much of a distinction (if at all!).
> > > The readback might be required
> > > to properly fulfill all requirements
> > > of a full state change protocol specification,
> > > which might easily be the case for both RS(*) and virtual hardware.
> > > And especially for virtual hardware
> > > such a "readback" event
> > > might be an extremely important "end of transaction" marker
> > > which may often be needed for freeing of temporary resources etc.
> > 
> > I'm not convinced that it's required in real silicon (though there are
> > many MPIC implementations which have their own quirks...), and I'm 100%
> > sure that it's not required in the QEMU/KVM implementation of MPIC.
> > 
> > It would have been nice if a code comment explained why it was doing the
> > readback...  I don't see any particular need to wait for EOI completion
> > here (unlike when masking).
> 
> Hmm, yeah.
> 
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/history/history.git
> git checkout v2.6.11
> git blame ./ppc64/kernel/mpic.c
> git show 378193eb
>     [PATCH] ppc64: Rewrite the openpic driver
> 
> +/* Send an EOI */
> +static inline void mpic_eoi(struct mpic *mpic)
> +{
> +       mpic_cpu_write(MPIC_CPU_EOI, 0);
> +       (void)mpic_cpu_read(MPIC_CPU_WHOAMI);
> +}
> 
> 
> -static void openpic_eoi(void)
> -{
> -       DECL_THIS_CPU;
> -
> -       CHECK_THIS_CPU;
> -       openpic_write(&OpenPIC->THIS_CPU.EOI, 0);
> -       /* Handle PCI write posting */
> -       (void)openpic_read(&OpenPIC->THIS_CPU.EOI);
> -}
> 
> 
> So, this does seem to be about PCI posted writes after all.
> Which begs the question whether all PIC hardware is connected via PCI bus,
> which... is not the case for emulated hardware at least, I'd think.
> 
> And it's somewhat unfortunate
> that the comment in fact was removed in that commit
> (perhaps reinstate this comment in all of the various mpic.c life forms?).

But even for PCI, why do we need to wait for this write to complete?
Back in the arch/ppc days ppc_md.get_irq() was called in a loop, so it
would make sense that we'd need the next IRQ to be ready by the time
it's called again, but now that there's no get_irq() loop we shouldn't
need to wait.

-Scott


