Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbaFEAWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:22:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaFDXW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 131/228] Input: serio - add firmware_id sysfs attribute
Date: Wed,  4 Jun 2014 16:22:40 -0700
Message-Id: <20140604232352.230941675@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/serio.c |   14 ++++++++++++++
 include/linux/serio.h       |    1 +
 2 files changed, 15 insertions(+)

--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -451,6 +451,13 @@ static ssize_t serio_set_bind_mode(struc
 	return retval;
 }
 
+static ssize_t firmware_id_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct serio *serio = to_serio_port(dev);
+
+	return sprintf(buf, "%s\n", serio->firmware_id);
+}
+
 static DEVICE_ATTR_RO(type);
 static DEVICE_ATTR_RO(proto);
 static DEVICE_ATTR_RO(id);
@@ -473,12 +480,14 @@ static DEVICE_ATTR_RO(modalias);
 static DEVICE_ATTR_WO(drvctl);
 static DEVICE_ATTR(description, S_IRUGO, serio_show_description, NULL);
 static DEVICE_ATTR(bind_mode, S_IWUSR | S_IRUGO, serio_show_bind_mode, serio_set_bind_mode);
+static DEVICE_ATTR_RO(firmware_id);
 
 static struct attribute *serio_device_attrs[] = {
 	&dev_attr_modalias.attr,
 	&dev_attr_description.attr,
 	&dev_attr_drvctl.attr,
 	&dev_attr_bind_mode.attr,
+	&dev_attr_firmware_id.attr,
 	NULL
 };
 
@@ -921,9 +930,14 @@ static int serio_uevent(struct device *d
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
--- a/include/linux/serio.h
+++ b/include/linux/serio.h
@@ -23,6 +23,7 @@ struct serio {
 
 	char name[32];
 	char phys[32];
+	char firmware_id[128];
 
 	bool manual_bind;
 


