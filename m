Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaBZROw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:14:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbaBZROv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:14:51 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: [RFC] perf tools: Fix strict alias issue for find_first_bit
Date: Wed, 26 Feb 2014 18:14:26 +0100
Message-Id: <1393434867-20271-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
got issue below when compiling perf tool on i686 with gcc 4.4,
but not sure the patch is correct workaround here.

thanks for comments,
jirka


---
When compiling perf tool code with gcc 4.4.7 I'm getting
following error:

  CC       util/session.o
cc1: warnings being treated as errors
util/session.c: In function ‘perf_session_deliver_event’:
/root/linux/tools/perf/util/include/linux/bitops.h:109: error: dereferencing pointer ‘p’ does break strict-aliasing rules
/root/linux/tools/perf/util/include/linux/bitops.h:101: error: dereferencing pointer ‘p’ does break strict-aliasing rules
util/session.c:697: note: initialized from here
/root/linux/tools/perf/util/include/linux/bitops.h:101: note: initialized from here
make[1]: *** [util/session.o] Error 1
make: *** [util/session.o] Error 2

The aliased types here are u64 and unsigned long pointers,
which is safe for the find_first_bit processing.

This error shows up for me only for gcc 4.4 on 32bit x86,
even for -Wstrict-aliasing=3, while newer gcc are quiet
and scream here for -Wstrict-aliasing={2,1}. Looks like
newer gcc changed the rules for strict alias warnings.

The gcc documentation offers workaround for valid
aliasing by using __may_alias__ attribute:
  http://gcc.gnu.org/onlinedocs/gcc-4.4.0/gcc/Type-Attributes.html

Using this workaround for the find_first_bit function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
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
 
-- 
1.8.3.1

