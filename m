Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3IINdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:33:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12599 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3IIN0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:26:50 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=BP604nfWqvwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=tVU5si3swWsA:10 a=VwQbUJbxAAAA:8 a=aEvpvKATvMdsf35bc-8A:9 a=9J5VuaLb3qoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130909124758.826663268@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 09 Sep 2013 08:47:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>,
        Mike Galbraith <bitbucket@online.de>
Subject: [PATCH RT 02/16] x86/mce: fix mce timer interval
References: <20130909124745.590777496@goodmis.org>
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
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8ceb100..b08a373 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1139,7 +1139,7 @@ static enum hrtimer_restart mce_start_timer(struct hrtimer *timer)
 		*n = min(*n*2, round_jiffies_relative(check_interval*HZ));
 
 	hrtimer_forward(timer, timer->base->get_time(),
-			ns_to_ktime(jiffies_to_usecs(*n) * 1000));
+			ns_to_ktime(jiffies_to_usecs(*n) * 1000ULL));
 	return HRTIMER_RESTART;
 }
 
@@ -1435,7 +1435,7 @@ static void __mcheck_cpu_init_timer(void)
 	if (!*n)
 		return;
 
-	hrtimer_start_range_ns(t, ns_to_ktime(jiffies_to_usecs(*n) * 1000),
+	hrtimer_start_range_ns(t, ns_to_ktime(jiffies_to_usecs(*n) * 1000ULL),
 			       0 , HRTIMER_MODE_REL_PINNED);
 }
 
-- 
1.7.10.4


