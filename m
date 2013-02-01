Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3BAScH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:32:07 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:15261 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab3BAScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:32:03 -0500
Message-ID: <1359743519.2759.38.camel@lorien2>
Subject: Re: IO_PAGE_FAULTs on unity mapped regions during amd_iommu_init()
 in Linux 3.4
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Date: Fri, 01 Feb 2013 11:31:59 -0700
In-Reply-To: <20130201130035.GE25591@8bytes.org>
References: <1359657210.6061.3.camel@lorien2>
	 <20130201130035.GE25591@8bytes.org>
Organization: ISS-Linux
Content-Type: multipart/mixed; boundary="=-9Y90mSEDPkKGf20NaSCm"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9Y90mSEDPkKGf20NaSCm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2013-02-01 at 14:00 +0100, Joerg Roedel wrote:
> Hi Shuah,
> 
> On Thu, Jan 31, 2013 at 11:33:30AM -0700, Shuah Khan wrote:
> > Access to these ranges continues to work with no errors until AMD IOMMU
> > driver disables and re-enables IOMMU in enable_iommus(). These faults
> > don't persist and appear between the enable_iommus() call and before
> > amd_iommu_init() gets done printing "AMD-Vi: Lazy IO/TLB flushing
> > enabled" message.
> 
> Hmm, okay. I had a look into the v3.4 sources. This looks like a race
> condition. The IOMMUs are enabled in amd_iommu_init_hardware() but the
> unity-mapped regions are created later in amd_iommu_init_dma_ops(). This
> leaves a small window where the page-faults happen that you see.
> 
> But I am not sure why this doesn't hit on 3.7 and above. The race is
> still there. Anyway, definitly something that needs to be fixed.
> 

Hi Joerg,

Yes, 3.7 has the same window of opportunity for this race condition,
however I couldn't figure out why it doesn't happen on 3.7. On 3.7 the
window between amd_iommu_init_hardware() and amd_iommu_init_dma_ops()
might actually be wider than the window in 3.4.

I think understanding why it doesn't happen on 3.7 is probably key. On
3.6, I experimented with back-porting your Split device table
initialization patch (33f28c59e18d83fd2aeef258d211be66b9b80eb3) from 3.7
and the patch that moved iommu_init from subsys_initcall() to
arch_initcall() and that solved the problem on 3.6. I am attaching those
patches. I can't easily back-port either one of those to 3.4 though.

That experiment made me think that this problem has something to do with
when device_table gets initialized vs. dma_ops are initialized. However,
there is no change to when unity mapped regions are created in 3.4 and
3.7.

If you look at 3.4 initialization sequence closely, you will notice that
init_device_table() gets called before init_iommu_all() and
init_memory_definitions() get done.

Another big difference is 3.4 init_device_table() sets DEV_ENTRY_VALID,
and DEV_ENTRY_TRANSLATION bits way earlier than 3.7 and these bits get
set in init_device_table_dma() which is called much later in 3.7.

init_unity_mappings_for_device() has a strong dependency on pci
sub-system having been initialized. Is it possible to move it up closer
to amd_iommu_init_hardware()?

I have a system I can reproduce the problem easily and I have a tried
making a few changes to the initialization sequence, with no results.
Any thoughts what other changes should I be looking at to solve the
problem besides the ones I already tried.

Thanks,
-- Shuah






--=-9Y90mSEDPkKGf20NaSCm
Content-Disposition: attachment;
	filename*0=0001-iommu-amd-delay-dma-init-right-before-dma_ops-are-in.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-iommu-amd-delay-dma-init-right-before-dma_ops-are-in.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From a91c02486e5ecb332c4e63d2ec35262c573c6631 Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Fri, 21 Dec 2012 16:28:03 -0700
Subject: [PATCH] iommu/amd: delay dma init right before dma_ops are
 initialized - backport


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 drivers/iommu/amd_iommu_init.c |   45 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 18a89b7..33a9a6e 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1308,7 +1308,7 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
  * Init the device table to not allow DMA access for devices and
  * suppress all page faults
  */
-static void init_device_table(void)
+static void init_device_table_dma(void)
 {
 	u32 devid;
 
@@ -1318,6 +1318,32 @@ static void init_device_table(void)
 	}
 }
 
+/*
+Dont' need - probably
+static void __init uninit_device_table_dma(void)
+{
+	u32 devid;
+
+	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
+		amd_iommu_dev_table[devid].data[0] = 0ULL;
+		amd_iommu_dev_table[devid].data[1] = 0ULL;
+	}
+}
+*/
+
+static void init_device_table(void)
+{
+/*
+Dont' need - probably
+
+	u32 devid;
+
+	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid)
+		set_dev_entry_bit(devid, DEV_ENTRY_IRQ_TBL_EN);
+*/
+	return;
+}
+
 static void iommu_init_flags(struct amd_iommu *iommu)
 {
 	iommu->acpi_flags & IVHD_FLAG_HT_TUN_EN_MASK ?
@@ -1494,6 +1520,16 @@ static void __init free_on_init_error(void)
 #endif
 }
 
+static void __init free_dma_resources(void)
+{
+	amd_iommu_uninit_devices();
+
+	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
+		   get_order(MAX_DOMAIN_ID/8));
+
+	free_unity_maps();
+}
+
 /*
  * This is the hardware init function for AMD IOMMU in the system.
  * This function is called either from amd_iommu_init or from the interrupt
@@ -1657,8 +1693,14 @@ static bool detect_ivrs(void)
 
 static int amd_iommu_init_dma(void)
 {
+	struct amd_iommu *iommu;
 	int ret;
 
+	init_device_table_dma();
+
+	for_each_iommu(iommu)
+		iommu_flush_all_caches(iommu);
+
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
@@ -1762,6 +1804,7 @@ static int __init amd_iommu_init(void)
 
 	ret = iommu_go_to_state(IOMMU_INITIALIZED);
 	if (ret) {
+		free_dma_resources();
 		disable_iommus();
 		free_on_init_error();
 	}
-- 
1.7.9.5


--=-9Y90mSEDPkKGf20NaSCm
Content-Disposition: attachment; filename="iommu-moving-initialization-earlier.patch"
Content-Type: text/x-patch; name="iommu-moving-initialization-earlier.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ddbdaca..1065a1a 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -861,7 +861,7 @@ static int __init iommu_init(void)
 
 	return 0;
 }
-subsys_initcall(iommu_init);
+arch_initcall(iommu_init);
 
 int iommu_domain_get_attr(struct iommu_domain *domain,
 			  enum iommu_attr attr, void *data)

--=-9Y90mSEDPkKGf20NaSCm--

