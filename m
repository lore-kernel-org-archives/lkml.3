Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbaCNWlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:41:52 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:9112
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756260AbaCNWlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:41:49 -0400
Message-ID: <1394836901.12479.125.camel@snotra.buserror.net>
Subject: Re: [PATCH 5/9] powerpc/85xx: disable irq by hardware when suspend
 for 64-bit
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Fri, 14 Mar 2014 17:41:41 -0500
In-Reply-To: <20140312074610.GD4706@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-5-git-send-email-chenhui.zhao@freescale.com>
	 <1394581880.13761.69.camel@snotra.buserror.net>
	 <20140312074610.GD4706@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR06CA016.namprd06.prod.outlook.com (10.141.154.164)
 To BLUPR03MB389.namprd03.prod.outlook.com (10.141.78.11)
X-Forefront-PRVS: 0150F3F97D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(24454002)(51704005)(189002)(199002)(51856001)(20776003)(93516002)(81816001)(63696002)(47776003)(69226001)(46102001)(74662001)(88136002)(81686001)(47446002)(74502001)(79102001)(95666003)(59766001)(31966008)(23676002)(94316002)(94946001)(54316002)(56776001)(76482001)(80022001)(65816001)(53806001)(86362001)(33646001)(93916002)(95416001)(42186004)(74366001)(87976001)(97186001)(77096001)(77156001)(74876001)(50466002)(74706001)(87266001)(76786001)(76796001)(56816005)(47736001)(49866001)(89996001)(50226001)(85852003)(83072002)(50986001)(47976001)(85306002)(83322001)(19580405001)(19580395003)(80976001)(62966002)(81342001)(81542001)(92566001)(90146001)(92726001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB389;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:5CD7C3D8.E73E1F0D.3DF42BB2.88BCFE31.202A0;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 15:46 +0800, Chenhui Zhao wrote:
> On Tue, Mar 11, 2014 at 06:51:20PM -0500, Scott Wood wrote:
> > On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> > > In 64-bit mode, kernel just clears the irq soft-enable flag
> > > in struct paca_struct to disable external irqs. But, in
> > > the case of suspend, irqs should be disabled by hardware.
> > > Therefore, hook a function to ppc_md.suspend_disable_irqs
> > > to really disable irqs.
> > > 
> > > Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
> > > ---
> > >  arch/powerpc/platforms/85xx/corenet_generic.c |   12 ++++++++++++
> > >  1 files changed, 12 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/powerpc/platforms/85xx/corenet_generic.c b/arch/powerpc/platforms/85xx/corenet_generic.c
> > > index 3fdf9f3..983d81f 100644
> > > --- a/arch/powerpc/platforms/85xx/corenet_generic.c
> > > +++ b/arch/powerpc/platforms/85xx/corenet_generic.c
> > > @@ -32,6 +32,13 @@
> > >  #include <sysdev/fsl_pci.h>
> > >  #include "smp.h"
> > >  
> > > +#if defined(CONFIG_PPC64) && defined(CONFIG_SUSPEND)
> > > +static void fsl_suspend_disable_irqs(void)
> > > +{
> > > +	__hard_irq_disable();
> > > +}
> > > +#endif
> > 
> > Why the underscore version?  Don't you want PACA_IRQ_HARD_DIS to be set?
> > 
> > If hard disabling is appropriate here, shouldn't we do it in
> > generic_suspend_disable_irqs()?
> > 
> > Are there any existing platforms that supply a
> > ppc_md.suspend_disable_irqs()?  I don't see any when grepping.
> > 
> > -Scott
> 
> Will use hard_irq_disable().
> 
> I think this is a general problem for powerpc.
> Should clear MSR_EE before suspend. I agree to put it
> in generic_suspend_disable_irqs().

BTW, make sure you test this patchset with CONFIG_DEBUG_PREEMPT and
similar debugging options to help ensure that the soft IRQ state is
being tracked properly.

-Scott


