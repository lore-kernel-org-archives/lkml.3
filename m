Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3CFNv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:51:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab3CFNvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:51:24 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=pcAIvQPzzWgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=wNERI9Toi8oA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=pMiH-cKfca9Qi_HVc-MA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130306135122.481660396@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Mar 2013 08:49:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [RFC][PATCH 2/2] tracing: Do not return EINVAL in snapshot when not allocated
References: <20130306134916.923746858@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Do-not-return-EINVAL-in-snapshot-when-not-al.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

To use the tracing snapshot feature, writing a '1' into the snapshot
file causes the snapshot buffer to be allocated if it has not already
been allocated and dose a 'swap' with the main buffer, so that the
snapshot now contains what was in the main buffer, and the main buffer
now writes to what was the snapshot buffer.

To free the snapshot buffer, a '0' is written into the snapshot file.

To clear the snapshot buffer, any number but a '0' or '1' is written
into the snapshot file. But if the file is not allocated it returns
-EINVAL error code. This is rather pointless. It is better just to
do nothing and return success.

Cc: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9e3120b..1f835a8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4167,8 +4167,6 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	default:
 		if (current_trace->allocated_snapshot)
 			tracing_reset_online_cpus(&max_tr);
-		else
-			ret = -EINVAL;
 		break;
 	}
 
-- 
1.7.10.4


