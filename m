Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab3ICHQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:16:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36034 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759614Ab3ICHQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:16:12 -0400
Date: Tue, 3 Sep 2013 00:15:59 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-0b8c25d949e010274c6697c570b772797ebc7c27@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1375026512-45826-1-git-send-email-dsahern@gmail.com>
References: <1375026512-45826-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix symbol offset computation for some dsos
Git-Commit-ID: 0b8c25d949e010274c6697c570b772797ebc7c27
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 03 Sep 2013 00:16:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b8c25d949e010274c6697c570b772797ebc7c27
Gitweb:     http://git.kernel.org/tip/0b8c25d949e010274c6697c570b772797ebc7c27
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 28 Jul 2013 09:48:32 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Sep 2013 14:58:21 -0300

perf tools: Fix symbol offset computation for some dsos

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
Link: http://lkml.kernel.org/r/1375026512-45826-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 1 +
 tools/perf/util/symbol.c  | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 07642a7..1fc0c62 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1513,6 +1513,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 				printf(" ");
 				if (print_symoffset) {
 					al.addr = node->ip;
+					al.map  = node->map;
 					symbol__fprintf_symname_offs(node->sym, &al, stdout);
 				} else
 					symbol__fprintf_symname(node->sym, stdout);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 77f3b95..7eb0362 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -259,7 +259,10 @@ size_t symbol__fprintf_symname_offs(const struct symbol *sym,
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
