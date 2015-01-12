Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbbALP24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:28:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56458 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbALP2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:28:54 -0500
From: Colin King <colin.king@canonical.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][RESEND] static code analysis from cppcheck reports:
Date: Mon, 12 Jan 2015 15:27:52 +0000
Message-Id: <1421076472-7101-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[drivers/video/fbdev/broadsheetfb.c:673]:
  (error) Memory leak: sector_buffer

sector_buffer is not being kfree'd on each call to
broadsheet_spiflash_rewrite_sector(), so free it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/video/fbdev/broadsheetfb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/broadsheetfb.c b/drivers/video/fbdev/broadsheetfb.c
index 1c29bd1..0e5fde1 100644
--- a/drivers/video/fbdev/broadsheetfb.c
+++ b/drivers/video/fbdev/broadsheetfb.c
@@ -636,7 +636,7 @@ static int broadsheet_spiflash_rewrite_sector(struct broadsheetfb_par *par,
 		err = broadsheet_spiflash_read_range(par, start_sector_addr,
 						data_start_addr, sector_buffer);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	/* now we copy our data into the right place in the sector buffer */
@@ -657,7 +657,7 @@ static int broadsheet_spiflash_rewrite_sector(struct broadsheetfb_par *par,
 		err = broadsheet_spiflash_read_range(par, tail_start_addr,
 			tail_len, sector_buffer + tail_start_addr);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	/* if we got here we have the full sector that we want to rewrite. */
@@ -665,11 +665,13 @@ static int broadsheet_spiflash_rewrite_sector(struct broadsheetfb_par *par,
 	/* first erase the sector */
 	err = broadsheet_spiflash_erase_sector(par, start_sector_addr);
 	if (err)
-		return err;
+		goto out;
 
 	/* now write it */
 	err = broadsheet_spiflash_write_sector(par, start_sector_addr,
 					sector_buffer, sector_size);
+out:
+	kfree(sector_buffer);
 	return err;
 }
 
-- 
2.1.4

