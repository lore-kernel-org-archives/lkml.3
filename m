Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaABMLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:11:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50515 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaABMIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH, RFC 29/30] char: nwbutton: open-code interruptible_sleep_on
Date: Thu,  2 Jan 2014 13:07:53 +0100
Message-Id: <1388664474-1710039-30-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:spXZ1bBTzFUQT9QlgI2vjb6wQpWfJti//T11zuMb4pb
 eL4wE/Uu4Jy1GorxHj2v9hUXmzog+zOIiI5x9exIULNRYG69D0
 av5WvKVRoDxdHsWWxr/Wx8j1Qmn3LGoIiX/fld+mb9U63e88/Q
 mmFcEYXw/UIXT//Xl1aYafpEGhqwSyW85W5nDUPMoDYxQuhSr1
 X8SwiUuzxcRoFycl8PIAySltkrW1//+AxYXzX3mTnv4ZQsbPoS
 xb3LG5q4AmTk1/HidRMSGgSW7P2+mCGaQO+ybh9qLpXdyV8IG/
 IkKQW5V/QuRe31lSCkeVA6OmC1VZNTRR8MKNF7GpBKsQkazlYc
 gH8DLIDOBib0TYHPtCkI2PASu4l4kGPZ2Rsff9Jij
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nwbutton driver uses interruptible_sleep_on to wait for buttons
getting pressed after we enter the read() function, which is inherently
racy and cannot be fixed by using wait_event without changing the
driver's user space interface.

Instead, this patch just uses an open-coded variant of the same
interruptible_sleep_on() call, so the driver behavior doesn't change
but we remove the sleep_on family from the kernel.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/nwbutton.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/nwbutton.c b/drivers/char/nwbutton.c
index 1fd00dc..76c490f 100644
--- a/drivers/char/nwbutton.c
+++ b/drivers/char/nwbutton.c
@@ -168,7 +168,10 @@ static irqreturn_t button_handler (int irq, void *dev_id)
 static int button_read (struct file *filp, char __user *buffer,
 			size_t count, loff_t *ppos)
 {
-	interruptible_sleep_on (&button_wait_queue);
+	DEFINE_WAIT(wait);
+	prepare_to_wait(&button_wait_queue, &wait, TASK_INTERRUPTIBLE);
+	schedule();
+	finish_wait(&button_wait_queue, &wait);
 	return (copy_to_user (buffer, &button_output_buffer, bcount))
 		 ? -EFAULT : bcount;
 }
-- 
1.8.3.2

