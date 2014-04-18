Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaDRJti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:49:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45884 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Tomas Cech <tcech@suse.cz>, Corey Minyard <minyard@acm.org>,
        <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 08/72] Char: ipmi_bt_sm, fix infinite loop
Date: Fri, 18 Apr 2014 11:21:41 +0200
Message-Id: <1070f32690efdfef2dc64183dded068ec54266c7.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a94cdd1f4d30f12904ab528152731fb13a812a16 upstream.

In read_all_bytes, we do

  unsigned char i;
  ...
  bt->read_data[0] = BMC2HOST;
  bt->read_count = bt->read_data[0];
  ...
  for (i = 1; i <= bt->read_count; i++)
    bt->read_data[i] = BMC2HOST;

If bt->read_data[0] == bt->read_count == 255, we loop infinitely in the
'for' loop.  Make 'i' an 'int' instead of 'char' to get rid of the
overflow and finish the loop after 255 iterations every time.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-and-debugged-by: Rui Hui Dian <rhdian@novell.com>
Cc: Tomas Cech <tcech@suse.cz>
Cc: Corey Minyard <minyard@acm.org>
Cc: <openipmi-developer@lists.sourceforge.net>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/ipmi/ipmi_bt_sm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index a22a7a502740..8156cafad11a 100644
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
1.9.2

