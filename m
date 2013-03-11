Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3CKM3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:29:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab3CKM3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:29:04 -0400
Date: Mon, 11 Mar 2013 09:28:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130311092848.652c0d46@redhat.com>
In-Reply-To: <20130311090746.199a4c06@redhat.com>
References: <20121211140108.GC4303@liondog.tnic>
	<20130307095703.03d040ee@redhat.com>
	<20130307130635.GD5239@pd.tnic>
	<20130307110213.7a5a9978@redhat.com>
	<20130309154635.GA18316@pd.tnic>
	<20130311090746.199a4c06@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 11 Mar 2013 09:07:46 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Sat, 9 Mar 2013 16:46:35 +0100
> Borislav Petkov <bp@alien8.de> escreveu:
> 
> > On Thu, Mar 07, 2013 at 11:02:13AM -0300, Mauro Carvalho Chehab wrote:
> > > Sure. See below:
> > > 

...

> > So, actually to satisfy the new api, you'll probably need to stick down
> > this information above, i.e. the chip selects *per* DCT which equals
> > also the ranks.
> > 
> 
> Yes. Basically, we should revert this patchset:
> 	commit 16a528ee3975c860dc93fbfc718fe9aa25ed92bc
> 	Author: Borislav Petkov <borislav.petkov@amd.com>
> 	Date:   Thu Sep 13 18:53:58 2012 +0200
> 
> And fill dimm->nr_pages with:
> 
> 	dimm->nr_pages = nr_pages / pvt->channel_count;
> 
> This way, both new API and the old API will reflect the right size.
> 
> The patch below does that.

...

> [PATCH] Fix dimm size on amd64_edac
> 
...
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -180,9 +180,6 @@ static ssize_t csrow_size_show(struct device *dev,
>  	int i;
>  	u32 nr_pages = 0;
>  
> -	if (csrow->mci->csbased)
> -		return sprintf(data, "%u\n", PAGES_TO_MiB(csrow->nr_pages));
> -

With this patch, mci->csbased field got unused. So, it makes sense to
also remove it. The enclosed patch does that.

Regards,
Mauro

-

[PATCH] edac: merge mci.mem_is_per_rank with mci.csbased

Both mci.mem_is_per_rank and mci.csbased have the same meaning:
the memory controller is csrows based. Merge both fields into one.

There's no need for the driver to actually fill it, as the core
detectsi it by checking if one of the layes has the csrows type
as part of the memory hierarchy:

	if (layers[i].type == EDAC_MC_LAYER_CHIP_SELECT)
			per_rank = true;
...
	mci->csbased = per_rank;

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 074657d..06e633a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2418,7 +2418,6 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 
 	mci->pvt_info = pvt;
 	mci->pdev = &pvt->F2->dev;
-	mci->csbased = 1;
 
 	setup_mci_misc_attrs(mci, fam_type);
 
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index cdb81aa..27e86d9 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -86,7 +86,7 @@ static void edac_mc_dump_dimm(struct dimm_info *dimm, int number)
 	edac_dimm_info_location(dimm, location, sizeof(location));
 
 	edac_dbg(4, "%s%i: %smapped as virtual row %d, chan %d\n",
-		 dimm->mci->mem_is_per_rank ? "rank" : "dimm",
+		 dimm->mci->csbased ? "rank" : "dimm",
 		 number, location, dimm->csrow, dimm->cschannel);
 	edac_dbg(4, "  dimm = %p\n", dimm);
 	edac_dbg(4, "  dimm->label = '%s'\n", dimm->label);
@@ -341,7 +341,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	memcpy(mci->layers, layers, sizeof(*layer) * n_layers);
 	mci->nr_csrows = tot_csrows;
 	mci->num_cschannel = tot_channels;
-	mci->mem_is_per_rank = per_rank;
+	mci->csbased = per_rank;
 
 	/*
 	 * Alocate and fill the csrow/channels structs
@@ -1235,7 +1235,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			 * incrementing the compat API counters
 			 */
 			edac_dbg(4, "%s csrows map: (%d,%d)\n",
-				 mci->mem_is_per_rank ? "rank" : "dimm",
+				 mci->csbased ? "rank" : "dimm",
 				 dimm->csrow, dimm->cschannel);
 			if (row == -1)
 				row = dimm->csrow;
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 5463ed3..6ab4a50 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -609,7 +609,7 @@ static int edac_create_dimm_object(struct mem_ctl_info *mci,
 	device_initialize(&dimm->dev);
 
 	dimm->dev.parent = &mci->dev;
-	if (mci->mem_is_per_rank)
+	if (mci->csbased)
 		dev_set_name(&dimm->dev, "rank%d", index);
 	else
 		dev_set_name(&dimm->dev, "dimm%d", index);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index ab1ea98..7f5d8d6 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -675,11 +675,11 @@ struct mem_ctl_info {
 	 * sees memory sticks ("dimms"), and the ones that sees memory ranks.
 	 * All old memory controllers enumerate memories per rank, but most
 	 * of the recent drivers enumerate memories per DIMM, instead.
-	 * When the memory controller is per rank, mem_is_per_rank is true.
+	 * When the memory controller is per rank, csbased is true.
 	 */
 	unsigned n_layers;
 	struct edac_mc_layer *layers;
-	bool mem_is_per_rank;
+	bool csbased;
 
 	/*
 	 * DIMM info. Will eventually remove the entire csrows_info some day
@@ -740,7 +740,6 @@ struct mem_ctl_info {
 	u32 fake_inject_ue;
 	u16 fake_inject_count;
 #endif
-	__u8 csbased : 1,	/* csrow-based memory controller */
 	     __resv  : 7;
 };
 

