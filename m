Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab3J1FYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:24:31 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64098 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3J1FYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:24:30 -0400
Date: Mon, 28 Oct 2013 13:23:48 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chen Gang <gang.chen@asianux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Michal Marek <mmarek@suse.cz>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
Message-ID: <20131028132348.62f7e368@tom-ThinkPad-T410>
In-Reply-To: <874n82gk89.fsf@rustcorp.com.au>
References: <1382498320-26594-1-git-send-email-tom.leiming@gmail.com>
	<87eh7bfoq9.fsf@rustcorp.com.au>
	<20131024084559.GD16735@n2100.arm.linux.org.uk>
	<87mwlyclng.fsf@rustcorp.com.au>
	<CACVXFVO86u0h0V-1_DCkO5HNyUp2i_UsjPrVWDb-ZBtmwVk28A@mail.gmail.com>
	<87y55h7vcd.fsf@rustcorp.com.au>
	<CACVXFVPXEUX9JQ2NZvL8=J34zbw2fn202QW2SQtpKjdQ+tv=vg@mail.gmail.com>
	<87sivp7eai.fsf@rustcorp.com.au>
	<CACVXFVN7PiU1dorkeamtC9-Wg_TVQE8xFiJtad-C8q4_=Rc1Ow@mail.gmail.com>
	<874n82gk89.fsf@rustcorp.com.au>
Organization: Ming
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013 13:44:30 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Ming Lei <tom.leiming@gmail.com> writes:
> 
> I don't know...  It would be your job, as the person making the change,
> to find all the users of kallsyms and prove that.
> 
> This is why it is easier not to include incorrect values in the kernel's
> kallsyms in the first place.

OK, thanks for your comment, and I figured out one way to do it in
scripts/kallsyms.c, could you comment on below patch?

--
>From 4327534dedfa60d208ac3e23db7556c243e1c7dc Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Mon, 28 Oct 2013 13:04:49 +0800
Subject: [PATCH] scripts/kallsyms: filter symbols not in kernel address space

This patch uses CONFIG_PAGE_OFFSET to filter symbols which
are not in kernel address space because these symbols are
generally for generating code purpose and can't be run at
kernel mode, so we needn't keep them in /proc/kallsyms.

For example, on ARM there are some symbols which may be
linked in relocatable code section, then perf can't parse
symbols any more from /proc/kallsyms, this patch fixes the
problem.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 scripts/kallsyms.c      |   12 +++++++++++-
 scripts/link-vmlinux.sh |    2 ++
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
index 0149949..32b10f5 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -82,6 +82,8 @@ kallsyms()
 		kallsymopt="${kallsymopt} --all-symbols"
 	fi
 
+	kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
+
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
 
-- 
1.7.9.5




Thanks,
-- 
Ming Lei
