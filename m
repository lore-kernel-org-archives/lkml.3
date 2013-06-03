Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3FCTVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:21:22 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57404 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab3FCTVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:21:19 -0400
From: Nikolay Balandin <n.a.balandin@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Dmitry Krivoschekov <dkrivoschokov@dev.rtsoft.ru>,
        Alexander Stauffenberg <Alexander.Stauffenberg@kontron.com>,
        Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Subject: [PATCH v1 1/1] Documentation/rtc: update ioctl return values checkings in example code
Date: Mon,  3 Jun 2013 23:20:22 +0400
Message-Id: <1370287222-24417-1-git-send-email-n.a.balandin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Update ioctl return values for rtc example code to correctly determine
does the rtc driver support corresponding IRQ type or not.

According to the rtc subsystem interface return values:
 For the update and alarm interrupts rtc subsystem interface will
return -EINVAL error code if a device driver does not implement
corresponding handler (RTC_UIE_ON or RTC_ALM_SET).
 For the periodic IRQs (RTC_IRQP_READ) rtc-dev will return 0 as a period
if rtc->irq_freq property is not initialized.

Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
---
 Documentation/rtc.txt |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index 32aa400..f911e4a 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -270,7 +270,7 @@ int main(int argc, char **argv)
 	/* Turn on update interrupts (one per second) */
 	retval = ioctl(fd, RTC_UIE_ON, 0);
 	if (retval == -1) {
-		if (errno == ENOTTY) {
+		if (errno == EINVAL) {
 			fprintf(stderr,
 				"\n...Update IRQs not supported.\n");
 			goto test_READ;
@@ -353,7 +353,7 @@ test_READ:
 
 	retval = ioctl(fd, RTC_ALM_SET, &rtc_tm);
 	if (retval == -1) {
-		if (errno == ENOTTY) {
+		if (errno == EINVAL) {
 			fprintf(stderr,
 				"\n...Alarm IRQs not supported.\n");
 			goto test_PIE;
@@ -401,13 +401,12 @@ test_PIE:
 	/* Read periodic IRQ rate */
 	retval = ioctl(fd, RTC_IRQP_READ, &tmp);
 	if (retval == -1) {
-		/* not all RTCs support periodic IRQs */
-		if (errno == ENOTTY) {
-			fprintf(stderr, "\nNo periodic IRQ support\n");
-			goto done;
-		}
 		perror("RTC_IRQP_READ ioctl");
 		exit(errno);
+	} else if (tmp == 0) {
+		/* not all RTCs support periodic IRQs */
+		fprintf(stderr, "\nNo periodic IRQ support\n");
+		goto done;
 	}
 	fprintf(stderr, "\nPeriodic IRQ rate is %ldHz.\n", tmp);
 
-- 
1.7.9.5

