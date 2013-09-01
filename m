Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3IAPaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 11:30:22 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35359 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab3IAPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 11:30:21 -0400
From: Chenggang Qin <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: root <root@core097011.sqa.cm4>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: [PATCH 1/3] perf core: Fix a mmap and munmap mismatched bug
Date: Sun,  1 Sep 2013 23:29:43 +0800
Message-Id: <1378049385-4466-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@core097011.sqa.cm4>

In function filename__read_debuglink(), while the ELF file is opend and mmapped
in elf_begin(), but if this file is considered to not be usable during the
following code, we will goto the close(fd) directly. The elf_end() is skipped.
So, the mmaped ELF file cannot be munmapped. The memory areas are mmapped is
exist during the life of perf. This is a memory leak.
This patch fixed this bug.
Thanks.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
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

