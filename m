Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaCGAlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:41:16 -0500
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:57995 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751065AbaCGAlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:41:15 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3867:3871:4250:4321:5007:6119:7652:7903:10004:10400:10848:11026:11473:11657:11658:11914:12043:12296:12517:12519:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pipe13_7f0836e75f928
X-Filterd-Recvd-Size: 3210
Message-ID: <1394152871.16156.32.camel@joe-AO722>
Subject: Re: [PATCH] x86: new Intel Atom SoC power management controller
 driver
From: Joe Perches <joe@perches.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, mingo@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        "alan@linux.intel.com" <alan@linux.intel.com>
Date: Thu, 06 Mar 2014 16:41:11 -0800
In-Reply-To: <53191222.2000904@linux.intel.com>
References: <5317EC0C.4010807@linux.intel.com>
	 <5317F044.8080407@linux.intel.com> <531805D4.6040806@linux.intel.com>
	 <5318076C.7080605@linux.intel.com> <531808BD.4070000@linux.intel.com>
	 <53180D39.7050207@linux.intel.com> <53180E98.9000608@linux.intel.com>
	 <5318A2BE.2070707@linux.intel.com> <53191222.2000904@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 08:26 +0800, Li, Aubrey wrote:

> my patch is word wrapped while I was not aware, hope this one work.

trivial notes:

> diff --git a/arch/x86/include/asm/pmc_atom.h b/arch/x86/include/asm/pmc_atom.h
[]
> +#define	BIT_LPSS1_F0_DMA	(1 << 0)
> +#define	BIT_LPSS1_F1_PWM1	(1 << 1)

These could use BIT(foo)

#define	BIT_LPSS1_F0_DMA	BIT(0)
#define	BIT_LPSS1_F1_PWM1	BIT(1)

etc..

> +#define	BIT_SMB			(1 << 0)
> +#define	BIT_USH_SS_PHY		(1 << 1)
> +#define	BIT_OTG_SS_PHY		(1 << 2)
> +#define	BIT_DFX			(1 << 3)

here too.

> diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
[]
> @@ -0,0 +1,301 @@
> +/*
> + * Intel Atom SOC Power Management Controller Driver
[]
> + */

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

> +static void pmc_power_off(void)
> +{
[]
> +	printk(KERN_INFO, "PMC: Preparing to enter system sleep state S5\n");

	pr_info("Preparing to enter system sleep state S5\n");

> +		if (func_dis_index & dev_map[dev_index].bit_mask) {
> +			seq_printf(s, "Dev: %-32s\tState: %s [%s]\n",
> +				dev_map[dev_index].name, "Disabled",
> +				(d3_sts_index & dev_map[dev_index].bit_mask) ?
> +				"D3":"D0");
> +		} else {
> +			seq_printf(s, "Dev: %-32s\tState: %s [%s]\n",
> +				dev_map[dev_index].name, "Enabled ",
> +				(d3_sts_index & dev_map[dev_index].bit_mask) ?
> +				"D3":"D0");
> +		}

Maybe better with a single seq_printf

		seq_printf(s, "Dev: %-32s\tState: %s [%s]\n",
			   dev_map[dev_index].name,
			   dev_map[dev_index].bit_mask & func_dis_index ?
			   "Disabled" : " Enabled ",
			   dev_map[dev_index].bit_mask & d3_sts_index ?
			   "D3" : "D0");

> +static int pmc_probe(struct pci_dev *pdev,
> +			  const struct pci_device_id *unused)
> +{

> +	pmc = devm_kzalloc(&pdev->dev, sizeof(struct pmc_dev), GFP_KERNEL);
> +	if (!pmc) {
> +		dev_err(&pdev->dev, "error: could not allocate memory\n");

Unnecessary OOM message, kzalloc will dump_stack()


