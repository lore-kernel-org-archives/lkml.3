Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbbA1Ubc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:31:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:30215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777AbbA1Ub1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:31:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677268982"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [Patch v2 12/22] ACPI: Enforce stricter checks for address space descriptors
Date: Wed, 28 Jan 2015 18:57:30 +0800
Message-Id: <1422442660-455-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enforce stricter checks for address space descriptors according to
ACPI spec.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 5bf73a9f26d9..57891a621b96 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -192,6 +192,15 @@ static bool acpi_decode_space(struct resource *res,
 	bool wp = addr->info.mem.write_protect;
 	u64 len = attr->address_length;
 
+	/*
+	 * Filter out invalid descriptor according to ACPI Spec 5.0, section
+	 * 6.4.3.5 Address Space Resource Descriptors.
+	 */
+	if ((addr->min_address_fixed != addr->max_address_fixed && len) ||
+	    (addr->min_address_fixed && addr->max_address_fixed && !len))
+		pr_debug("ACPI: Invalid address space min_addr_fix %d, max_addr_fix %d, len %llx\n",
+			 addr->min_address_fixed, addr->max_address_fixed, len);
+
 	res->start = attr->minimum;
 	res->end = attr->maximum;
 
-- 
1.7.10.4

