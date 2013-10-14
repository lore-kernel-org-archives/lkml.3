Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab3JNUID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:08:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39340 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab3JNUIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:08:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Chenggang Qin <chenggang.qcg@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 161/161] perf symbols: Fix a mmap and munmap mismatched bug
Date: Mon, 14 Oct 2013 17:02:30 -0300
Message-Id: <1381780950-25642-162-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chenggang Qin <chenggang.qcg@taobao.com>

In function filename__read_debuglink(), while the ELF file is opend and
mmapped in elf_begin(), but if this file is considered to not be usable
during the following code, we will goto the close(fd) directly. The
elf_end() is skipped.  So, the mmaped ELF file cannot be munmapped. The
mmapped areas exist during the life of perf.

This is a memory leak.  This patch fixed this bug.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Chenggang Qin <chenggang.qcg@taobao.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Link: http://lkml.kernel.org/r/1381451279-4109-1-git-send-email-chenggang.qin@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index d6b8af3ce344..eed0b96302af 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -487,27 +487,27 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 
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
1.8.1.4

