Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab3KYNMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:12:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57344 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab3KYNJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:09:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Mazur <krzysiek@podlesie.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 73/78] usb: fix cleanup after failure in hub_configure()
Date: Mon, 25 Nov 2013 13:07:00 +0000
Message-Id: <1385384825-21681-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Mazur <krzysiek@podlesie.net>

commit d0308d4b6b02597f39fc31a9bddf7bb3faad5622 upstream.

If the hub_configure() fails after setting the hdev->maxchild
the hub->ports might be NULL or point to uninitialized kzallocated
memory causing NULL pointer dereference in hub_quiesce() during cleanup.

Now after such error the hdev->maxchild is set to 0 to avoid cleanup
of uninitialized ports.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index b5503b0..b79aa83 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1562,6 +1562,7 @@ static int hub_configure(struct usb_hub *hub,
 	return 0;
 
 fail:
+	hdev->maxchild = 0;
 	dev_err (hub_dev, "config failed, %s (err %d)\n",
 			message, ret);
 	/* hub_disconnect() frees urb and descriptor */
-- 
1.8.3.2

