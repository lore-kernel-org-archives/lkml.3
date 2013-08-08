Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab3HHIAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:00:49 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63108 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934027Ab3HHIAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:00:46 -0400
From: Milo Kim <woogyom.kim@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Milo Kim <milo.kim@ti.com>
Subject: [PATCH 08/10] leds: lp5523: remove unnecessary writing commands
Date: Thu,  8 Aug 2013 16:59:52 +0900
Message-Id: <1375948794-6286-9-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reduces the number of programming commands.

(Count of sending commands)
Old code: 32 + program size (32 counts for clearing program memory)
New code: 32

Pattern buffer is initialized to 0 in this function.
Just update new program data and remaining buffers are filled with 0.
So it's needless to clear whole area.

Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5523.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 9b8be6f6..fe3bcbb 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -312,17 +312,11 @@ static int lp5523_update_program_memory(struct lp55xx_chip *chip,
 	u8 pattern[LP5523_PROGRAM_LENGTH] = {0};
 	unsigned cmd;
 	char c[3];
-	int update_size;
 	int nrchars;
-	int offset = 0;
 	int ret;
-	int i;
-
-	/* clear program memory before updating */
-	for (i = 0; i < LP5523_PROGRAM_LENGTH; i++)
-		lp55xx_write(chip, LP5523_REG_PROG_MEM + i, 0);
+	int offset = 0;
+	int i = 0;
 
-	i = 0;
 	while ((offset < size - 1) && (i < LP5523_PROGRAM_LENGTH)) {
 		/* separate sscanfs because length is working only for %s */
 		ret = sscanf(data + offset, "%2s%n ", c, &nrchars);
@@ -342,11 +336,9 @@ static int lp5523_update_program_memory(struct lp55xx_chip *chip,
 	if (i % 2)
 		goto err;
 
-	update_size = i;
-
 	mutex_lock(&chip->lock);
 
-	for (i = 0; i < update_size; i++) {
+	for (i = 0; i < LP5523_PROGRAM_LENGTH; i++) {
 		ret = lp55xx_write(chip, LP5523_REG_PROG_MEM + i, pattern[i]);
 		if (ret) {
 			mutex_unlock(&chip->lock);
-- 
1.7.9.5

