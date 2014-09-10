Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaIJR7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:59:53 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:55823 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaIJR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:59:51 -0400
Date: Wed, 10 Sep 2014 13:59:47 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Kukjin Kim <kgene.kim@samsung.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
In-Reply-To: <20140910174141.GH12361@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1409101356270.16533@knanqh.ubzr>
References: <20140901230728.GM29327@sirena.org.uk> <1627064.QhxvejlWdk@amdc1032> <alpine.DEB.2.11.1409020857110.9201@gentwo.org> <alpine.DEB.2.11.1409020958530.9608@gentwo.org> <alpine.LFD.2.11.1409051525440.16533@knanqh.ubzr>
 <20140910174141.GH12361@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Russell King - ARM Linux wrote:

> On Fri, Sep 05, 2014 at 03:27:51PM -0400, Nicolas Pitre wrote:
> > On Tue, 2 Sep 2014, Christoph Lameter wrote:
> > 
> > > On Tue, 2 Sep 2014, Christoph Lameter wrote:
> > > 
> > > > Oww.. This is double indirection deal there. A percpu offset pointing to
> > > > a pointer?
> > > >
> > > > Generally the following is true (definition from
> > > > include/asm-generic/percpu.h that is used for ARM for raw_cpu_read):
> > > >
> > > > #define raw_cpu_read_4(pcp)             (*raw_cpu_ptr(&(pcp)))
> > > 
> > > I think what the issue is that we dropped the fetch of the percpu offset
> > > in the patch. Instead we are using the address of the variable that
> > > contains the offset. Does this patch fix it?
> > > 
> > > 
> > > Subject: irqchip: Properly fetch the per cpu offset
> > > 
> > > The raw_cpu_read() conversion dropped the fetch of the offset
> > > from base->percpu_base in gic_get_percpu_base.
> > > 
> > > Signed-off-by: Christoph Lameter <cl@linux.com>
> > > 
> > > Index: linux/drivers/irqchip/irq-gic.c
> > > ===================================================================
> > > --- linux.orig/drivers/irqchip/irq-gic.c
> > > +++ linux/drivers/irqchip/irq-gic.c
> > > @@ -102,7 +102,7 @@ static struct gic_chip_data gic_data[MAX
> > >  #ifdef CONFIG_GIC_NON_BANKED
> > >  static void __iomem *gic_get_percpu_base(union gic_base *base)
> > >  {
> > > -	return raw_cpu_read(base->percpu_base);
> > > +	return raw_cpu_read(*base->percpu_base);
> > 
> > Isn't the pointer dereference supposed to be performed _outside_ the per 
> > CPU accessor?
> 
> I think this is correct.
> 
> Let's start from the depths of raw_cpu_read(), where the pointer is
> verified to be the correct type:
> 
> #define __verify_pcpu_ptr(ptr)                                          \
> do {                                                                    \
>         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
>         (void)__vpp_verify;                                             \
> } while (0)
> 
> So, "ptr" should be of type "const void __percpu *" (note the __percpu
> annotation there, which makes it sparse-checkable.)
> 
> The next level up is this:
> 
> #define __pcpu_size_call_return(stem, variable)                         \
> ({                                                                      \
>         typeof(variable) pscr_ret__;                                    \
>         __verify_pcpu_ptr(&(variable));                                 \
> 
> So, we pass the address of the variable to the verification function.
> That makes it a void-typed variable - "const void __percpu".
> 
> #define raw_cpu_read(pcp)   __pcpu_size_call_return(raw_cpu_read_, pcp)
> 
> So this also makes "pcp" a "const void __percpu".
> 
> Now, what type is base->percpu_base?
> 
>         void __percpu * __iomem *percpu_base;
> 
> The thing we want to be per-cpu is a "void __iomem *" pointer.  However,
> we have a pointer to the per-cpu instance.  That's the "void __percpu *"
> bit.
> 
> So, for this to match the requirements for raw_cpu_read(), we need to
> do one dereference to end up with "void __percpu".
> 
> Hence, to me, the patch looks correct.

Good, I now agree.  If needed:

Acked-by: Nicolas Pitre <nico@linaro.org>

> Whether it works or not is a /completely/ different matter.  As has been
> pointed out, the only place this code gets used is on a very small number
> of platforms, which I don't have, and that gives me zero way to test it.
> If it's Exynos which is affected by this, we need to call on Samsung to
> test this patch.

AFAICS it was tested already and confirmed working.

> Now, this code was introduced by Marc Zyngier in order to support Exynos,
> probably the result of another patch on the mailing list from Samsung.
> (I've added Marc and another Samsung guy to the Cc list.)  Whatever,
> *someone* needs to verify this but it needs to be done with the affected
> hardware.  Whether Marc can, or whether it has to be someone from Samsung,
> I don't care which.
> 
> /Or/ we deem the code unmaintained, broken, and untestable, and we start
> considering ripping it out of the mainline kernel on the basis that no
> one cares about it anymore.

The problem was reported by someone who tested linux-next on the 
affected platform, so it must still be used.


Nicolas
