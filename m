Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaDXJbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:31:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbaDXIzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu Hua <sdu.liu@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 138/182] hung_task: check the value of "sysctl_hung_task_timeout_sec"
Date: Thu, 24 Apr 2014 09:51:03 +0100
Message-Id: <1398329507-5911-139-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Hua <sdu.liu@huawei.com>

commit 80df28476505ed4e6701c3448c63c9229a50c655 upstream.

As sysctl_hung_task_timeout_sec is unsigned long, when this value is
larger then LONG_MAX/HZ, the function schedule_timeout_interruptible in
watchdog will return immediately without sleep and with print :

  schedule_timeout: wrong timeout value ffffffffffffff83

and then the funtion watchdog will call schedule_timeout_interruptible
again and again.  The screen will be filled with

	"schedule_timeout: wrong timeout value ffffffffffffff83"

This patch does some check and correction in sysctl, to let the function
schedule_timeout_interruptible allways get the valid parameter.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
Tested-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.11:
  - pick hung_task_timeout_secs documentation from commit 270750d
    ("hung_task: Display every hung task warning") ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/sysctl/kernel.txt | 11 +++++++++++
 kernel/sysctl.c                 |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 7ea3a96..1bf2a24 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -286,6 +286,17 @@ Default value is "/sbin/hotplug".
 
 ==============================================================
 
+hung_task_timeout_secs:
+
+Check interval. When a task in D state did not get scheduled
+for more than this value report a warning.
+This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+
+0: means infinite timeout - no checking done.
+Possible values to set are in range {0..LONG_MAX/HZ}.
+
+==============================================================
+
 kptr_restrict:
 
 This toggle indicates whether restrictions are placed on
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f252045..8515e5f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -143,6 +143,11 @@ static int min_percpu_pagelist_fract = 8;
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
@@ -972,6 +977,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_dohung_task_timeout_secs,
+		.extra2		= &hung_task_timeout_max,
 	},
 	{
 		.procname	= "hung_task_warnings",
-- 
1.9.1

