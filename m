Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaEPClf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 22:41:35 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:63407 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752233AbaEPCld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 22:41:33 -0400
X-IronPort-AV: E=Sophos;i="4.97,1064,1389715200"; 
   d="scan'208";a="30598296"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>, <tj@kernel.org>,
        <hpa@zytor.com>, <toshi.kani@hp.com>, <mingo@elte.hu>,
        <hutao@cn.fujitsu.com>, <laijs@cn.fujitsu.com>
CC: <guz.fnst@cn.fujitsu.com>, <isimatu.yasuaki@jp.fujitsu.com>,
        <tangchen@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH 1/1] mem-hotplug: Avoid illegal state prefixed with legal state when changing state of memory_block.
Date: Fri, 16 May 2014 10:42:29 +0800
Message-ID: <1400208149-9041-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the following command to online a memory_block:

echo online|online_kernel|online_movable > /sys/devices/system/memory/memoryXXX/state

But, if we typed "online_movbale" by mistake (typo, not "online_movable"), it will be 
recognized as "online", and it will online the memory block successfully. "online" command
will put the memory block into the same zone as it was in before last offlined, which may 
be ZONE_NORMAL, not ZONE_MOVABLE. Since it succeeds without any warning, it may confuse 
users.

Furthermore, if we do the following:

echo online_fhsjkghfkd > /sys/devices/system/memory/memoryXXX/state
the block will also be onlined.

echo offline_ohjkjewrj > /sys/devices/system/memory/memoryXXX/state
the block will also be offlined.

This is because the following code in store_mem_state() does not compare the whole string,
but only the prefix of the string.

store_mem_state()
{
	......
 328         if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))

Here, only compare the first 13 letters of the string. If we give "online_kernelXXXXXX",
it will be recognized as online_kernel, which is incorrect.

 329                 online_type = ONLINE_KERNEL;
 330         else if (!strncmp(buf, "online_movable", min_t(int, count, 14)))

We have the same problem here,

 331                 online_type = ONLINE_MOVABLE;
 332         else if (!strncmp(buf, "online", min_t(int, count, 6)))

here,

(Here is more problematic. If we give online_movalbe, which is a typo of online_movable,
 it will be recognized as online without noticing the author.)

 333                 online_type = ONLINE_KEEP;
 334         else if (!strncmp(buf, "offline", min_t(int, count, 7)))

and here.

 335                 online_type = -1;
 336         else {
 337                 ret = -EINVAL;
 338                 goto err;
 339         }
	......
}

This patch fix this problem by checking if the length of the string is 6,7,13,14, and then
compare the whole string.

And in store_mem_state(), the parameter count passed from user space includes '\0' in the
end of the string, so the real length of the string is count-1.

Reported-by: Hu Tao <hutao@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/base/memory.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index bece691..3ff2adb 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -319,19 +319,27 @@ store_mem_state(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct memory_block *mem = to_memory_block(dev);
-	int ret, online_type;
+	int ret, online_type, len;
 
 	ret = lock_device_hotplug_sysfs();
 	if (ret)
 		return ret;
 
-	if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))
+	/*
+	 * count passed from user space includes \0, so the real length
+	 * is count-1.
+	 */
+	len = count - 1;
+
+	if (len == strlen("online_kernel") &&
+	    !strncmp(buf, "online_kernel", len))
 		online_type = ONLINE_KERNEL;
-	else if (!strncmp(buf, "online_movable", min_t(int, count, 14)))
+	else if (len == strlen("online_movable") &&
+		 !strncmp(buf, "online_movable", len))
 		online_type = ONLINE_MOVABLE;
-	else if (!strncmp(buf, "online", min_t(int, count, 6)))
+	else if (len == strlen("online") && !strncmp(buf, "online", len))
 		online_type = ONLINE_KEEP;
-	else if (!strncmp(buf, "offline", min_t(int, count, 7)))
+	else if (len == strlen("offline") && !strncmp(buf, "offline", len))
 		online_type = -1;
 	else {
 		ret = -EINVAL;
-- 
1.8.3.1

