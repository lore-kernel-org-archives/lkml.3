Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbbA2Jte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:49:34 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58058
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325AbbA2Jt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:49:29 -0500
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com
Cc: haiyangz@microsoft.com
Subject: [PATCH 3/3] hv: vmbus_open(): reset the channel state on ENOMEM
Date: Thu, 29 Jan 2015 03:02:50 -0800
Message-Id: <1422529370-28261-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, the state is put to CHANNEL_OPENING_STATE, and when
the driver is loaded next time, vmbus_open() will fail immediately due to
newchannel->state != CHANNEL_OPEN_STATE.

CC: "K. Y. Srinivasan" <kys@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/hv/channel.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 2978f5e..26dcf26 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -89,9 +89,10 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	out = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
 		get_order(send_ringbuffer_size + recv_ringbuffer_size));
 
-	if (!out)
-		return -ENOMEM;
-
+	if (!out) {
+		err = -ENOMEM;
+		goto error0;
+	}
 
 	in = (void *)((unsigned long)out + send_ringbuffer_size);
 
@@ -199,6 +200,7 @@ error0:
 	free_pages((unsigned long)out,
 		get_order(send_ringbuffer_size + recv_ringbuffer_size));
 	kfree(open_info);
+	newchannel->state = CHANNEL_OPEN_STATE;
 	return err;
 }
 EXPORT_SYMBOL_GPL(vmbus_open);
-- 
1.9.1

