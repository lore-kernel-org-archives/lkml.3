Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3AYL45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:56:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42130 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab3AYL4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:56:55 -0500
Date: Fri, 25 Jan 2013 03:56:28 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-3cecaa2002273887a9364c454684fa8491bb2b10@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1358337594-10916-1-git-send-email-namhyung@kernel.org>
References: <1358337594-10916-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Do not include PERF-VERSION-FILE to Makefile
Git-Commit-ID: 3cecaa2002273887a9364c454684fa8491bb2b10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:56:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cecaa2002273887a9364c454684fa8491bb2b10
Gitweb:     http://git.kernel.org/tip/3cecaa2002273887a9364c454684fa8491bb2b10
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 16 Jan 2013 20:59:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:45 -0300

perf tools: Do not include PERF-VERSION-FILE to Makefile

When make runs it tries to update the Makefile rules by reading all of
included Makefiles.  During the perf build it checks PERF-VERSION-FILE
to get the current version number.  But it triggers Makefile update so
that make runs again with the update Makefile and, in turn, users will
see duplicate CHK message on the second path.

Running make with -d option for debugging tells me this:

GNU Make 3.82
Built for x86_64-redhat-linux-gnu
Copyright (C) 2010  Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Reading makefiles...
Reading makefile `Makefile'...
Reading makefile `../scripts/Makefile.include' (search path) (no ~ expansion)...
Reading makefile `config/utilities.mak' (search path) (no ~ expansion)...
Reading makefile `PERF-VERSION-FILE' (search path) (don't care) (no ~ expansion)...
Reading makefile `config/feature-tests.mak' (search path) (don't care) (no ~ expansion)...
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
...
Updating makefiles....
 Considering target file `PERF-VERSION-FILE'.
 Must remake target `PERF-VERSION-FILE'.
Invoking recipe from Makefile:52 to update target `PERF-VERSION-FILE'.
Putting child 0x14037a0 (PERF-VERSION-FILE) PID 31925 on the chain.
Live child 0x14037a0 (PERF-VERSION-FILE) PID 31925
PERF_VERSION = 3.8.rc3.gf751db6
Reaping winning child 0x14037a0 PID 31925
Removing child 0x14037a0 PID 31925 from chain.
 Successfully remade target file `PERF-VERSION-FILE'.
...
Re-executing[1]: make -d                       <------------ here
GNU Make 3.82
Built for x86_64-redhat-linux-gnu
Copyright (C) 2010  Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Reading makefiles...
Reading makefile `Makefile'...
Reading makefile `../scripts/Makefile.include' (search path) (no ~ expansion)...
Reading makefile `config/utilities.mak' (search path) (no ~ expansion)...
Reading makefile `PERF-VERSION-FILE' (search path) (don't care) (no ~ expansion)...
Reading makefile `config/feature-tests.mak' (search path) (don't care) (no ~ expansion)...
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
...

Actually PERF-VERSION-FILE is used only for perf.c to #define
PERF_VERSION macro.  So make it like a C header file and include it
during compiling the perf.c file will remove the need of being
included into Makefile.  Hench no need to update the Makefile and no
CHK lines anymore.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1358337594-10916-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile              | 3 +--
 tools/perf/util/PERF-VERSION-GEN | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6aef6d0..a84021a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -50,7 +50,6 @@ include config/utilities.mak
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
--include $(OUTPUT)PERF-VERSION-FILE
 
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 
@@ -887,7 +886,7 @@ strip: $(PROGRAMS) $(OUTPUT)perf
 	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf
 
 $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -DPERF_VERSION='"$(PERF_VERSION)"' \
+	$(QUIET_CC)$(CC) -include $(OUTPUT)PERF-VERSION-FILE \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
 		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
 
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 6aa34e5..055fef3 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -26,13 +26,13 @@ VN=$(expr "$VN" : v*'\(.*\)')
 
 if test -r $GVF
 then
-	VC=$(sed -e 's/^PERF_VERSION = //' <$GVF)
+	VC=$(sed -e 's/^#define PERF_VERSION "\(.*\)"/\1/' <$GVF)
 else
 	VC=unset
 fi
 test "$VN" = "$VC" || {
 	echo >&2 "PERF_VERSION = $VN"
-	echo "PERF_VERSION = $VN" >$GVF
+	echo "#define PERF_VERSION \"$VN\"" >$GVF
 }
 
 
