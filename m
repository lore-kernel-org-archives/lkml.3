Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaGIJl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:41:56 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37184 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaGIJlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:41:53 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] scripts: modpost: Remove numeric suffix pattern matching
Organization: D03
References: <1403685999-31013-1-git-send-email-linux@rasmusvillemoes.dk>
	<53AADC30.7080401@windriver.com> <8761jooaw2.fsf@rasmusvillemoes.dk>
	<87d2df768c.fsf@rustcorp.com.au> <20140709071319.GA30377@ravnborg.org>
X-Hashcash: 1:20:140709:sam@ravnborg.org::p5RXgGTKS07wXg83:00G4y
X-Hashcash: 1:20:140709:rusty@rustcorp.com.au::QF/kejXStDbtaQDy:00000000000000000000000000000000000000002Kbu
X-Hashcash: 1:20:140709:paul.gortmaker@windriver.com::FVJOXAr/pVXw6fGR:0000000000000000000000000000000002QP8
X-Hashcash: 1:20:140709:linux-kernel@vger.kernel.org::IytuI8tZQhQlHH46:000000000000000000000000000000000330c
X-Hashcash: 1:20:140709:akpm@linux-foundation.org::hEqBiQNRm8iKdaTh:0000000000000000000000000000000000005K4y
X-Hashcash: 1:20:140709:hpa@linux.intel.com::1rCOEjOfBTkCtqwk:000000000000000000000000000000000000000000614x
Date: Wed, 09 Jul 2014 11:41:48 +0200
In-Reply-To: <20140709071319.GA30377@ravnborg.org> (Sam Ravnborg's message of
	"Wed, 9 Jul 2014 09:13:19 +0200")
Message-ID: <87a98idg2r.fsf_-_@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For several years, the pattern "foo$" has effectively been treated as
equivalent to "foo" due to a bug in the (misnamed) helper
number_prefix(). This hasn't been observed to cause any problems, so
remove the broken $ functionality and change all foo$ patterns to foo.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
Sam, was this what you meant? Otherwise, I'd be more than happy to
leave the issue to someone else.

 scripts/mod/modpost.c | 49 ++++++++++---------------------------------------
 1 file changed, 10 insertions(+), 39 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 9d9c5b9..8f5e122 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -772,32 +772,10 @@ static const char *sech_name(struct elf_info *elf, Elf_Shdr *sechdr)
 		sechdr->sh_name;
 }
 
-/* if sym is empty or point to a string
- * like ".[0-9]+" then return 1.
- * This is the optional prefix added by ld to some sections
- */
-static int number_prefix(const char *sym)
-{
-	if (*sym++ == '\0')
-		return 1;
-	if (*sym != '.')
-		return 0;
-	do {
-		char c = *sym++;
-		if (c < '0' || c > '9')
-			return 0;
-	} while (*sym);
-	return 1;
-}
-
 /* The pattern is an array of simple patterns.
  * "foo" will match an exact string equal to "foo"
  * "*foo" will match a string that ends with "foo"
  * "foo*" will match a string that begins with "foo"
- * "foo$" will match a string equal to "foo" or "foo.1"
- *   where the '1' can be any number including several digits.
- *   The $ syntax is for sections where ld append a dot number
- *   to make section name unique.
  */
 static int match(const char *sym, const char * const pat[])
 {
@@ -816,13 +794,6 @@ static int match(const char *sym, const char * const pat[])
 			if (strncmp(sym, p, strlen(p) - 1) == 0)
 				return 1;
 		}
-		/* "foo$" */
-		else if (*endp == '$') {
-			if (strncmp(sym, p, strlen(p) - 1) == 0) {
-				if (number_prefix(sym + strlen(p) - 1))
-					return 1;
-			}
-		}
 		/* no wildcards */
 		else {
 			if (strcmp(p, sym) == 0)
@@ -880,20 +851,20 @@ static void check_section(const char *modname, struct elf_info *elf,
 
 
 #define ALL_INIT_DATA_SECTIONS \
-	".init.setup$", ".init.rodata$", ".meminit.rodata$", \
-	".init.data$", ".meminit.data$"
+	".init.setup", ".init.rodata", ".meminit.rodata", \
+	".init.data", ".meminit.data"
 #define ALL_EXIT_DATA_SECTIONS \
-	".exit.data$", ".memexit.data$"
+	".exit.data", ".memexit.data"
 
 #define ALL_INIT_TEXT_SECTIONS \
-	".init.text$", ".meminit.text$"
+	".init.text", ".meminit.text"
 #define ALL_EXIT_TEXT_SECTIONS \
-	".exit.text$", ".memexit.text$"
+	".exit.text", ".memexit.text"
 
 #define ALL_PCI_INIT_SECTIONS	\
-	".pci_fixup_early$", ".pci_fixup_header$", ".pci_fixup_final$", \
-	".pci_fixup_enable$", ".pci_fixup_resume$", \
-	".pci_fixup_resume_early$", ".pci_fixup_suspend$"
+	".pci_fixup_early", ".pci_fixup_header", ".pci_fixup_final", \
+	".pci_fixup_enable", ".pci_fixup_resume", \
+	".pci_fixup_resume_early", ".pci_fixup_suspend"
 
 #define ALL_XXXINIT_SECTIONS MEM_INIT_SECTIONS
 #define ALL_XXXEXIT_SECTIONS MEM_EXIT_SECTIONS
@@ -901,8 +872,8 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
 
-#define DATA_SECTIONS ".data$", ".data.rel$"
-#define TEXT_SECTIONS ".text$", ".text.unlikely$"
+#define DATA_SECTIONS ".data", ".data.rel"
+#define TEXT_SECTIONS ".text", ".text.unlikely"
 
 #define INIT_SECTIONS      ".init.*"
 #define MEM_INIT_SECTIONS  ".meminit.*"
-- 
1.9.2

