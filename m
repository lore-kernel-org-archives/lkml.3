Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab3CLJQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:16:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34745 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab3CLJQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:16:35 -0400
Date: Tue, 12 Mar 2013 10:16:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130312091630.GC5455@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-edac <linux-edac@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20121211140108.GC4303@liondog.tnic>
 <20130307095703.03d040ee@redhat.com>
 <20130307130635.GD5239@pd.tnic>
 <20130307110213.7a5a9978@redhat.com>
 <20130309154635.GA18316@pd.tnic>
 <20130311090746.199a4c06@redhat.com>
 <20130311092848.652c0d46@redhat.com>
 <20130312085855.GB5455@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130312085855.GB5455@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw,

the first one I changed to not divide by the channel_count, see below.
Now I'll go and run them to check everything's fine.

Thanks.

>From ef11e0b3e22d19f06474ced9365c69a0353f793a Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 11 Mar 2013 09:07:46 -0300
Subject: [PATCH 1/2] amd64_edac: Correct dimm sizes

We were filling the csrow size with a wrong value. 16a528ee3975 ("EDAC:
Fix csrow size reported in sysfs") tried to address the issue. It fixed
the report with the old API but not with the new one. Correct it for the
new API too.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/amd64_edac.c    | 14 +++++++++-----
 drivers/edac/edac_mc_sysfs.c | 13 +++----------
 include/linux/edac.h         |  1 -
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 910b0116c128..532de775a184 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2048,12 +2048,18 @@ static int init_csrows(struct mem_ctl_info *mci)
 		edac_dbg(1, "MC node: %d, csrow: %d\n",
 			    pvt->mc_node_id, i);
 
-		if (row_dct0)
+		if (row_dct0) {
 			nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
+			csrow->channels[0]->dimm->nr_pages = nr_pages;
+		}
 
 		/* K8 has only one DCT */
-		if (boot_cpu_data.x86 != 0xf && row_dct1)
-			nr_pages += amd64_csrow_nr_pages(pvt, 1, i);
+		if (boot_cpu_data.x86 != 0xf && row_dct1) {
+			int row_dct1_pages = amd64_csrow_nr_pages(pvt, 1, i);
+
+			csrow->channels[1]->dimm->nr_pages = row_dct1_pages;
+			nr_pages += row_dct1_pages;
+		}
 
 		mtype = amd64_determine_memory_type(pvt, i);
 
@@ -2072,9 +2078,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 			dimm = csrow->channels[j]->dimm;
 			dimm->mtype = mtype;
 			dimm->edac_mode = edac_mode;
-			dimm->nr_pages = nr_pages;
 		}
-		csrow->nr_pages = nr_pages;
 	}
 
 	return empty;
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 4f4b6137d74e..5463ed3abfec 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -180,9 +180,6 @@ static ssize_t csrow_size_show(struct device *dev,
 	int i;
 	u32 nr_pages = 0;
 
-	if (csrow->mci->csbased)
-		return sprintf(data, "%u\n", PAGES_TO_MiB(csrow->nr_pages));
-
 	for (i = 0; i < csrow->nr_channels; i++)
 		nr_pages += csrow->channels[i]->dimm->nr_pages;
 	return sprintf(data, "%u\n", PAGES_TO_MiB(nr_pages));
@@ -778,14 +775,10 @@ static ssize_t mci_size_mb_show(struct device *dev,
 	for (csrow_idx = 0; csrow_idx < mci->nr_csrows; csrow_idx++) {
 		struct csrow_info *csrow = mci->csrows[csrow_idx];
 
-		if (csrow->mci->csbased) {
-			total_pages += csrow->nr_pages;
-		} else {
-			for (j = 0; j < csrow->nr_channels; j++) {
-				struct dimm_info *dimm = csrow->channels[j]->dimm;
+		for (j = 0; j < csrow->nr_channels; j++) {
+			struct dimm_info *dimm = csrow->channels[j]->dimm;
 
-				total_pages += dimm->nr_pages;
-			}
+			total_pages += dimm->nr_pages;
 		}
 	}
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 4fd4999ccb5b..ab1ea98e767c 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -561,7 +561,6 @@ struct csrow_info {
 
 	u32 ue_count;		/* Uncorrectable Errors for this csrow */
 	u32 ce_count;		/* Correctable Errors for this csrow */
-	u32 nr_pages;		/* combined pages count of all channels */
 
 	struct mem_ctl_info *mci;	/* the parent */
 
-- 
1.8.1.3.535.ga923c31


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
