Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbbAVEyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:54:07 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37054 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbAVEx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:53:26 -0500
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Dave Martin <Dave.Martin@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: [PATCH V2 1/3] perf symbols: Ignore mapping symbols on aarch64
Date: Wed, 21 Jan 2015 20:52:56 -0800
Message-Id: <1421902378-3634-2-git-send-email-victor.kamensky@linaro.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1421902378-3634-1-git-send-email-victor.kamensky@linaro.org>
References: <1421902378-3634-1-git-send-email-victor.kamensky@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aarch64 ELF files use mapping symbols with special names $x, $d
to identify regions of Aarch64 code (see Aarch64 ELF ABI - "ARM
IHI 0056B", section "4.5.4 Mapping symbols").

The patch filters out these symbols at load time, similar to
"696b97a perf symbols: Ignore mapping symbols on ARM" changes
done for ARM before V8.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
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
Cc: Dave Martin <Dave.Martin@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 tools/perf/util/symbol-elf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 06fcd1b..1e188dd 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -862,6 +862,14 @@ int dso__load_sym(struct dso *dso, struct map *map,
 			    !strcmp(elf_name, "$t"))
 				continue;
 		}
+		/* Reject Aarch64 ELF "mapping symbols": these aren't unique and
+		 * don't identify functions, so will confuse the profile
+		 * output: */
+		if (ehdr.e_machine == EM_AARCH64) {
+			if (!strcmp(elf_name, "$x") ||
+			    !strcmp(elf_name, "$d"))
+				continue;
+		}
 
 		if (runtime_ss->opdsec && sym.st_shndx == runtime_ss->opdidx) {
 			u32 offset = sym.st_value - syms_ss->opdshdr.sh_addr;
-- 
1.9.3

