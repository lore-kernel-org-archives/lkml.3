Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876Ab3GQWze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:55:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56601 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964836Ab3GQWz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 116/145] uprobes: Fix return value in error handling path
Date: Wed, 17 Jul 2013 15:47:28 -0700
Message-Id: <1374101277-7915-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/trace/trace_uprobe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index c86e6d4..c3946f9 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -244,8 +244,10 @@ static int create_trace_uprobe(int argc, char **argv)
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
1.8.1.2

