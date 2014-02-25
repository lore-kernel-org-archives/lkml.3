Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaBYKPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:15:02 -0500
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33620 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136AbaBYKPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:15:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: minyard@acm.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Tomas Cech <tcech@suse.cz>,
        <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH 1/1] Char: ipmi_bt_sm, fix infinite loop
Date: Tue, 25 Feb 2014 11:14:54 +0100
Message-Id: <1393323294-11423-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In read_all_bytes, we do
  unsigned char i;
...
  bt->read_data[0] = BMC2HOST;
  bt->read_count = bt->read_data[0];
...
  for (i = 1; i <= bt->read_count; i++)
    bt->read_data[i] = BMC2HOST;

If bt->read_data[0] == bt->read_count == 255, we loop infinitely in
the 'for' loop. Make 'i' an 'int' instead of 'char' to get rid of the
overflow and finish the loop after 255 iterations every time.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-and-debugged-by: Rui Hui Dian <rhdian@novell.com>
Cc: Tomas Cech <tcech@suse.cz>
Cc: Corey Minyard <minyard@acm.org>
Cc: <openipmi-developer@lists.sourceforge.net>
---
 drivers/char/ipmi/ipmi_bt_sm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index f5e4cd7617f6..61e71616689b 100644
--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -352,7 +352,7 @@ static inline void write_all_bytes(struct si_sm_data *bt)
 
 static inline int read_all_bytes(struct si_sm_data *bt)
 {
-	unsigned char i;
+	unsigned int i;
 
 	/*
 	 * length is "framing info", minimum = 4: NetFn, Seq, Cmd, cCode.
-- 
1.9.0

