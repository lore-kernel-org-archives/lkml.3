Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaKCND7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:03:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbaKCNCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:02:17 -0500
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 15/18] x86: Support PAT bit in pagetable dump for lower levels
Date: Mon,  3 Nov 2014 14:02:01 +0100
Message-Id: <1415019724-4317-16-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dumping page table protection bits is not correct for entries on levels
2 and 3 regarding the PAT bit, which is at a different position as on
level 4.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/dump_pagetables.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 95a427e..6c2ca03 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -126,7 +126,7 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
 
 	if (!pgprot_val(prot)) {
 		/* Not present */
-		pt_dump_cont_printf(m, dmsg, "                          ");
+		pt_dump_cont_printf(m, dmsg, "                              ");
 	} else {
 		if (pr & _PAGE_USER)
 			pt_dump_cont_printf(m, dmsg, "USR ");
@@ -145,18 +145,16 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
 		else
 			pt_dump_cont_printf(m, dmsg, "    ");
 
-		/* Bit 9 has a different meaning on level 3 vs 4 */
-		if (level <= 3) {
-			if (pr & _PAGE_PSE)
-				pt_dump_cont_printf(m, dmsg, "PSE ");
-			else
-				pt_dump_cont_printf(m, dmsg, "    ");
-		} else {
-			if (pr & _PAGE_PAT)
-				pt_dump_cont_printf(m, dmsg, "pat ");
-			else
-				pt_dump_cont_printf(m, dmsg, "    ");
-		}
+		/* Bit 7 has a different meaning on level 3 vs 4 */
+		if (level <= 3 && pr & _PAGE_PSE)
+			pt_dump_cont_printf(m, dmsg, "PSE ");
+		else
+			pt_dump_cont_printf(m, dmsg, "    ");
+		if ((level == 4 && pr & _PAGE_PAT) ||
+		    ((level == 3 || level == 2) && pr & _PAGE_PAT_LARGE))
+			pt_dump_cont_printf(m, dmsg, "pat ");
+		else
+			pt_dump_cont_printf(m, dmsg, "    ");
 		if (pr & _PAGE_GLOBAL)
 			pt_dump_cont_printf(m, dmsg, "GLB ");
 		else
-- 
1.8.4.5

