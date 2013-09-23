Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3IWUcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:32:20 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:54527 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3IWUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:32:18 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Paolo Pisati <paolo.pisati@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] TTY: hvc_dcc: probe for a JTAG connection before registering
Date: Mon, 23 Sep 2013 15:30:34 -0500
Message-Id: <1379968234-23373-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Enabling the ARM DCC console and using without a JTAG connection will
simply hang the system. Since distros like to turn on all options, this
is a reoccurring problem to debug. We can do better by checking if
anything is attached and handling characters. There is no way to probe
this, so send a newline and check that it is handled.

Cc: Paolo Pisati <paolo.pisati@canonical.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/tty/hvc/hvc_dcc.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
index 44fbeba..44c8aff 100644
--- a/drivers/tty/hvc/hvc_dcc.c
+++ b/drivers/tty/hvc/hvc_dcc.c
@@ -86,6 +86,21 @@ static int hvc_dcc_get_chars(uint32_t vt, char *buf, int count)
 	return i;
 }
 
+static bool hvc_dcc_check(void)
+{
+	unsigned long time = jiffies;
+
+	/* Write a test character to check if it is handled */
+	__dcc_putchar('\n');
+
+	while (jiffies < time + (HZ / 10)) {
+		if (!(__dcc_getstatus() & DCC_STATUS_TX))
+			return true;
+	}
+
+	return false;
+}
+
 static const struct hv_ops hvc_dcc_get_put_ops = {
 	.get_chars = hvc_dcc_get_chars,
 	.put_chars = hvc_dcc_put_chars,
@@ -93,6 +108,9 @@ static const struct hv_ops hvc_dcc_get_put_ops = {
 
 static int __init hvc_dcc_console_init(void)
 {
+	if (!hvc_dcc_check())
+		return -ENODEV;
+
 	hvc_instantiate(0, 0, &hvc_dcc_get_put_ops);
 	return 0;
 }
@@ -100,6 +118,9 @@ console_initcall(hvc_dcc_console_init);
 
 static int __init hvc_dcc_init(void)
 {
+	if (!hvc_dcc_check())
+		return -ENODEV;
+
 	hvc_alloc(0, 0, &hvc_dcc_get_put_ops, 128);
 	return 0;
 }
-- 
1.8.1.2

