Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3AXDcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:32:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44434 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3AXDbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 64/74] s390/time: fix sched_clock() overflow
Date: Thu, 24 Jan 2013 01:27:16 -0200
Message-Id: <1358998046-613-65-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/s390/include/asm/timex.h |   28 ++++++++++++++++++++++++++++
 arch/s390/kernel/time.c       |    2 +-
 arch/s390/kvm/interrupt.c     |    2 +-
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index 239ece9..706c535 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -130,4 +130,32 @@ static inline unsigned long long get_clock_monotonic(void)
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
index d4e1cb1..c5531db 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -64,7 +64,7 @@ static DEFINE_PER_CPU(struct clock_event_device, comparators);
  */
 unsigned long long notrace __kprobes sched_clock(void)
 {
-	return (get_clock_monotonic() * 125) >> 9;
+	return tod_to_ns(get_clock_monotonic());
 }
 
 /*
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 2d9f9a7..10e13b3 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -390,7 +390,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	sltime = ((vcpu->arch.sie_block->ckc - now)*125)>>9;
+	sltime = tod_to_ns(vcpu->arch.sie_block->ckc - now);
 
 	hrtimer_start(&vcpu->arch.ckc_timer, ktime_set (0, sltime) , HRTIMER_MODE_REL);
 	VCPU_EVENT(vcpu, 5, "enabled wait via clock comparator: %llx ns", sltime);
-- 
1.7.9.5

