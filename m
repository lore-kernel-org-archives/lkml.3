Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaFXLZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:25:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36199 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaFXLZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:25:09 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86, CPU: Add bug flags to /proc/cpuinfo
Date: Tue, 24 Jun 2014 13:25:03 +0200
Message-Id: <1403609105-8332-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403609105-8332-1-git-send-email-bp@alien8.de>
References: <1403609105-8332-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Dump the flags which denote we have detected and/or have applied bug
workarounds to the CPU we're executing on, in a similar manner to the
feature flags.

The advantage is that those are not accumulating over time like the CPU
features.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 10 ++++++--
 arch/x86/kernel/cpu/mkcapflags.sh | 51 ++++++++++++++++++++++++++++-----------
 arch/x86/kernel/cpu/proc.c        |  8 ++++++
 3 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 52df22bde0dd..327a061f32df 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -239,8 +239,8 @@
 #define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
 #define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
 #define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
-#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
-#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* AMD Erratum 400 */
+#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* "tlb_mmatch" AMD Erratum 383 */
+#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* "apic_c1e" AMD Erratum 400 */
 #define X86_BUG_11AP		X86_BUG(5) /* Bad local APIC aka 11AP */
 #define X86_BUG_FXSAVE_LEAK	X86_BUG(6) /* FXSAVE leaks FOP/FIP/FOP */
 #define X86_BUG_CLFLUSH_MONITOR	X86_BUG(7) /* AAI65, CLFLUSH required before MONITOR */
@@ -253,6 +253,12 @@
 extern const char * const x86_cap_flags[NCAPINTS*32];
 extern const char * const x86_power_flags[32];
 
+/*
+ * In order to save room, we index into this array by doing
+ * X86_BUG_<name> - NCAPINTS*32.
+ */
+extern const char * const x86_bug_flags[NBUGINTS*32];
+
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
 
diff --git a/arch/x86/kernel/cpu/mkcapflags.sh b/arch/x86/kernel/cpu/mkcapflags.sh
index 2bf616505499..e2b22df964cd 100644
--- a/arch/x86/kernel/cpu/mkcapflags.sh
+++ b/arch/x86/kernel/cpu/mkcapflags.sh
@@ -1,23 +1,25 @@
 #!/bin/sh
 #
-# Generate the x86_cap_flags[] array from include/asm/cpufeature.h
+# Generate the x86_cap/bug_flags[] arrays from include/asm/cpufeature.h
 #
 
 IN=$1
 OUT=$2
 
-TABS="$(printf '\t\t\t\t\t')"
-trap 'rm "$OUT"' EXIT
+function dump_array()
+{
+	ARRAY=$1
+	SIZE=$2
+	PFX=$3
+	POSTFIX=$4
 
-(
-	echo "#ifndef _ASM_X86_CPUFEATURE_H"
-	echo "#include <asm/cpufeature.h>"
-	echo "#endif"
-	echo ""
-	echo "const char * const x86_cap_flags[NCAPINTS*32] = {"
+	PFX_SZ=$(echo $PFX | wc -c)
+	TABS="$(printf '\t\t\t\t\t')"
+
+	echo "const char * const $ARRAY[$SIZE] = {"
 
-	# Iterate through any input lines starting with #define X86_FEATURE_
-	sed -n -e 's/\t/ /g' -e 's/^ *# *define *X86_FEATURE_//p' $IN |
+	# Iterate through any input lines starting with #define $PFX
+	sed -n -e 's/\t/ /g' -e "s/^ *# *define *$PFX//p" $IN |
 	while read i
 	do
 		# Name is everything up to the first whitespace
@@ -31,11 +33,32 @@ trap 'rm "$OUT"' EXIT
 		# Name is uppercase, VALUE is all lowercase
 		VALUE="$(echo "$VALUE" | tr A-Z a-z)"
 
-		TABCOUNT=$(( ( 5*8 - 14 - $(echo "$NAME" | wc -c) ) / 8 ))
-		printf "\t[%s]%.*s = %s,\n" \
-			"X86_FEATURE_$NAME" "$TABCOUNT" "$TABS" "$VALUE"
+        if [ -n "$POSTFIX" ]; then
+            T=$(( $PFX_SZ + $(echo $POSTFIX | wc -c) + 2 ))
+	        TABS="$(printf '\t\t\t\t\t\t')"
+		    TABCOUNT=$(( ( 6*8 - ($T + 1) - $(echo "$NAME" | wc -c) ) / 8 ))
+		    printf "\t[%s - %s]%.*s = %s,\n" "$PFX$NAME" "$POSTFIX" "$TABCOUNT" "$TABS" "$VALUE"
+        else
+		    TABCOUNT=$(( ( 5*8 - ($PFX_SZ + 1) - $(echo "$NAME" | wc -c) ) / 8 ))
+            printf "\t[%s]%.*s = %s,\n" "$PFX$NAME" "$TABCOUNT" "$TABS" "$VALUE"
+        fi
 	done
 	echo "};"
+}
+
+trap 'rm "$OUT"' EXIT
+
+(
+	echo "#ifndef _ASM_X86_CPUFEATURE_H"
+	echo "#include <asm/cpufeature.h>"
+	echo "#endif"
+	echo ""
+
+	dump_array "x86_cap_flags" "NCAPINTS*32" "X86_FEATURE_" ""
+	echo ""
+
+	dump_array "x86_bug_flags" "NBUGINTS*32" "X86_BUG_" "NCAPINTS*32"
+
 ) > $OUT
 
 trap - EXIT
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 06fe3ed8b851..5433658e598d 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -97,6 +97,14 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
 
+	seq_printf(m, "\nbugs\t\t:");
+	for (i = 0; i < 32*NBUGINTS; i++) {
+		unsigned int bug_bit = 32*NCAPINTS + i;
+
+		if (cpu_has_bug(c, bug_bit) && x86_bug_flags[i])
+			seq_printf(m, " %s", x86_bug_flags[i]);
+	}
+
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
 		   c->loops_per_jiffy/(500000/HZ),
 		   (c->loops_per_jiffy/(5000/HZ)) % 100);
-- 
2.0.0

