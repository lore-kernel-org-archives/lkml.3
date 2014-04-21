Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaDUEgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:36:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaDUEey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:34:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Tomas Cech <tcech@suse.cz>,
        Corey Minyard <minyard@acm.org>,
        openipmi-developer@lists.sourceforge.net,
        Corey Minyard <cminyard@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 02/32] Char: ipmi_bt_sm, fix infinite loop
Date: Sun, 20 Apr 2014 19:13:19 -0700
Message-Id: <20140421021134.212611245@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ipmi/ipmi_bt_sm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -352,7 +352,7 @@ static inline void write_all_bytes(struc
 
 static inline int read_all_bytes(struct si_sm_data *bt)
 {
-	unsigned char i;
+	unsigned int i;
 
 	/*
 	 * length is "framing info", minimum = 4: NetFn, Seq, Cmd, cCode.


