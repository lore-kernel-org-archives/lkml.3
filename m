Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaIWAY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:24:26 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37538 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbaIWAYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:24:25 -0400
Date: Tue, 23 Sep 2014 09:22:36 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: dgap: use dgap_release_remap() in
 dgap_cleanup_board()
Message-ID: <20140923002236.GA20782@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just simply use dgap_release_remap() in dgap_cleanup_board() for
releasing map memory.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 637ea8a..d0be1ce 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -683,17 +683,7 @@ static void dgap_cleanup_board(struct board_t *brd)
 
 	tasklet_kill(&brd->helper_tasklet);
 
-	if (brd->re_map_port) {
-		release_mem_region(brd->membase + 0x200000, 0x200000);
-		iounmap(brd->re_map_port);
-		brd->re_map_port = NULL;
-	}
-
-	if (brd->re_map_membase) {
-		release_mem_region(brd->membase, 0x200000);
-		iounmap(brd->re_map_membase);
-		brd->re_map_membase = NULL;
-	}
+	dgap_release_remap(brd);
 
 	/* Free all allocated channels structs */
 	for (i = 0; i < MAXPORTS ; i++)
@@ -1023,10 +1013,15 @@ static int dgap_do_remap(struct board_t *brd)
 
 static void dgap_release_remap(struct board_t *brd)
 {
-	release_mem_region(brd->membase, 0x200000);
-	release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
-	iounmap(brd->re_map_membase);
-	iounmap(brd->re_map_port);
+	if (brd->re_map_membase) {
+		release_mem_region(brd->membase, 0x200000);
+		iounmap(brd->re_map_membase);
+	}
+
+	if (brd->re_map_port) {
+		release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
+		iounmap(brd->re_map_port);
+	}
 }
 /*****************************************************************************
 *
-- 
1.7.1

