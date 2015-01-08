Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbbAHCcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:32:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:27186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbbAHCbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:31:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509087077"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [RFC Patch 14/19] ACPI: Translate resource into master side address for bridge window resources
Date: Thu,  8 Jan 2015 10:33:01 +0800
Message-Id: <1420684386-5975-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add translation_offset into the result address for bridge window
resources to form the master side address.

Currently acpi_dev_resource_{ext_}address_space() are only used for
devices instead of bridges, so it won't break current users. Later
it will be used to support PCI host bridge drivers.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index d3aa56674bd4..16d334a1ee25 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -203,6 +203,20 @@ static bool acpi_decode_space(struct resource *res, resource_size_t *offset,
 	res->start = addr->minimum;
 	res->end = addr->maximum;
 
+	/*
+	 * For bridges that translate addresses across the bridge,
+	 * translation_offset is the offset that must be added to the
+	 * address on the secondary side to obtain the address on the
+	 * primary side. Non-bridge devices must list 0 for all Address
+	 * Translation offset bits.
+	 */
+	if (base->producer_consumer == ACPI_PRODUCER) {
+		res->start += addr->translation_offset;
+		res->end += addr->translation_offset;
+	} else if (addr->translation_offset) {
+		return false;
+	}
+
 	switch(base->resource_type) {
 	case ACPI_MEMORY_RANGE:
 		acpi_dev_memresource_flags(res, len, wp);
-- 
1.7.10.4

