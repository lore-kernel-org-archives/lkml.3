Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab3KHCSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:18:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab3KHCQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:26 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Michal Marek <mmarek@suse.cz>,
        Ming Lei <tom.leiming@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 91/91] scripts/kallsyms: filter symbols not in kernel address space
Date: Thu,  7 Nov 2013 18:15:46 -0800
Message-Id: <1383876946-2396-92-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

commit f6537f2f0eba4eba3354e48dbe3047db6d8b6254 upstream.

This patch uses CONFIG_PAGE_OFFSET to filter symbols which
are not in kernel address space because these symbols are
generally for generating code purpose and can't be run at
kernel mode, so we needn't keep them in /proc/kallsyms.

For example, on ARM there are some symbols which may be
linked in relocatable code section, then perf can't parse
symbols any more from /proc/kallsyms, this patch fixes the
problem (introduced b9b32bf70f2fb710b07c94e13afbc729afe221da)

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 scripts/kallsyms.c      | 12 +++++++++++-
 scripts/link-vmlinux.sh |  2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 487ac6f..9a11f9f 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -55,6 +55,7 @@ static struct sym_entry *table;
 static unsigned int table_size, table_cnt;
 static int all_symbols = 0;
 static char symbol_prefix_char = '\0';
+static unsigned long long kernel_start_addr = 0;
 
 int token_profit[0x10000];
 
@@ -65,7 +66,10 @@ unsigned char best_table_len[256];
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--symbol-prefix=<prefix char>] < in.map > out.S\n");
+	fprintf(stderr, "Usage: kallsyms [--all-symbols] "
+			"[--symbol-prefix=<prefix char>] "
+			"[--page-offset=<CONFIG_PAGE_OFFSET>] "
+			"< in.map > out.S\n");
 	exit(1);
 }
 
@@ -194,6 +198,9 @@ static int symbol_valid(struct sym_entry *s)
 	int i;
 	int offset = 1;
 
+	if (s->addr < kernel_start_addr)
+		return 0;
+
 	/* skip prefix char */
 	if (symbol_prefix_char && *(s->sym + 1) == symbol_prefix_char)
 		offset++;
@@ -646,6 +653,9 @@ int main(int argc, char **argv)
 				if ((*p == '"' && *(p+2) == '"') || (*p == '\'' && *(p+2) == '\''))
 					p++;
 				symbol_prefix_char = *p;
+			} else if (strncmp(argv[i], "--page-offset=", 14) == 0) {
+				const char *p = &argv[i][14];
+				kernel_start_addr = strtoull(p, NULL, 16);
 			} else
 				usage();
 		}
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index b3d907e..5716ba1 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -83,6 +83,8 @@ kallsyms()
 		kallsymopt="${kallsymopt} --all-symbols"
 	fi
 
+	kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
+
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
 
-- 
1.8.1.2

