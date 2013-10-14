Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab3JNUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:16:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39076 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 141/161] perf tools: Fix old GCC build error in 'get_srcline'
Date: Mon, 14 Oct 2013 17:02:10 -0300
Message-Id: <1381780950-25642-142-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

trace-event-parse.c:parse_proc_kallsyms()

    Old GCC (4.4.2) does not see through the code flow of get_srcline() and
gets confused about the status of 'file' and 'line':

    CC       /tmp/build/perf/util/srcline.o
  cc1: warnings being treated as errors
  util/srcline.c: In function ¿get_srcline¿:
  util/srcline.c:226: error: ¿file¿ may be used uninitialized in this function
  util/srcline.c:227: error: ¿line¿ may be used uninitialized in this function
  make[1]: *** [/tmp/build/perf/util/srcline.o] Error 1
  make: *** [install] Error 2
  make: Leaving directory `/home/acme/git/linux/tools/perf'
  [acme@fedora12 linux]$

Help out GCC by initializing 'file' and 'line'.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Link: http://lkml.kernel.org/n/tip-h8k7h49z3cndqgjdftkmm9f8@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/srcline.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 37353194e0f6..d11aefbc4b8d 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -223,8 +223,8 @@ out:
 
 char *get_srcline(struct dso *dso, unsigned long addr)
 {
-	char *file;
-	unsigned line;
+	char *file = NULL;
+	unsigned line = 0;
 	char *srcline;
 	char *dso_name = dso->long_name;
 	size_t size;
-- 
1.8.1.4

