Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab3E3Oqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:46:44 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:44266 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196Ab3E3OqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:46:17 -0400
From: Betty Dall <betty.dall@hp.com>
To: rjw@sisk.pl, bhelgaas@google.com
Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH v2 2/3] ACPI/APEI: Force fatal AER severity when bus has been reset
Date: Thu, 30 May 2013 08:39:28 -0600
Message-Id: <1369924769-17183-3-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPER error record has a reset bit that indicates that the platform
has reset the bus. The reset bit can be set for any severity error
including recoverable.  From the AER code path's perspective,
any error is fatal if the bus has been reset. This patch upgrades the
severity of the AER recovery to AER_FATAL whenever the CPER error record
indicates that the bus has been reset.

Changes since v1:
Fixed a typo in comment.

Signed-off-by: Betty Dall <betty.dall@hp.com>
---

 drivers/acpi/apei/ghes.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)


diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index d668a8a..1c67d5a 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -451,7 +451,26 @@ static void ghes_do_proc(struct ghes *ghes,
 				int aer_severity;
 				devfn = PCI_DEVFN(pcie_err->device_id.device,
 						  pcie_err->device_id.function);
-				aer_severity = cper_severity_to_aer(sev);
+				/*
+				 * Some Firmware First implementations
+				 * put the device in SBR to contain
+				 * the error. This is indicated by the
+				 * CPER Section Descriptor Flags reset
+				 * bit which means the component must
+				 * be re-initialized or re-enabled
+				 * prior to use. Promoting the AER
+				 * serverity to FATAL will cause the
+				 * AER code to link_reset and allow
+				 * drivers to reprogram their cards.
+				 */
+				if (gdata->flags & CPER_SEC_RESET)
+					aer_severity = cper_severity_to_aer(
+							CPER_SEV_FATAL);
+				else
+					aer_severity =
+						cper_severity_to_aer(sev);
+
+
 				aer_recover_queue(pcie_err->device_id.segment,
 						  pcie_err->device_id.bus,
 						  devfn, aer_severity);
