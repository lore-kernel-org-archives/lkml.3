Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3K2XBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 18:01:05 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:37545 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3K2XBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 18:01:01 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] drivers/misc/ti-st: Prefer tty_driver_flush_buffer
Date: Fri, 29 Nov 2013 18:00:35 -0500
Message-Id: <1385766035-5029-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty core provides an interface for flushing the driver's
write buffer: tty_driver_flush_buffer(); prefer the provided
interface over open-coded. Open-coding can lead to errors
such as the duplicated call in the st_kim driver.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/misc/ti-st/st_core.c | 2 +-
 drivers/misc/ti-st/st_kim.c  | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 8d64b68..3aed525 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -812,7 +812,7 @@ static void st_tty_flush_buffer(struct tty_struct *tty)
 	kfree_skb(st_gdata->tx_skb);
 	st_gdata->tx_skb = NULL;
 
-	tty->ops->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
 	return;
 }
 
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 83907c7..9c14b07 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -531,7 +531,6 @@ long st_kim_stop(void *kim_data)
 		/* Flush any pending characters in the driver and discipline. */
 		tty_ldisc_flush(tty);
 		tty_driver_flush_buffer(tty);
-		tty->ops->flush_buffer(tty);
 	}
 
 	/* send uninstall notification to UIM */
-- 
1.8.1.2

