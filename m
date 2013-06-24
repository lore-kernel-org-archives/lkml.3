Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab3FXHsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:48:38 -0400
Received: from shutemov.name ([204.155.152.216]:38140 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab3FXHsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:48:37 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] perf: fix build with perl 5.18
Date: Mon, 24 Jun 2013 11:43:14 +0300
Message-Id: <1372063394-20126-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

perl.h from new Perl release doesn't like -Wundef and -Wswitch-default:

/usr/lib/perl5/core_perl/CORE/perl.h:548:5: error: "SILENT_NO_TAINT_SUPPORT" is not defined [-Werror=undef]
 #if SILENT_NO_TAINT_SUPPORT && !defined(NO_TAINT_SUPPORT)
     ^
/usr/lib/perl5/core_perl/CORE/perl.h:556:5: error: "NO_TAINT_SUPPORT" is not defined [-Werror=undef]
 #if NO_TAINT_SUPPORT
     ^
In file included from /usr/lib/perl5/core_perl/CORE/perl.h:3471:0,
                 from util/scripting-engines/trace-event-perl.c:30:
/usr/lib/perl5/core_perl/CORE/sv.h:1455:5: error: "NO_TAINT_SUPPORT" is not defined [-Werror=undef]
 #if NO_TAINT_SUPPORT
     ^
In file included from /usr/lib/perl5/core_perl/CORE/perl.h:3472:0,
                 from util/scripting-engines/trace-event-perl.c:30:
/usr/lib/perl5/core_perl/CORE/regexp.h:436:5: error: "NO_TAINT_SUPPORT" is not defined [-Werror=undef]
 #if NO_TAINT_SUPPORT
     ^
In file included from /usr/lib/perl5/core_perl/CORE/hv.h:592:0,
                 from /usr/lib/perl5/core_perl/CORE/perl.h:3480,
                 from util/scripting-engines/trace-event-perl.c:30:
/usr/lib/perl5/core_perl/CORE/hv_func.h: In function ‘S_perl_hash_siphash_2_4’:
/usr/lib/perl5/core_perl/CORE/hv_func.h:222:3: error: switch missing default case [-Werror=switch-default]
   switch( left )
   ^
/usr/lib/perl5/core_perl/CORE/hv_func.h: In function ‘S_perl_hash_superfast’:
/usr/lib/perl5/core_perl/CORE/hv_func.h:274:5: error: switch missing default case [-Werror=switch-default]
     switch (rem) { \
     ^
/usr/lib/perl5/core_perl/CORE/hv_func.h: In function ‘S_perl_hash_murmur3’:
/usr/lib/perl5/core_perl/CORE/hv_func.h:398:5: error: switch missing default case [-Werror=switch-default]
     switch(bytes_in_carry) { /* how many bytes in carry */
     ^

Let's disable the warnings for code which uses perl.h.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 tools/perf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b0f164b..3230f9e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1035,10 +1035,10 @@ $(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls $<
 
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
 
 $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs -Wno-undef -Wno-switch-default $<
 
 $(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
-- 
1.8.3.1

