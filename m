Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3BCO4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:56:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34300 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab3BCO4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:11 -0500
Message-Id: <20130203144649.001149710@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 056/128] s390/time: fix sched_clock() overflow
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit ed4f20943cd4c7b55105c04daedf8d63ab6d499c upstream.

Converting a 64 Bit TOD format value to nanoseconds means that the value
must be divided by 4.096. In order to achieve that we multiply with 125
and divide by 512.
When used within sched_clock() this triggers an overflow after appr.
417 days. Resulting in a sched_clock() return value that is much smaller
than previously and therefore may cause all sort of weird things in
subsystems that rely on a monotonic sched_clock() behaviour.

To fix this implement a tod_to_ns() helper function which converts TOD
values without overflow and call this function from both places that
open coded the conversion: sched_clock() and kvm_s390_handle_wait().

Reviewed-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/include/asm/timex.h |   28 ++++++++++++++++++++++++++++
 arch/s390/kernel/time.c       |    2 +-
 arch/s390/kvm/interrupt.c     |    2 +-
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index fba4d66..4c060bb 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -128,4 +128,32 @@ static inline unsigned long long get_clock_monotonic(void)
 	return get_clock_xt() - sched_clock_base_cc;
 }
 
+/**
+ * tod_to_ns - convert a TOD format value to nanoseconds
+ * @todval: to be converted TOD format value
+ * Returns: number of nanoseconds that correspond to the TOD format value
+ *
+ * Converting a 64 Bit TOD format value to nanoseconds means that the value
+ * must be divided by 4.096. In order to achieve that we multiply with 125
+ * and divide by 512:
+ *
+ *    ns = (todval * 125) >> 9;
+ *
+ * In order to avoid an overflow with the multiplication we can rewrite this.
+ * With a split todval == 2^32 * th + tl (th upper 32 bits, tl lower 32 bits)
+ * we end up with
+ *
+ *    ns = ((2^32 * th + tl) * 125 ) >> 9;
+ * -> ns = (2^23 * th * 125) + ((tl * 125) >> 9);
+ *
+ */
+static inline unsigned long long tod_to_ns(unsigned long long todval)
+{
+	unsigned long long ns;
+
+	ns = ((todval >> 32) << 23) * 125;
+	ns += ((todval & 0xffffffff) * 125) >> 9;
+	return ns;
+}
+
 #endif
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index aff0e35..a5f4f5a 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -63,7 +63,7 @@ static DEFINE_PER_CPU(struct clock_event_device, comparators);
  */
 unsigned long long notrace __kprobes sched_clock(void)
 {
-	return (get_clock_monotonic() * 125) >> 9;
+	return tod_to_ns(get_clock_monotonic());
 }
 
 /*
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index c30615e..82c481d 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -408,7 +408,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	sltime = ((vcpu->arch.sie_block->ckc - now)*125)>>9;
+	sltime = tod_to_ns(vcpu->arch.sie_block->ckc - now);
 
 	hrtimer_start(&vcpu->arch.ckc_timer, ktime_set (0, sltime) , HRTIMER_MODE_REL);
 	VCPU_EVENT(vcpu, 5, "enabled wait via clock comparator: %llx ns", sltime);


