Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3I0VZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 17:25:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39088 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab3I0VZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 17:25:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ian.campbell@citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/hvc-console: Make it work with HVM guests.
Date: Fri, 27 Sep 2013 17:25:17 -0400
Message-Id: <1380317117-21719-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/hvc/hvc_xen.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index e61c36c..513a79b 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -183,7 +183,7 @@ static int dom0_write_console(uint32_t vtermno, const char *str, int len)
 {
 	int rc = HYPERVISOR_console_io(CONSOLEIO_write, len, (char *)str);
 	if (rc < 0)
-		return 0;
+		return rc;
 
 	return len;
 }
@@ -641,7 +641,20 @@ struct console xenboot_console = {
 
 void xen_raw_console_write(const char *str)
 {
-	dom0_write_console(0, str, strlen(str));
+	ssize_t len = strlen(str);
+	int rc = 0;
+
+	if (xen_domain()) {
+		dom0_write_console(0, str, len);
+		if (rc == -ENOSYS && xen_hvm_domain())
+			goto outb_print;
+
+	} else if (xen_cpuid_base()) {
+		int i;
+outb_print:
+		for (i = 0; i < len; i++)
+			outb(str[i], 0xe9);
+	}
 }
 
 void xen_raw_printk(const char *fmt, ...)
-- 
1.7.7.6

