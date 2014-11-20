Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbaKTCT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 21:19:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:3580 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbaKTCT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 21:19:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,421,1413270000"; 
   d="scan'208";a="640128337"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 1/2] ACPICA: Events: Remove duplicated sanity check in acpi_ev_enable_gpe().
Date: Thu, 20 Nov 2014 10:19:49 +0800
Message-Id: <434e1c81cce083f6a2d56e5cba3aba762f254449.1416449853.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <20141119121615.GA2514@node.dhcp.inet.fi>
References: <20141119121615.GA2514@node.dhcp.inet.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deletes a sanity check from acpi_ev_enable_gpe().

This kind of check is already done in
acpi_enable_gpe()/acpi_remove_gpe_handler()/acpi_update_all_gpes() before invoking
acpi_ev_enable_gpe():
1. acpi_enable_gpe(): same check (skip if DISPATCH_NONE) is now implemented.
2. acpi_remove_gpe_handler(): a more strict check (skip if !DISPATCH_HANDLER)
                           is implemented.
3. acpi_update_all_gpes(): a more strict check (skip if DISPATCH_NONE ||
                        DISPATCH_HANDLER || CAN_WAKE)
4. acpi_set_gpe(): since it is invoked by the OSPM driver where the GPE
                 handler is known to be available, such check isn't needed.
So we can simply remove this duplicated check from acpi_ev_enable_gpe().
Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpica/evgpe.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 2095dfb..9d1771d7 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -114,17 +114,6 @@ acpi_status acpi_ev_enable_gpe(struct acpi_gpe_event_info *gpe_event_info)
 
 	ACPI_FUNCTION_TRACE(ev_enable_gpe);
 
-	/*
-	 * We will only allow a GPE to be enabled if it has either an associated
-	 * method (_Lxx/_Exx) or a handler, or is using the implicit notify
-	 * feature. Otherwise, the GPE will be immediately disabled by
-	 * acpi_ev_gpe_dispatch the first time it fires.
-	 */
-	if ((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
-	    ACPI_GPE_DISPATCH_NONE) {
-		return_ACPI_STATUS(AE_NO_HANDLER);
-	}
-
 	/* Clear the GPE (of stale events) */
 
 	status = acpi_hw_clear_gpe(gpe_event_info);
-- 
1.7.10

