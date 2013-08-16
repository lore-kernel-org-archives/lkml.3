Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3HQAIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:08:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51695 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3HPWju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Fleig <andreasfleig@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 098/133] ACPI / PM: Fix /proc/acpi/wakeup for devices w/o bus or parent
Date: Fri, 16 Aug 2013 15:34:00 -0700
Message-Id: <1376692475-28413-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Fleig <andreasfleig@gmail.com>

commit 65ab96f60621c4da8f1b4087a57b788bc4d8f27b upstream.

Fix /proc/acpi/wakeup for devices without bus or parent

This patch fixes printing the wakeup status for devices without a bus
or parent, such as laptop lid switches and sleep buttons. These devices
have an empty physical_node_list, because acpi_bind_one is never run
for them.

[rjw: White space and coding style.]
Signed-off-by: Andreas Fleig <andreasfleig@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ kamal: 3.8.y-stable prereq for 623cf33c ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/proc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index ef98796..52ce767 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -311,11 +311,12 @@ acpi_system_wakeup_device_seq_show(struct seq_file *seq, void *offset)
 			   dev->pnp.bus_id,
 			   (u32) dev->wakeup.sleep_state);
 
-		if (!dev->physical_node_count)
+		if (!dev->physical_node_count) {
 			seq_printf(seq, "%c%-8s\n",
-				dev->wakeup.flags.run_wake ?
-				'*' : ' ', "disabled");
-		else {
+				dev->wakeup.flags.run_wake ? '*' : ' ',
+				device_may_wakeup(&dev->dev) ?
+					"enabled" : "disabled");
+		} else {
 			struct device *ldev;
 			list_for_each_entry(entry, &dev->physical_node_list,
 					node) {
-- 
1.8.1.2

