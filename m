Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbaGODHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:07:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:36975 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699AbaGODHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:07:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="569859763"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 3/9] ACPICA: Events: Fix an issue that GPE APIs cannot be invoked in deferred handlers.
Date: Tue, 15 Jul 2014 11:07:32 +0800
Message-Id: <80efac4faa51e1f075a214637f70cfffb2c2e5ae.1405306438.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405306438.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405306438.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi_os_wait_events_complete() is used for flushing the deferred executed
handlers, invoking it for GPE interrupt handlers doesn't help to protect
GPE handler callback.  On the contrary, it prevents GPE APIs from being
invoked in the deferred notify handlers.

Actually, the GPE interrupt handlers' invocation is protected by the
previous implemented reference counting mechanism.

This patch fixes this GPE APIs invocation issue in a seperate commit other
than the reference counting one, so that if any regressions are reported,
this patch can be temporarily reverted before the regressions are root
caused. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/evxface.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index a538b03..fc075a5 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -919,10 +919,6 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 
-	/* Make sure all deferred GPE tasks are completed */
-
-	acpi_os_wait_events_complete();
-
 	/* Now we can free the handler object */
 
 	ACPI_FREE(handler);
-- 
1.7.10

