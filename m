Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbaBGLvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42120 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaBGLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adrian Hunter <adrian.hunter@intel.com>, Chris Ball <chris@printf.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 148/233] mmc: sdhci-pci: Fix BYT sd card getting stuck in runtime suspend
Date: Fri,  7 Feb 2014 11:46:07 +0000
Message-Id: <1391773652-25214-149-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 77a0122e0838663795651aa0beb2325156f98c09 upstream.

A host controller for a SD card may need a GPIO for card detect in order
to wake up from runtime suspend when a card is inserted.  If that GPIO is
not configured, then the host controller will not wake up.  Fix that for
the affected devices by not enabling runtime PM unless the GPIO is
successfully set up.

This affects BYT sd card host controller which had runtime PM enabled from
v3.11.  For completeness, the MFD sd card host controller is flagged also.

The original patch before rebasing (see link below) was tested on v3.11.10
and v3.12.4 although the patch applied with some offsets and fuzz.  The
original patch is here:

    http://marc.info/?l=linux-mmc&m=138676702327057

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Chris Ball <chris@printf.net>
[ luis: backported to 3.11:
  - struct sdhci_pci_fixes is defined in sdhci-pci.c, not in sdhci-pci.h ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/sdhci-pci.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index d7d6bc8..33593e7 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -59,6 +59,7 @@ struct sdhci_pci_fixes {
 	unsigned int		quirks;
 	unsigned int		quirks2;
 	bool			allow_runtime_pm;
+	bool			own_cd_for_runtime_pm;
 
 	int			(*probe) (struct sdhci_pci_chip *);
 
@@ -290,6 +291,7 @@ static const struct sdhci_pci_fixes sdhci_intel_mrst_hc1_hc2 = {
 static const struct sdhci_pci_fixes sdhci_intel_mfd_sd = {
 	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC,
 	.allow_runtime_pm = true,
+	.own_cd_for_runtime_pm = true,
 };
 
 static const struct sdhci_pci_fixes sdhci_intel_mfd_sdio = {
@@ -354,6 +356,7 @@ static const struct sdhci_pci_fixes sdhci_intel_byt_sdio = {
 static const struct sdhci_pci_fixes sdhci_intel_byt_sd = {
 	.quirks2	= SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON,
 	.allow_runtime_pm = true,
+	.own_cd_for_runtime_pm = true,
 };
 
 /* O2Micro extra registers */
@@ -1381,6 +1384,14 @@ static struct sdhci_pci_slot *sdhci_pci_probe_slot(
 
 	sdhci_pci_add_own_cd(slot);
 
+	/*
+	 * Check if the chip needs a separate GPIO for card detect to wake up
+	 * from runtime suspend.  If it is not there, don't allow runtime PM.
+	 * Note sdhci_pci_add_own_cd() sets slot->cd_gpio to -EINVAL on failure.
+	 */
+	if (chip->fixes->own_cd_for_runtime_pm && !gpio_is_valid(slot->cd_gpio))
+		chip->allow_runtime_pm = false;
+
 	return slot;
 
 remove:
-- 
1.8.3.2

