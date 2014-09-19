Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbaISFWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:22:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbaISFWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:22:44 -0400
Date: Thu, 18 Sep 2014 22:22:31 -0700
From: tip-bot for Anton Blanchard <tipbot@zytor.com>
Message-ID: <tip-d0b0d0406fe6743e734e1ba780155f8db5f713e6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, anton@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@samba.org, mingo@redhat.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, tglx@linutronix.de
In-Reply-To: <20140909085929.4a5a81f0@kryten>
References: <20140909085929.4a5a81f0@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Ignore stripped vmlinux and fallback to kallsyms
Git-Commit-ID: d0b0d0406fe6743e734e1ba780155f8db5f713e6
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

Commit-ID:  d0b0d0406fe6743e734e1ba780155f8db5f713e6
Gitweb:     http://git.kernel.org/tip/d0b0d0406fe6743e734e1ba780155f8db5f713e6
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Tue, 9 Sep 2014 08:59:29 +1000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:10 -0300

perf symbols: Ignore stripped vmlinux and fallback to kallsyms

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
index 9c9b27f..2a92e10 100644
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
