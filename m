Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3IYCGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 22:06:08 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43939 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3IYCGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 22:06:06 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Paolo Pisati <paolo.pisati@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2] TTY: hvc_dcc: probe for a JTAG connection before registering
Date: Tue, 24 Sep 2013 21:05:58 -0500
Message-Id: <1380074758-19808-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379968234-23373-1-git-send-email-robherring2@gmail.com>
References: <1379968234-23373-1-git-send-email-robherring2@gmail.com>
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
v2: use time_is_after_jiffies

 drivers/tty/hvc/hvc_dcc.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
index 44fbeba..3502a7b 100644
--- a/drivers/tty/hvc/hvc_dcc.c
+++ b/drivers/tty/hvc/hvc_dcc.c
@@ -86,6 +86,21 @@ static int hvc_dcc_get_chars(uint32_t vt, char *buf, int count)
 	return i;
 }
 
+static bool hvc_dcc_check(void)
+{
+	unsigned long time = jiffies + (HZ / 10);
+
+	/* Write a test character to check if it is handled */
+	__dcc_putchar('\n');
+
+	while (time_is_after_jiffies(time)) {
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

