Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3JATWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:22:34 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37399 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab3JATWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:22:32 -0400
Date: Tue, 1 Oct 2013 12:22:04 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] x86, relocs: add more per-cpu gold special cases
Message-ID: <20131001192203.GA29794@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "gold" linker doesn't seem to put some additional per-cpu cases in
the right place. Add these to the per-cpu check. Without this, the kASLR
patch series fails to correctly apply relocations, and fails to boot.

Found and fixed by Michael Davidson.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/tools/relocs.c |   18 +++++++++++++-----
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
 
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
