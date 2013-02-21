Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3BUMEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 07:04:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab3BUMEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 07:04:36 -0500
Date: Thu, 21 Feb 2013 09:04:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 03/13] ghes: add the needed hooks for EDAC error
 report
Message-ID: <20130221090428.3b36b1ea@redhat.com>
In-Reply-To: <1361409967.7093.20.camel@yhuang-dev>
References: <cover.1360931635.git.mchehab@redhat.com>
	<a6aaff7d219b878ca655fde3757ecd0170caec2c.1360931635.git.mchehab@redhat.com>
	<1361409967.7093.20.camel@yhuang-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 21 Feb 2013 09:26:07 +0800
Huang Ying <ying.huang@intel.com> escreveu:

> Sorry for late!

Thanks for your comments. See my answers below.
> 
> On Fri, 2013-02-15 at 10:44 -0200, Mauro Carvalho Chehab wrote:
> > In order to allow reporting errors via EDAC, add hooks for:
> > 
> > 1) register an EDAC driver;
> > 2) unregister an EDAC driver;
> > 3) report errors via EDAC.
> > 
> > As the EDAC driver will need to access the ghes structure, adds it
> > as one of the parameters for ghes_do_proc.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  drivers/acpi/apei/ghes.c | 17 ++++++++++++++---
> >  include/acpi/ghes.h      | 27 +++++++++++++++++++++++++++
> >  2 files changed, 41 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> > index 6d0e146..a21d7da 100644
> > --- a/drivers/acpi/apei/ghes.c
> > +++ b/drivers/acpi/apei/ghes.c
> > @@ -409,7 +409,8 @@ static void ghes_clear_estatus(struct ghes *ghes)
> >  	ghes->flags &= ~GHES_TO_CLEAR;
> >  }
> >  
> > -static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
> > +static void ghes_do_proc(struct ghes *ghes,
> > +			 const struct acpi_hest_generic_status *estatus)
> >  {
> >  	int sev, sec_sev;
> >  	struct acpi_hest_generic_data *gdata;
> > @@ -421,6 +422,8 @@ static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
> >  				 CPER_SEC_PLATFORM_MEM)) {
> >  			struct cper_sec_mem_err *mem_err;
> >  			mem_err = (struct cper_sec_mem_err *)(gdata+1);
> > +			ghes_edac_report_mem_error(ghes, sev, mem_err);
> > +
> >  #ifdef CONFIG_X86_MCE
> >  			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
> >  						  mem_err);
> > @@ -639,7 +642,7 @@ static int ghes_proc(struct ghes *ghes)
> >  		if (ghes_print_estatus(NULL, ghes->generic, ghes->estatus))
> >  			ghes_estatus_cache_add(ghes->generic, ghes->estatus);
> >  	}
> > -	ghes_do_proc(ghes->estatus);
> > +	ghes_do_proc(ghes, ghes->estatus);
> >  out:
> >  	ghes_clear_estatus(ghes);
> >  	return 0;
> > @@ -732,7 +735,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
> >  		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
> >  		len = apei_estatus_len(estatus);
> >  		node_len = GHES_ESTATUS_NODE_LEN(len);
> > -		ghes_do_proc(estatus);
> > +		ghes_do_proc(estatus_node->ghes, estatus);
> >  		if (!ghes_estatus_cached(estatus)) {
> >  			generic = estatus_node->generic;
> >  			if (ghes_print_estatus(NULL, generic, estatus))
> > @@ -821,6 +824,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
> >  		estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool,
> >  						      node_len);
> >  		if (estatus_node) {
> > +			estatus_node->ghes = ghes;
> >  			estatus_node->generic = ghes->generic;
> >  			estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
> >  			memcpy(estatus, ghes->estatus, len);
> > @@ -942,6 +946,10 @@ static int ghes_probe(struct platform_device *ghes_dev)
> >  	}
> >  	platform_set_drvdata(ghes_dev, ghes);
> >  
> > +	rc = ghes_edac_register(ghes, &ghes_dev->dev);
> > +	if (rc < 0)
> > +		goto err;
> > +
> 
> If ghes_edac_register() failed, we need to do some cleanup such as
> unregister from hed etc.
> 
> Or just move ghes_edac_register() before switch?

Moving it to happen before the switch() looks the better. We need to unregister
ghes_edac if IRQ fails.

