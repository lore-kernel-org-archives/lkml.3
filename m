Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab3G3KDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:03:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab3G3JcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 005/106] uprobes: Fix return value in error handling path
Date: Tue, 30 Jul 2013 10:30:24 +0100
Message-Id: <1375176725-5825-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

commit fa44063f9ef163c3a4c8d8c0465bb8a056b42035 upstream.

When wrong argument is passed into uprobe_events it does not return
an error:

[root@jovi tracing]# echo 'p:myprobe /bin/bash' > uprobe_events
[root@jovi tracing]#

The proper response is:

[root@jovi tracing]# echo 'p:myprobe /bin/bash' > uprobe_events
-bash: echo: write error: Invalid argument

Link: http://lkml.kernel.org/r/51B964FF.5000106@huawei.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <srikar@linux.vnet.ibm.com>
Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace_uprobe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2b36ac6..5c83613 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -243,8 +243,10 @@ static int create_trace_uprobe(int argc, char **argv)
 		return -EINVAL;
 	}
 	arg = strchr(argv[1], ':');
-	if (!arg)
+	if (!arg) {
+		ret = -EINVAL;
 		goto fail_address_parse;
+	}
 
 	*arg++ = '\0';
 	filename = argv[1];
-- 
1.8.3.2

