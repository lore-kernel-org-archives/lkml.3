Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3IHP6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 11:58:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13590 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab3IHP4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:56:49 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=TXM2OkA9vmQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=tVU5si3swWsA:10 a=VwQbUJbxAAAA:8 a=WPOwCad6GuLPpt5m05IA:9 a=9J5VuaLb3qoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908151445.962814337@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 11:13:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>,
        Mike Galbraith <bitbucket@online.de>
Subject: [PATCH RT 02/19] x86/mce: fix mce timer interval
References: <20130908151355.362583092@goodmis.org>
Content-Disposition: inline; filename=0002-x86-mce-fix-mce-timer-interval.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <bitbucket@online.de>

Seems mce timer fire at the wrong frequency in -rt kernels since roughly
forever due to 32 bit overflow.  3.8-rt is also missing a multiplier.

Add missing us -> ns conversion and 32 bit overflow prevention.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[bigeasy: use ULL instead of u64 cast]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e31ea90..339bb4d0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1649,7 +1649,7 @@ static void __mcheck_cpu_init_timer(void)
 	__this_cpu_write(mce_next_interval, iv);
 	if (!iv)
 		return;
-	hrtimer_start_range_ns(t, ns_to_ktime(jiffies_to_usecs(iv) * 1000),
+	hrtimer_start_range_ns(t, ns_to_ktime(jiffies_to_usecs(iv) * 1000ULL),
 			       0, HRTIMER_MODE_REL_PINNED);
 }
 
-- 
1.7.10.4


