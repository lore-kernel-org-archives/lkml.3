Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbbAUTDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:03:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbbAUTCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:02:22 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 1/3] Drivers: hv: vmbus: avoid double kfree for device_obj
Date: Wed, 21 Jan 2015 20:02:07 +0100
Message-Id: <1421866929-20167-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421866929-20167-1-git-send-email-vkuznets@redhat.com>
References: <1421866929-20167-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On driver shutdown device_obj is being freed twice:
1) In vmbus_free_channels()
2) vmbus_device_release() (which is being triggered by device_unregister() in
   vmbus_device_unregister().
This double kfree leads to the following sporadic crash on driver unload:

[   23.469876] general protection fault: 0000 [#1] SMP
[   23.470036] Modules linked in: hv_vmbus(-)
[   23.470036] CPU: 2 PID: 213 Comm: rmmod Not tainted 3.19.0-rc5_bug923184+ #488
[   23.470036] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   23.470036] task: ffff880036ef1cb0 ti: ffff880036ce8000 task.ti: ffff880036ce8000
[   23.470036] RIP: 0010:[<ffffffff811d2e1b>]  [<ffffffff811d2e1b>] __kmalloc_node_track_caller+0xdb/0x1e0
[   23.470036] RSP: 0018:ffff880036cebcc8  EFLAGS: 00010246
...

When this crash does not happen on driver unload the similar one is expected if
we try to load hv_vmbus again.

Remove kfree from vmbus_free_channels() as freeing it from
vmbus_device_release() seems right.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/channel_mgmt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 877a944..0141a3d 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -259,7 +259,6 @@ void vmbus_free_channels(void)
 
 	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
 		vmbus_device_unregister(channel->device_obj);
-		kfree(channel->device_obj);
 		free_channel(channel);
 	}
 }
-- 
1.9.3

