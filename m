Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaEDPmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaEDPmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Hua <sdu.liu@huawei.com>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 139/158] hung_task: check the value of "sysctl_hung_task_timeout_sec"
Date: Sun,  4 May 2014 11:40:48 -0400
Message-Id: <20140504154048.903336677@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/sysctl/kernel.txt |    1 +
 kernel/sysctl.c                 |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -317,6 +317,7 @@ for more than this value report a warnin
 This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
 0: means infinite timeout - no checking done.
+Possible values to set are in range {0..LONG_MAX/HZ}.
 
 ==============================================================
 
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -144,6 +144,11 @@ static int min_percpu_pagelist_fract = 8
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


