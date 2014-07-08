Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaGHHAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:00:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:24851 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbaGHHAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:00:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,624,1400050800"; 
   d="scan'208";a="540100146"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, lenb@kernel.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] ACPI/Wakup: Enable button wakeup GPEs if these GPEs have associated GPE methods.
Date: Tue,  8 Jul 2014 14:57:58 +0800
Message-Id: <1404802679-24019-2-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404802679-24019-1-git-send-email-tianyu.lan@intel.com>
References: <1404802679-24019-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The button wakeup GPEs are enabled unconditionally in the current world by
commit 2a5d24(ACPI / Wakeup: Enable button GPEs unconditionally during
initialization). Because button's GPE methods needs to be run to clear
GPE status on some machines when there is GPE interrupt. If not, it will
cause machines resume immediately after being suspended since GPE status
isn't cleared correctly.

But if there is no GPE method for button wakeup GPE, these GPEs should not
be enabled since nothing needs to be done when they are triggered and this
also causes LID GPE storm on Lenovo Ideapad y560p.

This patch is to check Button GPE method and enable it if there is associated
GPE method.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=61051
Reported-by: James Tocknell<aragilar@gmail.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/wakeup.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
index 1638401..5b20ae4 100644
--- a/drivers/acpi/wakeup.c
+++ b/drivers/acpi/wakeup.c
@@ -86,9 +86,14 @@ int __init acpi_wakeup_device_init(void)
 						       struct acpi_device,
 						       wakeup_list);
 		if (device_can_wakeup(&dev->dev)) {
-			/* Button GPEs are supposed to be always enabled. */
-			acpi_enable_gpe(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number);
+			/*
+			 * Button GPEs are supposed to be always enabled if
+			 * they have associated GPE methods.
+			 */
+			if (ACPI_SUCCESS(acpi_check_gpe_method(
+			    dev->wakeup.gpe_device, dev->wakeup.gpe_number)))
+				acpi_enable_gpe(dev->wakeup.gpe_device,
+						dev->wakeup.gpe_number);
 			device_set_wakeup_enable(&dev->dev, true);
 		}
 	}
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

