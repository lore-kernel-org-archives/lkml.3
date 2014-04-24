Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaDXJ1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:27:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbaDXIzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Slaby <jslaby@suse.cz>, Tomas Cech <tcech@suse.cz>,
        Corey Minyard <minyard@acm.org>,
        <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 148/182] Char: ipmi_bt_sm, fix infinite loop
Date: Thu, 24 Apr 2014 09:51:13 +0100
Message-Id: <1398329507-5911-149-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/ipmi/ipmi_bt_sm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index a22a7a5..8156caf 100644
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
1.9.1

