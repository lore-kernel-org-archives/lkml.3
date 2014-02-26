Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaBZUQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:16:31 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44226 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaBZUQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:16:29 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 11/12] asus-wmi: Restrict debugfs interface when trusted_kernel is true
Date: Wed, 26 Feb 2014 15:11:12 -0500
Message-Id: <1393445473-15068-12-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have no way of validating what all of the Asus WMI methods do on a
given machine, and there's a risk that some will allow hardware state to
be manipulated in such a way that arbitrary code can be executed in the
kernel. Prevent that if trusted_kernel is true.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/platform/x86/asus-wmi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index c5e082f..4c1000b 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -46,6 +46,7 @@
 #include <linux/platform_device.h>
 #include <linux/thermal.h>
 #include <linux/acpi.h>
+#include <linux/security.h>
 #include <acpi/video.h>
 
 #include "asus-wmi.h"
@@ -1595,6 +1596,9 @@ static int show_dsts(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
+	if (get_trusted_kernel())
+		return -EPERM;
+
 	err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
 
 	if (err < 0)
@@ -1611,6 +1615,9 @@ static int show_devs(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
+	if (get_trusted_kernel())
+		return -EPERM;
+
 	err = asus_wmi_set_devstate(asus->debug.dev_id, asus->debug.ctrl_param,
 				    &retval);
 
@@ -1635,6 +1642,9 @@ static int show_call(struct seq_file *m, void *data)
 	union acpi_object *obj;
 	acpi_status status;
 
+	if (get_trusted_kernel())
+		return -EPERM;
+
 	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
 				     1, asus->debug.method_id,
 				     &input, &output);
-- 
1.8.5.3

