Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab3FXOAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:00:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59674 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3FXOAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:00:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org
Subject: scripts/kallsyms: Avoid ARM veneer symbols
Date: Mon, 24 Jun 2013 16:01:43 +0200
Message-ID: <2983817.Xe2505Drlj@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:M4beAbuKpxwZLGplNNXxmkvnKEYt3mzm589idLvNXas
 +sBtPMCGsSCXBO6X955Ue5M/LjBNIlw9pHUW/VHeb/+x+e2MMw
 x97bzvvcp+uIVe9z3TXQ42ClnRwQCMY6Rw0MKdmpufPmJlJ6Xf
 gdvTXfHzFe8VDCy5KOQZlnXt/FpLgBeippGpL9NlDT8ZL35Q5z
 ako5gsu1CnyQwIrmH4UhKJesuYJ/qEhNU0x9QjtNS/8JtR5drF
 ir349KL7DRfKYMaCw+trTGlJvU8G1yoczaM2/r31H4fY5JIPFP
 9SAogG587KhyaBSweDd3zjbS477qwJ+pMFXpuUp++fG26RF+T6
 mFBvXAF8ZhMZKUZrtZnw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building ARM kernels that exceed a certain size, the linker
will add "veneers" that allow long branches. Unfortunately,
using a longer kallsyms section may lead to the extra veneers
being needed, which leads to inconsistent kallsyms data with the
message

Inconsistent kallsyms data
Try make KALLSYMS_EXTRA_PASS=1 as a workaround

In some case, not just one but up to three extra passes were
needed before getting to a state that needed no extra veneers.
The easiest solution is to skip veneers in kallsyms in the
same way we already skip a couple of other symbols.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 487ac6f..53ec0bb 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -69,14 +69,32 @@ static void usage(void)
 	exit(1);
 }
 
-/*
- * This ignores the intensely annoying "mapping symbols" found
- * in ARM ELF files: $a, $t and $d.
- */
 static inline int is_arm_mapping_symbol(const char *str)
 {
-	return str[0] == '$' && strchr("atd", str[1])
-	       && (str[2] == '\0' || str[2] == '.');
+	size_t len;
+
+	/*
+	 * This ignores the intensely annoying "mapping symbols" found
+	 * in ARM ELF files: $a, $t and $d.
+	 */
+	if (str[0] == '$' && strchr("atd", str[1])
+	       && (str[2] == '\0' || str[2] == '.'))
+		return 1;
+
+	len = strlen(str);
+	if (len < 10)
+		return 0;
+
+	/*
+	 * This ignores any __.*_veneer symbol, which get
+	 * inserted for large kernels, in order to avoid
+	 * inconsistent data.
+	 */
+	if (str[0] == '_' && str[1] == '_' &&
+	    strcmp(str + len - 7, "_veneer") == 0)
+		return 1; 
+
+	return 0;
 }
 
 static int read_symbol_tr(const char *sym, unsigned long long addr)

