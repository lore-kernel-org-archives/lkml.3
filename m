Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaGHADn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:03:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaGHADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 28/44] acpi/video_detect: blacklist samsung x360
Date: Mon,  7 Jul 2014 17:07:18 -0700
Message-Id: <20140707235859.484874132@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corentin Chary <corentin.chary@gmail.com>

commit 084940d5b101e9ca91a689eb5048151b14076839 upstream.

On Samsung X360, the BIOS will set a flag (VDRV) if the generic
ACPI backlight device is used. This flag will definitively break
the backlight interface (even the vendor interface) untill next
reboot. It's why we should prevent video.ko from being used here
and we can't rely on a later call to acpi_video_unregister().

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video_detect.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -132,6 +132,33 @@ find_video(acpi_handle handle, u32 lvl,
 	return AE_OK;
 }
 
+/* Force to use vendor driver when the ACPI device is known to be
+ * buggy */
+static int video_detect_force_vendor(const struct dmi_system_id *d)
+{
+	acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
+	return 0;
+}
+
+static struct dmi_system_id video_detect_dmi_table[] = {
+	/* On Samsung X360, the BIOS will set a flag (VDRV) if generic
+	 * ACPI backlight device is used. This flag will definitively break
+	 * the backlight interface (even the vendor interface) untill next
+	 * reboot. It's why we should prevent video.ko from being used here
+	 * and we can't rely on a later call to acpi_video_unregister().
+	 */
+	{
+	 .callback = video_detect_force_vendor,
+	 .ident = "X360",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "X360"),
+		DMI_MATCH(DMI_BOARD_NAME, "X360"),
+		},
+	},
+	{ },
+};
+
 /*
  * Returns the video capabilities of a specific ACPI graphics device
  *
@@ -164,6 +191,8 @@ long acpi_video_get_capabilities(acpi_ha
 		 *		ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
 		 *}
 		 */
+
+		dmi_check_system(video_detect_dmi_table);
 	} else {
 		status = acpi_bus_get_device(graphics_handle, &tmp_dev);
 		if (ACPI_FAILURE(status)) {


