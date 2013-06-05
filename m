Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab3FEQdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:33:39 -0400
Received: from queue01b.mail.zen.net.uk ([212.23.3.242]:54261 "EHLO
	queue01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3FEQdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:33:38 -0400
Message-ID: <1370449950.3496.12.camel@linaro1.home>
Subject: Re: [RFC PATCH v2 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Date: Wed, 05 Jun 2013 17:32:30 +0100
In-Reply-To: <1370432767-6620-3-git-send-email-lorenzo.pieralisi@arm.com>
References: <1370432767-6620-1-git-send-email-lorenzo.pieralisi@arm.com>
	 <1370432767-6620-3-git-send-email-lorenzo.pieralisi@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 12:46 +0100, Lorenzo Pieralisi wrote:
[...]
> +
> +static bool __init __vexpress_spc_check_loaded(void);
> +static bool (*spc_check_loaded)(void) = &__vexpress_spc_check_loaded;

We get a section mismatch warning from the above because
__vexpress_spc_check_loaded is marked __init.

Now, we know the code is safe because we replace the reference in the
early_initcall below, before the init section is discarded (which is the
whole point of the construct) so we can add __refdata to the declaration
of spc_check_loaded to silence the warning.

Other than that I've not noticed any issues when testing the patches.

> +
> +static bool __init __vexpress_spc_check_loaded(void)
> +{
> +	if (vexpress_spc_load_result == -EAGAIN)
> +		vexpress_spc_load_result = vexpress_spc_init();
> +	spc_check_loaded = &vexpress_spc_initialized;
> +	return vexpress_spc_initialized();
> +}
> +
> +/*
> + * Function exported to manage early_initcall ordering.
> + * SPC code is needed very early in the boot process
> + * to bring CPUs out of reset and initialize power
> + * management back-end. After boot swap pointers to
> + * make the functionality check available to loadable
> + * modules, when early boot init functions have been
> + * already freed from kernel address space.
> + */
> +bool vexpress_spc_check_loaded(void)
> +{
> +	return spc_check_loaded();
> +}
> +EXPORT_SYMBOL_GPL(vexpress_spc_check_loaded);
> +
> +static int __init vexpress_spc_early_init(void)
> +{
> +	__vexpress_spc_check_loaded();
> +	return vexpress_spc_load_result;
> +}
> +early_initcall(vexpress_spc_early_init);
[...]

-- 
Tixy

