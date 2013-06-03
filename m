Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816Ab3FCWVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:21:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814Ab3FCWMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:01 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=WpD12FY-48YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=N1bbi4PdpE4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=5RAGcMhyOaGCbW0FJhMA:9 a=Zh68SRI7RUMA:10 a=jEp0ucaQiEUA:10 a=9J5VuaLb3qoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221154.654385631@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [15/65] tick: Cleanup NOHZ per cpu data on cpu down
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0015-tick-Cleanup-NOHZ-per-cpu-data-on-cpu-down.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 4b0c0f294f60abcdd20994a8341a95c8ac5eeb96 ]

Prarit reported a crash on CPU offline/online. The reason is that on
CPU down the NOHZ related per cpu data of the dead cpu is not cleaned
up. If at cpu online an interrupt happens before the per cpu tick
device is registered the irq_enter() check potentially sees stale data
and dereferences a NULL pointer.

Cleanup the data after the cpu is dead.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Cc: Mike Galbraith <bitbucket@online.de>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1305031451561.2886@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e430b97..7dba89d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -909,7 +909,7 @@ void tick_cancel_sched_timer(int cpu)
 		hrtimer_cancel(&ts->sched_timer);
 # endif
 
-	ts->nohz_mode = NOHZ_MODE_INACTIVE;
+	memset(ts, 0, sizeof(*ts));
 }
 #endif
 
-- 
1.7.10.4


