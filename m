Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3BFWMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:12:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3BFWMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:12:07 -0500
Date: Wed, 6 Feb 2013 14:11:40 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-b22e79395c0fe4c86dd35745a929366034386ccc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, drjones@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, drjones@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1360080351-3246-2-git-send-email-jolsa@redhat.com>
References: <1360080351-3246-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf perl scripts:
  Fix SIGALRM and pipe read race for rwtop
Git-Commit-ID: b22e79395c0fe4c86dd35745a929366034386ccc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:11:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b22e79395c0fe4c86dd35745a929366034386ccc
Gitweb:     http://git.kernel.org/tip/b22e79395c0fe4c86dd35745a929366034386ccc
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 5 Feb 2013 17:05:50 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:27 -0300

perf perl scripts: Fix SIGALRM and pipe read race for rwtop

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
 
