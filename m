Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3JKGhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:37:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33370 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3JKGhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:37:06 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52579C69.1080304@jp.fujitsu.com>
Date: Fri, 11 Oct 2013 15:36:25 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <toshi.kani@hp.com>, <sjenning@linux.vnet.ibm.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH] Release device_hotplug_lock when store_mem_state returns
 EINVAL
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When inserting a wrong value to /sys/devices/system/memory/memoryX/state file,
following messages are shown. And device_hotplug_lock is never released.

================================================
[ BUG: lock held when returning to user space! ]
3.12.0-rc4-debug+ #3 Tainted: G        W
------------------------------------------------
bash/6442 is leaving the kernel with locks still held!
1 lock held by bash/6442:
 #0:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff8146cbb5>] lock_device_hotplug_sysfs+0x15/0x50

This issue was introdued by commit fa2be40 (drivers: base: use standard
device online/offline for state change).

This patch releases device_hotplug_lcok when store_mem_state returns EINVAL.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Toshi Kani <toshi.kani@hp.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/memory.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 9e59f65..bece691 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -333,8 +333,10 @@ store_mem_state(struct device *dev,
 		online_type = ONLINE_KEEP;
 	else if (!strncmp(buf, "offline", min_t(int, count, 7)))
 		online_type = -1;
-	else
-		return -EINVAL;
+	else {
+		ret = -EINVAL;
+		goto err;
+	}

 	switch (online_type) {
 	case ONLINE_KERNEL:
@@ -357,6 +359,7 @@ store_mem_state(struct device *dev,
 		ret = -EINVAL; /* should never happen */
 	}

+err:
 	unlock_device_hotplug();

 	if (ret)

