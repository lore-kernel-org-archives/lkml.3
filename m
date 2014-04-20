Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161158AbaDTIEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:04:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161074AbaDTIEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:04:13 -0400
Date: Sun, 20 Apr 2014 01:03:45 -0700
From: tip-bot for Vladimir Nikulichev <tipbot@zytor.com>
Message-ID: <tip-922d0e4d9f042f68baea28e5b3bd7bb708875f2e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        nvs@tbricks.com, namhyung@kernel.org, jolsa@redhat.com,
        adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nvs@tbricks.com, namhyung@kernel.org, jolsa@redhat.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <969812.163009436-sendEmail@nvs>
References: <969812.163009436-sendEmail@nvs>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Adjust symbols in VDSO
Git-Commit-ID: 922d0e4d9f042f68baea28e5b3bd7bb708875f2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  922d0e4d9f042f68baea28e5b3bd7bb708875f2e
Gitweb:     http://git.kernel.org/tip/922d0e4d9f042f68baea28e5b3bd7bb708875f2e
Author:     Vladimir Nikulichev <nvs@tbricks.com>
AuthorDate: Thu, 17 Apr 2014 08:27:01 -0700
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Sun, 20 Apr 2014 00:15:11 +0200

perf tools: Adjust symbols in VDSO

pert-report doesn't resolve function names in VDSO:

$ perf report --stdio -g flat,0.0,15,callee --sort pid
...
            8.76%
               0x7fff6b1fe861
               __gettimeofday
               ACE_OS::gettimeofday()
...

In this case symbol values should be adjusted the same way as for executables,
relocatable objects and prelinked libraries.

After fix:

$ perf report --stdio -g flat,0.0,15,callee --sort pid
...
            8.76%
               __vdso_gettimeofday
               __gettimeofday
               ACE_OS::gettimeofday()

Signed-off-by: Vladimir Nikulichev <nvs@tbricks.com>
Tested-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Link: http://lkml.kernel.org/r/969812.163009436-sendEmail@nvs
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/symbol-elf.c | 2 ++
 1 file changed, 2 insertions(+)

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
