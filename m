Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab3GVUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:25:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab3GVUWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:22:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/11] perf tools: Fix build with perl 5.18
Date: Mon, 22 Jul 2013 17:22:33 -0300
Message-Id: <1374524559-9839-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374524559-9839-1-git-send-email-acme@infradead.org>
References: <1374524559-9839-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
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
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1372063394-20126-1-git-send-email-kirill@shutemov.name
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2a69026..024680b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -631,10 +631,10 @@ $(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls $<
 
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
 
 $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs -Wno-undef -Wno-switch-default $<
 
 $(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
-- 
1.8.1.4

