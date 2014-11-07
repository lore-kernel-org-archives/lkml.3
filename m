Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaKGFco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:32:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaKGFcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:32:39 -0500
Date: Thu, 6 Nov 2014 21:31:43 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-416c419cc3799ddf7ea467c9adcb4cd038bd94a4@git.kernel.org>
Cc: paulus@samba.org, acme@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        namhyung@gmail.com, jolsa@kernel.org, fweisbec@gmail.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        adrian.hunter@intel.com, hpa@zytor.com, peterz@infradead.org
Reply-To: dsahern@gmail.com, acme@redhat.com, mingo@kernel.org,
        paulus@samba.org, mingo@redhat.com, fweisbec@gmail.com,
        namhyung@gmail.com, jolsa@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        adrian.hunter@intel.com, hpa@zytor.com
In-Reply-To: <1414363445-22370-1-git-send-email-jolsa@kernel.org>
References: <1414363445-22370-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add test_and_set_bit function
Git-Commit-ID: 416c419cc3799ddf7ea467c9adcb4cd038bd94a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  416c419cc3799ddf7ea467c9adcb4cd038bd94a4
Gitweb:     http://git.kernel.org/tip/416c419cc3799ddf7ea467c9adcb4cd038bd94a4
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sun, 26 Oct 2014 23:44:03 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 6 Nov 2014 17:42:13 -0300

perf tools: Add test_and_set_bit function

Set a bit and return its old value. Stolen from kernel sources, will be
used in next patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1414363445-22370-1-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/bitmap.h | 17 +++++++++++++++++
 tools/perf/util/include/linux/bitops.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/perf/util/include/linux/bitmap.h
index 01ffd12..40bd214 100644
--- a/tools/perf/util/include/linux/bitmap.h
+++ b/tools/perf/util/include/linux/bitmap.h
@@ -46,4 +46,21 @@ static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 		__bitmap_or(dst, src1, src2, nbits);
 }
 
+/**
+ * test_and_set_bit - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ */
+static inline int test_and_set_bit(int nr, unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long old;
+
+	old = *p;
+	*p = old | mask;
+
+	return (old & mask) != 0;
+}
+
 #endif /* _PERF_BITOPS_H */
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index dadfa7e..c329416 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -15,6 +15,8 @@
 #define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
 #define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
 #define BITS_TO_BYTES(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE)
+#define BIT_WORD(nr)            ((nr) / BITS_PER_LONG)
+#define BIT_MASK(nr)            (1UL << ((nr) % BITS_PER_LONG))
 
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
