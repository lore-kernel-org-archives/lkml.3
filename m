Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3GCLin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:38:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab3GCLhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:37:21 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=difIAhfdVDoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Yaqw2A5lkYAA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=UWnsfagYElI4lnaaA5AA:9 a=hPjdaMEvmhQA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703113718.846774035@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 07:36:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <srikar@linux.vnet.ibm.com>,
        <stable@vger.kernel.org>, "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 3/8] uprobes: Fix return value in error handling path
References: <20130703113635.696310819@goodmis.org>
Content-Disposition: inline; filename=0003-uprobes-Fix-return-value-in-error-handling-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

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
Cc: stable@vger.kernel.org # 3.5+
Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 32494fb0..d5d0cd3 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -283,8 +283,10 @@ static int create_trace_uprobe(int argc, char **argv)
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
1.7.10.4


