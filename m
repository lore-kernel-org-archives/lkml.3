Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbaLJUQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:16:34 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35342 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaLJUQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:16:31 -0500
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: jaswinder.singh@linaro.org
Cc: broonie@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-acpi@lists.linaro.org,
        patches@linaro.org, arnd@arndb.de,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>
Subject: [PATCH] Mailbox: Complete wait event only if Tx was successful
Date: Wed, 10 Dec 2014 15:16:12 -0500
Message-Id: <1418242572-20998-1-git-send-email-ashwin.chaugule@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a wait_for_completion_timeout() call returns due to a timeout,
the mbox code can still call complete() after returning from the wait.
This can cause subsequent transmissions on a channel to fail, since
the wait_for_completion_timeout() sees the completion variable
is !=0, caused by the erroneous complete() call, and immediately
returns without waiting for the time as expected by the client.

Fix this by calling complete() only if the TX was successful.

Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
---
 drivers/mailbox/mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 17e9e4a..4acaddb 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -101,7 +101,7 @@ static void tx_tick(struct mbox_chan *chan, int r)
 	if (mssg && chan->cl->tx_done)
 		chan->cl->tx_done(chan->cl, mssg, r);
 
-	if (chan->cl->tx_block)
+	if ((!r) && chan->cl->tx_block)
 		complete(&chan->tx_complete);
 }
 
-- 
1.9.1

