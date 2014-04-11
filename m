Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbaDKOT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:19:58 -0400
Received: from mx.tbricks.com ([212.247.19.44]:39975 "EHLO mx.tbricks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbaDKOTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:19:54 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 10:19:54 EDT
Message-ID: <969812.163009436-sendEmail@nvs>
From: "Vladimir Nikulichev" <nvs@tbricks.com>
To: "Jiri Olsa" <jolsa@redhat.com>
Cc: "Namhyung Kim" <namhyung@kernel.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Paul Mackerras" <paulus@samba.org>, "Ingo Molnar" <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf tools: Adjust symbols in VDSO
Date: Fri, 11 Apr 2014 13:19:50 +0000
X-Mailer: sendEmail-1.56
MIME-Version: 1.0
Content-Type: multipart/related; boundary="----MIME delimiter for sendEmail-456372.307221503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format. To properly display this message you need a MIME-Version 1.0 compliant Email program.

------MIME delimiter for sendEmail-456372.307221503
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

perf tools: Adjust symbols in VDSO

pert-report doesn't resolve function names in VDSO:

$ perf report --stdio -g flat,0.0,15,callee --sort pid
..
            8.76%
               0x7fff6b1fe861
               __gettimeofday
               ACE_OS::gettimeofday()
..

In this case symbol values should be adjusted the same way as for executables, relocatable objects and prelinked libraries.

After fix:

$ perf report --stdio -g flat,0.0,15,callee --sort pid
..
            8.76%
               __vdso_gettimeofday
               __gettimeofday
               ACE_OS::gettimeofday()

Signed-off-by: Vladimir Nikulichev <nvs@tbricks.com>

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3b7dbf5..6864661 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -6,6 +6,7 @@
#include <inttypes.h>

#include "symbol.h"
+#include "vdso.h"
#include <symbol/kallsyms.h>
#include "debug.h"

@@ -618,6 +619,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
		GElf_Shdr shdr;
		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
				ehdr.e_type == ET_REL ||
+				is_vdso_map(dso->short_name) ||
				elf_section_by_name(elf, &ehdr, &shdr,
						     ".gnu.prelink_undo",
						     NULL) != NULL);


------MIME delimiter for sendEmail-456372.307221503--

