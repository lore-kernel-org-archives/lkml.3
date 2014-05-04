Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaEDPmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaEDPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Hua <sdu.liu@huawei.com>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 80/86] hung_task: check the value of "sysctl_hung_task_timeout_sec"
Date: Sun,  4 May 2014 11:41:55 -0400
Message-Id: <20140504154151.313097047@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/sysctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

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
@@ -966,6 +971,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_dohung_task_timeout_secs,
+		.extra2		= &hung_task_timeout_max,
 	},
 	{
 		.procname	= "hung_task_warnings",


