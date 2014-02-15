Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaBOS02 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 13:26:28 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42660 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbaBOS01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 13:26:27 -0500
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv3 4/6] mailbox: Fix TX completion init
Date: Sat, 15 Feb 2014 23:56:11 +0530
Message-Id: <1392488771-18072-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: LeyFoon Tan <lftan.linux@gmail.com>

For fast TX the complete could be called before being initialized as follows
 ipc_send_message --> poll_txdone --> tx_tick --> complete(&chan->tx_complete)

Init the completion early enough to fix the race.

Signed-off-by: LeyFoon Tan <lftan.linux@gmail.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 drivers/mailbox/mailbox.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 3082f08..f8b31da 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -258,6 +258,9 @@ request_token_t ipc_send_message(void *channel, void *mssg)
 	if (!chan || !chan->assigned)
 		return 0;
 
+	if (chan->tx_block)
+		init_completion(&chan->tx_complete);
+
 	t = _add_to_rbuf(chan, mssg);
 	if (!t)
 		pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");
@@ -269,7 +272,6 @@ request_token_t ipc_send_message(void *channel, void *mssg)
 
 	if (chan->tx_block && chan->active_req) {
 		int ret;
-		init_completion(&chan->tx_complete);
 		ret = wait_for_completion_timeout(&chan->tx_complete,
 			chan->tx_tout);
 		if (ret == 0) {
-- 
1.8.1.2

