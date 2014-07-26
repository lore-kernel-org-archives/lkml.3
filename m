Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaGZOl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:41:57 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49860 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaGZOlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:41:55 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        navin patidar <navinp@cdac.in>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: stub_main.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:43:20 +0200
Message-Id: <1406385801-3757-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/usbip/stub_main.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 9c5832a..44ab43f 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -94,7 +94,7 @@ static int add_match_busid(char *busid)
 
 	for (i = 0; i < MAX_BUSID; i++)
 		if (!busid_table[i].name[0]) {
-			strncpy(busid_table[i].name, busid, BUSID_SIZE);
+			strlcpy(busid_table[i].name, busid, BUSID_SIZE);
 			if ((busid_table[i].status != STUB_BUSID_ALLOC) &&
 			    (busid_table[i].status != STUB_BUSID_REMOV))
 				busid_table[i].status = STUB_BUSID_ADDED;
@@ -158,15 +158,11 @@ static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
 	if (count < 5)
 		return -EINVAL;
 
-	/* strnlen() does not include \0 */
-	len = strnlen(buf + 4, BUSID_SIZE);
-
 	/* busid needs to include \0 termination */
-	if (!(len < BUSID_SIZE))
+	len = strlcpy(busid, buf + 4, BUSID_SIZE);
+	if (sizeof(busid) <= len)
 		return -EINVAL;
 
-	strncpy(busid, buf + 4, BUSID_SIZE);
-
 	if (!strncmp(buf, "add ", 4)) {
 		if (add_match_busid(busid) < 0)
 			return -ENOMEM;
-- 
1.7.10.4

