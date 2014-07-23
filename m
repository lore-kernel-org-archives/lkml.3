Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaGWGok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:44:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:4871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbaGWGoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:44:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,715,1400050800"; 
   d="scan'208";a="547603453"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, lenb@kernel.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] ACPI/NVS: Not save NVS region for new machine to accelerate S3
Date: Wed, 23 Jul 2014 14:42:33 +0800
Message-Id: <1406097753-7398-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405662922-23606-1-git-send-email-tianyu.lan@intel.com>
References: <1405662922-23606-1-git-send-email-tianyu.lan@intel.com>
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
Change since V1:
	Change the order between checking acpisleep quirk table and setting
the flag of nosaving nvs for S3.

 drivers/acpi/sleep.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index b3e3cc7..54da4a3 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -322,6 +322,11 @@ static struct dmi_system_id acpisleep_dmi_table[] __initdata = {
 
 static void acpi_sleep_dmi_check(void)
 {
+	int year;
+
+	if (dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL) && year >= 2012)
+		acpi_nvs_nosave_s3();
+
 	dmi_check_system(acpisleep_dmi_table);
 }
 
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

