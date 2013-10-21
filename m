Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3JUI54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:57:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39873 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754490Ab3JUIxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matt Waddel" <mwaddel@yahoo.com>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Greg Ungerer" <gerg@uclinux.org>, "Kurt Mahan" <kmahan@xmission.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.539260977@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 125/149] m68k: use non-MMU linker script for ColdFire
 MMU builds
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Ungerer <gerg@uclinux.org>

commit ed865e31a8273be200db9ddcdb6b844e48777abd upstream.

Use the non-MMU linker script for ColdFire builds when we are building
for MMU enabled. The image layout is correct for loading on existing
ColdFire dev boards. The only addition required to the current non-MMU
linker script is to add support for the fixup section.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Matt Waddel <mwaddel@yahoo.com>
Acked-by: Kurt Mahan <kmahan@xmission.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/m68k/kernel/vmlinux-nommu.lds | 8 ++++++++
 arch/m68k/kernel/vmlinux.lds.S     | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/kernel/vmlinux-nommu.lds b/arch/m68k/kernel/vmlinux-nommu.lds
index 4e23893..8e66ccb 100644
--- a/arch/m68k/kernel/vmlinux-nommu.lds
+++ b/arch/m68k/kernel/vmlinux-nommu.lds
@@ -69,6 +69,7 @@ SECTIONS {
 		SCHED_TEXT
 		LOCK_TEXT
 		*(.text..lock)
+		*(.fixup)
 
 		. = ALIGN(16);          /* Exception table              */
 		__start___ex_table = .;
@@ -161,6 +162,13 @@ SECTIONS {
 		_edata = . ;
 	} > DATA
 
+	.m68k_fixup : {
+		__start_fixup = .;
+		*(.m68k_fixup)
+		__stop_fixup = .;
+	} > DATA
+	NOTES > DATA
+
 	.init.text : {
 		. = ALIGN(PAGE_SIZE);
 		__init_begin = .;
diff --git a/arch/m68k/kernel/vmlinux.lds.S b/arch/m68k/kernel/vmlinux.lds.S
index 3d99a04..69ec796 100644
--- a/arch/m68k/kernel/vmlinux.lds.S
+++ b/arch/m68k/kernel/vmlinux.lds.S
@@ -1,4 +1,4 @@
-#ifdef CONFIG_MMU
+#if defined(CONFIG_MMU) && !defined(CONFIG_COLDFIRE)
 PHDRS
 {
   text PT_LOAD FILEHDR PHDRS FLAGS (7);

