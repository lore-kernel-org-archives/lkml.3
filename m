Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab3A1Qnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:43:52 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34043 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab3A1Qmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:42:55 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 08/15] asus-wmi: Restrict debugfs interface
Date: Mon, 28 Jan 2013 11:42:32 -0500
Message-Id: <1359391359-25783-9-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have no way of validating what all of the Asus WMI methods do on a
given machine, and there's a risk that some will allow hardware state to
be manipulated in such a way that arbitrary code can be executed in the
kernel. Add a capability check to prevent that.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/platform/x86/asus-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index f80ae4d..059195f 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1521,6 +1521,9 @@ static int show_dsts(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
 
 	if (err < 0)
@@ -1537,6 +1540,9 @@ static int show_devs(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	err = asus_wmi_set_devstate(asus->debug.dev_id, asus->debug.ctrl_param,
 				    &retval);
 
@@ -1561,6 +1567,9 @@ static int show_call(struct seq_file *m, void *data)
 	union acpi_object *obj;
 	acpi_status status;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
 				     1, asus->debug.method_id,
 				     &input, &output);
-- 
1.8.0.2

