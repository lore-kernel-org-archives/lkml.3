Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbaGODH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:07:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:8693 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757741AbaGODHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:07:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="561821073"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 5/9] ACPICA: Events: Fix an issue that acpi_set_gpe() cannot unconditionally enable GPEs.
Date: Tue, 15 Jul 2014 11:07:44 +0800
Message-Id: <da0798d9e4f2c963ff9337655b58d0daa4b25ef1.1405306438.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405306438.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405306438.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds unconditional GPE enabling support into acpi_set_gpe().

Originally this function checks if the GPE has been enabled with handlers
and performs acknowledging before enabling it.

First, IRQ enabling/disabling has 2 use cases:
1. When upper layers (the users of the driver) submit requests to the
   drivers, it means they care about the underlying hardware. For this
   case, acpi_enable_gpe() should be invoked. When the reference count is
   increased from 0 to 1, driver enables the hardware IRQ. And
   acpi_disable_gpe() is used as the reversal when the users have completed
   the submitted requests.
2. Driver may temporarily disables the IRQ and wants to re-enable it later,
   this case is normally used in order to prevent IRQ storm. When a driver
   cannot fully solve the condition that triggered the IRQ in the IRQ
   context, in order not to trigger IRQ storm, driver has to disable IRQ
   and re-enables it in the defered execution environment - which should be
   in a task context. This API should be used exactly for this purpose.

Second, since the acpi_set_gpe() should be invoked from an IRQ handler, the
handler check is useless for this API.

Third, given the fact that drivers should complete all outstanding requests
before putting themselves into the sleep states, as this API is executed for
outstanding requests, it should also have nothing to do with the
"RUN"/"WAKE" distinguishing. That's why the acpi_set_gpe(ACPI_GPE_ENABLE)
should not be implemented by acpi_hw_low_set_gpe(ACPI_GPE_CONDITIONAL_ENABLE).

Fourth, GPE clearing is used to acknowledge the GPE. The combination of
acknowledging and enabling may not be expected by the hardware drivers. For
GPE clearing, we have a seperate API acpi_clear_gpe(). There are cases
drivers do want the 2 operations to be split. For example, a high IO
throughput IRQ requires the IRQ to be cleared in the IRQ context. In order
to avoid GPE storm, same driver need to invoke IRQ re-enabling in the task
context. So splitting these 2 operations could facilitates drivers the
maximum possibilities to achieve success. For a combined one, we already
have acpi_finish_gpe() ready to be invoked.

This patch converts acpi_set_gpe(ACPI_GPE_ENABLE) into
acpi_hw_low_set_gpe(ACPI_GPE_ENABLE) to achieve a seperate GPE enabling API.
Drivers are encouraged to use this API when they need to handle the above
mentioned cases. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/evxfgpe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index d66d50b..6c53633 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -218,7 +218,7 @@ acpi_status acpi_set_gpe(acpi_handle gpe_device, u32 gpe_number, u8 action)
 	switch (action) {
 	case ACPI_GPE_ENABLE:
 
-		status = acpi_ev_enable_gpe(gpe_event_info);
+		status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_ENABLE);
 		break;
 
 	case ACPI_GPE_DISABLE:
-- 
1.7.10

