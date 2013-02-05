Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3BEQHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:07:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab3BEQG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:06:59 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Andrew Jones <drjones@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/2] perf scripts: Fix SIGALRM and pipe read race for rwtop
Date: Tue,  5 Feb 2013 17:05:50 +0100
Message-Id: <1360080351-3246-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1360080351-3246-1-git-send-email-jolsa@redhat.com>
References: <1360080351-3246-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing rwtop script race. The issue is caused by rwtop
script triggering SIGALRM and underneath pipe reading
layer reporting error when interrupted.

Fixing this by setting SA_RESTART for rwtop SIGALRM handler,
which avoids interruption of the pipe reading layer.

The discussion for this issue & fix is here:
https://lkml.org/lkml/2012/9/18/123

Original-patch-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Andrew Jones <drjones@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
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
1.7.11.7

