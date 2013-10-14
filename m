Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab3JNUON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:14:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39102 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 110/161] perf trace: Add 'trace' alias to 'perf trace'
Date: Mon, 14 Oct 2013 17:01:39 -0300
Message-Id: <1381780950-25642-111-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Make 'perf trace' more accessible by aliasing it to just 'trace':

  [root@zoo linux]# trace --duration 15 -a -e futex sleep 1
   110.092 (16.188 ms): libvirtd/1166 futex(uaddr: 0x185b344, op: WAIT|PRIV, val: 174293                    ) = 0
   110.101 (15.903 ms): libvirtd/1171 futex(uaddr: 0x185b3dc, op: WAIT|PRIV, val: 139265                    ) = 0
   111.594 (15.776 ms): libvirtd/1165 futex(uaddr: 0x185b344, op: WAIT|PRIV, val: 174295                    ) = 0
   111.610 (15.969 ms): libvirtd/1169 futex(uaddr: 0x185b3dc, op: WAIT|PRIV, val: 139267                    ) = 0
   113.556 (16.216 ms): libvirtd/1168 futex(uaddr: 0x185b3dc, op: WAIT|PRIV, val: 139269                    ) = 0
   291.265 (199.508 ms): chromium-brows/15830 futex(uaddr: 0x7fff2986bcb4, op: WAIT_BITSET|PRIV|CLKRT, val: 1, utime: 0x7fff2986bab0, val3: 4294967295) = -1 ETIMEDOUT Connection timed out
     360.354 (69.053 ms): chromium-brows/15830 futex(uaddr: 0x7fff2986bcb4, op: WAIT_BITSET|PRIV|CLKRT, val: 1, utime: 0x7fff2986bab0, val3: 4294967295) = -1 ETIMEDOUT Connection timed out
  [root@zoo linux]#

I.e. looking for futex calls that take at least 15ms, system wide, during a one
second window. Now to get callchains into 'trace' to figure out what are those
locks :-)

Requested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ch4smqz8b5fmgrte7c5e4fuw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf | 2 ++
 tools/perf/perf.c        | 9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1f1361531f92..2badb08a0037 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -78,6 +78,7 @@ CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
 RM      = rm -f
+LN      = ln -f
 MKDIR   = mkdir
 FIND    = find
 INSTALL = install
@@ -809,6 +810,7 @@ install-gtk:
 install-bin: all install-gtk
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(LN) '$(DESTDIR_SQ)$(bindir_SQ)/perf' '$(DESTDIR_SQ)$(bindir_SQ)/trace'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifndef NO_LIBPERL
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 626577830264..8b38b4e80ec2 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -481,7 +481,14 @@ int main(int argc, const char **argv)
 		fprintf(stderr, "cannot handle %s internally", cmd);
 		goto out;
 	}
-
+#ifdef HAVE_LIBAUDIT_SUPPORT
+	if (!prefixcmp(cmd, "trace")) {
+		set_buildid_dir();
+		setup_path();
+		argv[0] = "trace";
+		return cmd_trace(argc, argv, NULL);
+	}
+#endif
 	/* Look for flags.. */
 	argv++;
 	argc--;
-- 
1.8.1.4

