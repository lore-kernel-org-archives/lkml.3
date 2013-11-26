Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3KZRxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:53:40 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:58634 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3KZRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:53:39 -0500
Date: Tue, 26 Nov 2013 18:53:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] tools/perf/util: Document and clean up readn() a bit
Message-ID: <20131126175335.GA9300@gmail.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <1385130268-10664-2-git-send-email-jolsa@redhat.com>
 <20131125192909.GA27323@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125192909.GA27323@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Fri, Nov 22, 2013 at 03:24:26PM +0100, Jiri Olsa escreveu:
> >  }
> > +
> > +ssize_t perf_data_file__write(struct perf_data_file *file,
> > +			      void *buf, size_t size)
> > +{
> > +	ssize_t total = size;
> > +
> > +	while (size) {
> > +		ssize_t ret = write(file->fd, buf, size);
> > +
> > +		if (ret < 0) {
> > +			pr_err("failed to write perf data, error: %m\n");
> > +			return -1;
> > +		}
> > +
> > +		size -= ret;
> > +		buf  += ret;
> > +	}
> > +
> > +	return total;
> 
> So this is the functional equivalent of "readn", so please move it to
> just after "readn" and make this just a simple wrapper.

Btw., would be nice to add a small comment to readn() that describes 
its semantics, it looks like a useful helper.

I also added a check for the input parameter 'n', plus I added a 
'left' variable to make the flow clearer, and added a debug check for 
the return value - I think returning 'n' is more obvious.

Totally untested though.

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 28a0a89..4789081 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -6,6 +6,7 @@
 #endif
 #include <stdio.h>
 #include <stdlib.h>
+#include <linux/kernel.h>
 
 /*
  * XXX We need to find a better place for these things...
@@ -151,21 +152,29 @@ unsigned long convert_unit(unsigned long value, char *unit)
 	return value;
 }
 
-int readn(int fd, void *buf, size_t n)
+/*
+ * Read exactly 'n' bytes or return an error:
+ */
+int readn(int fd, void *buf, ssize_t n)
 {
 	void *buf_start = buf;
+	size_t left = n;
+
+	BUG_ON(n <= 0);
 
-	while (n) {
-		int ret = read(fd, buf, n);
+	while (left) {
+		int ret = read(fd, buf, left);
 
 		if (ret <= 0)
 			return ret;
 
-		n -= ret;
+		left -= ret;
 		buf += ret;
 	}
 
-	return buf - buf_start;
+	BUG_ON(buf-buf_start != n);
+
+	return n;
 }
 
 size_t hex_width(u64 v)
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index c8f362d..bb0a336 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -253,7 +253,7 @@ bool strlazymatch(const char *str, const char *pat);
 int strtailcmp(const char *s1, const char *s2);
 char *strxfrchar(char *s, char from, char to);
 unsigned long convert_unit(unsigned long value, char *unit);
-int readn(int fd, void *buf, size_t size);
+int readn(int fd, void *buf, ssize_t size);
 
 struct perf_event_attr;
 
