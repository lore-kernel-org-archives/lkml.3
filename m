Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaI3Vir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32854 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaI3Vin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 045/103] USB: option: reduce interrupt-urb logging verbosity
Date: Tue, 30 Sep 2014 14:30:50 -0700
Message-Id: <1412112708-27356-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit f0e4cba2534cd88476dff920727c81350130f3c5 upstream.

Do not log normal interrupt-urb shutdowns as errors.

The option driver has always been logging any nonzero interrupt-urb
status as an error, including when the urb is killed during normal
operation.

Commit 9096f1fbba91 ("USB: usb_wwan: fix potential NULL-deref at
resume") moved the interrupt urb submission from port probe and release
to open and close, thus potentially increasing the number of these
false-positive error messages dramatically.

Reported-by: Ed Butler <ressy66@ausics.net>
Tested-by: Ed Butler <ressy66@ausics.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 04d3eef..2ab1c8c 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1917,6 +1917,8 @@ static void option_instat_callback(struct urb *urb)
 			dev_dbg(dev, "%s: type %x req %x\n", __func__,
 				req_pkt->bRequestType, req_pkt->bRequest);
 		}
+	} else if (status == -ENOENT || status == -ESHUTDOWN) {
+		dev_dbg(dev, "%s: urb stopped: %d\n", __func__, status);
 	} else
 		dev_err(dev, "%s: error %d\n", __func__, status);
 
-- 
1.9.1

