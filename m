Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaLZBhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 20:37:19 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46708 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLZBhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 20:37:16 -0500
Date: Fri, 26 Dec 2014 10:34:32 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgap: use gotos for handling error in dgap_remap()
Message-ID: <20141226013432.GA29373@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index bdb5317..518ab56 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -1400,27 +1400,27 @@ static int dgap_remap(struct board_t *brd)
 		return -ENOMEM;
 
 	if (!request_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000,
-					"dgap")) {
-		release_mem_region(brd->membase, 0x200000);
-		return -ENOMEM;
-	}
+					"dgap"))
+		goto err_req_mem;
 
 	brd->re_map_membase = ioremap(brd->membase, 0x200000);
-	if (!brd->re_map_membase) {
-		release_mem_region(brd->membase, 0x200000);
-		release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
-		return -ENOMEM;
-	}
+	if (!brd->re_map_membase)
+		goto err_remap_mem;
 
 	brd->re_map_port = ioremap((brd->membase + PCI_IO_OFFSET), 0x200000);
-	if (!brd->re_map_port) {
-		release_mem_region(brd->membase, 0x200000);
-		release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
-		iounmap(brd->re_map_membase);
-		return -ENOMEM;
-	}
+	if (!brd->re_map_port)
+		goto err_remap_port;
 
 	return 0;
+
+err_remap_port:
+	iounmap(brd->re_map_membase);
+err_remap_mem:
+	release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
+err_req_mem:
+	release_mem_region(brd->membase, 0x200000);
+
+	return -ENOMEM;
 }
 
 static void dgap_unmap(struct board_t *brd)
-- 
1.7.1

