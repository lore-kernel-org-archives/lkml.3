Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaC1Mgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 08:36:40 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:3498 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaC1Mgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:36:38 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <mingo@kernel.org>, <rob@landley.net>
CC: <peterz@infradead.org>, <riel@redhat.com>, <akpm@linux-foundation.org>,
        <lizefan@huawei.com>, <wangnan0@huawei.com>, <peifeiyue@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <liusdu@126.com>, Liu Hua <sdu.liu@huawei.com>,
        <stable@vger.kernel.org.#.3.4+>
Subject: [PATCH v3] hung_task : check the value of "sysctl_hung_task_timeout_sec"
Date: Fri, 28 Mar 2014 20:30:08 +0800
Message-ID: <1396009808-66019-1-git-send-email-sdu.liu@huawei.com>
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

and then the funtion watchdog will call schedule_timeout_interruptible
again and again. The screen will be filled with
	"schedule_timeout: wrong timeout value ffffffffffffff83"

This patch does some check and correction in sysctl, to let the
function schedule_timeout_interruptible allways get the valid parameter.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
Tested-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: stable@vger.kernel.org # 3.4+
---
 Documentation/sysctl/kernel.txt | 1 +
 kernel/sysctl.c                 | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index e55124e..855d9b3 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -317,6 +317,7 @@ for more than this value report a warning.
 This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
 0: means infinite timeout - no checking done.
+Possible values to set are in range {0..LONG_MAX/HZ}.
 
 ==============================================================
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 49e13e1..aae21e8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -144,6 +144,11 @@ static int min_percpu_pagelist_fract = 8;
 static int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
 
+/*this is needed for proc_doulongvec_minmax of sysctl_hung_task_timeout_secs */
+#ifdef CONFIG_DETECT_HUNG_TASK
+static unsigned long hung_task_timeout_max = (LONG_MAX/HZ);
+#endif
+
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
 #endif
@@ -995,6 +1000,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_dohung_task_timeout_secs,
+		.extra2		= &hung_task_timeout_max,
 	},
 	{
 		.procname	= "hung_task_warnings",
-- 
1.9.0

