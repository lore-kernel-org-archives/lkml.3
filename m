Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbaGPJxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:53:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaGPJxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:53:04 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, x86@kernel.org,
        mtosatti@redhat.com
Subject: [PATCH] ensure guest's kvmclock never goes backwards when TSC jumps backward
Date: Wed, 16 Jul 2014 09:52:48 +0000
Message-Id: <1405504368-5581-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are buggy hosts in the wild that advertise invariant
TSC and as result host uses TSC as clocksource, but TSC on
such host sometimes sporadically jumps backwards.

This causes kvmclock to go backwards if host advertises
PVCLOCK_TSC_STABLE_BIT, which turns off aggregated clock
accumulator and returns:
  pvclock_vcpu_time_info.system_timestamp + offset
where 'offset' is calculated using TSC.
Since TSC is not virtualized in KVM, it makes guest see
TSC jumped backwards and leads to kvmclock going backwards
as well.

This is defensive patch that keeps per CPU last clock value
and ensures that clock will never go backwards even with
using PVCLOCK_TSC_STABLE_BIT enabled path.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
RHBZ: 1115795

---
 arch/x86/kernel/pvclock.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 2f355d2..dd9df0e 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -71,11 +71,14 @@ u8 pvclock_read_flags(struct pvclock_vcpu_time_info *src)
 	return flags & valid_flags;
 }
 
+static DEFINE_PER_CPU(cycle_t, last_clock);
+
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 {
 	unsigned version;
 	cycle_t ret;
-	u64 last;
+	u64 last, *this_cpu_last;
+	s64 clock_delta;
 	u8 flags;
 
 	do {
@@ -87,6 +90,16 @@ cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 		pvclock_touch_watchdogs();
 	}
 
+	this_cpu_last = &get_cpu_var(last_clock);
+	clock_delta = ret - *this_cpu_last;
+	if (likely(clock_delta > 0)) {
+		*this_cpu_last = ret;
+	} else {
+		ret = *this_cpu_last;
+		WARN_ONCE(1, "clock went backwards");
+	}
+	put_cpu_var(last_clock);
+
 	if ((valid_flags & PVCLOCK_TSC_STABLE_BIT) &&
 		(flags & PVCLOCK_TSC_STABLE_BIT))
 		return ret;
-- 
1.8.3.1

