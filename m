Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaDEUzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 16:55:08 -0400
Received: from mail.ispras.ru ([83.149.199.45]:41378 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbaDEUzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 16:55:05 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] input: pcap2: avoid calling mutex_lock() in irq handler
Date: Sun,  6 Apr 2014 00:54:50 +0400
Message-Id: <1396731290-7062-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcap_keys_handler() calls ezx_pcap_read() that calls mutex_lock().
pcap_keys_handler() is registered as nonthreaded irq handler,
that means sleeping function is called in irq handler.

The patch makes a switch to threaded irq handling.
Compile tested only.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/input/misc/pcap_keys.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/input/misc/pcap_keys.c b/drivers/input/misc/pcap_keys.c
index cd230365166e..2a10f3a30969 100644
--- a/drivers/input/misc/pcap_keys.c
+++ b/drivers/input/misc/pcap_keys.c
@@ -79,13 +79,15 @@ static int pcap_keys_probe(struct platform_device *pdev)
 	if (err)
 		goto fail_allocate;
 
-	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
-			pcap_keys_handler, 0, "Power key", pcap_keys);
+	err = request_threaded_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
+				   NULL, pcap_keys_handler, 0,
+				   "Power key", pcap_keys);
 	if (err)
 		goto fail_register;
 
-	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
-			pcap_keys_handler, 0, "Headphone button", pcap_keys);
+	err = request_threaded_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
+				   NULL, pcap_keys_handler, 0,
+				   "Headphone button", pcap_keys);
 	if (err)
 		goto fail_pwrkey;
 
-- 
1.8.3.2

