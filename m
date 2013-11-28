Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099Ab3K1Po2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:44:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab3K1PoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:44:24 -0500
Date: Thu, 28 Nov 2013 16:43:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCHv3 3/7] perf tools: Fine tune readn function
Message-ID: <20131128154350.GB31444@krava.brq.redhat.com>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
 <1385634619-8129-4-git-send-email-jolsa@redhat.com>
 <52975F17.2050402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52975F17.2050402@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 08:19:51AM -0700, David Ahern wrote:
> On 11/28/13, 3:30 AM, Jiri Olsa wrote:
> >@@ -151,21 +152,26 @@ unsigned long convert_unit(unsigned long value, char *unit)
> >  	return value;
> >  }
> >
> >+/*
> >+ * Read exactly 'n' bytes or return an error.
> >+ */
> >  ssize_t readn(int fd, void *buf, size_t n)
> >  {
> >  	void *buf_start = buf;
> >+	size_t left = n;
> >
> >-	while (n) {
> >-		ssize_t ret = read(fd, buf, n);
> >+	while (left) {
> >+		ssize_t ret = read(fd, buf, left);
> >
> >  		if (ret <= 0)
> >  			return ret;
> 
> handle EINTR errors? no need to fail readn if the system call is
> interrupted.

right, how about the v3 below?

thanks,
jirka


---
Added a 'left' variable to make the flow clearer, and added a debug
check for the return value - returning 'n' is more obvious. Also do
not fail on EINTR error.

Added small comment for readn.

Original-patch-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9440481..f12eada 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -6,6 +6,8 @@
 #endif
 #include <stdio.h>
 #include <stdlib.h>
+#include <linux/kernel.h>
+#include <errno.h>
 
 /*
  * XXX We need to find a better place for these things...
@@ -151,21 +153,26 @@ unsigned long convert_unit(unsigned long value, char *unit)
 	return value;
 }
 
+/*
+ * Read exactly 'n' bytes or return an error.
+ */
 ssize_t readn(int fd, void *buf, size_t n)
 {
 	void *buf_start = buf;
+	size_t left = n;
 
-	while (n) {
-		ssize_t ret = read(fd, buf, n);
+	while (left) {
+		ssize_t ret = read(fd, buf, left);
 
-		if (ret <= 0)
+		if ((ret <= 0) && (errno != EINTR))
 			return ret;
 
-		n -= ret;
-		buf += ret;
+		left -= ret;
+		buf  += ret;
 	}
 
-	return buf - buf_start;
+	BUG_ON((size_t)(buf - buf_start) != n);
+	return n;
 }
 
 size_t hex_width(u64 v)
-- 
1.8.3.1

