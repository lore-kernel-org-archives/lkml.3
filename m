Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3CZR6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:58:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3CZRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:07 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jq1uZMvjvoEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-M5UATQmbqEA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=m8K8Gxsb1v0i5IKd:21 a=2BQqwjqo8GV48iEp:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173602.967201536@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>
Subject: [PATCH 19/86] pktgen: correctly handle failures when adding a device
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0019-pktgen-correctly-handle-failures-when-adding-a-devic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit 604dfd6efc9b79bce432f2394791708d8e8f6efc ]

The return value of pktgen_add_device() is not checked, so
even if we fail to add some device, for example, non-exist one,
we still see "OK:...". This patch fixes it.

After this patch, I got:

	# echo "add_device non-exist" > /proc/net/pktgen/kpktgend_0
	-bash: echo: write error: No such device
	# cat /proc/net/pktgen/kpktgend_0
	Running:
	Stopped:
	Result: ERROR: can not add device non-exist
	# echo "add_device eth0" > /proc/net/pktgen/kpktgend_0
	# cat /proc/net/pktgen/kpktgend_0
	Running:
	Stopped: eth0
	Result: OK: add_device=eth0

(Candidate for -stable)

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/pktgen.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index e356b8d..d7881b2 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1797,10 +1797,13 @@ static ssize_t pktgen_thread_write(struct file *file,
 			return -EFAULT;
 		i += len;
 		mutex_lock(&pktgen_thread_lock);
-		pktgen_add_device(t, f);
+		ret = pktgen_add_device(t, f);
 		mutex_unlock(&pktgen_thread_lock);
-		ret = count;
-		sprintf(pg_result, "OK: add_device=%s", f);
+		if (!ret) {
+			ret = count;
+			sprintf(pg_result, "OK: add_device=%s", f);
+		} else
+			sprintf(pg_result, "ERROR: can not add device %s", f);
 		goto out;
 	}
 
-- 
1.7.10.4


