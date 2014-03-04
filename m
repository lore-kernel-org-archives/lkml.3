Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaCDFUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:20:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaCDFUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:20:15 -0500
Message-ID: <1393910409.6415.9.camel@marge.simpson.net>
Subject: [RFC][PATCH] clocksource: avoid unnecessary overflow in
 cyclecounter_cyc2ns()
From: Mike Galbraith <bitbucket@online.de>
To: John Stultz <johnstul@us.ibm.com>
Cc: Salman Qazi <sqazi@google.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 04 Mar 2014 06:20:09 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Cq7c0V/YWN9OBQPKLqRUaVCLUwJaMmonOpD5fzVaROZ
 R4zPIU7HtP1+GCLvg/ijFl3Tzb4+0KMA4N57io0m4u6/Isq7t1
 FZuq/rf5MqIxQBgzzRvXJ3hqOSjHqmhngdhq+Y4UwsbZaL54lh
 BO5ZLblTg3SQbh75+lN3A5zMP1NKjGm2bH/0CWo/CLxbIZhC7P
 ImTHFUmRv8lnirAGNy3GaxHsLduk2itJp8E9poCEMKyR+xyfgp
 MAp37tevyKnaVW1LWEFuPf7ni7NIdFTgPn/H1cv1BRft9bEj5B
 9cLJeHpVMqNQ7OQqgNpSOp5Gz5UhYFnRAHoOKxmyurBFzdBIV9
 KKB7Wx5HLv2fwlPVpBWmdOgGDGIK2chNrTkBlYhJc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

While rummaging around looking for HTH a gaggle of weird a$$ machines
can manage to timewarp back and forth by exactly 208 days, I stumbled
across $subject which looks like it may want to borrow Salman's fix.

clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()

As per 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock",
cycles * mult >> shift is overflow prone. so give it the same treatment.

Cc: Salman Qazi <sqazi@google.com>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 include/linux/clocksource.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -77,13 +77,18 @@ struct timecounter {
  *
  * XXX - This could use some mult_lxl_ll() asm optimization. Same code
  * as in cyc2ns, but with unsigned result.
+ *
+ * Because it is the same as x86 __cycles_2_ns, give it the same treatment as
+ * commit 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock"
+ * to avoid a potential cycles * mult overflow.
  */
 static inline u64 cyclecounter_cyc2ns(const struct cyclecounter *cc,
 				      cycle_t cycles)
 {
-	u64 ret = (u64)cycles;
-	ret = (ret * cc->mult) >> cc->shift;
-	return ret;
+	u64 quot = (u64)cycles >> cc->shift;
+	u64 rem = (u64)cycles & ((1ULL << cc->shift) - 1);
+
+	return  quot * cc->mult + ((rem * cc->mult) >> cc->shift);
 }
 
 /**


