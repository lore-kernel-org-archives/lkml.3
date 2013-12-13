Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3LMPco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:32:44 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:8643 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3LMPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:32:42 -0500
From: Betty Dall <betty.dall@hp.com>
To: lenb@kernel.org, rjw@rjwysocki.net, bhelgaas@google.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Betty Dall <betty.dall@hp.com>
Subject: [PATCH] PCI AER: Handle non-AER HEST error sources in aer_hest_parse()
Date: Fri, 13 Dec 2013 08:23:16 -0700
Message-Id: <1386948196-9409-1-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aer_hest_parse() could pass a non-AER HEST error source to the function
hest_match_pci(). hest_match_pci() assumes that the HEST error source is
type ACPI_HEST_TYPE_AER_ROOT_PORT, ACPI_HEST_TYPE_AER_ENDPOINT, or
ACPI_HEST_TYPE_AER_BRIDGE. I have a platform that has some
ACPI_HEST_TYPE_GENERIC error sources where hest_match_pci() was trying to
access the structure as if it had the acpi_hest_aer_common fields.

aer_hest_parse() is only ever interested in the AER type HEST error
sources. Add a check on the type of the error souce at the beginning of
aer_hest_parse().

Signed-off-by: Betty Dall <betty.dall@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_acpi.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index cf611ab..39186e3 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -56,6 +56,10 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
 	struct acpi_hest_aer_common *p;
 	int ff;
 
+	if (hest_hdr->type != ACPI_HEST_TYPE_AER_ROOT_PORT &&
+		hest_hdr->type != ACPI_HEST_TYPE_AER_ENDPOINT &&
+		hest_hdr->type != ACPI_HEST_TYPE_AER_BRIDGE)
+		return 0;
 	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
 	ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
 	if (p->flags & ACPI_HEST_GLOBAL) {
