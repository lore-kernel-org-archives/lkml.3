Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab3EOK5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 06:57:00 -0400
Received: from 8bytes.org ([85.214.48.195]:52840 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab3EOK47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 06:56:59 -0400
Date: Wed, 15 May 2013 12:56:56 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Add missing lock in n_tty_write()
Message-ID: <20130515105656.GI24440@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed May 15 12:56:57 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 519369f923674373111016
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call of the tty->ops->write callback is protected by
output_lock in all other places I looked at. So it seems the
lock in this code-branch is missing, so take the output_lock
there too.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/tty/n_tty.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index d655416..ffb94a4 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2058,10 +2058,14 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			if (tty->ops->flush_chars)
 				tty->ops->flush_chars(tty);
 		} else {
+			struct n_tty_data *l = tty->disc_data;
+
+			mutex_lock(&l->output_lock);
 			while (nr > 0) {
 				c = tty->ops->write(tty, b, nr);
 				if (c < 0) {
 					retval = c;
+					mutex_unlock(&l->output_lock);
 					goto break_out;
 				}
 				if (!c)
@@ -2069,6 +2073,7 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 				b += c;
 				nr -= c;
 			}
+			mutex_unlock(&l->output_lock);
 		}
 		if (!nr)
 			break;
-- 
1.7.9.5

