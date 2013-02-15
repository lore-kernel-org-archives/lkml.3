Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab3BOReF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:34:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab3BOReC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:34:02 -0500
Date: Fri, 15 Feb 2013 15:33:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 13/13] ghes_edac: Improve driver's printk messages
Message-ID: <20130215153354.2779cf4b@redhat.com>
In-Reply-To: <1360946297.2089.6.camel@joe-AO722>
References: <cover.1360931635.git.mchehab@redhat.com>
	<30bb26a76d98f876648020517cd38a4884626f44.1360931635.git.mchehab@redhat.com>
	<1360946297.2089.6.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 15 Feb 2013 08:38:17 -0800
Joe Perches <joe@perches.com> escreveu:

> On Fri, 2013-02-15 at 10:45 -0200, Mauro Carvalho Chehab wrote:
> > Provide a better infrastructure for printk's inside the driver:
> > 	- use edac_dbg() for debug messages;
> > 	- standardize the usage of pr_info();
> > 	- provide warning about the risk of relying on this
> > 	  driver.
> []
> > diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
> []
> > @@ -80,7 +80,8 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
> >  						       dimm_fill->count, 0, 0);
> >  
> >  		if (entry->size == 0xffff) {
> > -			pr_info(GHES_PFX "Can't get dimm size\n");
> > +			pr_info(GHES_PFX "Can't get DIMM%i size\n",
> > +				dimm_fill->count);
> 
> Perhaps these should use
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> and remove GHEX_PFX from all the pr_<level>()'s?

Yeah, sure.

Regards,
Mauro

-

[PATCH] ghes_edac: remove GHES_PFX macro

As suggested by Joe:

On Fri, 15 Feb 2013 08:38:17 -0800
Joe Perches <joe@perches.com> wrote:

	Perhaps these should use
	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
	and remove GHES_PFX from all the pr_<level>()'s?

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 782ed74..9fe787b 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -1,14 +1,16 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <acpi/ghes.h>
 #include <linux/edac.h>
 #include <linux/dmi.h>
 #include "edac_core.h"
 
-#define GHES_PFX   "ghes_edac: "
 #define GHES_EDAC_REVISION " Ver: 1.0.0"
 
 static DEFINE_MUTEX(ghes_edac_lock);
 static int ghes_edac_mc_num;
 
+
 /* Memory Device - Type 17 of SMBIOS spec */
 struct memdev_dmi_entry {
 	u8 type;
@@ -80,7 +82,7 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 						       dimm_fill->count, 0, 0);
 
 		if (entry->size == 0xffff) {
-			pr_info(GHES_PFX "Can't get DIMM%i size\n",
+			pr_info("Can't get DIMM%i size\n",
 				dimm_fill->count);
 			dimm->nr_pages = MiB_TO_PAGES(32);/* Unknown */
 		} else if (entry->size == 0x7fff) {
@@ -232,7 +234,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	mutex_lock(&ghes_edac_lock);
 	mci = edac_mc_alloc(ghes_edac_mc_num, ARRAY_SIZE(layers), layers, 0);
 	if (!mci) {
-		pr_info(GHES_PFX "Can't allocate memory for EDAC data\n");
+		pr_info("Can't allocate memory for EDAC data\n");
 		mutex_unlock(&ghes_edac_lock);
 		return -ENOMEM;
 	}
@@ -250,17 +252,17 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 
 	if (!ghes_edac_mc_num) {
 		if (!fake) {
-			pr_info(GHES_PFX "This EDAC driver relies on BIOS to enumerate memory and get error reports.\n");
-			pr_info(GHES_PFX "Unfortunately, not all BIOSes reflect the memory layout correctly.\n");
-			pr_info(GHES_PFX "So, the end result of using this driver varies from vendor to vendor.\n");
-			pr_info(GHES_PFX "If you find incorrect reports, please contact your hardware vendor\n");
-			pr_info(GHES_PFX "to correct its BIOS.\n");
-			pr_info(GHES_PFX "This system has %d DIMM sockets.\n",
+			pr_info("This EDAC driver relies on BIOS to enumerate memory and get error reports.\n");
+			pr_info("Unfortunately, not all BIOSes reflect the memory layout correctly.\n");
+			pr_info("So, the end result of using this driver varies from vendor to vendor.\n");
+			pr_info("If you find incorrect reports, please contact your hardware vendor\n");
+			pr_info("to correct its BIOS.\n");
+			pr_info("This system has %d DIMM sockets.\n",
 				num_dimm);
 		} else {
-			pr_info(GHES_PFX "This system has a very crappy BIOS: It doesn't even list the DIMMS.\n");
-			pr_info(GHES_PFX "Its SMBIOS info is wrong. It is doubtful that the error report would\n");
-			pr_info(GHES_PFX "work on such system. Use this driver with caution\n");
+			pr_info("This system has a very crappy BIOS: It doesn't even list the DIMMS.\n");
+			pr_info("Its SMBIOS info is wrong. It is doubtful that the error report would\n");
+			pr_info("work on such system. Use this driver with caution\n");
 		}
 	}
 
@@ -291,7 +293,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 
 	rc = edac_mc_add_mc(mci);
 	if (rc < 0) {
-		pr_info(GHES_PFX "Can't register at EDAC core\n");
+		pr_info("Can't register at EDAC core\n");
 		edac_mc_free(mci);
 		mutex_unlock(&ghes_edac_lock);
 		return -ENODEV;

