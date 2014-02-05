Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaBEUH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:07:29 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48462 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaBEUHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 156/213] usbdevfs: Correct amount of data copied to user in processcompl_compat
Date: Wed, 5 Feb 2014 15:01:51 -0500
Message-ID: <1391630568-49251-157-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2102e06a5f2e414694921f23591f072a5ba7db9f upstream.

iso data buffers may have holes in them if some packets were short, so for
iso urbs we should always copy the entire buffer, just like the regular
processcompl does.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/devio.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 85a496754780..3437cf2cdcaf 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1527,10 +1527,14 @@ static int processcompl_compat(struct async *as, void __user * __user *arg)
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer && urb->actual_length)
-		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->actual_length))
+	if (as->userbuffer && urb->actual_length) {
+		if (urb->number_of_packets > 0)		/* Isochronous */
+			i = urb->transfer_buffer_length;
+		else					/* Non-Isoc */
+			i = urb->actual_length;
+		if (copy_to_user(as->userbuffer, urb->transfer_buffer, i))
 			return -EFAULT;
+	}
 	if (put_user(as->status, &userurb->status))
 		return -EFAULT;
 	if (put_user(urb->actual_length, &userurb->actual_length))
-- 
1.8.5.2

