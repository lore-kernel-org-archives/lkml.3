Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3AYL6C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:58:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab3AYL6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:58:00 -0500
Date: Fri, 25 Jan 2013 03:57:39 -0800
From: tip-bot for Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Message-ID: <tip-15268138e334bd0362f8395edac4822351714a22@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@redhat.com, anton@au1.ibm.com,
        tglx@linutronix.de, sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@redhat.com,
        anton@au1.ibm.com, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <20130117172814.GA18882@us.ibm.com>
References: <20130117172814.GA18882@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix PMU format parsing test failure
Git-Commit-ID: 15268138e334bd0362f8395edac4822351714a22
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:57:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15268138e334bd0362f8395edac4822351714a22
Gitweb:     http://git.kernel.org/tip/15268138e334bd0362f8395edac4822351714a22
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Thu, 17 Jan 2013 09:11:30 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:47 -0300

perf tools: Fix PMU format parsing test failure

On POWER, the 'perf format parsing' test always fails.

Looks like it is because memset() is being passed number of longs rather
than number of bytes. It is interesting that the test always passes on
my x86 box.

With this patch, the test passes on POWER and continues to pass on x86.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20130117172814.GA18882@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/bitops.h | 1 +
 tools/perf/util/pmu.c                  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

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
