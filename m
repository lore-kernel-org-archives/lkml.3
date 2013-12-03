Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3LCHP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 02:15:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:2119 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab3LCHPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 02:15:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445838770"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/7] perf tools: Do not need to read symbols for source line lookup
Date: Tue,  3 Dec 2013 09:23:09 +0200
Message-Id: <1386055390-13757-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using libbfd to lookup source filename and line number,
libbfd does not need the symbol table.  Removing the symbol
table reading, doubles the speed of 'perf script' with the
'srcline' option.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/srcline.c | 53 +----------------------------------------------
 1 file changed, 1 insertion(+), 52 deletions(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 93795f9..e09c9e0 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -29,54 +29,6 @@ struct a2l_data {
 	asymbol 	**syms;
 };
 
-static int bfd_error(const char *string)
-{
-	const char *errmsg;
-
-	errmsg = bfd_errmsg(bfd_get_error());
-	fflush(stdout);
-
-	if (string)
-		pr_debug("%s: %s\n", string, errmsg);
-	else
-		pr_debug("%s\n", errmsg);
-
-	return -1;
-}
-
-static int slurp_symtab(bfd *abfd, struct a2l_data *a2l)
-{
-	long storage;
-	long symcount;
-	asymbol **syms;
-	bfd_boolean dynamic = FALSE;
-
-	if ((bfd_get_file_flags(abfd) & HAS_SYMS) == 0)
-		return bfd_error(bfd_get_filename(abfd));
-
-	storage = bfd_get_symtab_upper_bound(abfd);
-	if (storage == 0L) {
-		storage = bfd_get_dynamic_symtab_upper_bound(abfd);
-		dynamic = TRUE;
-	}
-	if (storage < 0L)
-		return bfd_error(bfd_get_filename(abfd));
-
-	syms = malloc(storage);
-	if (dynamic)
-		symcount = bfd_canonicalize_dynamic_symtab(abfd, syms);
-	else
-		symcount = bfd_canonicalize_symtab(abfd, syms);
-
-	if (symcount < 0) {
-		free(syms);
-		return bfd_error(bfd_get_filename(abfd));
-	}
-
-	a2l->syms = syms;
-	return 0;
-}
-
 static void find_address_in_section(bfd *abfd, asection *section, void *data)
 {
 	bfd_vma pc, vma;
@@ -96,7 +48,7 @@ static void find_address_in_section(bfd *abfd, asection *section, void *data)
 	if (pc < vma || pc >= vma + size)
 		return;
 
-	a2l->found = bfd_find_nearest_line(abfd, section, a2l->syms, pc - vma,
+	a2l->found = bfd_find_nearest_line(abfd, section, NULL, pc - vma,
 					   &a2l->filename, &a2l->funcname,
 					   &a2l->line);
 }
@@ -122,9 +74,6 @@ static struct a2l_data *addr2line_init(const char *path)
 	if (a2l->input == NULL)
 		goto out;
 
-	if (slurp_symtab(abfd, a2l))
-		goto out;
-
 	return a2l;
 
 out:
-- 
1.7.11.7

