Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbbANH2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:28:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbbANH2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:28:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3.18 100/150] Drivers: hv: vmbus: Fix a race condition when unregistering a device
Date: Tue, 13 Jan 2015 23:22:51 -0800
Message-Id: <20150114072100.396672249@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/hv/channel_mgmt.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -216,9 +216,16 @@ static void vmbus_process_rescind_offer(
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