> >  	return 0;
> >  err:
> >  	if (ghes) {
> > @@ -995,6 +1003,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
> >  	}
> >  
> >  	ghes_fini(ghes);
> > +
> > +	ghes_edac_unregister(ghes);
> > +
> >  	kfree(ghes);
> >  
> >  	platform_set_drvdata(ghes_dev, NULL);
> > diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
> > index 3eb8dc4..c6fef72 100644
> > --- a/include/acpi/ghes.h
> > +++ b/include/acpi/ghes.h
> > @@ -22,11 +22,14 @@ struct ghes {
> >  		struct timer_list timer;
> >  		unsigned int irq;
> >  	};
> > +
> > +	struct mem_ctl_info *mci;
> 
> Why we need this?  This is not used by ghes.[hc].

This will be needed by the EDAC driver, as the EDAC core has its own main
struct, and such struct need to be recovered when reporting an error.

As this struct is not used by ghes, there's no need to even include the
include/linux/edac.h, where this is declared, as gcc will just handle it
as "void *" when compiling ghes.

I opted for this design as it is simpler, and costs just 8 bytes for each
ghes struct, and no extra code is needed.

However, as you're not happy with it, I'm removing it from there, and adding
a list at the edac driver, together with a mutex, to serialize its access,
associating each ghes struct with their corresponding MC struct.

I'll post the patch replacing patch 05/13 soon.

> 
> >  };
> >  
> >  struct ghes_estatus_node {
> >  	struct llist_node llnode;
> >  	struct acpi_hest_generic *generic;
> > +	struct ghes *ghes;
> >  };
> >  
> >  struct ghes_estatus_cache {
> > @@ -43,3 +46,27 @@ enum {
> >  	GHES_SEV_RECOVERABLE = 0x2,
> >  	GHES_SEV_PANIC = 0x3,
> >  };
> > +
> > +#ifdef CONFIG_EDAC_GHES
> > +void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
> > +				struct cper_sec_mem_err *mem_err);
> > +
> > +int ghes_edac_register(struct ghes *ghes, struct device *dev);
> > +
> > +void ghes_edac_unregister(struct ghes *ghes);
> > +
> > +#else
> > +static inline void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
> > +				       struct cper_sec_mem_err *mem_err)
> > +{
> > +}
> > +
> > +static inline int ghes_edac_register(struct ghes *ghes, struct device *dev)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void ghes_edac_unregister(struct ghes *ghes)
> > +{
> > +}
> > +#endif
> 
> I think it is better to put the above declaration into module which
> implement these functions instead of use these functions.

This is due to Linux Coding Style. See Documentation/SubmittingPatches,
session 2, item 1:

	2) #ifdefs are ugly

	Code cluttered with ifdefs is difficult to read and maintain.  Don't do
	it.  Instead, put your ifdefs in a header, and conditionally define
	'static inline' functions, or macros, which are used in the code.
	Let the compiler optimize away the "no-op" case.

	Simple example, of poor code:

	        dev = alloc_etherdev (sizeof(struct funky_private));
       	 if (!dev)
	                return -ENODEV;
	        #ifdef CONFIG_NET_FUNKINESS
	        init_funky_net(dev);
	        #endif

	Cleaned-up example:

	(in header)
	        #ifndef CONFIG_NET_FUNKINESS
	        static inline void init_funky_net (struct net_device *d) {}
	        #endif

	(in the code itself)
	        dev = alloc_etherdev (sizeof(struct funky_private));
	        if (!dev)
	                return -ENODEV;
	        init_funky_net(dev);

There is also an advantage on taking this approach: this patch can have just
the ghes changes, and will still compile fine, as CONFIG_EDAC_GHES is not
defined yet. So, the patch becomes is simpler and easier to review.

If I would do it otherwise, I would need to fold patch 5 to avoid breaking
git bisect.

Regards,
Mauro

Patch with the changes enclosed.

-

[PATCH EDACv2 03/13] ghes: add the needed hooks for EDAC error report

In order to allow reporting errors via EDAC, add hooks for:

1) register an EDAC driver;
2) unregister an EDAC driver;
3) report errors via EDAC.

