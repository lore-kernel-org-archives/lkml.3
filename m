Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaEOGM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:12:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37188 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbaEOGM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:12:26 -0400
X-Google-Original-From: Jassi Brar <jaswinder.singh@linaro.org>
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, loic.pallardy@st.com,
        lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, robherring2@gmail.com, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv5 3/4] mailbox: Fix TX completion init
Date: Thu, 15 May 2014 11:41:41 +0530
Message-Id: <1400134301-4010-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
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
index 921fedd3..befb256 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -245,6 +245,9 @@ int mbox_send_message(struct mbox_chan *chan, void *mssg)
 	if (!chan || !chan->cl)
 		return -EINVAL;
 
+	if (chan->cl->tx_block)
+		init_completion(&chan->tx_complete);
+
 	t = _add_to_rbuf(chan, mssg);
 	if (t < 0) {
 		pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");
@@ -258,7 +261,6 @@ int mbox_send_message(struct mbox_chan *chan, void *mssg)
 
 	if (chan->cl->tx_block && chan->active_req) {
 		int ret;
-		init_completion(&chan->tx_complete);
 		ret = wait_for_completion_timeout(&chan->tx_complete,
 			chan->cl->tx_tout);
 		if (ret == 0) {
-- 
1.8.1.2

