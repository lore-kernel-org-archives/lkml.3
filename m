Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaIGUng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 16:43:36 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:61599 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaIGUne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 16:43:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] rtc: pcf8563: fix uninitialized use warning
Date: Sun, 07 Sep 2014 22:42:43 +0200
Message-ID: <3640058.m4Rfp1dmTJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vyIvX/pu5ooSPjgADPg8g+ryeGD9DlqJkLTz1fKjGPP
 ZTv5erWPLGlhbFXL+qnXJCLkn5bmvqeUOTu+MTjIbZqIJiaW0e
 LZXMnDNKGA3lVilkybmVsGnaQOW8cmhbfWrFT6f841yFtws3nQ
 E6kc84paCOqgFhsYMnuDMeo5OqGrEpaXLVVCXG2PIgzchINqZe
 bVIQUb4DaN+USRXbLSbAZIH5KUF3IOXEe9kAV6ENlIyoal+Enq
 Uc1HsOmCFF0obgMXjOlKpxA6MRuoQjwc//KHXVNUzQnHhFapSi
 Gxm4o8WfH3F21H3Ut0XPwnWCCW4Bhjo/RsFwdEIBGf8z+w5H82
 kq//uQx4cOvQQ7VbJZQY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc-4.9 found a potential condition under which the 'pending'
variable may be used uninitialized:

drivers/rtc/rtc-pcf8563.c: In function 'pcf8563_irq':
drivers/rtc/rtc-pcf8563.c:173:5: warning: 'pending' may be used uninitialized in this function [-Wmaybe-uninitialized]

This is because in the pcf8563_get_alarm_mode() function, we
check any nonzero return of pcf8563_read_block_data, but
in the irq function we only check for negative values, so
a possible positive value does not get detected if the compiler
chooses not to inline the entire call chain.

Checking for any non-zero value in the interrupt handler as well
is just as correct and lets the compiler know what we are doing,
without needing a bogus initialization.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 5a197d9dc7e7..3a6f994c4da8 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -167,7 +167,7 @@ static irqreturn_t pcf8563_irq(int irq, void *dev_id)
 	char pending;
 
 	err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
-	if (err < 0)
+	if (err)
 		return err;
 
 	if (pending) {

