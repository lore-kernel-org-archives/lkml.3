Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaFBFIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 01:08:35 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54936 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaFBFIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 01:08:34 -0400
Date: Mon, 2 Jun 2014 14:07:46 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] staging: dgap: unwind on error in dgap_tty_init()
Message-ID: <20140602050746.GA29907@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kzalloc() fails for channels, it need to handle
that error. It should free channels which were already
allocated.

And also removes the call to dgap_tty_uninit() in
dgap_firmware_load().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index fcfa061..8580f4b 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -957,10 +957,8 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 	 * Do tty device initialization.
 	 */
 	ret = dgap_tty_init(brd);
-	if (ret < 0) {
-		dgap_tty_uninit(brd);
+	if (ret < 0)
 		return ret;
-	}
 
 	ret = dgap_tty_register_ports(brd);
 	if (ret)
@@ -1330,6 +1328,7 @@ static int dgap_tty_init(struct board_t *brd)
 	struct channel_t *ch;
 	struct bs_t __iomem *bs;
 	struct cm_t __iomem *cm;
+	int ret;
 
 	if (!brd)
 		return -EIO;
@@ -1381,8 +1380,10 @@ static int dgap_tty_init(struct board_t *brd)
 	for (i = 0; i < brd->nasync; i++) {
 		brd->channels[i] =
 			kzalloc(sizeof(struct channel_t), GFP_KERNEL);
-		if (!brd->channels[i])
-			return -ENOMEM;
+		if (!brd->channels[i]) {
+			ret = -ENOMEM;
+			goto free_chan;
+		}
 	}
 
 	ch = brd->channels[0];
@@ -1478,6 +1479,13 @@ static int dgap_tty_init(struct board_t *brd)
 	}
 
 	return 0;
+
+free_chan:
+	while (--i >= 0) {
+		kfree(brd->channels[i]);
+		brd->channels[i] = NULL;
+	}
+	return ret;
 }
 
 /*
-- 
1.7.1

