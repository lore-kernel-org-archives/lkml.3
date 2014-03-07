Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaCGCVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:21:38 -0500
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:39140 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751735AbaCGCVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:21:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3874:4321:4605:5007:6119:7652:7875:10004:10400:10848:11026:11232:11473:11658:11914:12294:12296:12517:12519:12740:13069:13311:13357:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ocean82_822a67b26e013
X-Filterd-Recvd-Size: 3209
Message-ID: <1394158890.16156.46.camel@joe-AO722>
Subject: Re: [PATCH] x86: new Intel Atom SoC power management controller
 driver
From: Joe Perches <joe@perches.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, mingo@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        "alan@linux.intel.com" <alan@linux.intel.com>
Date: Thu, 06 Mar 2014 18:21:30 -0800
In-Reply-To: <53192A39.5030309@linux.intel.com>
References: <5317EC0C.4010807@linux.intel.com>
	 <5317F044.8080407@linux.intel.com> <531805D4.6040806@linux.intel.com>
	 <5318076C.7080605@linux.intel.com> <531808BD.4070000@linux.intel.com>
	 <53180D39.7050207@linux.intel.com> <53180E98.9000608@linux.intel.com>
	 <5318A2BE.2070707@linux.intel.com> <53191222.2000904@linux.intel.com>
	 <1394152871.16156.32.camel@joe-AO722> <53192A39.5030309@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 10:08 +0800, Li, Aubrey wrote:

> The Power Management Controller (PMC) controls many of the power
> management features present in the SoC. This driver provides
> interface to configure the Power Management Controller (PMC).

More trivial notes.

Nothing really that should stop this from being applied.

> diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c

I still think that
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
is useful here.

> +#include <linux/module.h>
> +#include <linux/init.h>
[]
> +#define	DRIVER_NAME "pmc_atom"

Maybe

#define DRIVER_NAME KBUILD_MODNAME

too

> +struct pmc_dev_map {
> +       char *name;
> +       u32 bit_mask;
> +};
> 
> +static struct pmc_dev_map dev_map[] = {

static const to reduce data?

struct pmc_dev_map {
	const char *name;
	u32 bit_mask;
};

> +static struct pmc_dev_map dev_map[] = {

static const struct pmc_dev_map dev_map[] = {

> +	{"0  - LPSS1_F0_DMA",		BIT_LPSS1_F0_DMA},
> +	{"1  - LPSS1_F1_PWM1",		BIT_LPSS1_F1_PWM1},

[]

> +static void pmc_power_off(void)
> +{
[]
> +	pr_info("%s: Preparing to enter system sleep state S5\n", DRIVER_NAME);

This is larger code than using pr_fmt

> +#ifdef CONFIG_DEBUG_FS
> +static int pmc_dev_state_show(struct seq_file *s, void *unused)
> +{
[]
> +		seq_printf(s, "Dev: %-32s\tState: %s [%s]\n",
> +			dev_map[dev_index].name,
> +			dev_map[dev_index].bit_mask & func_dis_index ?
> +			"Disabled" : "Enabled ",
> +			(d3_sts_index & dev_map[dev_index].bit_mask) ?
> +			"D3" : "D0");

This reverses the order of the 1st and 2nd trigraph test
and to me would be easier to read like:

		seq_printf(s, "Dev: %-32s\tState: %s [%s]\n",
			dev_map[dev_index].name,
			dev_map[dev_index].bit_mask & func_dis_index ?
			"Disabled" : "Enabled ",
			dev_map[dev_index].bit_mask & d3_sts_index ?
			"D3" : "D0");


