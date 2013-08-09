Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab3HIOzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:55:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38154 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3HIOzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:55:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/hvc: If we use xen_raw_printk let it also work on HVM guests.
Date: Fri,  9 Aug 2013 10:55:33 -0400
Message-Id: <1376060133-6382-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xen_raw_printk works great for debugging purposes and for
it print anything the Xen hypervisor has to be built with 'debug=y'.

As such there is no difference between a PV or an PVHVM guest
using the hypercall, so lets use it.

Lastly if the hyper-page is not setup yet (for example during
early HVM boot), then use the 0xe9 port if it has detected
that it is running under an Xen hypervisor.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/hvc/hvc_xen.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 682210d..69454a0 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -641,7 +641,17 @@ struct console xenboot_console = {
 
 void xen_raw_console_write(const char *str)
 {
-	dom0_write_console(0, str, strlen(str));
+	if (!xen_domain())
+		return;
+
+	if (xen_pv_domain())
+		dom0_write_console(0, str, strlen(str));
+	else if (xen_hvm_domain() || xen_cpuid_base()) {
+		/* The hyperpage has not been setup yet. */
+		int i, len = strlen(str);
+		for (i = 0; i < len; i++)
+			 outb(str[i], 0xe9);
+	}
 }
 
 void xen_raw_printk(const char *fmt, ...)
-- 
1.7.7.6

