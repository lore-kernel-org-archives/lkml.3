Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbaKTGpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:45:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:55000 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaKTGpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:45:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,422,1413270000"; 
   d="scan'208";a="635011264"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [RFC PATCH v4] ACPICA/Events: Add support to ensure GPE is disabled by default for handlers.
Date: Thu, 20 Nov 2014 14:44:59 +0800
Message-Id: <ce3ab540463bc5d97e527f24ca7d7d82b2952fae.1416459350.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <20141119121615.GA2514@node.dhcp.inet.fi>
References: <20141119121615.GA2514@node.dhcp.inet.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms, GPE is not disabled by default after ACPI hardware is
enabled. This confuses GPE drivers. This patch adds support to disable GPE
by default for GPE handler drivers.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
---
 drivers/acpi/acpica/evxface.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-acpica/drivers/acpi/acpica/evxface.c
===================================================================
--- linux-acpica.orig/drivers/acpi/acpica/evxface.c
+++ linux-acpica/drivers/acpi/acpica/evxface.c
@@ -821,6 +821,14 @@ acpi_install_gpe_handler(acpi_handle gpe
 	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 	gpe_event_info->flags |= (u8)(type | ACPI_GPE_DISPATCH_HANDLER);
 
+	/*
+	 * Make sure that the GPE is disabled by default for the GPE
+	 * handler driver. It is expected that the GPE handler driver
+	 * should invoke acpi_enable_gpe() after installing the GPE
+	 * handler.
+	 */
+	(void)acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_DISABLE);
+
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 
 unlock_and_exit:
