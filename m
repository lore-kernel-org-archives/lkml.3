Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaD1BdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42820 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "" <openipmi-developer@lists.sourceforge.net>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jiri Slaby" <jslaby@suse.cz>, "Corey Minyard" <minyard@acm.org>,
        "Tomas Cech" <tcech@suse.cz>, "Corey Minyard" <cminyard@mvista.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.417635741@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 89/94] Char: ipmi_bt_sm, fix infinite loop
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/ipmi/ipmi_bt_sm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index f5e4cd7..61e7161 100644
--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -352,7 +352,7 @@ static inline void write_all_bytes(struct si_sm_data *bt)
 
 static inline int read_all_bytes(struct si_sm_data *bt)
 {
-	unsigned char i;
+	unsigned int i;
 
 	/*
 	 * length is "framing info", minimum = 4: NetFn, Seq, Cmd, cCode.

