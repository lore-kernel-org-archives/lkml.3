Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab3HNKhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:37:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34481 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab3HNKhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 25/75] ACPI / battery: Fix parsing _BIX return value
Date: Wed, 14 Aug 2013 11:36:14 +0100
Message-Id: <1376476624-10011-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 016d5baad04269e8559332df05f89bd95b52d6ad upstream.

The _BIX method returns extended battery info as a package.
According the ACPI spec (ACPI 5, Section 10.2.2.2), the first member
of that package should be "Revision".  However, the current ACPI
battery driver treats the first member as "Power Unit" which should
be the second member.  This causes the result of _BIX return data
parsing to be incorrect.

Fix this by adding a new member called 'revision' to struct
acpi_battery and adding the offsetof() information on it to
extended_info_offsets[] as the first row.

[rjw: Changelog]
Reported-and-tested-by: Jan Hoffmann <jan.christian.hoffmann@gmail.com>
References: http://bugzilla.kernel.org/show_bug.cgi?id=60519
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/battery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 6ea287e2..9bdfcf5 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -117,6 +117,7 @@ struct acpi_battery {
 	struct acpi_device *device;
 	struct notifier_block pm_nb;
 	unsigned long update_time;
+	int revision;
 	int rate_now;
 	int capacity_now;
 	int voltage_now;
@@ -350,6 +351,7 @@ static struct acpi_offsets info_offsets[] = {
 };
 
 static struct acpi_offsets extended_info_offsets[] = {
+	{offsetof(struct acpi_battery, revision), 0},
 	{offsetof(struct acpi_battery, power_unit), 0},
 	{offsetof(struct acpi_battery, design_capacity), 0},
 	{offsetof(struct acpi_battery, full_charge_capacity), 0},
-- 
1.8.3.2

