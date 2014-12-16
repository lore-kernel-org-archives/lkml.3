Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaLPQRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:17:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:2905 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaLPQRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:17:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,587,1413270000"; 
   d="scan'208";a="624666085"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linus.walleij@linaro.org, lee.jones@linaro.org, rjw@rjwysocki.net
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, heikki.krogerus@intel.com,
        mika.westerberg@linux.intel.com, linux-acpi@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH 1/4] ACPICA: take ACPI_MTX_INTERPRETER in acpi_unload_table_id
Date: Tue, 16 Dec 2014 18:12:30 +0200
Message-Id: <1418746353-3481-2-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com>
References: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_tb_delete_namespace_by_owner expects ACPI_MTX_INTERPRETER to be
taken. This fixes the following issue:

ACPI Error: Mutex [0x0] is not acquired, cannot release (20141107/utmutex-322)
Call Trace:
  [<ffffffff81b0bd28>] dump_stack+0x4f/0x7b
  [<ffffffff81546bfc>] acpi_ut_release_mutex+0x47/0x67
  [<ffffffff81542cf1>] acpi_tb_delete_namespace_by_owner+0x57/0x8d
  [<ffffffff81543ef1>] acpi_unload_table_id+0x3a/0x5e

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/acpi/acpica/tbxface.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index 6482b0d..9520ae1 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -281,6 +281,11 @@ acpi_status acpi_unload_table_id(acpi_owner_id id)
 
 	ACPI_FUNCTION_TRACE(acpi_unload_table_id);
 
+	status = acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
 	/* Find table in the global table list */
 	for (i = 0; i < acpi_gbl_root_table_list.current_table_count; ++i) {
 		if (id != acpi_gbl_root_table_list.tables[i].owner_id) {
@@ -297,6 +302,8 @@ acpi_status acpi_unload_table_id(acpi_owner_id id)
 		acpi_tb_set_table_loaded_flag(i, FALSE);
 		break;
 	}
+
+	(void)acpi_ut_release_mutex(ACPI_MTX_INTERPRETER);
 	return_ACPI_STATUS(status);
 }
 
-- 
1.9.1

