Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbaBEU1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:27:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:55291 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbaBEUHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mark Ferrell <mferrell@uplogix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 151/213] usb: serial: mos7840: Fixup mos7840_chars_in_buffer()
Date: Wed, 5 Feb 2014 15:01:46 -0500
Message-ID: <1391630568-49251-152-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Ferrell <mferrell@uplogix.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5c263b92f828af6a8cf54041db45ceae5af8f2ab upstream.

 * Use the buffer content length as opposed to the total buffer size.  This can
   be a real problem when using the mos7840 as a usb serial-console as all
   kernel output is truncated during boot.

Signed-off-by: Mark Ferrell <mferrell@uplogix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/mos7840.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index c55d2aa35eaa..a87c43012b5a 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1180,9 +1180,12 @@ static int mos7840_chars_in_buffer(struct tty_struct *tty)
 	}
 
 	spin_lock_irqsave(&mos7840_port->pool_lock, flags);
-	for (i = 0; i < NUM_URBS; ++i)
-		if (mos7840_port->busy[i])
-			chars += URB_TRANSFER_BUFFER_SIZE;
+	for (i = 0; i < NUM_URBS; ++i) {
+		if (mos7840_port->busy[i]) {
+			struct urb *urb = mos7840_port->write_urb_pool[i];
+			chars += urb->transfer_buffer_length;
+		}
+	}
 	spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
 	dbg("%s - returns %d", __func__, chars);
 	return chars;
-- 
1.8.5.2

