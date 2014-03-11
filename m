Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaCKWUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:20:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52144 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbaCKWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:20:14 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@rjwysocki.net,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 2/3] ACPI: Don't call PCI OSC on Apple hardware when claiming to be Darwin
Date: Tue, 11 Mar 2014 18:20:01 -0400
Message-Id: <1394576402-2910-3-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394576402-2910-1-git-send-email-matthew.garrett@nebula.com>
References: <1394576402-2910-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Apple PCI _OSC method has the following code:

if (LEqual (0x01, OSDW ()))
  if (LAnd (LEqual (Arg0, GUID), NEXP)
    (do stuff)
  else
    (fail)

NEXP is a value in high memory and is presumably under the control of the
firmware. No methods set it. The methods that are called in the "do stuff"
path are dummies. Unless there's some additional firmware call in early boot,
there's no way for this call to succeed - and even if it does, it doesn't do
anything.

The easiest way to handle this is simply to ignore it. We know which flags
would be set, so just set them by hand if the platform is running in Darwin
mode.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/acpi/pci_root.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index c1c4102..8d3178c 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -432,6 +432,17 @@ static void negotiate_os_control(struct acpi_pci_root *root, int *no_aspm,
 	acpi_handle handle = device->handle;
 
 	/*
+	 * Apple always return failure on _OSC calls when _OSI("Darwin") has
+	 * been called successfully. We know the feature set supported by the
+	 * platform, so avoid calling _OSC at all
+	 */
+
+	if (acpi_gbl_osi_data == ACPI_OSI_DARWIN) {
+		root->osc_control_set = ~OSC_PCI_EXPRESS_PME_CONTROL;
+		return;
+	}
+
+	/*
 	 * All supported architectures that use ACPI have support for
 	 * PCI domains, so we indicate this in _OSC support capabilities.
 	 */
-- 
1.8.5.3

