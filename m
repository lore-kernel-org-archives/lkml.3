Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaL0SmP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 13:42:15 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47703 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaL0SmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 13:42:11 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Monam Agarwal <monamagarwal123@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ft1000: ft1000-usb: ft1000_hw.c:  Fix a potential memory leak.
Date: Sat, 27 Dec 2014 19:45:07 +0100
Message-Id: <1419705907-5937-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid allocate memory if we will exit the function.

Was found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 2e13e7b..72b8f03 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -331,15 +331,15 @@ int card_send_command(struct ft1000_usb *ft1000dev, void *ptempbuffer,
 
 	DEBUG("card_send_command: enter card_send_command... size=%d\n", size);
 
+	ret = ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
+	if (ret)
+		return ret;
+
 	commandbuf = kmalloc(size + 2, GFP_KERNEL);
 	if (!commandbuf)
 		return -ENOMEM;
 	memcpy((void *)commandbuf + 2, (void *)ptempbuffer, size);
 
-	ret = ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
-	if (ret)
-		return ret;
-
 	if (temp & 0x0100)
 		usleep_range(900, 1100);
 
-- 
1.7.10.4

