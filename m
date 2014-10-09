Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaJICSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 22:18:23 -0400
Received: from mail-bl2on0114.outbound.protection.outlook.com ([65.55.169.114]:54580
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751261AbaJICSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 22:18:16 -0400
From: Hongtao Jia <hongtao.jia@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jojy G Varghese <jojyv@juniper.net>,
        "Guenter Roeck" <groeck@juniper.net>
Subject: RE: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Thread-Topic: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Thread-Index: AQHP3AVDC3AT59iZz0+7oSg9BNxjZpwYcGoAgA0ejJCAAV2rgIAAJXfw
Date: Thu, 9 Oct 2014 02:18:10 +0000
Message-ID: <aeabfa2d438542c3962a57854c155066@BLUPR03MB149.namprd03.prod.outlook.com>
References: <1412009312-7400-1-git-send-email-linux@roeck-us.net>
	 <1412015766.13320.253.camel@snotra.buserror.net>
	 <cfa12996b9a54b3baaa75f517f78c7ea@BLUPR03MB149.namprd03.prod.outlook.com>
 <1412812099.13320.547.camel@snotra.buserror.net>
In-Reply-To: <1412812099.13320.547.camel@snotra.buserror.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
x-forefront-prvs: 0359162B6D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(13464003)(199003)(189002)(377454003)(377424004)(24454002)(19580395003)(2656002)(97736003)(108616004)(101416001)(86362001)(76482002)(66066001)(80022003)(106356001)(87936001)(99396003)(120916001)(92566001)(31966008)(46102003)(77096002)(85306004)(21056001)(106116001)(105586002)(93886004)(76176999)(33646002)(76576001)(15975445006)(4396001)(54356999)(15202345003)(95666004)(64706001)(19580405001)(99286002)(74316001)(20776003)(122556002)(110136001)(85852003)(107046002)(50986999)(40100002)(7059025)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:BLUPR03MB149.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s992IR6a027997



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Thursday, October 09, 2014 7:48 AM
> To: Jia Hongtao-B38951
> Cc: Guenter Roeck; Benjamin Herrenschmidt; Paul Mackerras; Michael
> Ellerman; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> Jojy G Varghese; Guenter Roeck
> Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
> exception on E500MC / E5500
> 
> On Tue, 2014-10-07 at 22:08 -0500, Jia Hongtao-B38951 wrote:
> >
> > > -----Original Message-----
> > > From: Wood Scott-B07421
> > > Sent: Tuesday, September 30, 2014 2:36 AM
> > > To: Guenter Roeck
> > > Cc: Benjamin Herrenschmidt; Paul Mackerras; Michael Ellerman;
> > > linuxppc- dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Jojy G
> > > Varghese; Guenter Roeck; Jia Hongtao-B38951
> > > Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine
> > > check exception on E500MC / E5500
> > >
> > > On Mon, 2014-09-29 at 09:48 -0700, Guenter Roeck wrote:
> > > > From: Jojy G Varghese <jojyv@juniper.net>
> > > >
> > > > For E500MC and E5500, a machine check exception in pci(e) memory
> > > > space crashes the kernel.
> > > >
> > > > Testing shows that the MCAR(U) register is zero on a MC exception
> > > > for the
> > > > E5500 core. At the same time, DEAR register has been found to have
> > > > the address of the faulty load address during an MC exception for
> this core.
> > > >
> > > > This fix changes the current behavior to fixup the result register
> > > > and instruction pointers in the case of a load operation on a
> > > > faulty PCI address.
> > > >
> > > > The changes are:
> > > > - Added the hook to pci machine check handing to the e500mc
> > > > machine
> > > check
> > > >   exception handler.
> > > > - For the E5500 core, load faulting address from SPRN_DEAR register.
> > > >   As mentioned above, this is necessary because the E5500 core does
> not
> > > >   report the fault address in the MCAR register.
> > > >
> > > > Cc: Scott Wood <scottwood@freescale.com>
> > > > Signed-off-by: Jojy G Varghese <jojyv@juniper.net> [Guenter Roeck:
> > > > updated description]
> > > > Signed-off-by: Guenter Roeck <groeck@juniper.net>
> > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > > ---
> > > >  arch/powerpc/kernel/traps.c   | 3 ++-
> > > >  arch/powerpc/sysdev/fsl_pci.c | 5 +++++
> > > >  2 files changed, 7 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/powerpc/kernel/traps.c
> > > > b/arch/powerpc/kernel/traps.c index 0dc43f9..ecb709b 100644
> > > > --- a/arch/powerpc/kernel/traps.c
> > > > +++ b/arch/powerpc/kernel/traps.c
> > > > @@ -494,7 +494,8 @@ int machine_check_e500mc(struct pt_regs *regs)
> > > >  	int recoverable = 1;
> > > >
> > > >  	if (reason & MCSR_LD) {
> > > > -		recoverable = fsl_rio_mcheck_exception(regs);
> > > > +		recoverable = fsl_rio_mcheck_exception(regs) ||
> > > > +			fsl_pci_mcheck_exception(regs);
> > > >  		if (recoverable == 1)
> > > >  			goto silent_out;
> > > >  	}
> > > > diff --git a/arch/powerpc/sysdev/fsl_pci.c
> > > > b/arch/powerpc/sysdev/fsl_pci.c index c507767..bdb956b 100644
> > > > --- a/arch/powerpc/sysdev/fsl_pci.c
> > > > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > > > @@ -1021,6 +1021,11 @@ int fsl_pci_mcheck_exception(struct pt_regs
> > > > *regs)  #endif
> > > >  	addr += mfspr(SPRN_MCAR);
> > > >
> > > > +#ifdef CONFIG_E5500_CPU
> > > > +	if (mfspr(SPRN_EPCR) & SPRN_EPCR_ICM)
> > > > +		addr = PFN_PHYS(vmalloc_to_pfn((void
> *)mfspr(SPRN_DEAR)));
> > > #endif
> > >
> > > Kconfig tells you what hardware is supported, not what hardware
> > > you're actually running on.
> > >
> > > Jia Hongtao, do you know anything about this issue?  Is there an
> erratum?
> >
> > Sorry for the late response, I just return from my vacation.
> > I don't know this issue.
> >
> > > What chips are affected by the the erratum covered by
> > > <http://patchwork.ozlabs.org/patch/240239/>?
> >
> > MPC8544, MPC8548, MPC8572 are affected by this erratum.
> 
> What is the erratum number?

The number of this erratum for each chip is not consistent.
MPC8544: PCIe 4
MPC8548: PCI-Ex 39
MPC8572: PCI-Ex 3

> 
> > I checked P4080 which using e500mc and no such erratum is found.
> 
> What is the erratum behavior, and how does it differ from the problem
> that Jojy and Guenter are trying to solve?

Here is the description of the erratum:

"When its link goes down, the PCI Express controller clears all outstanding transactions with an
error indicator and sends a link down exception to the interrupt controller if
PEX_PME_MES_DISR[LDDD] = 0. If, however, any transactions are sent to the controller
after the link down event, they will be accepted by the controller and wait for the link to come
back up before starting any timeout counters (e.g. completion timeout). There is no mechanism
to cancel the new transactions short of a device HRESET."

For e500mc as Jojy and Guenter described it's like the same erratum on e500, not 100% sure.

For e5500 I don't quite understand yet.

> 
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
