Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3JHQSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:18:00 -0400
Received: from xes-mad.com ([216.165.139.218]:29621 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab3JHQRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:17:46 -0400
X-Greylist: delayed 1453 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 12:17:46 EDT
Date: Tue, 08 Oct 2013 10:53:40 -0500 (CDT)
From: Aaron Sierra <asierra@xes-inc.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] powerpc/fsl-booke: Let lowmem use all CAM entries
Message-ID: <8946cc20-6c84-4ea8-bc14-0e1ed0c4d798@zimbra>
In-Reply-To: <adcc2e4b-d494-4de2-8f11-10dd73f24a3d@zimbra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.16.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch essentially changes the sense of CONFIG_LOWMEM_CAM_NUM
so that all available TLB1 CAM entries can be used for mapping lowmem
unless the user specifies a specific number through CONFIG_LOWMEM_CAM_NUM.

This greatly simplifies using CONFIG_LOWMEM_SIZE with high granularity.

Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
---
 arch/powerpc/mm/fsl_booke_mmu.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/powerpc/mm/fsl_booke_mmu.c b/arch/powerpc/mm/fsl_booke_mmu.c
index 92685d8..44378ac 100644
--- a/arch/powerpc/mm/fsl_booke_mmu.c
+++ b/arch/powerpc/mm/fsl_booke_mmu.c
@@ -178,6 +178,14 @@ unsigned long map_mem_in_cams(unsigned long ram, int max_cam_idx)
 	phys_addr_t phys = memstart_addr;
 	unsigned long amount_mapped = 0;
 
+	/*
+	 * Allow finer resolution for user defined CONFIG_LOWMEM_SIZE by
+	 * allowing all TLB1 entries to be utilized if the user doesn't define
+	 * a specific max_cam_idx value via CONFIG_LOWMEM_CAM_NUM.
+	 */
+	if (!max_cam_idx)
+		max_cam_idx = mfspr(SPRN_TLB1CFG) & 0xfff;
+
 	/* Calculate CAM values */
 	for (i = 0; ram && i < max_cam_idx; i++) {
 		unsigned long cam_sz;
@@ -222,7 +230,11 @@ void __init adjust_total_lowmem(void)
 	/* adjust lowmem size to __max_low_memory */
 	ram = min((phys_addr_t)__max_low_memory, (phys_addr_t)total_lowmem);
 
+#ifdef CONFIG_LOWMEM_CAM_NUM_BOOL
 	__max_low_memory = map_mem_in_cams(ram, CONFIG_LOWMEM_CAM_NUM);
+#else
+	__max_low_memory = map_mem_in_cams(ram, 0);
+#endif
 
 	pr_info("Memory CAM mapping: ");
 	for (i = 0; i < tlbcam_index - 1; i++)
-- 
1.7.9.5

