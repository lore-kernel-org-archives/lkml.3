Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbaLJWVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:21:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051AbaLJWVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:21:20 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] HID: logitech-hidpp: prefix the name with Logitech
Date: Wed, 10 Dec 2014 17:21:10 -0500
Message-Id: <1418250070-28604-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1418250070-28604-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1418250070-28604-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current names are reported as "K750", "M705", and it can be misleading
for the users when they look at their input device list.

Prefixing the names with "Logitech " makes things better.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Jiri,

I'd love to see this one in 3.19 (after a strong review, of course).
The idea came with the mouse DPI database that Peter is currently working on
(see http://who-t.blogspot.com.au/2014/12/building-a-dpi-database-for-mice.html).

I think, if you do not qualify the series for 3.19, we should drop it entirely.
3.19 introduces the hidpp module and changes the labels. The DPI hwdb will check
on the label to match the actual mouse, so if this one does not get into 3.19,
we will end up in 3 entries for each Logitech device.

Cheers,
Benjamin


 drivers/hid/hid-logitech-hidpp.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 3846305..8cf4352 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -282,6 +282,33 @@ static inline bool hidpp_report_is_connect_event(struct hidpp_report *report)
 		(report->rap.sub_id == 0x41);
 }
 
+/**
+ * hidpp_prefix_name() prefixes the current given name with "Logitech ".
+ */
+static void hidpp_prefix_name(char **name, int name_length)
+{
+#define PREFIX_SIZE 9 /* "Logitech " */
+
+	int new_length;
+	char *new_name;
+
+	if (name_length > PREFIX_SIZE &&
+	    strncmp(*name, "Logitech ", PREFIX_SIZE) == 0)
+		/* The prefix has is already in the name */
+		return;
+
+	new_length = name_length + PREFIX_SIZE;
+	new_name = kzalloc(new_length, GFP_KERNEL);
+	if (!new_name)
+		return;
+
+	snprintf(new_name, new_length, "Logitech %s", *name);
+
+	kfree(*name);
+
+	*name = new_name;
+}
+
 /* -------------------------------------------------------------------------- */
 /* HIDP++ 1.0 commands                                                        */
 /* -------------------------------------------------------------------------- */
@@ -318,6 +345,10 @@ static char *hidpp_get_unifying_name(struct hidpp_device *hidpp_dev)
 		return NULL;
 
 	memcpy(name, &response.rap.params[2], len);
+
+	/* include the terminating '\0' */
+	hidpp_prefix_name(&name, len + 1);
+
 	return name;
 }
 
@@ -489,6 +520,9 @@ static char *hidpp_get_device_name(struct hidpp_device *hidpp)
 			feature_index, index, name + index,
 			__name_length - index);
 
+	/* include the terminating '\0' */
+	hidpp_prefix_name(&name, __name_length + 1);
+
 	return name;
 
 out_err:
-- 
2.1.0

