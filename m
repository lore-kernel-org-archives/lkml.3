Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaGHXHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:07:13 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:61801 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbaGHXHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:07:11 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2014 19:07:11 EDT
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
Subject: [PATCH 1/3] x86: (ts5500) use DEVICE_ATTR_RO macro
Date: Tue,  8 Jul 2014 18:57:47 -0400
Message-Id: <1404860269-11837-2-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404860269-11837-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1404860269-11837-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the DEVICE_ATTR_RO helper macro to simplify the declaration of
read-only sysfs attributes.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 arch/x86/platform/ts5500/ts5500.c | 50 +++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index 9471b94..1bbf17b 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -147,45 +147,39 @@ cleanup:
 	return ret;
 }
 
-static ssize_t ts5500_show_id(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t id_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
 
 	return sprintf(buf, "0x%.2x\n", sbc->id);
 }
+static DEVICE_ATTR_RO(id);
 
-static ssize_t ts5500_show_jumpers(struct device *dev,
-				   struct device_attribute *attr,
-				   char *buf)
+static ssize_t jumpers_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
 
 	return sprintf(buf, "0x%.2x\n", sbc->jumpers >> 1);
 }
-
-#define TS5500_SHOW(field)					\
-	static ssize_t ts5500_show_##field(struct device *dev,	\
-			struct device_attribute *attr,		\
-			char *buf)				\
-	{							\
-		struct ts5500_sbc *sbc = dev_get_drvdata(dev);	\
-		return sprintf(buf, "%d\n", sbc->field);	\
-	}
-
-TS5500_SHOW(sram)
-TS5500_SHOW(rs485)
-TS5500_SHOW(adc)
-TS5500_SHOW(ereset)
-TS5500_SHOW(itr)
-
-static DEVICE_ATTR(id, S_IRUGO, ts5500_show_id, NULL);
-static DEVICE_ATTR(jumpers, S_IRUGO, ts5500_show_jumpers, NULL);
-static DEVICE_ATTR(sram, S_IRUGO, ts5500_show_sram, NULL);
-static DEVICE_ATTR(rs485, S_IRUGO, ts5500_show_rs485, NULL);
-static DEVICE_ATTR(adc, S_IRUGO, ts5500_show_adc, NULL);
-static DEVICE_ATTR(ereset, S_IRUGO, ts5500_show_ereset, NULL);
-static DEVICE_ATTR(itr, S_IRUGO, ts5500_show_itr, NULL);
+static DEVICE_ATTR_RO(jumpers);
+
+#define TS5500_ATTR_BOOL(_field)					\
+	static ssize_t _field##_show(struct device *dev,		\
+			struct device_attribute *attr, char *buf)	\
+	{								\
+		struct ts5500_sbc *sbc = dev_get_drvdata(dev);		\
+									\
+		return sprintf(buf, "%d\n", sbc->_field);		\
+	}								\
+	static DEVICE_ATTR_RO(_field)
+
+TS5500_ATTR_BOOL(sram);
+TS5500_ATTR_BOOL(rs485);
+TS5500_ATTR_BOOL(adc);
+TS5500_ATTR_BOOL(ereset);
+TS5500_ATTR_BOOL(itr);
 
 static struct attribute *ts5500_attributes[] = {
 	&dev_attr_id.attr,
-- 
1.9.1

