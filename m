Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbbAGBVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:21:19 -0500
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:21078
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751659AbbAGBVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:21:17 -0500
Message-ID: <1420593666.4961.40.camel@freescale.com>
Subject: Re: [PATCH v3 2/2] powerpc/8xx: use _PAGE_RO instead of _PAGE_RW
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        "paulus@samba.org" <paulus@samba.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Date: Tue, 6 Jan 2015 19:21:06 -0600
In-Reply-To: <54AB88C2.7040901@c-s.fr>
References: <20141222101450.D7DD11A5E15@localhost.localdomain>
	 <1420481520.25047.15.camel@transmode.se> <54AB88C2.7040901@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR05CA0058.namprd05.prod.outlook.com (10.141.20.28) To
 BN1PR0301MB0721.namprd03.prod.outlook.com (25.160.78.140)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR0301MB0721;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0721;
X-Forefront-PRVS: 044968D9E1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(377424004)(24454002)(479174004)(189002)(51704005)(120916001)(92566001)(20776003)(47776003)(64706001)(50986999)(103116003)(23676002)(99396003)(4396001)(31966008)(50466002)(46102003)(76176999)(50226001)(40100003)(68736005)(86362001)(101416001)(575784001)(36756003)(89996001)(33646002)(42186005)(87976001)(2950100001)(77156002)(62966003)(110136001)(19580405001)(107046002)(106356001)(105586002)(21056001)(97736003)(122386002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0721;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0721;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2015 01:21:13.2236 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0721
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0755;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-06 at 08:03 +0100, leroy christophe wrote:
> Le 05/01/2015 19:12, Joakim Tjernlund a écrit :
> > On Mon, 2014-12-22 at 11:14 +0100, Christophe Leroy wrote:
> >> On powerpc 8xx, in TLB entries, 0x400 bit is set to 1 for read-only pages
> >> and is set to 0 for RW pages. So we should use _PAGE_RO instead of _PAGE_RW
> >>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > Hi Christophe, been meaning to look over all you recent 8xx MMU/TLB patches
> > but got so little time :(
> >
> > This is very cool (not sure if there will be a performance gain)  but ..
> I think every saved cycle is worth it.
> Before I did any modification:
> * ITLBMiss was 28 instructions.
> * DTLBMiss was 32 instructions.
> Now, (No MODULES, no CPU6, no CPU15):
> * ITLBMiss is 15 instructions
> * DTLBMiss is 24 instructions
> >>
> >>
> >> diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
> >> index caf094a..b4e0c3b 100644
> >> --- a/arch/powerpc/include/asm/pgtable-ppc32.h
> >> +++ b/arch/powerpc/include/asm/pgtable-ppc32.h
> >> @@ -178,9 +178,10 @@ static inline unsigned long pte_update(pte_t *p,
> >>          andc    %1,%0,%5\n\
> >>          or      %1,%1,%6\n\
> >>          /* 0x200 == Extended encoding, bit 22 */ \
> >> -       /* Bit 22 has to be 1 if neither _PAGE_USER nor _PAGE_RW are set */ \
> >> +       /* Bit 22 has to be 1 when _PAGE_USER is unset and _PAGE_RO is set */ \
> >>          rlwimi  %1,%1,32-2,0x200\n /* get _PAGE_USER */ \
> >> -       rlwinm  %3,%1,32-1,0x200\n /* get _PAGE_RW */ \
> >> +       rlwinm  %3,%1,32-1,0x200\n /* get _PAGE_RO */ \
> >> +       xori    %3,%3,0x200\n \
> >>          or      %1,%3,%1\n\
> >>          xori    %1,%1,0x200\n"
> >>   "      stwcx.  %1,0,%4\n\
> > ... here I expected to loose the existing xori insn instead of adding one?
> >
> >
> Well, I could have xored the PAGE_USER bit instead, but in that case, it 
> is not anymore an 'or' but an 'and' that has to be performed between the 
> bits, and then all other bits must be set to 1, or the result of the 
> 'and' shall be inserted using 'rlwimi'. So it would be more 
> modifications than just adding an xori, and not less instructions.

How about "andc %3,%3,%1; rlwimi %1,%3,0,0x200" instead of the "xori,
or, xori" sequence?

-Scott


