Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3KOP1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:27:41 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:41301 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3KOP13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:27:29 -0500
Message-ID: <52863D5E.7080606@linux.com>
Date: Fri, 15 Nov 2013 16:27:26 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tc: account for device_register() failure
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the TURBOchannel driver bail out if the call
to device_register() failed.

Signed-off-by: Levente Kurusa <levex@linux.com>
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
