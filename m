Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab3BYAZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 19:25:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:15748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759311Ab3BYAZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 19:25:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,730,1355126400"; 
   d="scan'208";a="295309821"
Message-ID: <1361751932.29320.1.camel@yhuang-dev>
Subject: Re: [PATCH EDAC 03/13] ghes: add the needed hooks for EDAC error
 report
From: Huang Ying <ying.huang@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 25 Feb 2013 08:25:32 +0800
In-Reply-To: <20130222055755.22f7c5e3@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
	 <a6aaff7d219b878ca655fde3757ecd0170caec2c.1360931635.git.mchehab@redhat.com>
	 <1361409967.7093.20.camel@yhuang-dev> <20130221090428.3b36b1ea@redhat.com>
	 <1361493911.7093.37.camel@yhuang-dev> <20130222055021.12125c03@redhat.com>
	 <20130222055755.22f7c5e3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 05:57 -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 22 Feb 2013 05:50:21 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> 
> > Em Fri, 22 Feb 2013 08:45:11 +0800
> > Huang Ying <ying.huang@intel.com> escreveu:
> > 
> > > On Thu, 2013-02-21 at 09:04 -0300, Mauro Carvalho Chehab wrote:
> > > > Em Thu, 21 Feb 2013 09:26:07 +0800
> > > > Huang Ying <ying.huang@intel.com> escreveu:
> > > > 
> > 
> > > > There is also an advantage on taking this approach: this patch can have just
> > > > the ghes changes, and will still compile fine, as CONFIG_EDAC_GHES is not
> > > > defined yet. So, the patch becomes is simpler and easier to review.
> > > 
> > > Thanks for your explanation.  I agree to keep this in header file.
> > > 
> > > My original suggestion is that it may be better to move this from ghes.h
> > > to some place like "ghes_edac.h", because these functions are
> > > implemented in "ghes_edac.c" instead of ghes.c.
> > > 
> > 
> > Ah! Well, I considered a separate header when writing this patch, but adding 
> > another header for just 3 functions where the parameters are more related to
> > ghes than with ghes_edac seemed overkill to me.
> > 
> > IMO, a single comment at the header pointing to ghes_edac.c would improve it.
> > 
> ...
> > +/* From drivers/edac/ghes_acpi.h */
> 
> ...with is obviously wrong.
> 
> Mental note to myself: never hack too early in the morning before drinking a
> cup of coffee.
> 
> Anyway, fixed on the patch below. Could you please ack?
> 
> Regards,
> Mauro.
> 
> 
> [PATCH EDAC] ghes: add the needed hooks for EDAC error report
> 
> In order to allow reporting errors via EDAC, add hooks for:
> 
> 1) register an EDAC driver;
> 2) unregister an EDAC driver;
> 3) report errors via EDAC.
> 
> As the EDAC driver will need to access the ghes structure, adds it
> as one of the parameters for ghes_do_proc.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Huang Ying <ying.huang@intel.com>

> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 6d0e146..d668a8a 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -409,7 +409,8 @@ static void ghes_clear_estatus(struct ghes *ghes)
>  	ghes->flags &= ~GHES_TO_CLEAR;
>  }
>  
> -static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
> +static void ghes_do_proc(struct ghes *ghes,
> +			 const struct acpi_hest_generic_status *estatus)
>  {
>  	int sev, sec_sev;
>  	struct acpi_hest_generic_data *gdata;
> @@ -421,6 +422,8 @@ static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
>  				 CPER_SEC_PLATFORM_MEM)) {
>  			struct cper_sec_mem_err *mem_err;
>  			mem_err = (struct cper_sec_mem_err *)(gdata+1);
> +			ghes_edac_report_mem_error(ghes, sev, mem_err);
> +
>  #ifdef CONFIG_X86_MCE
>  			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
>  						  mem_err);
> @@ -639,7 +642,7 @@ static int ghes_proc(struct ghes *ghes)
>  		if (ghes_print_estatus(NULL, ghes->generic, ghes->estatus))
>  			ghes_estatus_cache_add(ghes->generic, ghes->estatus);
>  	}
> -	ghes_do_proc(ghes->estatus);
> +	ghes_do_proc(ghes, ghes->estatus);
>  out:
>  	ghes_clear_estatus(ghes);
>  	return 0;
> @@ -732,7 +735,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
>  		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
>  		len = apei_estatus_len(estatus);
>  		node_len = GHES_ESTATUS_NODE_LEN(len);
> -		ghes_do_proc(estatus);
> +		ghes_do_proc(estatus_node->ghes, estatus);
>  		if (!ghes_estatus_cached(estatus)) {
>  			generic = estatus_node->generic;
>  			if (ghes_print_estatus(NULL, generic, estatus))
> @@ -821,6 +824,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
>  		estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool,
>  						      node_len);
>  		if (estatus_node) {
> +			estatus_node->ghes = ghes;
>  			estatus_node->generic = ghes->generic;
>  			estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
>  			memcpy(estatus, ghes->estatus, len);
> @@ -899,6 +903,11 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  		ghes = NULL;
>  		goto err;
>  	}
> +
> +	rc = ghes_edac_register(ghes, &ghes_dev->dev);
> +	if (rc < 0)
> +		goto err;
> +
>  	switch (generic->notify.type) {
>  	case ACPI_HEST_NOTIFY_POLLED:
>  		ghes->timer.function = ghes_poll_func;
> @@ -911,13 +920,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  		if (acpi_gsi_to_irq(generic->notify.vector, &ghes->irq)) {
>  			pr_err(GHES_PFX "Failed to map GSI to IRQ for generic hardware error source: %d\n",
>  			       generic->header.source_id);
> -			goto err;
> +			goto err_edac_unreg;
>  		}
>  		if (request_irq(ghes->irq, ghes_irq_func,
>  				0, "GHES IRQ", ghes)) {
>  			pr_err(GHES_PFX "Failed to register IRQ for generic hardware error source: %d\n",
>  			       generic->header.source_id);
> -			goto err;
> +			goto err_edac_unreg;
>  		}
>  		break;
>  	case ACPI_HEST_NOTIFY_SCI:
> @@ -943,6 +952,8 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  	platform_set_drvdata(ghes_dev, ghes);
>  
>  	return 0;
> +err_edac_unreg:
> +	ghes_edac_unregister(ghes);
>  err:
>  	if (ghes) {
>  		ghes_fini(ghes);
> @@ -995,6 +1006,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
>  	}
>  
>  	ghes_fini(ghes);
> +
> +	ghes_edac_unregister(ghes);
> +
>  	kfree(ghes);
>  
>  	platform_set_drvdata(ghes_dev, NULL);
> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
> index 3eb8dc4..720446c 100644
> --- a/include/acpi/ghes.h
> +++ b/include/acpi/ghes.h
> @@ -27,6 +27,7 @@ struct ghes {
>  struct ghes_estatus_node {
>  	struct llist_node llnode;
>  	struct acpi_hest_generic *generic;
> +	struct ghes *ghes;
>  };
>  
>  struct ghes_estatus_cache {
> @@ -43,3 +44,29 @@ enum {
>  	GHES_SEV_RECOVERABLE = 0x2,
>  	GHES_SEV_PANIC = 0x3,
>  };
> +
> +/* From drivers/edac/ghes_edac.c */
> +
> +#ifdef CONFIG_EDAC_GHES
> +void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
> +				struct cper_sec_mem_err *mem_err);
> +
> +int ghes_edac_register(struct ghes *ghes, struct device *dev);
> +
> +void ghes_edac_unregister(struct ghes *ghes);
> +
> +#else
> +static inline void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
> +				       struct cper_sec_mem_err *mem_err)
> +{
> +}
> +
> +static inline int ghes_edac_register(struct ghes *ghes, struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static inline void ghes_edac_unregister(struct ghes *ghes)
> +{
> +}
> +#endif
> 


