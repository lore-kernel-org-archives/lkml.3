Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbbAZUn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:43:57 -0500
Received: from mx1.scotdoyle.com ([23.226.141.211]:44888 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAZUnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:43:51 -0500
Date: Mon, 26 Jan 2015 20:41:53 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] fbcon: expose cursor blink interval via sysfs
In-Reply-To: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
Message-ID: <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fbcon cursor, when set to blink, is hardcoded to toggle display state
five times per second. Expose this setting via
/sys/class/graphics/fbcon/cursor_blink_ms

Values written to the interface set the approximate time interval in
milliseconds between cursor toggles, from 1 to 32767. Since the interval
is stored internally as a number of jiffies, the millisecond value read
from the interface may not exactly match the entered value.

An outstanding blink timer is reset after a new value is entered.

If the cursor blink is disabled, either via the 'cursor_blink' boolean
setting or some other mechanism, the 'cursor_blink_ms' setting may still
be modified. The new value will be used if the blink is reactivated.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
---
 drivers/video/console/fbcon.c | 79 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 7a2030b..19620d2 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3495,11 +3495,90 @@ err:
 	return count;
 }
 
+static ssize_t show_cursor_blink_ms(struct device *device,
+				    struct device_attribute *attr, char *buf)
+{
+	struct fb_info *info;
+	struct fbcon_ops *ops;
+	int idx, ms = -1;
+
+	if (fbcon_has_exited) {
+		pr_err("%s: framebuffer console exited", __func__);
+		return 0;
+	}
+
+	console_lock();
+	idx = con2fb_map[fg_console];
+
+	if (idx == -1 || registered_fb[idx] == NULL) {
+		pr_err("%s: no console to framebuffer mapping", __func__);
+		goto err;
+	}
+
+	info = registered_fb[idx];
+
+	if ((ops = info->fbcon_par) == NULL) {
+		pr_err("%s: framebuffer has no device info", __func__);
+		goto err;
+	}
+
+	ms = jiffies_to_msecs(ops->blink_jiffies);
+
+err:
+	console_unlock();
+	return snprintf(buf, PAGE_SIZE, "%d\n", ms);
+}
+
+static ssize_t store_cursor_blink_ms(struct device *device,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct fb_info *info;
+	struct fbcon_ops *ops;
+	int idx;
+	short ms;
+
+	if (fbcon_has_exited) {
+		pr_err("%s: framebuffer console exited", __func__);
+		return count;
+	}
+
+	console_lock();
+	idx = con2fb_map[fg_console];
+
+	if (idx == -1 || registered_fb[idx] == NULL) {
+		pr_err("%s: no console to framebuffer mapping", __func__);
+		goto err;
+	}
+
+	info = registered_fb[idx];
+
+	if ((ops = info->fbcon_par) == NULL) {
+		pr_err("%s: framebuffer has no device info", __func__);
+		goto err;
+	}
+
+	if (!kstrtos16(buf, 0, &ms)) {
+		ops->blink_jiffies = max_t(int, msecs_to_jiffies(ms), 1);
+		if (info->queue.func == fb_flashcursor &&
+		    ops->flags & FBCON_FLAGS_CURSOR_TIMER) {
+			fbcon_del_cursor_timer(info);
+			fbcon_add_cursor_timer(info);
+		}
+	}
+
+err:
+	console_unlock();
+	return count;
+}
+
 static struct device_attribute device_attrs[] = {
 	__ATTR(rotate, S_IRUGO|S_IWUSR, show_rotate, store_rotate),
 	__ATTR(rotate_all, S_IWUSR, NULL, store_rotate_all),
 	__ATTR(cursor_blink, S_IRUGO|S_IWUSR, show_cursor_blink,
 	       store_cursor_blink),
+	__ATTR(cursor_blink_ms, S_IRUGO|S_IWUSR, show_cursor_blink_ms,
+	       store_cursor_blink_ms),
 };
 
 static int fbcon_init_device(void)
-- 
2.1.4

