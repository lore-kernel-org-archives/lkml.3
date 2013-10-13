Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3JMMBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 08:01:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43686 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3JMMBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 08:01:32 -0400
Date: Sun, 13 Oct 2013 05:01:08 -0700
From: tip-bot for Michael Davidson <tipbot@zytor.com>
Message-ID: <tip-d751c169e9a6f0f853346f1184881422bd10b3c2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, md@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, md@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20131011013954.GA28902@www.outflux.net>
References: <20131011013954.GA28902@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, relocs: Add more per-cpu gold special cases
Git-Commit-ID: d751c169e9a6f0f853346f1184881422bd10b3c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 13 Oct 2013 05:01:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d751c169e9a6f0f853346f1184881422bd10b3c2
Gitweb:     http://git.kernel.org/tip/d751c169e9a6f0f853346f1184881422bd10b3c2
Author:     Michael Davidson <md@google.com>
AuthorDate: Thu, 10 Oct 2013 18:39:54 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 13 Oct 2013 03:11:57 -0700

x86, relocs: Add more per-cpu gold special cases

The "gold" linker doesn't seem to put some additional per-cpu cases in
the right place. Add these to the per-cpu check. Without this, the kASLR
patch series fails to correctly apply relocations, and fails to boot.

Signed-off-by: Michael Davidson <md@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20131011013954.GA28902@www.outflux.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/tools/relocs.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index f7bab68..71a2533 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -722,15 +722,23 @@ static void percpu_init(void)
 
 /*
  * Check to see if a symbol lies in the .data..percpu section.
- * For some as yet not understood reason the "__init_begin"
- * symbol which immediately preceeds the .data..percpu section
- * also shows up as it it were part of it so we do an explict
- * check for that symbol name and ignore it.
+ *
+ * The linker incorrectly associates some symbols with the
+ * .data..percpu section so we also need to check the symbol
+ * name to make sure that we classify the symbol correctly.
+ *
+ * The GNU linker incorrectly associates:
+ *	__init_begin
+ *
+ * The "gold" linker incorrectly associates:
+ *	init_per_cpu__irq_stack_union
+ *	init_per_cpu__gdt_page
  */
 static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
 {
 	return (sym->st_shndx == per_cpu_shndx) &&
-		strcmp(symname, "__init_begin");
+		strcmp(symname, "__init_begin") &&
+		strncmp(symname, "init_per_cpu_", 13);
 }
 
 
