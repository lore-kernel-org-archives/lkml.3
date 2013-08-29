Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3H2MIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:08:30 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52328 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3H2MI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:08:28 -0400
From: Chenggang Qin <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chenggang Qin <chenggang.qcg@taobao.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf core: Fix a bug that lead to mmap() & munmap() mismatch
Date: Thu, 29 Aug 2013 20:08:01 +0800
Message-Id: <1377778081-7115-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chenggang Qin <chenggang.qcg@taobao.com>

In function filename__read_debuglink(), after the elf_begin() mmapped the dso file,
the execution stream may goto "out_close". So, the elf_end() is skipped, and the
munmap() cannot be executed.

While perf is executed for a long time, the files that are not munmapped will cost
a large memory.

This patch fixed this bug.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
---
 tools/perf/util/symbol-elf.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 4b12bf8..b4df870 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -471,27 +471,27 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 
 	ek = elf_kind(elf);
 	if (ek != ELF_K_ELF)
-		goto out_close;
+		goto out_elf_end;
 
 	if (gelf_getehdr(elf, &ehdr) == NULL) {
 		pr_err("%s: cannot get elf header.\n", __func__);
-		goto out_close;
+		goto out_elf_end;
 	}
 
 	sec = elf_section_by_name(elf, &ehdr, &shdr,
 				  ".gnu_debuglink", NULL);
 	if (sec == NULL)
-		goto out_close;
+		goto out_elf_end;
 
 	data = elf_getdata(sec, NULL);
 	if (data == NULL)
-		goto out_close;
+		goto out_elf_end;
 
 	/* the start of this section is a zero-terminated string */
 	strncpy(debuglink, data->d_buf, size);
 
+out_elf_end:
 	elf_end(elf);
-
 out_close:
 	close(fd);
 out:
-- 
1.7.8.rc2.5.g815b

