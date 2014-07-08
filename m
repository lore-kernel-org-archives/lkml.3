Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaGHXHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:07:18 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:51265 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaGHXHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:07:12 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
Subject: [PATCH 2/3] x86: (ts5500) add a name attribute
Date: Tue,  8 Jul 2014 18:57:48 -0400
Message-Id: <1404860269-11837-3-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404860269-11837-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1404860269-11837-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new "name" attribute to the ts5500 sysfs group, to clarify which
supported board model it is.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/ABI/testing/sysfs-platform-ts5500 |  7 +++++++
 arch/x86/platform/ts5500/ts5500.c               | 23 ++++++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-ts5500 b/Documentation/ABI/testing/sysfs-platform-ts5500
index c88375a..e685957 100644
--- a/Documentation/ABI/testing/sysfs-platform-ts5500
+++ b/Documentation/ABI/testing/sysfs-platform-ts5500
@@ -30,6 +30,13 @@ Description:
 		the corresponding bit is set. For instance, 0x0e means jumpers
 		2, 3 and 4 are set.
 
+What:		/sys/devices/platform/ts5500/name
+Date:		July 2014
+KernelVersion:	3.16
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Model name of the TS board, e.g. "TS-5500".
+
 What:		/sys/devices/platform/ts5500/rs485
 Date:		January 2013
 KernelVersion:	3.7
diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index 1bbf17b..4eb8eea 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -1,7 +1,7 @@
 /*
  * Technologic Systems TS-5500 Single Board Computer support
  *
- * Copyright (C) 2013 Savoir-faire Linux Inc.
+ * Copyright (C) 2013-2014 Savoir-faire Linux Inc.
  *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
  *
  * This program is free software; you can redistribute it and/or modify it under
@@ -66,6 +66,7 @@
 
 /**
  * struct ts5500_sbc - TS-5500 board description
+ * @name:	Board model name.
  * @id:		Board product ID.
  * @sram:	Flag for SRAM option.
  * @rs485:	Flag for RS-485 option.
@@ -75,6 +76,7 @@
  * @jumpers:	Bitfield for jumpers' state.
  */
 struct ts5500_sbc {
+	const char *name;
 	int	id;
 	bool	sram;
 	bool	rs485;
@@ -122,13 +124,14 @@ static int __init ts5500_detect_config(struct ts5500_sbc *sbc)
 	if (!request_region(TS5500_PRODUCT_CODE_ADDR, 4, "ts5500"))
 		return -EBUSY;
 
-	tmp = inb(TS5500_PRODUCT_CODE_ADDR);
-	if (tmp != TS5500_PRODUCT_CODE) {
-		pr_err("This platform is not a TS-5500 (found ID 0x%x)\n", tmp);
+	sbc->id = inb(TS5500_PRODUCT_CODE_ADDR);
+	if (sbc->id == TS5500_PRODUCT_CODE) {
+		sbc->name = "TS-5500";
+	} else {
+		pr_err("ts5500: unknown product code 0x%x\n", sbc->id);
 		ret = -ENODEV;
 		goto cleanup;
 	}
-	sbc->id = tmp;
 
 	tmp = inb(TS5500_SRAM_RS485_ADC_ADDR);
 	sbc->sram = tmp & TS5500_SRAM;
@@ -147,6 +150,15 @@ cleanup:
 	return ret;
 }
 
+static ssize_t name_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", sbc->name);
+}
+static DEVICE_ATTR_RO(name);
+
 static ssize_t id_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -183,6 +195,7 @@ TS5500_ATTR_BOOL(itr);
 
 static struct attribute *ts5500_attributes[] = {
 	&dev_attr_id.attr,
+	&dev_attr_name.attr,
 	&dev_attr_jumpers.attr,
 	&dev_attr_sram.attr,
 	&dev_attr_rs485.attr,
-- 
1.9.1

