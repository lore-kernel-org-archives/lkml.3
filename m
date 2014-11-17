Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaKQWvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:51:18 -0500
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58579 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaKQWue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:50:34 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: [PATCH V5 03/12] mailbox: Fix up error handling in mbox_request_channel()
Date: Mon, 17 Nov 2014 14:41:33 -0800
Message-Id: <1416264102-1323-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1416264102-1323-1-git-send-email-abrestic@chromium.org>
References: <1416264102-1323-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benson Leung <bleung@chromium.org>

mbox_request_channel() currently returns EBUSY in the event the controller
is not present or if of_xlate() fails, but in neither case is EBUSY really
appropriate.  Return EPROBE_DEFER if the controller is not yet present
and change of_xlate() to return an ERR_PTR instead of NULL so that the
error can be propagated back to the caller of mbox_request_channel().

Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
New for v5.
---
 drivers/mailbox/mailbox.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index c281e55..7b1e258 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -318,7 +318,7 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 		return ERR_PTR(-ENODEV);
 	}
 
-	chan = NULL;
+	chan = ERR_PTR(-EPROBE_DEFER);
 	list_for_each_entry(mbox, &mbox_cons, node)
 		if (mbox->dev->of_node == spec.np) {
 			chan = mbox->of_xlate(mbox, &spec);
@@ -327,7 +327,12 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 
 	of_node_put(spec.np);
 
-	if (!chan || chan->cl || !try_module_get(mbox->dev->driver->owner)) {
+	if (IS_ERR(chan)) {
+		mutex_unlock(&con_mutex);
+		return chan;
+	}
+
+	if (chan->cl || !try_module_get(mbox->dev->driver->owner)) {
 		dev_dbg(dev, "%s: mailbox not free\n", __func__);
 		mutex_unlock(&con_mutex);
 		return ERR_PTR(-EBUSY);
@@ -390,7 +395,7 @@ of_mbox_index_xlate(struct mbox_controller *mbox,
 	int ind = sp->args[0];
 
 	if (ind >= mbox->num_chans)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	return &mbox->chans[ind];
 }
-- 
2.1.0.rc2.206.gedb03e5

