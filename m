Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbbA0GeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:34:25 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59418 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbbA0GeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:34:20 -0500
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Dave Martin <Dave.Martin@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: [PATCH V3 1/2] perf symbols: Ignore mapping symbols on aarch64
Date: Mon, 26 Jan 2015 22:34:01 -0800
Message-Id: <1422340442-4673-2-git-send-email-victor.kamensky@linaro.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1422340442-4673-1-git-send-email-victor.kamensky@linaro.org>
References: <1422340442-4673-1-git-send-email-victor.kamensky@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aarch64 ELF files use mapping symbols with special names $x, $d
to identify regions of Aarch64 code (see Aarch64 ELF ABI - "ARM
IHI 0056B", section "4.5.4 Mapping symbols").

The patch filters out these symbols at load time, similar to
"696b97a perf symbols: Ignore mapping symbols on ARM" changes
done for ARM before V8.

Also added handling of mapping symbols that has format
"$d.<any>" and similar for both cases.

Note we are not making difference between EM_ARM and
EM_AARCH64 mapping symbols instead code handles superset
of both.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Avi Kivity <avi@cloudius-systems.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Dave Martin <Dave.Martin@arm.com>
---
 tools/perf/util/symbol-elf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 06fcd1b..8fc6e2f 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -856,10 +856,9 @@ int dso__load_sym(struct dso *dso, struct map *map,
 		/* Reject ARM ELF "mapping symbols": these aren't unique and
 		 * don't identify functions, so will confuse the profile
 		 * output: */
-		if (ehdr.e_machine == EM_ARM) {
-			if (!strcmp(elf_name, "$a") ||
-			    !strcmp(elf_name, "$d") ||
-			    !strcmp(elf_name, "$t"))
+		if (ehdr.e_machine == EM_ARM || ehdr.e_machine == EM_AARCH64) {
+			if (elf_name[0] == '$' && strchr("adtx", elf_name[1])
+			    && (elf_name[2] == '\0' || elf_name[2] == '.'))
 				continue;
 		}
 
-- 
1.9.3

