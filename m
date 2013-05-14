Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab3ENOsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:48:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:52878 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab3ENOsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="313414913"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dong Zhu <bluezhudong@gmail.com>
Subject: [PATCH v2 1/8] time: add *_to_jiffies_timeout helpers to guarantee a minimum duration
Date: Tue, 14 May 2013 17:48:31 +0300
Message-Id: <1368542918-8861-2-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *_to_jiffies(x) macros return a jiffy value, which if used as a
delta to wait for a specific amount of time, may result in a wait time
that is less than x. Many callers already compensate for this by adding
one to the returned value. Instead of having this adjustment open-coded
at every call site add helpers that return the adjusted value. This will
make the intention for the adjustment more explicit and also provide
documentation for why it is needed.

Later patches will convert the currently open-coded call sites to use
the new helpers.

Also this can serve as a basis for auditing those users of *_to_jiffies
that most likely do the wrong thing - for example set a timeout value of
msecs_to_jiffies(1) - and converting them to use the new helpers.

Kudos to Daniel Vetter for the idea of the new helpers.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 include/linux/jiffies.h |    6 ++++++
 kernel/time.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 8fb8edf..e77a5a0 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -311,6 +311,12 @@ extern u64 nsec_to_clock_t(u64 x);
 extern u64 nsecs_to_jiffies64(u64 n);
 extern unsigned long nsecs_to_jiffies(u64 n);
 
+extern unsigned long msecs_to_jiffies_timeout(const unsigned int m);
+extern unsigned long usecs_to_jiffies_timeout(const unsigned int u);
+extern unsigned long nsecs_to_jiffies_timeout(const u64 n);
+extern unsigned long timespec_to_jiffies_timeout(const struct timespec *value);
+extern unsigned long timeval_to_jiffies_timeout(const struct timeval *value);
+
 #define TIMESTAMP_SIZE	30
 
 #endif
diff --git a/kernel/time.c b/kernel/time.c
index d3617db..759d897 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -712,3 +712,30 @@ struct timespec timespec_add_safe(const struct timespec lhs,
 
 	return res;
 }
+
+/**
+ * msecs_to_jiffies_timeout - Convert msecs to jiffies with guaranteed minimum
+ *
+ * Works similarly to msecs_to_jiffies(), but returns a value that represents
+ * a wait time that is guaranteed to be at least the given msecs duration. In
+ * contrast the value returned by msecs_to_jiffies() represents a wait time
+ * that can be up to 1 jiffy less than the specified msecs duration, depending
+ * on which point in time between two scheduling clock ticks we use the
+ * returned jiffy value.
+ *
+ * Similar helpers are available corresponding to the rest of *_to_jiffies()
+ * functions.
+ */
+#define __define_time_to_jiffies_timeout(tname, ttype)			\
+unsigned long tname ## _to_jiffies_timeout(const ttype v)		\
+{									\
+	unsigned long j = tname ## _to_jiffies(v);			\
+	return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);		\
+}									\
+EXPORT_SYMBOL(tname ## _to_jiffies_timeout);
+
+__define_time_to_jiffies_timeout(msecs, unsigned int)
+__define_time_to_jiffies_timeout(usecs, unsigned int)
+__define_time_to_jiffies_timeout(nsecs, u64)
+__define_time_to_jiffies_timeout(timespec, struct timespec *)
+__define_time_to_jiffies_timeout(timeval, struct timeval *)
-- 
1.7.10.4

