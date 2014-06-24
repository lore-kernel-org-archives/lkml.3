Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaFXRRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:17:20 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:29927
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755261AbaFXRRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:17:18 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alex.williamson@redhat.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 1/3] iommu/fsl: Fix PAMU window size check. 
Date: Tue, 24 Jun 2014 19:27:15 +0530
Message-ID: <1403618237-26248-2-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(104016002)(93916002)(19580395003)(84676001)(2201001)(44976005)(77156001)(99396002)(6806004)(20776003)(92726001)(68736004)(105606002)(81542001)(575784001)(106466001)(48376002)(83322001)(83072002)(19580405001)(80022001)(81342001)(36756003)(46102001)(4396001)(47776003)(89996001)(97736001)(87936001)(76482001)(104166001)(102836001)(85852003)(86362001)(79102001)(76176999)(21056001)(88136002)(50226001)(50986999)(31966008)(74502001)(85306003)(77982001)(87286001)(95666004)(26826002)(62966002)(74662001)(50466002)(92566001)(64706001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB468;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02524402D6
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Varun.Sethi@freescale.com; 
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_power_of_2 requires an unsigned long parameter which would
lead to truncation of 64 bit values on 32 bit architectures.

__ffs also expects an unsigned long parameter thus won't work
for 64 bit values on 32 bit architectures.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 drivers/iommu/fsl_pamu.c        |    8 ++++----
 drivers/iommu/fsl_pamu_domain.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index b99dd88..bb446d7 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -170,10 +170,10 @@ int pamu_disable_liodn(int liodn)
 static unsigned int map_addrspace_size_to_wse(phys_addr_t addrspace_size)
 {
 	/* Bug if not a power of 2 */
-	BUG_ON(!is_power_of_2(addrspace_size));
+	BUG_ON((addrspace_size & (addrspace_size - 1)));
 
 	/* window size is 2^(WSE+1) bytes */
-	return __ffs(addrspace_size) - 1;
+	return fls64(addrspace_size) - 2;
 }
 
 /* Derive the PAACE window count encoding for the subwindow count */
@@ -351,7 +351,7 @@ int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t win_size,
 	struct paace *ppaace;
 	unsigned long fspi;
 
-	if (!is_power_of_2(win_size) || win_size < PAMU_PAGE_SIZE) {
+	if ((win_size & (win_size - 1)) || win_size < PAMU_PAGE_SIZE) {
 		pr_debug("window size too small or not a power of two %llx\n", win_size);
 		return -EINVAL;
 	}
@@ -464,7 +464,7 @@ int pamu_config_spaace(int liodn, u32 subwin_cnt, u32 subwin,
 		return -ENOENT;
 	}
 
-	if (!is_power_of_2(subwin_size) || subwin_size < PAMU_PAGE_SIZE) {
+	if ((subwin_size & (subwin_size - 1)) || subwin_size < PAMU_PAGE_SIZE) {
 		pr_debug("subwindow size out of range, or not a power of 2\n");
 		return -EINVAL;
 	}
diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 93072ba..3dd0b8e 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -301,7 +301,7 @@ static int check_size(u64 size, dma_addr_t iova)
 	 * Size must be a power of two and at least be equal
 	 * to PAMU page size.
 	 */
-	if (!is_power_of_2(size) || size < PAMU_PAGE_SIZE) {
+	if ((size & (size - 1)) || size < PAMU_PAGE_SIZE) {
 		pr_debug("%s: size too small or not a power of two\n", __func__);
 		return -EINVAL;
 	}
-- 
1.7.9.5

