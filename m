Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3G1Psi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 11:48:38 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49064 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3G1Psh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 11:48:37 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tool: Fix symbol offset computation for some dsos
Date: Sun, 28 Jul 2013 09:48:32 -0600
Message-Id: <1375026512-45826-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some dsos (e.g., libc, libpthread, kernel modules) the symbol offset
is huge. e.g.,

qemu-kvm 17238/17242 [007] 762235.640311:
    ffffffff816288a1 __schedule+0x451 ([kernel.kallsyms])
    ffffffff81629609 schedule+0x29 ([kernel.kallsyms])
    ffffffffa00a6ded kvm_vcpu_block+0xffffffffa00a106d (/lib/modules/3.11.0-rc1+/kernel/arch/x86/kvm/kvm.ko)
    ffffffffa00bae6b kvm_arch_vcpu_ioctl_run+0xffffffffa00a118b (/lib/modules/3.11.0-rc1+/kernel/arch/x86/kvm/kvm.ko)
    ffffffffa00a4d7a kvm_vcpu_ioctl+0xffffffffa00a141a (/lib/modules/3.11.0-rc1+/kernel/arch/x86/kvm/kvm.ko)
    ffffffff811a7bdb do_vfs_ioctl+0x8b ([kernel.kallsyms])
    ffffffff811a80c1 sys_ioctl+0x91 ([kernel.kallsyms])
    ffffffff81633182 system_call+0x72 ([kernel.kallsyms])
        7f882a97af27 __GI___ioctl+0x7f882a891007 (/lib64/libc-2.14.90.so)
           100000002 [unknown] ([unknown])

It seems to be maps with a non-0 start. Taking that into account the
offsets are correct:

qemu-kvm 17238/17242 [007] 762235.640311:
    ffffffff816288a1 __schedule+0x451 ([kernel.kallsyms])
    ffffffff81629609 schedule+0x29 ([kernel.kallsyms])
    ffffffffa00a6ded kvm_vcpu_block+0x6d (/lib/modules/3.11.0-rc1+/kernel/arch/x86/kvm/kvm.ko)
    ffffffffa00bae6b kvm_arch_vcpu_ioctl_run+0x18b (/lib/modules/3.11.0-rc1+/kernel/arch/x86/kvm/kvm.ko)
    ffffffffa00a4d7a kvm_vcpu_ioctl+0x41a (/lib/modules/3.11.0-rc1+/kernel/arch/x86/kvm/kvm.ko)
    ffffffff811a7bdb do_vfs_ioctl+0x8b ([kernel.kallsyms])
    ffffffff811a80c1 sys_ioctl+0x91 ([kernel.kallsyms])
    ffffffff81633182 system_call+0x72 ([kernel.kallsyms])
        7f882a97af27 __GI___ioctl+0x7 (/lib64/libc-2.14.90.so)
           100000002 [unknown] ([unknown])

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/session.c |    1 +
 tools/perf/util/symbol.c  |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 38320ac..8f9ba44 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1413,6 +1413,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 				printf(" ");
 				if (print_symoffset) {
 					al.addr = node->ip;
+					al.map  = node->map;
 					symbol__fprintf_symname_offs(node->sym, &al, stdout);
 				} else
 					symbol__fprintf_symname(node->sym, stdout);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 02718e7..2264733 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -248,7 +248,10 @@ size_t symbol__fprintf_symname_offs(const struct symbol *sym,
 	if (sym && sym->name) {
 		length = fprintf(fp, "%s", sym->name);
 		if (al) {
-			offset = al->addr - sym->start;
+			if (al->addr < sym->end)
+				offset = al->addr - sym->start;
+			else
+				offset = al->addr - al->map->start - sym->start;
 			length += fprintf(fp, "+0x%lx", offset);
 		}
 		return length;
-- 
1.7.10.1

