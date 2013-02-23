Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab3BWQ26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 11:28:58 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:64031 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972Ab3BWQ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 11:28:52 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 1/2] cputime: fix compiler warning caused by timeval_to_cputime()
Date: Sat, 23 Feb 2013 17:28:44 +0100
Message-Id: <1361636925-22288-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361636925-22288-1-git-send-email-fweisbec@gmail.com>
References: <1361636925-22288-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zhong <zhong@linux.vnet.ibm.com>

Saw the following compiler warning on next tree:

kernel/itimer.c: In function 'set_cpu_itimer':
kernel/itimer.c:152:2: warning: passing argument 1 of
'timeval_to_cputime' discards 'const' qualifier from pointer target type
[enabled by default]
...

timeval_to_cputime() is always passed a constant timeval in
argument, we need to teach the nsecs based cputime implementation
about that.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kevin Hilman <khilman@linaro.org>
---
 include/asm-generic/cputime_nsecs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index b6485ca..a8ece9a 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -76,7 +76,7 @@ static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
 /*
  * Convert cputime <-> timeval (msec)
  */
-static inline cputime_t timeval_to_cputime(struct timeval *val)
+static inline cputime_t timeval_to_cputime(const struct timeval *val)
 {
 	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_usec * NSEC_PER_USEC;
 	return (__force cputime_t) ret;
-- 
1.7.5.4

