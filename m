Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3LSPEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:04:45 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40438 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3LSPEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:41 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 16/38] mips: sgi-ip22: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:27 +0100
Message-Id: <1387465429-3568-17-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Also, create a gio_bus_release() that calls kfree on the device argument to
properly kfree() the memory allocated for the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/mips/sgi-ip22/ip22-gio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/sgi-ip22/ip22-gio.c b/arch/mips/sgi-ip22/ip22-gio.c
index ab0e379..931da33 100644
--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -24,8 +24,13 @@ static struct {
 	{ .name = "SGI GR2/GR3", .id = 0x7f },
 };
 
+void gio_bus_release(struct device *dev) {
+	kfree(dev);
+}
+
 static struct device gio_bus = {
 	.init_name = "gio",
+	.release = &gio_bus_release,
 };
 
 /**
@@ -400,8 +405,10 @@ int __init ip22_gio_init(void)
 	int ret;
 
 	ret = device_register(&gio_bus);
-	if (ret)
+	if (ret) {
+		put_device(&gio_bus);
 		return ret;
+	}
 
 	ret = bus_register(&gio_bus_type);
 	if (!ret) {
-- 
1.8.3.1

