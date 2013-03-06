Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3CFHTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:19:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:37047 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab3CFHTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:19:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,793,1355126400"; 
   d="scan'208";a="299868748"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: gong.chen@linux.intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 4/5] clocksource: Enable clocksource_cyc2ns() to cover big cycles
Date: Wed,  6 Mar 2013 15:17:50 +0800
Message-Id: <1362554271-22382-5-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362554271-22382-1-git-send-email-feng.tang@intel.com>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current clocksource_cyc2ns() has a implicit limit that the (cycles * mult)
can not exceed 64 bits limit. Jason Gunthorpe proposed a way to
handle this big cycles case, and this patch put the handling into
clocksource_cyc2ns() so that it could be used unconditionally.

Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 include/linux/clocksource.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index aa7032c..1ecc872 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -274,7 +274,16 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
  */
 static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 {
-	return ((u64) cycles * mult) >> shift;
+	u64 max = ULLONG_MAX / mult;
+	s64 nsec = 0;
+
+	/* The (mult * cycles) may overflow 64 bits, so add a max check */
+	if (cycles > max) {
+		nsec = ((max * mult) >> shift) * (cycles / max);
+		cycles %= max;
+	}
+	nsec += ((u64) cycles * mult) >> shift;
+	return nsec;
 }
 
 
-- 
1.7.9.5

