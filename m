Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3BVJYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:24:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab3BVJX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:23:57 -0500
Date: Fri, 22 Feb 2013 05:50:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 03/13] ghes: add the needed hooks for EDAC error
 report
Message-ID: <20130222055021.12125c03@redhat.com>
In-Reply-To: <1361493911.7093.37.camel@yhuang-dev>
References: <cover.1360931635.git.mchehab@redhat.com>
	<a6aaff7d219b878ca655fde3757ecd0170caec2c.1360931635.git.mchehab@redhat.com>
	<1361409967.7093.20.camel@yhuang-dev>
	<20130221090428.3b36b1ea@redhat.com>
	<1361493911.7093.37.camel@yhuang-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 22 Feb 2013 08:45:11 +0800
Huang Ying <ying.huang@intel.com> escreveu:

> On Thu, 2013-02-21 at 09:04 -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 21 Feb 2013 09:26:07 +0800
> > Huang Ying <ying.huang@intel.com> escreveu:
> > 

> > There is also an advantage on taking this approach: this patch can have just
> > the ghes changes, and will still compile fine, as CONFIG_EDAC_GHES is not
> > defined yet. So, the patch becomes is simpler and easier to review.
> 
> Thanks for your explanation.  I agree to keep this in header file.
> 
> My original suggestion is that it may be better to move this from ghes.h
> to some place like "ghes_edac.h", because these functions are
> implemented in "ghes_edac.c" instead of ghes.c.
> 

Ah! Well, I considered a separate header when writing this patch, but adding 
another header for just 3 functions where the parameters are more related to
ghes than with ghes_edac seemed overkill to me.

IMO, a single comment at the header pointing to ghes_edac.c would improve it.

> >  	switch (generic->notify.type) {
> >  	case ACPI_HEST_NOTIFY_POLLED:
> >  		ghes->timer.function = ghes_poll_func;
> > @@ -911,13 +920,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
> >  		if (acpi_gsi_to_irq(generic->notify.vector, &ghes->irq)) {
> >  			pr_err(GHES_PFX "Failed to map GSI to IRQ for generic hardware error source: %d\n",
> >  			       generic->header.source_id);
> > -			goto err;
> > +			goto err2;
> >  		}
> >  		if (request_irq(ghes->irq, ghes_irq_func,
> >  				0, "GHES IRQ", ghes)) {
> >  			pr_err(GHES_PFX "Failed to register IRQ for generic hardware error source: %d\n",
> >  			       generic->header.source_id);
> > -			goto err;
> > +			goto err2;
> >  		}
> >  		break;
> >  	case ACPI_HEST_NOTIFY_SCI:
> > @@ -943,6 +952,8 @@ static int ghes_probe(struct platform_device *ghes_dev)
> >  	platform_set_drvdata(ghes_dev, ghes);
> >  
> >  	return 0;
> > +err2:
> 
> Suggest to rename it to err_edac_unreg or something like that.  Just a
> suggestion.

Done.

I'm folding the enclosed patch on it.

Thanks for review!

Regards,
Mauro

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 19092dc..d668a8a 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -920,13 +920,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		if (acpi_gsi_to_irq(generic->notify.vector, &ghes->irq)) {
 			pr_err(GHES_PFX "Failed to map GSI to IRQ for generic hardware error source: %d\n",
 			       generic->header.source_id);
-			goto err2;
+			goto err_edac_unreg;
 		}
 		if (request_irq(ghes->irq, ghes_irq_func,
 				0, "GHES IRQ", ghes)) {
 			pr_err(GHES_PFX "Failed to register IRQ for generic hardware error source: %d\n",
 			       generic->header.source_id);
-			goto err2;
+			goto err_edac_unreg;
 		}
 		break;
 	case ACPI_HEST_NOTIFY_SCI:
@@ -952,7 +952,7 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	platform_set_drvdata(ghes_dev, ghes);
 
 	return 0;
-err2:
+err_edac_unreg:
 	ghes_edac_unregister(ghes);
 err:
 	if (ghes) {
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 9015ec2..d11d952 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -45,6 +45,8 @@ enum {
 	GHES_SEV_PANIC = 0x3,
 };
 
+/* From drivers/edac/ghes_acpi.h */
+
 #ifdef CONFIG_EDAC_GHES
 void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 				struct cper_sec_mem_err *mem_err);



-- 

Cheers,
Mauro
