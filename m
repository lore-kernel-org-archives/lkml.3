Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbaBKUdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:33:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbaBKTGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>, Chris Ball <chris@printf.net>
Subject: [PATCH 3.13 119/120] mmc: sdhci-pci: Fix BYT sd card getting stuck in runtime suspend
Date: Tue, 11 Feb 2014 11:06:00 -0800
Message-Id: <20140211184827.039243725@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -65,6 +65,7 @@ struct sdhci_pci_fixes {
 	unsigned int		quirks;
 	unsigned int		quirks2;
 	bool			allow_runtime_pm;
+	bool			own_cd_for_runtime_pm;
 
 	int			(*probe) (struct sdhci_pci_chip *);
 
@@ -296,6 +297,7 @@ static const struct sdhci_pci_fixes sdhc
 static const struct sdhci_pci_fixes sdhci_intel_mfd_sd = {
 	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC,
 	.allow_runtime_pm = true,
+	.own_cd_for_runtime_pm = true,
 };
 
 static const struct sdhci_pci_fixes sdhci_intel_mfd_sdio = {
@@ -360,6 +362,7 @@ static const struct sdhci_pci_fixes sdhc
 static const struct sdhci_pci_fixes sdhci_intel_byt_sd = {
 	.quirks2	= SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON,
 	.allow_runtime_pm = true,
+	.own_cd_for_runtime_pm = true,
 };
 
 /* Define Host controllers for Intel Merrifield platform */
@@ -1458,6 +1461,14 @@ static struct sdhci_pci_slot *sdhci_pci_
 
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


