Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3LMXHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:07:05 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:61545 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3LMXHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:07:02 -0500
Date: Fri, 13 Dec 2013 16:06:57 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Betty Dall <betty.dall@hp.com>
Cc: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI AER: Handle non-AER HEST error sources in
 aer_hest_parse()
Message-ID: <20131213230657.GD6746@google.com>
References: <1386948196-9409-1-git-send-email-betty.dall@hp.com>
 <20131213221616.GC6746@google.com>
 <1386974853.10497.64.camel@ejdallLaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386974853.10497.64.camel@ejdallLaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 03:47:33PM -0700, Betty Dall wrote:
> Yes, that is more readable code. Thanks for revising it. I tested it on
> my system that has non-AER error sources and it works fine. One nit is
> that "Ignore" is misspelled in the subject line. 

Thanks, fixed.

I should have thought longer before hitting send.  I think it's worthwhile
to use the same helper in aer_hest_parse_aff(), and once I did that, it
became more obvious that aer_hest_parse() and aer_hest_parse_aff() are
essentially similar, so I wonder if it's worth consolidating them, as
below.  It doesn't reduce the number of lines of code, but maybe it's
simpler for the reader?

Bjorn

commit 8e7f8d0b30d4e3e30007b10eb2916d970b5f8c93
Author: Betty Dall <betty.dall@hp.com>
Date:   Fri Dec 13 08:23:16 2013 -0700

    PCI/AER: Ignore non-PCIe AER error sources in aer_hest_parse()
    
    aer_set_firmware_first() searches the HEST for an error source descriptor
    matching the specified PCI device.  It uses the apei_hest_parse() iterator
    to call aer_hest_parse() for every descriptor in the HEST.
    
    Previously, aer_hest_parse() incorrectly assumed every descriptor was for a
    PCIe error source.  This patch adds a check to avoid that error.
    
    [bhelgaas: factor check into helper, use in aer_hest_parse_aff(), changelog]
    Signed-off-by: Betty Dall <betty.dall@hp.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index cf611ab2193a..a23995749f1d 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -50,12 +50,24 @@ struct aer_hest_parse_info {
 	int firmware_first;
 };
 
+static int hest_source_is_pcie_aer(struct acpi_hest_header *hest_hdr)
+{
+	if (hest_hdr->type == ACPI_HEST_TYPE_AER_ROOT_PORT ||
+	    hest_hdr->type == ACPI_HEST_TYPE_AER_ENDPOINT ||
+	    hest_hdr->type == ACPI_HEST_TYPE_AER_BRIDGE)
+		return 1;
+	return 0;
+}
+
 static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
 {
 	struct aer_hest_parse_info *info = data;
 	struct acpi_hest_aer_common *p;
 	int ff;
 
+	if (!hest_source_is_pcie_aer(hest_hdr))
+		return 0;
+
 	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
 	ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
 	if (p->flags & ACPI_HEST_GLOBAL) {
@@ -104,15 +116,12 @@ static int aer_hest_parse_aff(struct acpi_hest_header *hest_hdr, void *data)
 	if (aer_firmware_first)
 		return 0;
 
-	switch (hest_hdr->type) {
-	case ACPI_HEST_TYPE_AER_ROOT_PORT:
-	case ACPI_HEST_TYPE_AER_ENDPOINT:
-	case ACPI_HEST_TYPE_AER_BRIDGE:
-		p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
-		aer_firmware_first = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
-	default:
+	if (!hest_source_is_pcie_aer(hest_hdr))
 		return 0;
-	}
+
+	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
+	aer_firmware_first = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
+	return 0;
 }
 
 /**
commit 01600a1b034f93dab6f855c81626b8030b85aec0
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Fri Dec 13 15:42:53 2013 -0700

    PCI/AER: Consolidate HEST error source parsers
    
    aer_hest_parse() and aer_hest_parse_aff() are almost identical.
    We use aer_hest_parse() to check the ACPI_HEST_FIRMWARE_FIRST flag for a
    specific device, and we use aer_hest_parse_aff() to check to see if any
    device sets the flag.
    
    This drops aer_hest_parse_aff() and enhances aer_hest_parse() so it
    collects the union of the ACPI_HEST_FIRMWARE_FIRST flag setting when no
    specific device is supplied.
    
    No functional change.
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index a23995749f1d..4d6991794fa2 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -70,6 +70,17 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
 
 	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
 	ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
+
+	/*
+	 * If no specific device is supplied, determine whether
+	 * FIRMWARE_FIRST is set for *any* PCIe device.
+	 */
+	if (!info->pci_dev) {
+		info->firmware_first |= ff;
+		return 0;
+	}
+
+	/* Otherwise, check the specific device */
 	if (p->flags & ACPI_HEST_GLOBAL) {
 		if (hest_match_type(hest_hdr, info->pci_dev))
 			info->firmware_first = ff;
@@ -109,30 +120,20 @@ int pcie_aer_get_firmware_first(struct pci_dev *dev)
 
 static bool aer_firmware_first;
 
-static int aer_hest_parse_aff(struct acpi_hest_header *hest_hdr, void *data)
-{
-	struct acpi_hest_aer_common *p;
-
-	if (aer_firmware_first)
-		return 0;
-
-	if (!hest_source_is_pcie_aer(hest_hdr))
-		return 0;
-
-	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
-	aer_firmware_first = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
-	return 0;
-}
-
 /**
  * aer_acpi_firmware_first - Check if APEI should control AER.
  */
 bool aer_acpi_firmware_first(void)
 {
 	static bool parsed = false;
+	struct aer_hest_parse_info info = {
+		.pci_dev	= NULL,	/* Check all PCIe devices */
+		.firmware_first	= 0,
+	};
 
 	if (!parsed) {
-		apei_hest_parse(aer_hest_parse_aff, NULL);
+		apei_hest_parse(aer_hest_parse, &info);
+		aer_firmware_first = info.firmware_first;
 		parsed = true;
 	}
 	return aer_firmware_first;
