Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab3FMD0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:26:23 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:57897 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab3FMD0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:26:21 -0400
Date: Wed, 12 Jun 2013 23:26:19 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Pawel Moll <pawel.moll@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v3 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
In-Reply-To: <20130613000143.GB4567@zurbaran>
Message-ID: <alpine.LFD.2.03.1306122307390.18597@syhkavp.arg>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com> <1370512763-32200-3-git-send-email-lorenzo.pieralisi@arm.com> <20130613000143.GB4567@zurbaran>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013, Samuel Ortiz wrote:

> > +static struct vexpress_spc_drvdata *info;
> > +static u32 *vexpress_spc_config_data;
> > +static struct vexpress_config_bridge *vexpress_spc_config_bridge;
> > +static struct vexpress_config_func *opp_func, *perf_func;
> > +
> > +static int vexpress_spc_load_result = -EAGAIN;
> As I said, quite static...
> 
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

Maybe a bit of context might explain why things are done this way.

This code is, amongst other things, needed to properly bring up 
secondary CPUs during boot.  This means that it has to be initialized at 
the early_initcall level before SMP is initialized.  So that rules out 
most of the device driver niceties which are not initialized yet, and 
that also means that this can't be made into a loadable module.

To make things even more subtle, this code is needed to implement the 
backend for the MCPM layer through which the actual bringup of secondary 
CPUs is done.  So that MCPM backend is itself also initialized at the 
early_initcall level, but we don't know and can't enforce the order 
those different things will be initialized.  So the MCPM backend calls 
vexpress_spc_check_loaded() to initialize it if it has not been 
initialized yet, or return false if there is no SPC on the booted 
system.

Yet this code is also the entry point for some operating point changes 
requested by the cpufreq driver, and that one can be modular.  And the 
cpufreq driver also has to test for the presence of a SPC via 
vexpress_spc_check_loaded().

So that's the main reason why there is a static state variable, and why 
there is a switch of function pointed by spc_check_loaded to let the 
init code go after boot and still be able to be referenced by modules 
after boot.


Nicolas
