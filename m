Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaFMUlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:41:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40456 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaFMUlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:41:46 -0400
From: Mark Brown <broonie@kernel.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Fri, 13 Jun 2014 21:41:35 +0100
Message-Id: <1402692095-23126-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402692095-23126-1-git-send-email-broonie@kernel.org>
References: <1402692095-23126-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/2] mailbox: Remove const from client argument of mbox_request_channel()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

The struct mbox_client supplied to mbox_request_channel() is const but
it is stored in the channel in a non-constant member causing compiler
warnings.

While the mailbox API should treat the struct mailbox_client as const
itself the struct is passed back to the channel in callbacks without
a const so we need to either remove the const, change the callbacks to
take const or cast the const away when doing callbacks. Take the simplest
option and just remove the const.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mailbox/mailbox.c      | 2 +-
 include/linux/mailbox_client.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index ae4abd9f7513..662f8e550473 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -294,7 +294,7 @@ EXPORT_SYMBOL_GPL(mbox_send_message);
  * Return: Pointer to the channel assigned to the client if successful.
  *		ERR_PTR for request failure.
  */
-struct mbox_chan *mbox_request_channel(const struct mbox_client *cl)
+struct mbox_chan *mbox_request_channel(struct mbox_client *cl)
 {
 	struct device *dev = cl->dev;
 	struct mbox_controller *mbox;
diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
index cbfcf8478ca9..955f3d7641e8 100644
--- a/include/linux/mailbox_client.h
+++ b/include/linux/mailbox_client.h
@@ -37,7 +37,7 @@ struct mbox_client {
 	bool knows_txdone;
 };
 
-struct mbox_chan *mbox_request_channel(const struct mbox_client *cl);
+struct mbox_chan *mbox_request_channel(struct mbox_client *cl);
 int mbox_send_message(struct mbox_chan *chan, void *mssg);
 void mbox_client_txdone(struct mbox_chan *chan, int r);
 bool mbox_client_peek_data(struct mbox_chan *chan);
-- 
2.0.0

