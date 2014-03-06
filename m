Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaCFJSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:18:52 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:17918 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaCFJSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:18:48 -0500
Message-ID: <53183D5D.4020000@huawei.com>
Date: Thu, 6 Mar 2014 17:18:21 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <jiang.liu@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] numa: fix NULL pointer access and memory leak in unregister_one_node()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing socket hot remove, "node_devices[nid]" is set to NULL;
acpi_processor_remove()
	try_offline_node()
		unregister_one_node()

Then hot add a socket, but do not echo 1 > /sys/devices/system/cpu/cpuXX/online,
so register_one_node() will not be called, and "node_devices[nid]"
is still NULL.

If doing socket hot remove again, NULL pointer access will be happen.
unregister_one_node()
	unregister_node()

Another, we should free the memory used by "node_devices[nid]" in
unregister_one_node().

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 drivers/base/node.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index bc9f43b..8f7ed99 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -599,7 +599,11 @@ int register_one_node(int nid)
 
 void unregister_one_node(int nid)
 {
+	if (!node_devices[nid])
+		return;
+
 	unregister_node(node_devices[nid]);
+	kfree(node_devices[nid]);
 	node_devices[nid] = NULL;
 }
 
-- 
1.7.1


