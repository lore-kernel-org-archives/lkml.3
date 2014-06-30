Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaF3MW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:22:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51928 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbaF3LxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 062/181] USB: cdc-acm: fix shutdown and suspend race
Date: Mon, 30 Jun 2014 13:51:23 +0200
Message-Id: <6a8e4fe2bd2077c1c3f817c7fbafc32d01655a94.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ed797074031a37bb9bf4a70952fffc606b77274d upstream.

We should stop I/O unconditionally at suspend rather than rely on the
tty-port initialised flag (which is set prior to stopping I/O during
shutdown) in order to prevent suspend returning with URBs still active.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index d89871b49f11..ae4d028b4209 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1456,8 +1456,7 @@ static int acm_suspend(struct usb_interface *intf, pm_message_t message)
 	if (cnt)
 		return 0;
 
-	if (test_bit(ASYNCB_INITIALIZED, &acm->port.flags))
-		stop_data_traffic(acm);
+	stop_data_traffic(acm);
 
 	return 0;
 }
-- 
2.0.0

