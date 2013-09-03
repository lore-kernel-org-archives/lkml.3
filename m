Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171Ab3ICXuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:50:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33646 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab3ICXue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:50:34 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, keescook@chromium.org, hpa@zytor.com,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V3 09/11] uswsusp: Disable when module loading is restricted
Date: Tue,  3 Sep 2013 19:50:16 -0400
Message-Id: <1378252218-18798-10-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uswsusp allows a user process to dump and then restore kernel state, which
makes it possible to avoid module loading restrictions. Prevent this when
any restrictions have been imposed on loading modules.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/power/user.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index 4ed81e7..15cb72f 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -24,6 +24,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 
@@ -48,6 +49,9 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	struct snapshot_data *data;
 	int error;
 
+	if (secure_modules())
+		return -EPERM;
+
 	lock_system_sleep();
 
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
-- 
1.8.3.1

