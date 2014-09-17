Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbaIQVZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:25:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:58237 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757174AbaIQVZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:39 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/20] perf symbols: Ignore stripped vmlinux and fallback to kallsyms
Date: Wed, 17 Sep 2014 18:24:19 -0300
Message-Id: <1410989063-14207-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

If a vmlinux is stripped, perf will use it and ignore kallsyms. We
end up with useless profiles where everything maps to a few
runtime symbols:

    63.39%       swapper  [kernel.kallsyms]   [k] hcall_real_table
     4.90%      beam.smp  [kernel.kallsyms]   [k] hcall_real_table
     4.44%      beam.smp  [kernel.kallsyms]   [k] __sched_text_start
     3.72%      beam.smp  [kernel.kallsyms]   [k] __run_at_kexec

Detect this case and fallback to using kallsyms. This fixes the issue:

    62.81%       swapper  [kernel.kallsyms]   [k] snooze_loop
     4.44%      beam.smp  [kernel.kallsyms]   [k] __schedule
     0.91%      beam.smp  [kernel.kallsyms]   [k] _switch
     0.73%      beam.smp  [kernel.kallsyms]   [k] put_prev_entity

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140909085929.4a5a81f0@kryten
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 9c9b27fbc78d..2a92e10317c5 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -717,6 +717,14 @@ int dso__load_sym(struct dso *dso, struct map *map,
 		symbols__delete(&dso->symbols[map->type]);
 
 	if (!syms_ss->symtab) {
+		/*
+		 * If the vmlinux is stripped, fail so we will fall back
+		 * to using kallsyms. The vmlinux runtime symbols aren't
+		 * of much use.
+		 */
+		if (dso->kernel)
+			goto out_elf_end;
+
 		syms_ss->symtab  = syms_ss->dynsym;
 		syms_ss->symshdr = syms_ss->dynshdr;
 	}
-- 
1.9.3

