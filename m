Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431AbbA2C72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:59:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47015 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965374AbbA2Ch4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 030/139] Drivers: hv: vmbus: Fix a race condition when unregistering a device
Date: Wed, 28 Jan 2015 14:19:33 -0800
Message-Id: <1422483682-15393-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Kuznetsov <vkuznets@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hv/channel_mgmt.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index fa92046..505fe29 100644
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
1.9.1

