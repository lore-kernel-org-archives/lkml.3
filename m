Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbbA0Wdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:33:38 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42776
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046AbbA0Wdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:33:35 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com, tglx@linutronix.de
Cc: Vitaly Kuznetsov 
	<"[mailto:vkuznets@redhat.com]"@linuxonhyperv.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 4/8] Drivers: hv: vmbus: avoid double kfree for device_obj
Date: Tue, 27 Jan 2015 15:46:44 -0800
Message-Id: <1422402408-5504-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1422402408-5504-1-git-send-email-kys@microsoft.com>
References: <1422402376-5463-1-git-send-email-kys@microsoft.com>
 <1422402408-5504-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <[mailto:vkuznets@redhat.com]>

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
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel_mgmt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index ba4b25f..36bacc7 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -262,7 +262,6 @@ void vmbus_free_channels(void)
 
 	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
 		vmbus_device_unregister(channel->device_obj);
-		kfree(channel->device_obj);
 		free_channel(channel);
 	}
 }
-- 
1.7.4.1

