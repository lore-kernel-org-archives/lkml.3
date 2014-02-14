Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaBNV1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:27:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:38604 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbaBNVWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="481803176"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 15/19] Kbuild, lto: Fix single pass kallsyms for LTO
Date: Fri, 14 Feb 2014 22:21:39 +0100
Message-Id: <1392412903-25733-16-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

gcc-nm on slim LTO objects does not output static functions or variables.

This causes the first pass estimation of the kallsyms table
to be off too much. Add a hack using the LTO function sections
to retrieve all functions instead. I wrote that hack in perl,
as it exceeded my awk-fu (this adds a build dependency on perl,
but only if LTO is active). The hack also doesn't support
variables, but we handle that by disable KALLSYMS_ALL with LTO.
The hack is also somewhat depending on the internal LTO
object format.

Hopefully at some future point gcc-nm will be fixed and this
won't be necessary anymore.

One issue is that LTO can generate new symbols in the
final link, for example when cloning functions. These clones
are just copies of existing names with a postfix (which
we remove), so they compress well in the kallsyms compression.

With that we can get away by just adding a 5% safety factor
to the first pass kallsyms estimation, and hope all clones
fit into that.  If some obscure build has more clones than that
the PAD_RATIO value in kallsyms.c can be lowered to increase it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 init/Kconfig            |  5 ++++-
 scripts/link-vmlinux.sh | 24 +++++++++++++++++++++---
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 009a797..ea00c0e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1317,7 +1317,10 @@ config KALLSYMS
 
 config KALLSYMS_ALL
 	bool "Include all symbols in kallsyms"
-	depends on DEBUG_KERNEL && KALLSYMS
+	# the method LTO uses to predict the symbol table
+	# only supports functions for now
+	# This can be removed once http://gcc.gnu.org/PR60016 is fixed
+	depends on DEBUG_KERNEL && KALLSYMS && !LTO
 	help
 	   Normally kallsyms only contains the symbols of functions for nicer
 	   OOPS messages and backtraces (i.e., symbols from the text and inittext
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index b299fdd..5a28f2a 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -90,10 +90,28 @@ kallsyms()
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
 
-	${NM} -n ${1} | \
-		awk 'NF == 3 { print}' |
-		scripts/kallsyms ${kallsymopt} | \
+	# workaround for slim LTO gcc-nm not outputing static symbols
+	# http://gcc.gnu.org/PR60016
+	# generate a fake symbol table based on the LTO function sections.
+	# This unfortunately "knows" about the internal LTO file format
+	# and only works for functions
+	# needs perl for now when building for LTO
+	(
+	if $OBJDUMP --section-headers ${1} | grep -q \.gnu\.lto_ ; then
+		${OBJDUMP} --section-headers ${1} |
+		perl -ne '
+@n = split;
+next unless $n[1] =~ /\.gnu\.lto_([_a-zA-Z][^.]+)/;
+next if $n[1] eq $prev;
+$prev = $n[1];
+print "0 T ",$1,"\n"'
+	fi
+	${NM} -n ${1} | awk 'NF == 3 { print }'
+	)  > ${2}_sym
+	# run without pipe to make kallsyms errors stop the script
+	./scripts/kallsyms ${kallsymopt} < ${2}_sym |
 		${CC} ${aflags} -c -o ${2} -x assembler-with-cpp -
+
 }
 
 # Create map file with all symbols from ${1}
-- 
1.8.5.2

