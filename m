Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbaGRF5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:57:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:38818 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbaGRF5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:57:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,682,1400050800"; 
   d="scan'208";a="458484554"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, lenb@kernel.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI/NVS: Not save NVS region for new machines to accelerate S3
Date: Fri, 18 Jul 2014 13:55:22 +0800
Message-Id: <1405662922-23606-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVS region is saved and restored unconditionally for machines without
nvs_nosave quirk during S3. Tested some new machines and the operation
is not necessary. Saving NVS region also affects S2RAM speed. The time of
NVS saving and restoring depends on the size of NVS region and it consumes
7~10ms normally.

This patch is to make machines produced from 2012 to now not saving NVS region
to accelerate S3.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/sleep.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index b3e3cc7..896d8be 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -322,7 +322,12 @@ static struct dmi_system_id acpisleep_dmi_table[] __initdata = {
 
 static void acpi_sleep_dmi_check(void)
 {
+	int year;
+
 	dmi_check_system(acpisleep_dmi_table);
+
+	if (dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL) && year >= 2012)
+		acpi_nvs_nosave_s3();
 }
 
 /**
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

