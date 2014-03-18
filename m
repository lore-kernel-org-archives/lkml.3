Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbaCRSqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:46:39 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:39610 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638AbaCRSqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:46:36 -0400
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com, robherring2@gmail.com, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv4 4/5] mailbox: Fix TX completion init
Date: Wed, 19 Mar 2014 00:16:16 +0530
Message-Id: <1395168376-29200-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
References: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: LeyFoon Tan <lftan.linux@gmail.com>

For fast TX the complete could be called before being initialized as follows
 mbox_send_message --> poll_txdone --> tx_tick --> complete(&chan->tx_complete)

Init the completion early enough to fix the race.

Signed-off-by: LeyFoon Tan <lftan.linux@gmail.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 drivers/mailbox/mailbox.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 79d576e..cdf7d45 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -278,6 +278,9 @@ int mbox_send_message(struct mbox_chan *chan, void *mssg)
 	if (!chan || !chan->cl)
 		return -EINVAL;
 
+	if (chan->cl->tx_block)
+		init_completion(&chan->tx_complete);
+
 	t = _add_to_rbuf(chan, mssg);
 	if (t < 0) {
 		pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");
@@ -291,7 +294,6 @@ int mbox_send_message(struct mbox_chan *chan, void *mssg)
 
 	if (chan->cl->tx_block && chan->active_req) {
 		int ret;
-		init_completion(&chan->tx_complete);
 		ret = wait_for_completion_timeout(&chan->tx_complete,
 			chan->cl->tx_tout);
 		if (ret == 0) {
-- 
1.8.1.2

