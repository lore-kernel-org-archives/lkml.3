Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaABMMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:12:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaABMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH, RFC 09/30] staging: serqt_usb2: don't use sleep_on
Date: Thu,  2 Jan 2014 13:07:33 +0100
Message-Id: <1388664474-1710039-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:e+9Qf89/r8ZC19bb/PWvAtvrbXU2YXGJUHmR1GyZ1l8
 AXaKDg2tmlkl7kqb/gi9itmpsCuPzLYPT8DR3KDvIeePEYHUev
 I1/Lo1w8oTD9dOWivaqPuZEsmasgQaY+cbbZao0fjmJG0aycNp
 UQ3/fGZ11l7cp+ZrmvlSdjXHNutGgsj3aLd694c1ktBVUa+JM3
 AUvUm24Lnf6ZMJqBQOEP77rB9vZh48mDx19lSJBhac7bGPkWjF
 s9qriU0Pi9FC6IJGFOoOEHpWyLDE6ltOsQE5tMI1HgiA7lmeyz
 9flvxC73zK+q/2MrTC5fSjE9y+dEM8o3Puxokv82fnU72fhvRP
 f6GFp1bXQcEb2uHcW16WE9GryY1NDL3NQJp3EEvIV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep_on and related functions are going away and should not be used
in this driver any more.

This removes the call to interruptible_sleep_on for a wait queue that
is never woken up, and replaces an interruptible_sleep_on_timeout
call with the equivalent wait_event_interruptible_timeout() to
avoid a small race.

Both call sites still look fishy and need more work.

Signed-off-by: Arnd Bergmann <arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
Cc: Bill Pemberton <wfp5p@virginia.edu>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 73fc3cc..e0c209e 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -970,17 +970,11 @@ static void qt_block_until_empty(struct tty_struct *tty,
 {
 	int timeout = HZ / 10;
 	int wait = 30;
-	int count;
-
-	while (1) {
-
-		count = qt_chars_in_buffer(tty);
-
-		if (count <= 0)
-			return;
-
-		interruptible_sleep_on_timeout(&qt_port->wait, timeout);
 
+	/* returns if we get a signal, an error, or the buffer is empty */
+	while (wait_event_interruptible_timeout(qt_port->wait,
+					qt_chars_in_buffer(tty) <= 0,
+					timeout) == 0) {
 		wait--;
 		if (wait == 0) {
 			dev_dbg(&qt_port->port->dev, "%s - TIMEOUT", __func__);
@@ -1137,7 +1131,10 @@ static int qt_ioctl(struct tty_struct *tty,
 
 	if (cmd == TIOCMIWAIT) {
 		while (qt_port != NULL) {
+#if 0
+			/* this never wakes up */
 			interruptible_sleep_on(&qt_port->msr_wait);
+#endif
 			if (signal_pending(current))
 				return -ERESTARTSYS;
 			else {
-- 
1.8.3.2

