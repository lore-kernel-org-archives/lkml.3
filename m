Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaESCtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 22:49:31 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:47756
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750776AbaESCta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 22:49:30 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "superlibj8301@gmail.com" <superlibj8301@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] arm: ioremap: Fix static vm area boundary check.
Thread-Topic: [PATCH v3] arm: ioremap: Fix static vm area boundary check.
Thread-Index: AQHPcPEiev9bw5h3YUafPFV2neA6eptDgp2AgAO0PkA=
Date: Mon, 19 May 2014 02:49:26 +0000
Message-ID: <9258c0b00a33484a8d289378047f8cd4@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1400232920-25079-1-git-send-email-Li.Xiubo@freescale.com>
 <alpine.LFD.2.11.1405161403400.17310@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1405161403400.17310@knanqh.ubzr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(51704005)(86362001)(81542001)(76576001)(83322001)(74662001)(92566001)(77096999)(77982001)(80022001)(19580405001)(19580395003)(81342001)(76482001)(50986999)(66066001)(85852003)(54356999)(99396002)(46102001)(21056001)(101416001)(76176999)(74316001)(74502001)(2656002)(20776003)(87936001)(64706001)(31966008)(99286001)(83072002)(33646001)(79102001)(4396001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > For each vmalloc area, there is one guard page at the end of it.
> > so the vm->size = PAGE_ALIGN(offset + request size) + guard page size.
> 
> Nope.  There is no guard page for statically created vmalloc areas.
> 

Yes, you are right, I'm thinking why the static area has no guard page?

Thanks very much,

BRs
Xiubo


> 
> > Signed-off-by: Richard Lee <superlibj8301@gmail.com>
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Cc: Nicolas Pitre <nico@linaro.org>
> > Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > ---
> >  arch/arm/mm/ioremap.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> > index be69333..758e8f7 100644
> > --- a/arch/arm/mm/ioremap.c
> > +++ b/arch/arm/mm/ioremap.c
> > @@ -49,14 +49,18 @@ static struct static_vm
> *find_static_vm_paddr(phys_addr_t paddr,
> >  	struct vm_struct *vm;
> >
> >  	list_for_each_entry(svm, &static_vmlist, list) {
> > +		phys_addr_t paddr_end, phys_addr_end;
> > +
> >  		vm = &svm->vm;
> >  		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
> >  			continue;
> >  		if ((vm->flags & VM_ARM_MTYPE_MASK) != VM_ARM_MTYPE(mtype))
> >  			continue;
> >
> > -		if (vm->phys_addr > paddr ||
> > -			paddr + size - 1 > vm->phys_addr + vm->size - 1)
> > +		/* The PAGE_SIZE here is vmalloc area's guard page */
> > +		phys_addr_end = vm->phys_addr + vm->size - PAGE_SIZE - 1;
> > +		paddr_end = paddr + size - 1;
> > +		if (vm->phys_addr > paddr || paddr_end > phys_addr_end)
> >  			continue;
> >
> >  		return svm;
> > --
> > 1.8.4
> >
