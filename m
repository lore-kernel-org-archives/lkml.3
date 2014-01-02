Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaABMI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:08:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaABMIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH, RFC 08/30] [media] arv: fix sleep_on race
Date: Thu,  2 Jan 2014 13:07:32 +0100
Message-Id: <1388664474-1710039-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:+TQ5heWpNyvUP2384k2a0HDQ+jvYxAZ5Z0wJOuyQObf
 92DwiNrMujzfWE6IpJSUIZ/4PCGKhJTdsZTdgdJOTne/0gF6N/
 BH02re2LsSeXum0t3v95dVOhf5dViEHzg2M+z+nSc18m42Kme/
 Fb120KUIdGb4qQBPx4i5Joedai3S1TvlGGuekVRh5v7Aht47St
 IzX//hvElXJI4JRMqJwo6SNpaEXc6bpn52GCpkrLNGm8ZzbuVB
 iIncImei/qadEQKvKDTbTQjvBNHA0Y0oroA9W1ZMxe4BWTEk7s
 Rrsk+oZrr/Vd1dvkvc8E2MBNEzDtCuP4603scrgk4qjcR1bG5e
 oXZdJOQbOoy730PwNfS149DrYcKjm44QtCC4XPIRz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptible_sleep_on is racy and going away. In the arv driver that
race has probably never caused problems since it would require a whole
video frame to be captured before the read function has a chance to
go to sleep, but using wait_event_interruptible lets us kill off the
old interface. In order to do this, we have to slightly adapt the
meaning of the ar->start_capture field to distinguish between not having
started a frame and having completed it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/platform/arv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/arv.c b/drivers/media/platform/arv.c
index e346d32d..32f6d70 100644
--- a/drivers/media/platform/arv.c
+++ b/drivers/media/platform/arv.c
@@ -307,11 +307,11 @@ static ssize_t ar_read(struct file *file, char *buf, size_t count, loff_t *ppos)
 	/*
 	 * Okay, kick AR LSI to invoke an interrupt
 	 */
-	ar->start_capture = 0;
+	ar->start_capture = -1;
 	ar_outl(arvcr1 | ARVCR1_HIEN, ARVCR1);
 	local_irq_restore(flags);
 	/* .... AR interrupts .... */
-	interruptible_sleep_on(&ar->wait);
+	wait_event_interruptible(ar->wait, ar->start_capture == 0);
 	if (signal_pending(current)) {
 		printk(KERN_ERR "arv: interrupted while get frame data.\n");
 		ret = -EINTR;
-- 
1.8.3.2

