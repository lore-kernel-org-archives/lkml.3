Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3KRSz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:55:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3KRSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.11 22/25] usb: fix cleanup after failure in hub_configure()
Date: Mon, 18 Nov 2013 10:40:51 -0800
Message-Id: <20131118184039.078875288@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/core/hub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1568,6 +1568,7 @@ static int hub_configure(struct usb_hub
 	return 0;
 
 fail:
+	hdev->maxchild = 0;
 	dev_err (hub_dev, "config failed, %s (err %d)\n",
 			message, ret);
 	/* hub_disconnect() frees urb and descriptor */


