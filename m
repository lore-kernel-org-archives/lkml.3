Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaKPK6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:58:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34890 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbaKPK6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:58:33 -0500
Date: Sun, 16 Nov 2014 02:58:20 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-f439c429c320981943f8b64b2a4049d946cb492b@git.kernel.org>
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, stefan.bader@canonical.com,
        jgross@suse.com
Reply-To: jgross@suse.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        stefan.bader@canonical.com, tglx@linutronix.de, hpa@zytor.com
In-Reply-To: <1415019724-4317-16-git-send-email-jgross@suse.com>
References: <1415019724-4317-16-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86:
  Support PAT bit in pagetable dump for lower levels
Git-Commit-ID: f439c429c320981943f8b64b2a4049d946cb492b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f439c429c320981943f8b64b2a4049d946cb492b
Gitweb:     http://git.kernel.org/tip/f439c429c320981943f8b64b2a4049d946cb492b
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Mon, 3 Nov 2014 14:02:01 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Nov 2014 11:04:26 +0100

x86: Support PAT bit in pagetable dump for lower levels

Dumping page table protection bits is not correct for entries on levels
2 and 3 regarding the PAT bit, which is at a different position as on
level 4.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stefan.bader@canonical.com
Cc: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com
Cc: ville.syrjala@linux.intel.com
Cc: david.vrabel@citrix.com
Cc: jbeulich@suse.com
Cc: toshi.kani@hp.com
Cc: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com
Cc: bhelgaas@google.com
Link: http://lkml.kernel.org/r/1415019724-4317-16-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
