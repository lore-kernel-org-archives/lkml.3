Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaKDMkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:40:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaKDMkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:40:20 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Drivers: hv: vmbus: Fix a race condition when unregistering a device
Date: Tue,  4 Nov 2014 13:40:11 +0100
Message-Id: <1415104811-28142-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/hv/channel_mgmt.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index a2d1a96..d36ce68 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -216,9 +216,16 @@ static void vmbus_process_rescind_offer(struct work_struct *work)
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
1.9.3

