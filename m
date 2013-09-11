Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab3IKEbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:31:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10414 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3IKE3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:03 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=dSi1K-NqnAIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6fK1CUH1recA:10 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042856.926765523@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: ybu <ybu@qti.qualcomm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [028/251] printk: Fix rq->lock vs logbuf_lock unlock lock inversion
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0028-printk-Fix-rq-lock-vs-logbuf_lock-unlock-lock-invers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Bu, Yitian" <ybu@qti.qualcomm.com>

[ Upstream commit dbda92d16f8655044e082930e4e9d244b87fde77 ]

commit 07354eb1a74d1 ("locking printk: Annotate logbuf_lock as raw")
reintroduced a lock inversion problem which was fixed in commit
0b5e1c5255 ("printk: Release console_sem after logbuf_lock"). This
happened probably when fixing up patch rejects.

Restore the ordering and unlock logbuf_lock before releasing
console_sem.

Signed-off-by: ybu <ybu@qti.qualcomm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 2d3fc0e..74a3afb 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1364,9 +1364,9 @@ static int console_trylock_for_printk(unsigned int cpu)
 		}
 	}
 	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 
-- 
1.7.10.4


