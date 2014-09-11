Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaIKLCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:02:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9482 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaIKLCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:02:01 -0400
X-AuditID: cbfee61b-f79f86d00000144c-4b-5411812796e7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Christoph Lameter <cl@linux.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
Date: Thu, 11 Sep 2014 13:01:43 +0200
Message-id: <3931811.uoPC70E0Og@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <5410943E.3050505@arm.com>
References: <20140901230728.GM29327@sirena.org.uk>
 <20140910174141.GH12361@n2100.arm.linux.org.uk> <5410943E.3050505@arm.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=WINDOWS-1252
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jQV31RsEQg0m7tS2mPnzCZnH92xtG
	i94FV9kszja9Ybe4vGsOm8XBhW2MFrcv81r8vfOPzeLTs3/sFr+WH2V04PJYM28No0dLcw+b
	x6ZVnWwed67tYfN4cmU6k0ffllWMHp83yQWwR3HZpKTmZJalFunbJXBl3Jp+mb3gjEZF57SX
	jA2Mb2W7GDk5JARMJN6sPsMKYYtJXLi3nq2LkYtDSGA6o0TPjvmMEE4Lk8T0zTfZQarYBKwk
	JravYgSxRQTUJZ72PwOLMwtMYJY4fhMsLgwUPzxzDVicRUBV4ujxvWAbeAU0JTrWLWQCsUUF
	PCV2bF8JtI2DgxOofvLHeJCwkEC9xOs3f5khygUlfky+xwIxXl5i3/6prCDlzAJ6Eot3pk1g
	FJiFpGoWkqpZCFULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRHxDPpHYyrGiwOMQpw
	MCrx8FayCIYIsSaWFVfmHmKU4GBWEuEtLQQK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0o
	JJCeWJKanZpakFoEk2Xi4JRqYJz/9NcTp16DSddm/LryX9jK98DM+ECbmpvlm89lH3rIp1pb
	tP/a6hl3+w3zdsp8Xq3raqnFfl1+Kten7HvzM5yumhyVe2BTURNwqVVe+4XfXxcBFo0H7TcD
	V+fYXtRTfyB1Qud5WEHCr87XZxsi5zElbD/kKaF6l6No07HS34dOn+Q5KnH2AY8SS3FGoqEW
	c1FxIgCC/5x3hAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, September 10, 2014 07:11:10 PM Marc Zyngier wrote:
> Hi Russell,
> 
> On 10/09/14 18:41, Russell King - ARM Linux wrote:
> > On Fri, Sep 05, 2014 at 03:27:51PM -0400, Nicolas Pitre wrote:
> >> On Tue, 2 Sep 2014, Christoph Lameter wrote:
> >>
> >>> On Tue, 2 Sep 2014, Christoph Lameter wrote:
> >>>
> >>>> Oww.. This is double indirection deal there. A percpu offset pointing to
> >>>> a pointer?
> >>>>
> >>>> Generally the following is true (definition from
> >>>> include/asm-generic/percpu.h that is used for ARM for raw_cpu_read):
> >>>>
> >>>> #define raw_cpu_read_4(pcp)             (*raw_cpu_ptr(&(pcp)))
> >>>
> >>> I think what the issue is that we dropped the fetch of the percpu offset
> >>> in the patch. Instead we are using the address of the variable that
> >>> contains the offset. Does this patch fix it?
> >>>
> >>>
> >>> Subject: irqchip: Properly fetch the per cpu offset
> >>>
> >>> The raw_cpu_read() conversion dropped the fetch of the offset
> >>> from base->percpu_base in gic_get_percpu_base.
> >>>
> >>> Signed-off-by: Christoph Lameter <cl@linux.com>
> >>>
> >>> Index: linux/drivers/irqchip/irq-gic.c
> >>> ===================================================================
> >>> --- linux.orig/drivers/irqchip/irq-gic.c
> >>> +++ linux/drivers/irqchip/irq-gic.c
> >>> @@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
> >>>  #ifdef CONFIG_GIC_NON_BANKED
> >>>  static void __iomem *gic_get_percpu_base(union gic_base *base)
> >>>  {
> >>> -	return raw_cpu_read(base->percpu_base);
> >>> +	return raw_cpu_read(*base->percpu_base);
> >>
> >> Isn't the pointer dereference supposed to be performed _outside_ the per 
> >> CPU accessor?
> > 
> > I think this is correct.
> > 
> > Let's start from the depths of raw_cpu_read(), where the pointer is
> > verified to be the correct type:
> > 
> > #define __verify_pcpu_ptr(ptr)                                          \
> > do {                                                                    \
> >         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
> >         (void)__vpp_verify;                                             \
> > } while (0)
> > 
> > So, "ptr" should be of type "const void __percpu *" (note the __percpu
> > annotation there, which makes it sparse-checkable.)
> > 
> > The next level up is this:
> > 
> > #define __pcpu_size_call_return(stem, variable)                         \
> > ({                                                                      \
> >         typeof(variable) pscr_ret__;                                    \
> >         __verify_pcpu_ptr(&(variable));                                 \
> > 
> > So, we pass the address of the variable to the verification function.
> > That makes it a void-typed variable - "const void __percpu".
> > 
> > #define raw_cpu_read(pcp)   __pcpu_size_call_return(raw_cpu_read_, pcp)
> > 
> > So this also makes "pcp" a "const void __percpu".
> > 
> > Now, what type is base->percpu_base?
> > 
> >         void __percpu * __iomem *percpu_base;
> > 
> > The thing we want to be per-cpu is a "void __iomem *" pointer.  However,
> > we have a pointer to the per-cpu instance.  That's the "void __percpu *"
> > bit.
> > 
> > So, for this to match the requirements for raw_cpu_read(), we need to
> > do one dereference to end up with "void __percpu".
> > 
> > Hence, to me, the patch looks correct.
> > 
> > Whether it works or not is a /completely/ different matter.  As has been
> > pointed out, the only place this code gets used is on a very small number
> > of platforms, which I don't have, and that gives me zero way to test it.
> > If it's Exynos which is affected by this, we need to call on Samsung to
> > test this patch.
> > 
> > Now, this code was introduced by Marc Zyngier in order to support Exynos,
> > probably the result of another patch on the mailing list from Samsung.
> > (I've added Marc and another Samsung guy to the Cc list.)  Whatever,
> > *someone* needs to verify this but it needs to be done with the affected
> > hardware.  Whether Marc can, or whether it has to be someone from Samsung,
> > I don't care which.
> 
> Thanks for looping me in. I indeed introduced this as an alternative to
> an utterly broken patch that was submitted at the time.
> 
> As far as I can tell, and by reading your analysis, this patch looks
> perfectly sensible.
> 
> Now, I have long given up on trying to run *anything* on a Samsung
> platform other than my Chromebook - the various maintainers don't seem
> to care at all. I may be able to revive an Origen board though (I think
> I have one collecting the proverbial dust in a cupboard), assuming I can
> locate a bootloader for it.

Well, I'm not a maintainer but I try keep linux-next working on at least:

Origen (Exynos4210)
Origen Quad (Exynos4412)
ODROID U3 (Exynos4412)
Trats2 (Exynos4412)
Arndale (Exynos5250)

If you have problems booting linux-next on any of the above boards please
let me know.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