As the EDAC driver will need to access the ghes structure, adds it
as one of the parameters for ghes_do_proc.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 6d0e146..19092dc 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -409,7 +409,8 @@ static void ghes_clear_estatus(struct ghes *ghes)
 	ghes->flags &= ~GHES_TO_CLEAR;
 }
 
-static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
+static void ghes_do_proc(struct ghes *ghes,
+			 const struct acpi_hest_generic_status *estatus)
 {
 	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
@@ -421,6 +422,8 @@ static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
 				 CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err;
 			mem_err = (struct cper_sec_mem_err *)(gdata+1);
+			ghes_edac_report_mem_error(ghes, sev, mem_err);
+
 #ifdef CONFIG_X86_MCE
 			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
 						  mem_err);
@@ -639,7 +642,7 @@ static int ghes_proc(struct ghes *ghes)
 		if (ghes_print_estatus(NULL, ghes->generic, ghes->estatus))
 			ghes_estatus_cache_add(ghes->generic, ghes->estatus);
 	}
-	ghes_do_proc(ghes->estatus);
+	ghes_do_proc(ghes, ghes->estatus);
 out:
 	ghes_clear_estatus(ghes);
 	return 0;
@@ -732,7 +735,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
 		len = apei_estatus_len(estatus);
 		node_len = GHES_ESTATUS_NODE_LEN(len);
-		ghes_do_proc(estatus);
+		ghes_do_proc(estatus_node->ghes, estatus);
 		if (!ghes_estatus_cached(estatus)) {
 			generic = estatus_node->generic;
 			if (ghes_print_estatus(NULL, generic, estatus))
@@ -821,6 +824,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 		estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool,
 						      node_len);
 		if (estatus_node) {
+			estatus_node->ghes = ghes;
 			estatus_node->generic = ghes->generic;
 			estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
 			memcpy(estatus, ghes->estatus, len);
@@ -899,6 +903,11 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		ghes = NULL;
 		goto err;
 	}
+
+	rc = ghes_edac_register(ghes, &ghes_dev->dev);
+	if (rc < 0)
+		goto err;
+
 	switch (generic->notify.type) {
 	case ACPI_HEST_NOTIFY_POLLED:
 		ghes->timer.function = ghes_poll_func;
@@ -911,13 +920,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		if (acpi_gsi_to_irq(generic->notify.vector, &ghes->irq)) {
 			pr_err(GHES_PFX "Failed to map GSI to IRQ for generic hardware error source: %d\n",
 			       generic->header.source_id);
-			goto err;
+			goto err2;
 		}
 		if (request_irq(ghes->irq, ghes_irq_func,
 				0, "GHES IRQ", ghes)) {
 			pr_err(GHES_PFX "Failed to register IRQ for generic hardware error source: %d\n",
 			       generic->header.source_id);
-			goto err;
+			goto err2;
 		}
 		break;
 	case ACPI_HEST_NOTIFY_SCI:
@@ -943,6 +952,8 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	platform_set_drvdata(ghes_dev, ghes);
 
 	return 0;
+err2:
+	ghes_edac_unregister(ghes);
 err:
 	if (ghes) {
 		ghes_fini(ghes);
@@ -995,6 +1006,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
 	}
 
 	ghes_fini(ghes);
+
+	ghes_edac_unregister(ghes);
+
 	kfree(ghes);
 
 	platform_set_drvdata(ghes_dev, NULL);
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 3eb8dc4..9015ec2 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -27,6 +27,7 @@ struct ghes {
 struct ghes_estatus_node {
 	struct llist_node llnode;
 	struct acpi_hest_generic *generic;
+	struct ghes *ghes;
 };
 
 struct ghes_estatus_cache {
@@ -43,3 +44,27 @@ enum {
 	GHES_SEV_RECOVERABLE = 0x2,
 	GHES_SEV_PANIC = 0x3,
 };
+
+#ifdef CONFIG_EDAC_GHES
+void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
+				struct cper_sec_mem_err *mem_err);
+
+int ghes_edac_register(struct ghes *ghes, struct device *dev);
+
+void ghes_edac_unregister(struct ghes *ghes);
+
+#else
+static inline void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
+				       struct cper_sec_mem_err *mem_err)
+{
+}
+
+static inline int ghes_edac_register(struct ghes *ghes, struct device *dev)
+{
+	return 0;
+}
+
+static inline void ghes_edac_unregister(struct ghes *ghes)
+{
+}
+#endif

