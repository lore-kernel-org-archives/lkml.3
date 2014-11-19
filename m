Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbaKSQEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:04:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:51356 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbaKSQEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:04:11 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/16] perf symbols: Fallback to kallsyms when using the minimal 'ELF' loader
Date: Wed, 19 Nov 2014 13:03:23 -0300
Message-Id: <1416413016-19110-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The minimal ELF loader should not return 1 when it manages to read the
vmlinux build-id, it should instead return 0, meaning that it hasn't
loaded any symbols, since it doesn't parses ELF at all.

That way, the main symbol.c routines will understand that it is
necessary to continue looking for a file with symbols, and when no
libelf is linked, that means it will eventually try kallsyms.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20141111130326.GT18464@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-minimal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index c9541fea9514..fa585c63f56a 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -341,7 +341,6 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
 
 	if (filename__read_build_id(ss->name, build_id, BUILD_ID_SIZE) > 0) {
 		dso__set_build_id(dso, build_id);
-		return 1;
 	}
 	return 0;
 }
-- 
1.9.3

