Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaEZKYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:24:31 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60810 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaEZKYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:24:30 -0400
Date: Mon, 26 May 2014 19:23:47 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: dgap: implement proper error handling in
 dgap_firmware_load()
Message-ID: <20140526102347.GA13793@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dgap_tty_init() and dgap_tty_register_ports() are failed,
these are needed to free some memory properly.

It can be handled by calling dgap_tty_uninit() and dgap_cleanup_board().
But tty's ports are not registered yet when these function are failed,
so brd->nasync set to zero.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 60b7d70..db24f70 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -954,19 +954,30 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 	 * Do tty device initialization.
 	 */
 	ret = dgap_tty_init(brd);
-	if (ret < 0) {
-		dgap_tty_uninit(brd);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_cleanup;
 
 	ret = dgap_tty_register_ports(brd);
 	if (ret)
-		return ret;
+		goto err_cleanup;
 
 	brd->state = BOARD_READY;
 	brd->dpastatus = BD_RUNNING;
 
 	return 0;
+
+err_cleanup:
+	/*
+	 * Clear nasync to zero for avoiding to call
+	 * some destroyer for tty's ports which are not
+	 * registered yet in dgap_tty_uninit().
+	 */
+	brd->nasync = 0;
+
+	dgap_tty_uninit(brd);
+	dgap_cleanup_board(brd);
+	return ret;
+
 }
 
 /*
-- 
1.7.1

