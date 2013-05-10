Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3EJMNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:13:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:24047 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab3EJMNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:13:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,647,1363158000"; 
   d="scan'208";a="331926996"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 01/11] time: add *_to_jiffies_min helpers to guarantee a minimum duration
Date: Fri, 10 May 2013 15:13:19 +0300
Message-Id: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *_to_jiffies(x) macros return a jiffy value, which if used as a
delta to wait for a specific amount of time, may result in a wait-time
that is less than x. Many callers already compensate for this by adding
one to the returned value. To document why we need to add one and to get
rid of some code duplication add a helper that does the same.

Later patches will convert the currently open-coded call sites to use
the new helpers.

Also this can serve as a basis for auditing those users of *_to_jiffies
that most likely do the wrong thing - for example set a timeout value of
msecs_to_jiffies(1) - and converting them to use the new helpers.

Kudos to Daniel Vetter for the idea of the new helpers.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 include/linux/jiffies.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 82ed068..d12509b 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -312,6 +312,19 @@ extern u64 nsec_to_clock_t(u64 x);
 extern u64 nsecs_to_jiffies64(u64 n);
 extern unsigned long nsecs_to_jiffies(u64 n);
 
+#define __define_time_to_jiffies_min(tname, ttype)			\
+static inline unsigned long						\
+tname ## _to_jiffies_min(const ttype m)					\
+{									\
+	return max_t(long, MAX_JIFFY_OFFSET, tname ## _to_jiffies(m) + 1);\
+}
+
+__define_time_to_jiffies_min(msecs, unsigned int)
+__define_time_to_jiffies_min(usecs, unsigned int)
+__define_time_to_jiffies_min(nsecs, u64)
+__define_time_to_jiffies_min(timespec, struct timespec *)
+__define_time_to_jiffies_min(timeval, struct timeval *)
+
 #define TIMESTAMP_SIZE	30
 
 #endif
-- 
1.7.10.4

