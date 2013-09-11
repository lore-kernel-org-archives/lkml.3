Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3IKEoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:44:14 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39613 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab3IKEoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:44:12 -0400
Date: Tue, 10 Sep 2013 21:40:43 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org
Subject: [PATCH] staging: dgap: fix overflows and format strings
Message-ID: <20130911044043.GA17276@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boot message buffer could potentially overflow the stack and the
heap. Additionally make sure format strings could not leak into printk()
calls.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/dgap/dgap_driver.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dgap/dgap_driver.c b/drivers/staging/dgap/dgap_driver.c
index 724a685..40ef785 100644
--- a/drivers/staging/dgap/dgap_driver.c
+++ b/drivers/staging/dgap/dgap_driver.c
@@ -474,7 +474,7 @@ static void dgap_cleanup_board(struct board_t *brd)
 
                 DGAP_LOCK(dgap_global_lock, flags);
                 brd->msgbuf = NULL;
-                printk(brd->msgbuf_head);
+                printk("%s", brd->msgbuf_head);
                 kfree(brd->msgbuf_head);
                 brd->msgbuf_head = NULL;
                 DGAP_UNLOCK(dgap_global_lock, flags);
@@ -628,7 +628,7 @@ static int dgap_found_board(struct pci_dev *pdev, int id)
 	DPR_INIT(("dgap_scan(%d) - printing out the msgbuf\n", i));
 	DGAP_LOCK(dgap_global_lock, flags);
 	brd->msgbuf = NULL;
-	printk(brd->msgbuf_head);
+	printk("%s", brd->msgbuf_head);
 	kfree(brd->msgbuf_head);
 	brd->msgbuf_head = NULL;
 	DGAP_UNLOCK(dgap_global_lock, flags);
@@ -955,25 +955,28 @@ static void dgap_mbuf(struct board_t *brd, const char *fmt, ...) {
 	char		buf[1024];
 	int		i;
 	unsigned long	flags;
+	size_t		length;
 
 	DGAP_LOCK(dgap_global_lock, flags);
 
 	/* Format buf using fmt and arguments contained in ap. */
 	va_start(ap, fmt);
-	i = vsprintf(buf, fmt,  ap);
+	i = vsnprintf(buf, sizeof(buf), fmt,  ap);
 	va_end(ap);
 
 	DPR((buf));
 
 	if (!brd || !brd->msgbuf) {
-		printk(buf);
+		printk("%s", buf);
 		DGAP_UNLOCK(dgap_global_lock, flags);
 		return;
 	}
 
-	memcpy(brd->msgbuf, buf, strlen(buf));
-	brd->msgbuf += strlen(buf);
-	*brd->msgbuf = 0;
+	length = strlen(buf) + 1;
+	if (brd->msgbuf - brd->msgbuf_head < length)
+		length = brd->msgbuf - brd->msgbuf_head;
+	memcpy(brd->msgbuf, buf, length);
+	brd->msgbuf += length;
 
 	DGAP_UNLOCK(dgap_global_lock, flags);
 }
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
