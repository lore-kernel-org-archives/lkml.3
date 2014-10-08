Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaJHDXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:23:33 -0400
Received: from mail-bl2on0103.outbound.protection.outlook.com ([65.55.169.103]:2706
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752692AbaJHDXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:23:32 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2014 23:23:32 EDT
From: Hongtao Jia <hongtao.jia@freescale.com>
To: Scott Wood <scottwood@freescale.com>, Guenter Roeck <linux@roeck-us.net>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jojy G Varghese" <jojyv@juniper.net>,
        Guenter Roeck <groeck@juniper.net>
Subject: RE: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Thread-Topic: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Thread-Index: AQHP3AVDC3AT59iZz0+7oSg9BNxjZpwYcGoAgA0ejJA=
Date: Wed, 8 Oct 2014 03:08:13 +0000
Message-ID: <cfa12996b9a54b3baaa75f517f78c7ea@BLUPR03MB149.namprd03.prod.outlook.com>
References: <1412009312-7400-1-git-send-email-linux@roeck-us.net>
 <1412015766.13320.253.camel@snotra.buserror.net>
In-Reply-To: <1412015766.13320.253.camel@snotra.buserror.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0727;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(13464003)(189002)(377454003)(199003)(24454002)(377424004)(85306004)(92566001)(21056001)(97736003)(86362001)(19580395003)(46102003)(19580405001)(66066001)(15975445006)(80022003)(20776003)(106356001)(76482002)(33646002)(76176999)(105586002)(64706001)(54356999)(85852003)(77096002)(74316001)(101416001)(15202345003)(99396003)(108616004)(4396001)(106116001)(2656002)(95666004)(31966008)(122556002)(120916001)(87936001)(50986999)(40100002)(107046002)(7059024)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0727;H:BLUPR03MB149.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s983NfFk022053



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Tuesday, September 30, 2014 2:36 AM
> To: Guenter Roeck
> Cc: Benjamin Herrenschmidt; Paul Mackerras; Michael Ellerman; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Jojy G Varghese;
> Guenter Roeck; Jia Hongtao-B38951
> Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
> exception on E500MC / E5500
> 
> On Mon, 2014-09-29 at 09:48 -0700, Guenter Roeck wrote:
> > From: Jojy G Varghese <jojyv@juniper.net>
> >
> > For E500MC and E5500, a machine check exception in pci(e) memory space
> > crashes the kernel.
> >
> > Testing shows that the MCAR(U) register is zero on a MC exception for
> > the
> > E5500 core. At the same time, DEAR register has been found to have the
> > address of the faulty load address during an MC exception for this core.
> >
> > This fix changes the current behavior to fixup the result register and
> > instruction pointers in the case of a load operation on a faulty PCI
> > address.
> >
> > The changes are:
> > - Added the hook to pci machine check handing to the e500mc machine
> check
> >   exception handler.
> > - For the E5500 core, load faulting address from SPRN_DEAR register.
> >   As mentioned above, this is necessary because the E5500 core does not
> >   report the fault address in the MCAR register.
> >
> > Cc: Scott Wood <scottwood@freescale.com>
> > Signed-off-by: Jojy G Varghese <jojyv@juniper.net> [Guenter Roeck:
> > updated description]
> > Signed-off-by: Guenter Roeck <groeck@juniper.net>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  arch/powerpc/kernel/traps.c   | 3 ++-
> >  arch/powerpc/sysdev/fsl_pci.c | 5 +++++
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
> > index 0dc43f9..ecb709b 100644
> > --- a/arch/powerpc/kernel/traps.c
> > +++ b/arch/powerpc/kernel/traps.c
> > @@ -494,7 +494,8 @@ int machine_check_e500mc(struct pt_regs *regs)
> >  	int recoverable = 1;
> >
> >  	if (reason & MCSR_LD) {
> > -		recoverable = fsl_rio_mcheck_exception(regs);
> > +		recoverable = fsl_rio_mcheck_exception(regs) ||
> > +			fsl_pci_mcheck_exception(regs);
> >  		if (recoverable == 1)
> >  			goto silent_out;
> >  	}
> > diff --git a/arch/powerpc/sysdev/fsl_pci.c
> > b/arch/powerpc/sysdev/fsl_pci.c index c507767..bdb956b 100644
> > --- a/arch/powerpc/sysdev/fsl_pci.c
> > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > @@ -1021,6 +1021,11 @@ int fsl_pci_mcheck_exception(struct pt_regs
> > *regs)  #endif
> >  	addr += mfspr(SPRN_MCAR);
> >
> > +#ifdef CONFIG_E5500_CPU
> > +	if (mfspr(SPRN_EPCR) & SPRN_EPCR_ICM)
> > +		addr = PFN_PHYS(vmalloc_to_pfn((void *)mfspr(SPRN_DEAR)));
> #endif
> 
> Kconfig tells you what hardware is supported, not what hardware you're
> actually running on.
> 
> Jia Hongtao, do you know anything about this issue?  Is there an erratum?

Sorry for the late response, I just return from my vacation.
I don't know this issue.

> What chips are affected by the the erratum covered by
> <http://patchwork.ozlabs.org/patch/240239/>?

MPC8544, MPC8548, MPC8572 are affected by this erratum.
I checked P4080 which using e500mc and no such erratum is found.

> 
> Can we rely on DEAR or is this just a side effect of likely having taken
> a TLB miss for the address recently?  Perhaps we should use the
> instruction emulation to determine the effective address instead.
> 
> Guenter, is this patch intended to deal with an erratum or are you
> covering up legitimate errors?
> 
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
