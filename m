Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaEPHRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:17:43 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:19184
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751231AbaEPHRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:17:41 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Richard Lee <superlibj8301@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>
Subject: RE: [PATCHv2] ARM: ioremap: Fix static vm area boundary checking.
Thread-Topic: [PATCHv2] ARM: ioremap: Fix static vm area boundary checking.
Thread-Index: AQHPcB5WNK06+gqfzUqyaRck0cdofptB5e4AgACK7wCAAFpBMA==
Date: Fri, 16 May 2014 07:17:37 +0000
Message-ID: <308e7a7eeaf04ae8a90b8db39697009b@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1400142562-9111-1-git-send-email-superlibj8301@gmail.com>
	<alpine.LFD.2.11.1405151325250.17310@knanqh.ubzr>
 <CAHPCO9GrwRczw2R9nZDL0tDdYxSHV0f2aDhFSat+xhhiWaYbUg@mail.gmail.com>
In-Reply-To: <CAHPCO9GrwRczw2R9nZDL0tDdYxSHV0f2aDhFSat+xhhiWaYbUg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(164054003)(189002)(199002)(24454002)(377454003)(76482001)(74502001)(31966008)(76176999)(54356999)(50986999)(77096999)(33646001)(83322001)(99396002)(46102001)(81542001)(81342001)(77982001)(99286001)(74316001)(74662001)(19580405001)(19580395003)(86362001)(80022001)(76576001)(21056001)(92566001)(20776003)(79102001)(64706001)(83072002)(85852003)(66066001)(2656002)(4396001)(101416001)(87936001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCHv2] ARM: ioremap: Fix static vm area boundary checking.
> 
> On Fri, May 16, 2014 at 1:28 AM, Nicolas Pitre <nicolas.pitre@linaro.org>
> wrote:
> > On Thu, 15 May 2014, Richard Lee wrote:
> >
> >> Static vm area boundary check:
> >>
> >>       paddr1 --->|       |
> >>                  |       |
> >>                  |-------| <-\--- svm->vm->addr(is page aligned)
> >>       paddr2 --->|       |    |
> >>                  |     --| <--|-- svm->vm->phys_addr
> >>                  |       |    |
> >>       paddr3 --->|       |    |
> >>                  |       |    |
> >>                  |-------| <--|-- next page boundary
> >>                  |       |    |
> >>       paddr4 --->|       |    | <----- svm->vm->size(including guard page)
> >>                  |       |    |
> >>                  |       |    |
> >> max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
> >>                  | ///// |    |
> >>       paddr5 --->| guard |    |
> >>                  | page  |    |
> >>                  | ///// |    |
> >>                   -------  <-/--- svm->vm->addr + svm->vm_size
> >>
> >> <1> If the paddr == paddr1, then continue;
> >> <2> If the paddr == paddr2~paddr4 and paddr_end > phys_addr_end,
> >>     then continue;
> >> <3> if the paddr >= paddr5 then continue;
> >>
> >> Signed-off-by: Richard Lee <superlibj8301@gmail.com>
> >
> > instead of doing this repeatedly, why not simply ensure the recorded
> > static vm information is already page aligned in the first place?
> >
> 
> Sorry, I'm not very sure what vm information you meant here.
> 
> And the 'svm->vm->addr' and 'svm->vm->size' are all page aligned
> already, but we cannot make sure that the 'paddr' and
> 'svm->vm->phys_addr' are page aligned.
> 

The paddr and svm->vm->phys_addr are all already pfn aligned here.
What we should fix about is the boundary of them. 

Thanks,
BRs
Xiubo


> 
> Thanks,
> 
> BRs
> Richard Lee
> 
> >
> >
> >> ---
> >>
> >>
> >> Change in V2:
> >>  - PAGE_SIZE --> PAGE_MASK
> >>  - remove the 'size' page size align operation.
> >>
> >>
> >>
> >>
> >>
> >>
> >>  arch/arm/mm/ioremap.c | 40 ++++++++++++++++++++++++++++++++++++++--
> >>  1 file changed, 38 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> >> index be69333..f235ab7 100644
> >> --- a/arch/arm/mm/ioremap.c
> >> +++ b/arch/arm/mm/ioremap.c
> >> @@ -47,16 +47,52 @@ static struct static_vm
> *find_static_vm_paddr(phys_addr_t paddr,
> >>  {
> >>       struct static_vm *svm;
> >>       struct vm_struct *vm;
> >> +     size_t offset;
> >> +
> >> +     offset = paddr & ~PAGE_MASK;
> >>
> >>       list_for_each_entry(svm, &static_vmlist, list) {
> >> +             phys_addr_t paddr_end, phys_addr_end;
> >> +             size_t vmoff;
> >> +
> >>               vm = &svm->vm;
> >>               if (!(vm->flags & VM_ARM_STATIC_MAPPING))
> >>                       continue;
> >>               if ((vm->flags & VM_ARM_MTYPE_MASK) != VM_ARM_MTYPE(mtype))
> >>                       continue;
> >>
> >> -             if (vm->phys_addr > paddr ||
> >> -                     paddr + size - 1 > vm->phys_addr + vm->size - 1)
> >> +             /* Static vm area boundary check:
> >> +              *
> >> +              *       paddr1 --->|       |
> >> +              *                  |       |
> >> +              *                  |-------| <-\--- svm->vm->addr(page
> aligned)
> >> +              *       paddr2 --->|       |    |
> >> +              *                  |     --| <--|-- svm->vm->phys_addr
> >> +              *                  |       |    |
> >> +              *       paddr3 --->|       |    |
> >> +              *                  |       |    |
> >> +              *                  |-------| <--|-- next page boundary
> >> +              *                  |       |    |
> >> +              *       paddr4 --->|       |    | <----- svm->vm->size,
> >> +              *                  |       |    |         including guard
> page
> >> +              *                  |       |    |
> >> +              * max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
> >> +              *                  | ///// |    |
> >> +              *       paddr5 --->| guard |    |
> >> +              *                  | page  |    |
> >> +              *                  | ///// |    |
> >> +              *                   -------  <-/-- svm->vm->addr + svm-
> >vm_size
> >> +              *
> >> +              * <1> If paddr == paddr1, then continue;
> >> +              * <2> If paddr == paddr2~paddr4 and paddr_end >
> phys_addr_end,
> >> +              *     then continue;
> >> +              * <3> if paddr >= paddr5 then continue;
> >> +              */
> >> +             vmoff = vm->phys_addr & ~PAGE_MASK;
> >> +             phys_addr_end = vm->phys_addr + vm->size - PAGE_SIZE - vmoff;
> >> +             paddr_end = paddr + size - offset;
> >> +             if (__phys_to_pfn(vm->phys_addr) > __phys_to_pfn(paddr) ||
> >> +                     paddr_end - 1 > phys_addr_end - 1)
> >>                       continue;
> >>
> >>               return svm;
> >> --
> >> 1.8.4
> >>
