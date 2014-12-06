Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaLEXbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:31:48 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:32932
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbaLEXbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:31:46 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        linux-mm@kvack.org, isimatu.yasuaki@jp.fujitsu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock issue in the memory hot-add code
Date: Fri,  5 Dec 2014 16:41:38 -0800
Message-Id: <1417826498-21172-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1417826498-21172-1-git-send-email-kys@microsoft.com>
References: <1417826471-21131-1-git-send-email-kys@microsoft.com>
 <1417826498-21172-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft <apw@canonical.com> initially saw this deadlock. We
have seen this as well. Here is the original description of the
problem (and a potential solution) from Andy:

https://lkml.org/lkml/2014/3/14/451

Here is an excerpt from that mail:

"We are seeing machines lockup with what appears to be an ABBA
deadlock in the memory hotplug system.  These are from the 3.13.6 based Ubuntu kernels.
The hv_balloon driver is adding memory using add_memory() which takes
the hotplug lock, and then emits a udev event, and then attempts to
lock the sysfs device.  In response to the udev event udev opens the
sysfs device and locks it, then attempts to grab the hotplug lock to online the memory.
This seems to be inverted nesting in the two cases, leading to the hangs below:

[  240.608612] INFO: task kworker/0:2:861 blocked for more than 120 seconds.
[  240.608705] INFO: task systemd-udevd:1906 blocked for more than 120 seconds.

I note that the device hotplug locking allows complete retries (via
ERESTARTSYS) and if we could detect this at the online stage it could
be used to get us out.  But before I go down this road I wanted to
make sure I am reading this right.  Or indeed if the hv_balloon driver
is just doing this wrong."

This patch is based on the suggestion from
Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index afdb0d5..f525a62 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -22,6 +22,7 @@
 #include <linux/jiffies.h>
 #include <linux/mman.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -649,8 +650,11 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
 
 		release_region_mutex(false);
 		nid = memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
+
+		lock_device_hotplug();
 		ret = add_memory(nid, PFN_PHYS((start_pfn)),
 				(HA_CHUNK << PAGE_SHIFT));
+		unlock_device_hotplug();
 
 		if (ret) {
 			pr_info("hot_add memory failed error is %d\n", ret);
-- 
1.7.4.1

