Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaLFPNF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:13:05 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47651 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752201AbaLFPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 01/66] Input: serio - add firmware_id sysfs attribute
Date: Sat,  6 Dec 2014 16:06:53 +0100
Message-Id: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0456c66f4e905e1ca839318219c770988b47975c upstream.

serio devices exposed via platform firmware interfaces such as ACPI may
provide additional identifying information of use to userspace.

We don't associate the serio devices with the firmware device (we don't
set it as parent), so there's no way for userspace to make use of this
information.

We cannot change the parent for serio devices instantiated though a
firmware interface as that would break suspend / resume ordering.

Therefore this patch adds a new firmware_id sysfs attribute so that
userspace can get a string from there with any additional identifying
information the firmware interface may provide.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Peter Hutterer <peter.hutterer@who-t.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/serio/serio.c | 13 +++++++++++++
 include/linux/serio.h       |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index de019ebb7e29..fffc0a69c6ff 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -474,11 +474,19 @@ static ssize_t serio_set_bind_mode(struct device *dev, struct device_attribute *
 	return retval;
 }
 
+static ssize_t firmware_id_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct serio *serio = to_serio_port(dev);
+
+	return sprintf(buf, "%s\n", serio->firmware_id);
+}
+
 static struct device_attribute serio_device_attrs[] = {
 	__ATTR(description, S_IRUGO, serio_show_description, NULL),
 	__ATTR(modalias, S_IRUGO, serio_show_modalias, NULL),
 	__ATTR(drvctl, S_IWUSR, NULL, serio_rebind_driver),
 	__ATTR(bind_mode, S_IWUSR | S_IRUGO, serio_show_bind_mode, serio_set_bind_mode),
+	__ATTR(firmware_id, S_IRUGO, firmware_id_show, NULL),
 	__ATTR_NULL
 };
 
@@ -912,9 +920,14 @@ static int serio_uevent(struct device *dev, struct kobj_uevent_env *env)
 	SERIO_ADD_UEVENT_VAR("SERIO_PROTO=%02x", serio->id.proto);
 	SERIO_ADD_UEVENT_VAR("SERIO_ID=%02x", serio->id.id);
 	SERIO_ADD_UEVENT_VAR("SERIO_EXTRA=%02x", serio->id.extra);
+
 	SERIO_ADD_UEVENT_VAR("MODALIAS=serio:ty%02Xpr%02Xid%02Xex%02X",
 				serio->id.type, serio->id.proto, serio->id.id, serio->id.extra);
 
+	if (serio->firmware_id[0])
+		SERIO_ADD_UEVENT_VAR("SERIO_FIRMWARE_ID=%s",
+				     serio->firmware_id);
+
 	return 0;
 }
 #undef SERIO_ADD_UEVENT_VAR
diff --git a/include/linux/serio.h b/include/linux/serio.h
index 36aac733840a..9f779c7a2da4 100644
--- a/include/linux/serio.h
+++ b/include/linux/serio.h
@@ -23,6 +23,7 @@ struct serio {
 
 	char name[32];
 	char phys[32];
+	char firmware_id[128];
 
 	bool manual_bind;
 
-- 
2.1.3

