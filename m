Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3AQR3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:29:09 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49037 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab3AQR3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:29:07 -0500
Date: Thu, 17 Jan 2013 09:28:14 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: acme@ghostprotocols.net
Cc: jolsa@redhat.com, Anton Blanchard <anton@au1.ibm.com>, paulus@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] perf: Fix PMU format parsing test failure
Message-ID: <20130117172814.GA18882@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011717-9360-0000-0000-00000F57DFB0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 776e6d7942754f139c27753213c9cf4617536618 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Thu, 17 Jan 2013 09:11:30 -0800
Subject: [PATCH] perf; Fix PMU format parsing test failure

On POWER, the 'perf format parsing' test always fails.

Looks like it is because memset() is being passed number of longs
rather than number of bytes. It is interesting that the test always
passes on my x86 box.

With this patch, the test passes on POWER and continues to pass on x86.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/util/include/linux/bitops.h |    1 +
 tools/perf/util/pmu.c                  |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index a55d8cf..45cf10a 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -14,6 +14,7 @@
 #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
 #define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
+#define BITS_TO_BYTES(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE)
 
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 9bdc60c..b93ff14 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -548,7 +548,7 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
 	if (!to)
 		to = from;
 
-	memset(bits, 0, BITS_TO_LONGS(PERF_PMU_FORMAT_BITS));
+	memset(bits, 0, BITS_TO_BYTES(PERF_PMU_FORMAT_BITS));
 	for (b = from; b <= to; b++)
 		set_bit(b, bits);
 }
-- 
1.7.1

