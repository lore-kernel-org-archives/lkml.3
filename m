Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab3FMJy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:54:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54038 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583Ab3FMJyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:54:52 -0400
Date: Thu, 13 Jun 2013 10:54:46 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v3 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
Message-ID: <20130613095445.GA9045@e102568-lin.cambridge.arm.com>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1370512763-32200-3-git-send-email-lorenzo.pieralisi@arm.com>
 <20130613000143.GB4567@zurbaran>
MIME-Version: 1.0
In-Reply-To: <20130613000143.GB4567@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 13 Jun 2013 09:54:49.0677 (UTC) FILETIME=[0B35C7D0:01CE681C]
X-MC-Unique: 113061310545000201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

first things first, thanks a lot for having a look.

On Thu, Jun 13, 2013 at 01:01:43AM +0100, Samuel Ortiz wrote:
> Hi Lorenzo,
> 
> I don't particularily like this code, but I guess most of my dislike
> comes from the whole bridge interface API and how that forces you into
> implementing pretty much static code.

I do not particularly like it either; you have to grant us though, as Nico
explained, that the usage of this piece of hardware very early at boot is
forcing us to find a solution that is not necessarily easy to implement.

> A few nitpicks:
> 
> On Thu, Jun 06, 2013 at 10:59:23AM +0100, Lorenzo Pieralisi wrote:
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index d54e985..391eda1 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -1148,3 +1148,10 @@ config VEXPRESS_CONFIG
> >  	help
> >  	  Platform configuration infrastructure for the ARM Ltd.
> >  	  Versatile Express.
> > +
> > +config VEXPRESS_SPC
> > +	bool "Versatile Express SPC driver support"
> > +	depends on ARM
> > +	depends on VEXPRESS_CONFIG
> > +	help
> Please provide a detailed help entry here. 

Ok.

> > +	  Serial Power Controller driver for ARM Ltd. test chips.
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index 718e94a..3a01203 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -153,5 +153,6 @@ obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
> >  obj-$(CONFIG_MFD_SYSCON)	+= syscon.o
> >  obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
> >  obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o vexpress-sysreg.o
> > +obj-$(CONFIG_VEXPRESS_SPC)	+= vexpress-spc.o
> So you have Versatile Express platforms that will not need SPC ? i.e.
> why isn't all that stuff under a generic CONFIG_VEXPRESS symbol ?

You answered your own question, the Serial Power Controller aka SPC is
present only in one of the many coretiles that can be stacked on top
of the versatile express motherboard, so it requires a specific entry
unless we want to compile it in for all vexpress platforms.

> > +static struct vexpress_spc_drvdata *info;
> > +static u32 *vexpress_spc_config_data;
> > +static struct vexpress_config_bridge *vexpress_spc_config_bridge;
> > +static struct vexpress_config_func *opp_func, *perf_func;
> > +
> > +static int vexpress_spc_load_result = -EAGAIN;
> As I said, quite static...

I will have a look and see if I can improve it, I could include some of
those variables in the driver data and alloc them dynamically.

> > +irqreturn_t vexpress_spc_irq_handler(int irq, void *data)
> missing a static here ?

Were not there enough :-) ? Correct, I will fix it.

> > +static bool __init __vexpress_spc_check_loaded(void);
> > +/*
> > + * Pointer spc_check_loaded is swapped after init hence it is safe
> > + * to initialize it to a function in the __init section
> > + */
> > +static bool (*spc_check_loaded)(void) __refdata = &__vexpress_spc_check_loaded;
> > +
> > +static bool __init __vexpress_spc_check_loaded(void)
> > +{
> > +	if (vexpress_spc_load_result == -EAGAIN)
> > +		vexpress_spc_load_result = vexpress_spc_init();
> > +	spc_check_loaded = &vexpress_spc_initialized;
> > +	return vexpress_spc_initialized();
> > +}
> > +
> > +/*
> > + * Function exported to manage early_initcall ordering.
> > + * SPC code is needed very early in the boot process
> > + * to bring CPUs out of reset and initialize power
> > + * management back-end. After boot swap pointers to
> > + * make the functionality check available to loadable
> > + * modules, when early boot init functions have been
> > + * already freed from kernel address space.
> > + */
> > +bool vexpress_spc_check_loaded(void)
> > +{
> > +	return spc_check_loaded();
> > +}
> > +EXPORT_SYMBOL_GPL(vexpress_spc_check_loaded);
> That one and the previous function look really nasty to me.
> The simple fact that you need a static variable in your code to check if
> your module is loaded sounds really fishy.

Nico explained the reasons behind this nasty hack, because that's what it
is. The only solution is resorting to vexpress platform code to initialize
this driver directly (providing a static virtual memory mapping since that
has to happen very early) to remove all needs for early_initcall
synchronization and remove that variable. It won't look nicer though.

I will review the code again to see how I can improve it.

Thanks a lot,
Lorenzo

