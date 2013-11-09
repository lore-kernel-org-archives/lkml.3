Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab3KIHdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:33:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364Ab3KIGui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Ming Lei <tom.leiming@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3.10 35/74] scripts/kallsyms: filter symbols not in kernel address space
Date: Fri,  8 Nov 2013 22:51:40 -0800
Message-Id: <20131109065115.981102672@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/kallsyms.c      |   12 +++++++++++-
 scripts/link-vmlinux.sh |    2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)

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
 
@@ -194,6 +198,9 @@ static int symbol_valid(struct sym_entry
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
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -82,6 +82,8 @@ kallsyms()
 		kallsymopt="${kallsymopt} --all-symbols"
 	fi
 
+	kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
+
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
 


