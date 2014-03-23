Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaCWICv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 04:02:51 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:53746 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaCWICp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 04:02:45 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <paul.gortmaker@windriver.com>
CC: <mingo@kernel.org>, <wangnan0@huawei.com>, <linux-kernel@vger.kernel.org>,
        <peifeiyue@huawei.com>, <lizefan@huawei.com>,
        Liu Hua <sdu.liu@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] hung_task : check the value of "sysctl_hung_task_timeout_sec"
Date: Sun, 23 Mar 2014 15:54:04 +0800
Message-ID: <1395561244-69173-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As sysctl_hung_task_timeout_sec is unsigned long, when this value is
larger then LONG_MAX/HZ, the function schedule_timeout_interruptible in
watchdog will return immediately without sleep and with print :

[  205.452934] schedule_timeout: wrong timeout value ffffffffffffff83

and then the funtion watchdog will call schedule_timeout_interruptible again
and again. The screen will be filled with
	"schedule_timeout: wrong timeout value ffffffffffffff83"

This patch does some check and correction in timeout_jiffies, to let the
function schedule_timeout_interruptible allways get the valid parameter.

Cc: <stable@vger.kernel.org>
Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 kernel/hung_task.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 6df6149..f992286 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -174,8 +174,12 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 
 static unsigned long timeout_jiffies(unsigned long timeout)
 {
-	/* timeout of 0 will disable the watchdog */
-	return timeout ? timeout * HZ : MAX_SCHEDULE_TIMEOUT;
+	/* timeout of 0 or >= LONG_MAX/HZ will disable the watchdog */
+	if ((timeout == 0) || (timeout > MAX_SCHEDULE_TIMEOUT))
+		return MAX_SCHEDULE_TIMEOUT;
+
+	return (timeout * HZ) < MAX_SCHEDULE_TIMEOUT ?
+			timeout * HZ : MAX_SCHEDULE_TIMEOUT;
 }
 
 /*
-- 
1.9.0

