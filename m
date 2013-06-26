Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3FZM25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:28:57 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60787 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3FZM24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:28:56 -0400
Date: Wed, 26 Jun 2013 15:28:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: [PATCH staging-next] zram: protect zram_reset_device() call
Message-ID: <20130626122839.GA2268@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9b3bb7abcdf2df0f1b2657e6cbc9d06bc2b3b36f (remove
zram_sysfs file (v2)) accidentally made zram_reset_device()
racy. Protect zram_reset_device() call with zram->lock.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---
 drivers/staging/zram/zram_drv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 82c7202..e77fb6e 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -527,8 +527,11 @@ static void zram_reset_device(struct zram *zram)
 	size_t index;
 	struct zram_meta *meta;
 
-	if (!zram->init_done)
+	down_write(&zram->init_lock);
+	if (!zram->init_done) {
+		up_write(&zram->init_lock);
 		return;
+	}
 
 	meta = zram->meta;
 	zram->init_done = 0;
@@ -549,6 +552,7 @@ static void zram_reset_device(struct zram *zram)
 
 	zram->disksize = 0;
 	set_capacity(zram->disk, 0);
+	up_write(&zram->init_lock);
 }
 
 static void zram_init_device(struct zram *zram, struct zram_meta *meta)

