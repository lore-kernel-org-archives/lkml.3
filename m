Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbaCORhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 13:37:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:46849 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958AbaCORhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 13:37:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,661,1389772800"; 
   d="scan'208";a="499346545"
From: Lan Tianyu <tianyu.lan@intel.com>
To: lenb@kernel.org, rjw@rjwysocki.net, richard.musil@gmail.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, <stable@vger.kernel.org>
Subject: [Fix PATCH] ACPI/Button: Add ACPI Button event via netlink routine
Date: Sat, 15 Mar 2014 13:37:13 -0400
Message-Id: <1394905033-5695-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1696d9d(ACPI: Remove the old /proc/acpi/event interface)
removes ACPI Button event which originally was sent to userspace via
/proc/acpi/event. This causes ACPI shutdown regression on gentoo
in the VirtualBox. Now ACPI events are sent to userspace via netlink.
This patch is to add ACPI Button event back via netlink routine.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=71721
Reported-and-tested-by: Richard Musil <richard.musil@gmail.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Cc: <stable@vger.kernel.org> # 3.11.x
---
 drivers/acpi/button.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 714e957..db35594 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -302,6 +302,10 @@ static void acpi_button_notify(struct acpi_device *device, u32 event)
 			input_sync(input);
 
 			pm_wakeup_event(&device->dev, 0);
+			acpi_bus_generate_netlink_event(
+					device->pnp.device_class,
+					dev_name(&device->dev),
+					event, ++button->pushed);
 		}
 		break;
 	default:
-- 
1.8.3.1

