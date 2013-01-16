Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab3APJIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:08:18 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:56351 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932426Ab3APJHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:07:53 -0500
Message-ID: <50F66DE6.6080101@ilyx.ru>
Date: Wed, 16 Jan 2013 13:07:50 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
References: <50B45A49.2040104@ilyx.ru> <20121127172406.GE24592@kroah.com> <50B50AA0.7070603@ilyx.ru> <20121127193208.331673ae@pyramind.ukuu.org.uk>
In-Reply-To: <20121127193208.331673ae@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression 'tty: fix "IRQ45: nobody cared"'
Regression commit 7b292b4bf9a9d6098440d85616d6ca4c608b8304

  Function reset_buffer_flags() also invoked during the ioctl(...,TCFLSH,..). 
At the time of request we can have full buffers and throttled driver too. 
If we don't unthrottle driver, we can get forever throttled driver, because,
after request, we will have empty buffers and throttled driver and 
there is no place to unthrottle driver.
It simple reproduce with "pty" pair then one side sleep on tty->write_wait,
and other side do ioctl(...,TCFLSH,..). Then there is no place to do writers wake up.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
 drivers/tty/tty_ioctl.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 8481b29..cc0fc52 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1096,12 +1096,16 @@ int tty_perform_flush(struct tty_struct *tty, unsigned long arg)
 	ld = tty_ldisc_ref_wait(tty);
 	switch (arg) {
 	case TCIFLUSH:
-		if (ld && ld->ops->flush_buffer)
+		if (ld && ld->ops->flush_buffer) {
 			ld->ops->flush_buffer(tty);
+			tty_unthrottle(tty);
+		}
 		break;
 	case TCIOFLUSH:
-		if (ld && ld->ops->flush_buffer)
+		if (ld && ld->ops->flush_buffer) {
 			ld->ops->flush_buffer(tty);
+			tty_unthrottle(tty);
+		}
 		/* fall through */
 	case TCOFLUSH:
 		tty_driver_flush_buffer(tty);
