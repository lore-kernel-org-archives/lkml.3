Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaEZV7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:59:38 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:60560 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaEZV7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:59:36 -0400
Date: Mon, 26 May 2014 22:59:32 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: cmetcalf@tilera.com, richard@nod.at
Subject: [PATCH 01/12] [arch/tile] Remove obsolete strict_strto calls
Message-ID: <20140526215932.GC25779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH 01/12] [arch/tile] replace strict_strto* call with kstrto*

remove obsolete calls to strict_strto* and replace them
with kstrto* calls accordingly.

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 arch/tile/kernel/setup.c  | 7 ++-----
 arch/tile/kernel/signal.c | 7 +++----
 arch/tile/kernel/traps.c  | 5 ++---
 arch/tile/mm/init.c       | 2 +-
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 74c9172..9ff0074 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -228,13 +228,10 @@ early_param("isolnodes", setup_isolnodes);
 #if defined(CONFIG_PCI) && !defined(__tilegx__)
 static int __init setup_pci_reserve(char* str)
 {
-	unsigned long mb;
-
-	if (str == NULL || strict_strtoul(str, 0, &mb) != 0 ||
-	    mb > 3 * 1024)
+	if (str == NULL || kstrtouint(str, 0, &pci_reserve_mb) != 0 ||
+	    pci_reserve_mb > 3 * 1024)
 		return -EINVAL;
 
-	pci_reserve_mb = mb;
 	pr_info("Reserving %dMB for PCIE root complex mappings\n",
 		pci_reserve_mb);
 	return 0;
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 2d1dbf3..d1d026f 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -321,14 +321,13 @@ int show_unhandled_signals = 1;
 
 static int __init crashinfo(char *str)
 {
-	unsigned long val;
 	const char *word;
 
 	if (*str == '\0')
-		val = 2;
-	else if (*str != '=' || strict_strtoul(++str, 0, &val) != 0)
+		show_unhandled_signals = 2;
+	else if (*str != '=' || kstrtoint(++str, 0, &show_unhandled_signals) != 0)
 		return 0;
-	show_unhandled_signals = val;
+
 	switch (show_unhandled_signals) {
 	case 0:
 		word = "No";
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 6b603d5..f3ceb63 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -42,10 +42,9 @@ static int __init setup_unaligned_fixup(char *str)
 	 * will still parse the instruction, then fire a SIGBUS with
 	 * the correct address from inside the single_step code.
 	 */
-	long val;
-	if (strict_strtol(str, 0, &val) != 0)
+	if (kstrtoint(str, 0, &unaligned_fixup) != 0)
 		return 0;
-	unaligned_fixup = val;
+
 	pr_info("Fixups for unaligned data accesses are %s\n",
 	       unaligned_fixup >= 0 ?
 	       (unaligned_fixup ? "enabled" : "disabled") :
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 0fa1acf..df0e1c5 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -912,7 +912,7 @@ static long __write_once initfree = 1;
 static int __init set_initfree(char *str)
 {
 	long val;
-	if (strict_strtol(str, 0, &val) == 0) {
+	if (kstrtol(str, 0, &val) == 0) {
 		initfree = val;
 		pr_info("initfree: %s free init pages\n",
 			initfree ? "will" : "won't");
-- 
1.9.3

