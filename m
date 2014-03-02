Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaCBI6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 03:58:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaCBI6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 03:58:13 -0500
Date: Sun, 2 Mar 2014 00:57:36 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-b39c2a57a00a841f057a75b41df4c26173288b66@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1393434867-20271-1-git-send-email-jolsa@redhat.com>
References: <1393434867-20271-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix strict alias issue for find_first_bit
Git-Commit-ID: b39c2a57a00a841f057a75b41df4c26173288b66
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

Commit-ID:  b39c2a57a00a841f057a75b41df4c26173288b66
Gitweb:     http://git.kernel.org/tip/b39c2a57a00a841f057a75b41df4c26173288b66
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 26 Feb 2014 18:14:26 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 28 Feb 2014 10:39:40 -0300

perf tools: Fix strict alias issue for find_first_bit

When compiling perf tool code with gcc 4.4.7 I'm getting
following error:

    CC       util/session.o
  cc1: warnings being treated as errors
  util/session.c: In function ‘perf_session_deliver_event’:
  tools/perf/util/include/linux/bitops.h:109: error: dereferencing pointer ‘p’ does break strict-aliasing rules
  tools/perf/util/include/linux/bitops.h:101: error: dereferencing pointer ‘p’ does break strict-aliasing rules
  util/session.c:697: note: initialized from here
  tools/perf/util/include/linux/bitops.h:101: note: initialized from here
  make[1]: *** [util/session.o] Error 1
  make: *** [util/session.o] Error 2

The aliased types here are u64 and unsigned long pointers, which is safe
for the find_first_bit processing.

This error shows up for me only for gcc 4.4 on 32bit x86, even for
-Wstrict-aliasing=3, while newer gcc are quiet and scream here for
-Wstrict-aliasing={2,1}. Looks like newer gcc changed the rules for
strict alias warnings.

The gcc documentation offers workaround for valid aliasing by using
__may_alias__ attribute:

  http://gcc.gnu.org/onlinedocs/gcc-4.4.0/gcc/Type-Attributes.html

Using this workaround for the find_first_bit function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1393434867-20271-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/bitops.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 45cf10a..dadfa7e 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -87,13 +87,15 @@ static __always_inline unsigned long __ffs(unsigned long word)
 	return num;
 }
 
+typedef const unsigned long __attribute__((__may_alias__)) long_alias_t;
+
 /*
  * Find the first set bit in a memory region.
  */
 static inline unsigned long
 find_first_bit(const unsigned long *addr, unsigned long size)
 {
-	const unsigned long *p = addr;
+	long_alias_t *p = (long_alias_t *) addr;
 	unsigned long result = 0;
 	unsigned long tmp;
 
