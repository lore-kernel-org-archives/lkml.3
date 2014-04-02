Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbaDBKBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:01:03 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:48246 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbaDBKBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:01:00 -0400
From: Levente Kurusa <levex@linux.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux MIPS <linux-mips@linux-mips.org>,
        Levente Kurusa <levex@linux.com>
Subject: [PATCH RESEND] tc: account for device_register() failure
Date: Wed,  2 Apr 2014 12:00:37 +0200
Message-Id: <1396432837-10549-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the TURBOchannel driver bail out if the call
to device_register() failed.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
Resending as per Maciej's request to proper list and
people.
---
 tc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/tc/tc.c b/drivers/tc/tc.c
index a8aaf6a..6b3a038 100644
--- a/drivers/tc/tc.c
+++ b/drivers/tc/tc.c
@@ -129,7 +129,10 @@ static void __init tc_bus_add_devices(struct tc_bus *tbus)

 		tc_device_get_irq(tdev);

-		device_register(&tdev->dev);
+		if (device_register(&tdev->dev)) {
+			put_device(&tdev->dev);
+			goto out_err;
+		}
 		list_add_tail(&tdev->node, &tbus->devices);

 out_err:
@@ -148,7 +151,10 @@ static int __init tc_init(void)

 	INIT_LIST_HEAD(&tc_bus.devices);
 	dev_set_name(&tc_bus.dev, "tc");
-	device_register(&tc_bus.dev);
+	if (device_register(&tc_bus.dev)) {
+		put_device(&tc_bus.dev);
+		return 0;	
+	}

 	if (tc_bus.info.slot_size) {
 		unsigned int tc_clock = tc_get_speed(&tc_bus) / 100000;

