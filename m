Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaIHW7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:59:33 -0400
Received: from ozlabs.org ([103.22.144.67]:42199 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbaIHW7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:59:32 -0400
Date: Tue, 9 Sep 2014 08:59:29 +1000
From: Anton Blanchard <anton@samba.org>
To: acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Ignore stripped vmlinux and fallback to kallsyms
Message-ID: <20140909085929.4a5a81f0@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

Index: b/tools/perf/util/symbol-elf.c
===================================================================
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -712,6 +712,14 @@ int dso__load_sym(struct dso *dso, struc
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
