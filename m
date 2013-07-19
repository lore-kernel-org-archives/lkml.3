Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515Ab3GSRFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:05:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:36021 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760049Ab3GSRF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:05:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,703,1367996400"; 
   d="scan'208";a="333956846"
From: "Luck, Tony" <tony.luck@intel.com>
Date: Fri, 19 Jul 2013 09:50:15 -0700
Subject: [PATCH] mce: acpi/apei: Only disable banks listed in HEST if mce is configured
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Message-Id: <0129220@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

Randconfig testing found this error:
>> hest.c(.init.text+0x6004): undefined reference to 'mce_disable_bank'

Fix by wrapping body of hest_parse_cmc() inside #ifdef CONFIG_X86_MCE

Reported-by: "Wu, Fengguang" <fengguang.wu@intel.com>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

[Peter: Thanks for pulling Naveen's series from my ras tree. Fengguang's
 testbuild robot promtly found this build issue. Please apply this patch
 on top of the x86/mce branch. - Thanks]

 drivers/acpi/apei/hest.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index 5020245..f5e37f3 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -128,6 +128,7 @@ EXPORT_SYMBOL_GPL(apei_hest_parse);
  */
 static int __init hest_parse_cmc(struct acpi_hest_header *hest_hdr, void *data)
 {
+#ifdef CONFIG_X86_MCE
 	int i;
 	struct acpi_hest_ia_corrected *cmc;
 	struct acpi_hest_ia_error_bank *mc_bank;
@@ -152,7 +153,7 @@ static int __init hest_parse_cmc(struct acpi_hest_header *hest_hdr, void *data)
 	mc_bank = (struct acpi_hest_ia_error_bank *)(cmc + 1);
 	for (i = 0; i < cmc->num_hardware_banks; i++, mc_bank++)
 		mce_disable_bank(mc_bank->bank_number);
-
+#endif
 	return 1;
 }
 
-- 
1.8.1.4

