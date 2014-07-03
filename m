Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbaGCJW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:22:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51795 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455AbaGCJW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 069/198] USB: cdc-acm: fix shutdown and suspend race
Date: Thu,  3 Jul 2014 10:18:32 +0100
Message-Id: <1404379241-8590-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ed797074031a37bb9bf4a70952fffc606b77274d upstream.

We should stop I/O unconditionally at suspend rather than rely on the
tty-port initialised flag (which is set prior to stopping I/O during
shutdown) in order to prevent suspend returning with URBs still active.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ca53818690e3..014a1aa3f950 100644
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
1.9.1

