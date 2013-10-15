Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab3JOFg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:36:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33979 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab3JOFgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:36:21 -0400
Date: Mon, 14 Oct 2013 22:35:59 -0700
From: tip-bot for Chenggang Qin <tipbot@zytor.com>
Message-ID: <tip-784f3390f9bd900adfb3b0373615e105a0d9749a@git.kernel.org>
Cc: acme@redhat.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, akpm@linux-foundation.org,
        yanmin.zhang@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        namhyung@kernel.org, namhyung@gmail.com, chenggang.qcg@taobao.com
Reply-To: mingo@kernel.org, mingo@redhat.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, akpm@linux-foundation.org,
        yanmin.zhang@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        namhyung@kernel.org, namhyung@gmail.com, chenggang.qcg@taobao.com
In-Reply-To: <1381451279-4109-1-git-send-email-chenggang.qin@gmail.com>
References: <1381451279-4109-1-git-send-email-chenggang.qin@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Fix a mmap and munmap mismatched bug
Git-Commit-ID: 784f3390f9bd900adfb3b0373615e105a0d9749a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:36:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  784f3390f9bd900adfb3b0373615e105a0d9749a
Gitweb:     http://git.kernel.org/tip/784f3390f9bd900adfb3b0373615e105a0d9749a
Author:     Chenggang Qin <chenggang.qcg@taobao.com>
AuthorDate: Fri, 11 Oct 2013 08:27:57 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 12:21:23 -0300

perf symbols: Fix a mmap and munmap mismatched bug

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
index d6b8af3..eed0b96 100644
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
