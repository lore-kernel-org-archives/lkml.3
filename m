Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaIHVNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:13:01 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36283 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaIHVM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:12:59 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Darren Hart <dvhart@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] eeepc-laptop: remove disp attribute show function
Date: Mon,  8 Sep 2014 23:12:42 +0200
Message-Id: <1410210762-2487-1-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7288841.ayNsq2yeGO@vostro.rjw.lan>
References: <7288841.ayNsq2yeGO@vostro.rjw.lan>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com> <1409814488.5546.63.camel@x220> <20140906021757.GA9197@vmdeb7> <7288841.ayNsq2yeGO@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The disp attribute is write-only. This is enforced by mimicking sysfs
behavior store_sys_acpi() and show_sys_acpi(), but this is not ideal.
Behaving like sysfs is better left to sysfs.

Remove the show function from the disp attribute. This ensures userspace
can only write to disp at all times. While at it, propagate any errors
produced in store_sys_acpi() and show_sys_acpi(), instead of overriding
them with -EIO.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---

This patch applies on top of Paul's "eeepc-laptop: simplify parse_arg()".
Tested both patches separately, as well as combined. As far as I can see the
system behaves exactly like before.

 drivers/platform/x86/eeepc-laptop.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 78515b8..03bcbed 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -281,7 +281,7 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
 		return rv;
 	value = set_acpi(eeepc, cm, value);
 	if (value < 0)
-		return -EIO;
+		return value;
 	return count;
 }
 
@@ -291,7 +291,7 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
 	int value = get_acpi(eeepc, cm);
 
 	if (value < 0)
-		return -EIO;
+		return value;
 	return sprintf(buf, "%d\n", value);
 }
 
@@ -318,7 +318,20 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
 
 EEEPC_CREATE_DEVICE_ATTR(camera, 0644, CM_ASL_CAMERA);
 EEEPC_CREATE_DEVICE_ATTR(cardr, 0644, CM_ASL_CARDREADER);
-EEEPC_CREATE_DEVICE_ATTR(disp, 0200, CM_ASL_DISPLAYSWITCH);
+
+static ssize_t store_disp(struct device *dev,
+			  struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	return store_sys_acpi(dev, CM_ASL_DISPLAYSWITCH, buf, count);
+}
+
+static struct device_attribute dev_attr_disp = {
+	.attr = {
+		.name = "disp",
+		.mode = 0200 },
+	.store  = store_disp,
+};
 
 struct eeepc_cpufv {
 	int num;
-- 
2.1.0

