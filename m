Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbbA2Jee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:34:34 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44863 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760187AbbA2JGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:06:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 039/176] Drivers: hv: vmbus: Fix a race condition when unregistering a device
Date: Wed, 28 Jan 2015 15:27:49 +0100
Message-Id: <5ea7d58ceb75a5902252eca83df628b63fb913f6.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 04a258c162a85c0f4ae56be67634dc43c9a4fa9b upstream.

When build with Debug the following crash is sometimes observed:
Call Trace:
 [<ffffffff812b9600>] string+0x40/0x100
 [<ffffffff812bb038>] vsnprintf+0x218/0x5e0
 [<ffffffff810baf7d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff812bb4c1>] vscnprintf+0x11/0x30
 [<ffffffff8107a2f0>] vprintk+0xd0/0x5c0
 [<ffffffffa0051ea0>] ? vmbus_process_rescind_offer+0x0/0x110 [hv_vmbus]
 [<ffffffff8155c71c>] printk+0x41/0x45
 [<ffffffffa004ebac>] vmbus_device_unregister+0x2c/0x40 [hv_vmbus]
 [<ffffffffa0051ecb>] vmbus_process_rescind_offer+0x2b/0x110 [hv_vmbus]
...

This happens due to the following race: between 'if (channel->device_obj)' check
in vmbus_process_rescind_offer() and pr_debug() in vmbus_device_unregister() the
device can disappear. Fix the issue by taking an additional reference to the
device before proceeding to vmbus_device_unregister().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hv/channel_mgmt.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index fa920469bf10..505fe29c75b0 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -202,9 +202,16 @@ static void vmbus_process_rescind_offer(struct work_struct *work)
 	unsigned long flags;
 	struct vmbus_channel *primary_channel;
 	struct vmbus_channel_relid_released msg;
+	struct device *dev;
+
+	if (channel->device_obj) {
+		dev = get_device(&channel->device_obj->device);
+		if (dev) {
+			vmbus_device_unregister(channel->device_obj);
+			put_device(dev);
+		}
+	}
 
-	if (channel->device_obj)
-		vmbus_device_unregister(channel->device_obj);
 	memset(&msg, 0, sizeof(struct vmbus_channel_relid_released));
 	msg.child_relid = channel->offermsg.child_relid;
 	msg.header.msgtype = CHANNELMSG_RELID_RELEASED;
-- 
2.2.2

