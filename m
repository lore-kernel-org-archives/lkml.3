Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaCKKRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:17:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaCKKRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:17:18 -0400
Date: Tue, 11 Mar 2014 03:16:46 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-155b3a13a65d4217316dbe094843f2a7df0711fa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, albert@cloudflare.com,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        albert@cloudflare.com, mingo@elte.hu
In-Reply-To: <1393767127-599-1-git-send-email-jolsa@redhat.com>
References: <1393767127-599-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Fix crash in elf_section_by_name
Git-Commit-ID: 155b3a13a65d4217316dbe094843f2a7df0711fa
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

Commit-ID:  155b3a13a65d4217316dbe094843f2a7df0711fa
Gitweb:     http://git.kernel.org/tip/155b3a13a65d4217316dbe094843f2a7df0711fa
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 2 Mar 2014 14:32:07 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Mar 2014 11:17:14 -0300

perf symbols: Fix crash in elf_section_by_name

Fixing crash in elf_section_by_name function caused by missing section
name in elf binary.

Reported-by: Albert Strasheim <albert@cloudflare.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Albert Strasheim <albert@cloudflare.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1393767127-599-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3e9f336..516d19f 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -151,15 +151,15 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 
 		gelf_getshdr(sec, shp);
 		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
-		if (!strcmp(name, str)) {
+		if (str && !strcmp(name, str)) {
 			if (idx)
 				*idx = cnt;
-			break;
+			return sec;
 		}
 		++cnt;
 	}
 
-	return sec;
+	return NULL;
 }
 
 #define elf_section__for_each_rel(reldata, pos, pos_mem, idx, nr_entries) \
