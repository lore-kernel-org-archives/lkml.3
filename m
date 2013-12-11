Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3LKLKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:10:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60469 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3LKLJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:09:02 -0500
Date: Wed, 11 Dec 2013 03:08:27 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-ac5e7f84c0e050fe19146d9bf51f69890beabcef@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        jolsa@redhat.com, bccheng@google.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, bccheng@google.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <20131205182642.GA14614@quad>
References: <20131205182642.GA14614@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Fix bug in usage of the basename()
  function
Git-Commit-ID: ac5e7f84c0e050fe19146d9bf51f69890beabcef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:08:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac5e7f84c0e050fe19146d9bf51f69890beabcef
Gitweb:     http://git.kernel.org/tip/ac5e7f84c0e050fe19146d9bf51f69890beabcef
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 5 Dec 2013 19:26:42 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Dec 2013 16:51:11 -0300

perf symbols: Fix bug in usage of the basename() function

The basename() implementation varies a lot between systems.

The Linux man page says: "basename may modify the content of the path,
so it may be desirable to pass a copy when calling the function".

On some other systems, the returned address may come from an internal
buffer which can be reused in subsequent calls, thus the results should
also be copied.

The dso__set_basename() function was not doing this causing problems
on some systems with wrong library names being shown by perf report,
such as on Android systems.

This patch fixes the problem.
The patch is relative to tip.git.

In v2, we clean up the comments based on Ingo's feedback.

Reported-by: Ben Cheng <bccheng@google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ben Cheng <bccheng@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131205182642.GA14614@quad
[ v3: Fixed up wrt allocated flag now being set in dso__set_short_name ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 582b5d3..436922f 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -413,7 +413,28 @@ void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated)
 
 static void dso__set_basename(struct dso *dso)
 {
-	dso__set_short_name(dso, basename((char *)dso->long_name), false);
+       /*
+        * basename() may modify path buffer, so we must pass
+        * a copy.
+        */
+       char *base, *lname = strdup(dso->long_name);
+
+       if (!lname)
+               return;
+
+       /*
+        * basename() may return a pointer to internal
+        * storage which is reused in subsequent calls
+        * so copy the result.
+        */
+       base = strdup(basename(lname));
+
+       free(lname);
+
+       if (!base)
+               return;
+
+       dso__set_short_name(dso, base, true);
 }
 
 int dso__name_len(const struct dso *dso)
