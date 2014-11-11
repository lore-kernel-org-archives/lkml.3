Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaKKScy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:32:54 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50704 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751883AbaKKScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:32:53 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Sudeep Holla <sudeep.holla@arm.com>,
        Jassi Brar <jaswinder.singh@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] mailbox: add tx_prepare client callback
Date: Tue, 11 Nov 2014 18:33:01 +0000
Message-Id: <1415730781-17819-1-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415721852-10193-1-git-send-email-sudeep.holla@arm.com>
References: <1415721852-10193-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the mailbox controller expects the payload is in place before
initiating the transmit, then it's impossible to reuse the list
maintained by core mailbox code currently. Maintaining another list
for sending the message in the controller seems totally unnecessary
as core mailbox library already provides that feature.

This patch introduces tx_prepare callback in mbox_client which
can be used by the core mailbox library before initiating the
transaction through mbox->ops->send_data. The client driver can
implement this callback to ensure the payload is copied to the
shared memory.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/mailbox/mailbox.c      | 2 ++
 include/linux/mailbox_client.h | 3 +++
 2 files changed, 5 insertions(+)

v1->v2: Added missing documentation for tx_prepare callback

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 17e9e4afc528..06b27e2854a3 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -74,6 +74,8 @@ static void msg_submit(struct mbox_chan *chan)
 
 	data = chan->msg_data[idx];
 
+	if (chan->cl->tx_prepare)
+		chan->cl->tx_prepare(chan->cl, data);
 	/* Try to submit a message to the MBOX controller */
 	err = chan->mbox->ops->send_data(chan, data);
 	if (!err) {
diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
index 307d9cab2026..1726ccbd8009 100644
--- a/include/linux/mailbox_client.h
+++ b/include/linux/mailbox_client.h
@@ -25,6 +25,8 @@ struct mbox_chan;
  *			if the client receives some ACK packet for transmission.
  *			Unused if the controller already has TX_Done/RTR IRQ.
  * @rx_callback:	Atomic callback to provide client the data received
+ * @tx_prepare: 	Atomic callback to ask client to prepare the payload
+ *			before initiating the transmission if required.
  * @tx_done:		Atomic callback to tell client of data transmission
  */
 struct mbox_client {
@@ -34,6 +36,7 @@ struct mbox_client {
 	bool knows_txdone;
 
 	void (*rx_callback)(struct mbox_client *cl, void *mssg);
+	void (*tx_prepare)(struct mbox_client *cl, void *mssg);
 	void (*tx_done)(struct mbox_client *cl, void *mssg, int r);
 };
 
-- 
1.9.1

