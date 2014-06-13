Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaFMJUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:20:51 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52275 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaFMJUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:20:50 -0400
Date: Fri, 13 Jun 2014 18:19:55 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7 RESEND] staging: dgap: introduce dgap_tty_free() for
 freeing channels.
Message-ID: <20140613091955.GA3775@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be called after dgap_tty_register_ports() is failed.
So channels which are allocated in dgap_tty_init() will be freed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
resend: reordering this series of patches

 drivers/staging/dgap/dgap.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 352eb1b..eab8fd5 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -123,6 +123,7 @@ static void dgap_tty_send_xchar(struct tty_struct *tty, char ch);
 
 static int dgap_tty_register(struct board_t *brd);
 static int dgap_tty_init(struct board_t *);
+static void dgap_tty_free(struct board_t *);
 static void dgap_cleanup_tty(struct board_t *);
 static void dgap_carrier(struct channel_t *ch);
 static void dgap_input(struct channel_t *ch);
@@ -960,8 +961,10 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 		return ret;
 
 	ret = dgap_tty_register_ports(brd);
-	if (ret)
+	if (ret) {
+		dgap_tty_free(brd);
 		return ret;
+	}
 
 	brd->state = BOARD_READY;
 	brd->dpastatus = BD_RUNNING;
@@ -1488,6 +1491,18 @@ free_chan:
 }
 
 /*
+ * dgap_tty_free()
+ *
+ * Free the channles which are allocated in dgap_tty_init().
+ */
+static void dgap_tty_free(struct board_t *brd)
+{
+	int i;
+
+	for (i = 0; i < brd->nasync; i++)
+		kfree(brd->channels[i]);
+}
+/*
  * dgap_cleanup_tty()
  *
  * Uninitialize the TTY portion of this driver.  Free all memory and
-- 
1.7.1

