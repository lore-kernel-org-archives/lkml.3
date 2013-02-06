Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab3BFVqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:46:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57292 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab3BFVod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:44:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/17] perf perl scripts: Fix SIGALRM and pipe read race for rwtop
Date: Wed,  6 Feb 2013 18:44:14 -0300
Message-Id: <1360187059-12661-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360187059-12661-1-git-send-email-acme@infradead.org>
References: <1360187059-12661-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Fixing rwtop script race. The issue is caused by rwtop script triggering
SIGALRM and underneath pipe reading layer reporting error when
interrupted.

Fixing this by setting SA_RESTART for rwtop SIGALRM handler, which
avoids interruption of the pipe reading layer.

The discussion for this issue & fix is here:
https://lkml.org/lkml/2012/9/18/123

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Original-patch-by: Andrew Jones <drjones@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360080351-3246-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/perl/rwtop.pl | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/scripts/perl/rwtop.pl b/tools/perf/scripts/perl/rwtop.pl
index 4bb3ecd..8b20787 100644
--- a/tools/perf/scripts/perl/rwtop.pl
+++ b/tools/perf/scripts/perl/rwtop.pl
@@ -17,6 +17,7 @@ use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
 use lib "./Perf-Trace-Util/lib";
 use Perf::Trace::Core;
 use Perf::Trace::Util;
+use POSIX qw/SIGALRM SA_RESTART/;
 
 my $default_interval = 3;
 my $nlines = 20;
@@ -90,7 +91,10 @@ sub syscalls::sys_enter_write
 
 sub trace_begin
 {
-    $SIG{ALRM} = \&set_print_pending;
+    my $sa = POSIX::SigAction->new(\&set_print_pending);
+    $sa->flags(SA_RESTART);
+    $sa->safe(1);
+    POSIX::sigaction(SIGALRM, $sa) or die "Can't set SIGALRM handler: $!\n";
     alarm 1;
 }
 
-- 
1.8.1.1.361.gec3ae6e

