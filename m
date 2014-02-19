Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaBSExJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 23:53:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:46840 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaBSExH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 23:53:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,503,1389772800"; 
   d="scan'208";a="477459703"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        David Airlie <airlied@linux.ie>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Emil Velikov <emil.l.velikov@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nouveau, ACPI: fix regression caused by b072e53
Date: Wed, 19 Feb 2014 12:53:43 +0800
Message-Id: <1392785628-30633-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms, ACPI _DSM method (nouveau_op_dsm_muid, function 0)
has special requirements on the fourth parameter, which is different
from ACPI specifications. So revert to the private implementation
to check availability of _DSM functions instead of using common
acpi_check_dsm() interface.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Maarten,
	Thanks for bisecting. Could you please help to verify whether
this patch fixes the regression?

Thanks!
Gerry
---
 drivers/gpu/drm/nouveau/nouveau_acpi.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 4ef83df..c6c7d0d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -106,6 +106,29 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
 	return 0;
 }
 
+/*
+ * On some platforms, _DSM(nouveau_op_dsm_muid, func0) has special
+ * requirements on the fourth parameter, so a private implementation
+ * instead of using acpi_check_dsm().
+ */
+static int nouveau_check_optimus_dsm(acpi_handle handle)
+{
+	int result;
+
+	/*
+	 * Function 0 returns a Buffer containing available functions.
+	 * The args parameter is ignored for function 0, so just put 0 in it
+	 */
+	if (nouveau_optimus_dsm(handle, 0, 0, &result)
+		return 0;
+
+	/*
+	 * ACPI Spec v4 9.14.1: if bit 0 is zero, no function is supported.
+	 * If the n-th bit is enabled, function n is supported
+	 */
+	return result & 1 && result & (1 << NOUVEAU_DSM_OPTIMUS_CAPS);
+}
+
 static int nouveau_dsm(acpi_handle handle, int func, int arg)
 {
 	int ret = 0;
@@ -207,8 +230,7 @@ static int nouveau_dsm_pci_probe(struct pci_dev *pdev)
 			   1 << NOUVEAU_DSM_POWER))
 		retval |= NOUVEAU_DSM_HAS_MUX;
 
-	if (acpi_check_dsm(dhandle, nouveau_op_dsm_muid, 0x00000100,
-			   1 << NOUVEAU_DSM_OPTIMUS_CAPS))
+	if (nouveau_check_optimus_dsm(dhandle))
 		retval |= NOUVEAU_DSM_HAS_OPT;
 
 	if (retval & NOUVEAU_DSM_HAS_OPT) {
-- 
1.7.10.4

