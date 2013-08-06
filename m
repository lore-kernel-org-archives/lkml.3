Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3HFHh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 03:37:59 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55181 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3HFHh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 03:37:58 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-ad-5200a7d3bd17
Subject: [PATCH -tip ] x86/insn: Add Haswell-introduced opcodes
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 06 Aug 2013 16:37:50 +0900
Message-ID: <20130806073750.4049.12365.stgit@udc4-manage.rcp.hitachi.co.jp>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TSX-NI related instructions and new instructions to
x86-opcode-map.txt according to the Intel(R) 64 and IA-32
Architectures Software Developer's Manual Vol2C (June, 2013).
This also includes below updates.
 - Fix a typo of MWAIT (the lack of (11B)).
 - Change NOP Ev to prefetchw Ev
 - Add CRC32 new prefix style (66&F2)
 - Add ADCX, ADOX, RDSEED, CLAC and STAC instructions

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/lib/x86-opcode-map.txt      |   42 +++++++++++++++++++---------------
 arch/x86/tools/gen-insn-attr-x86.awk |    4 ++-
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 5d7e51f..533a85e 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -1,10 +1,8 @@
 # x86 Opcode Maps
 #
 # This is (mostly) based on following documentations.
-# - Intel(R) 64 and IA-32 Architectures Software Developer's Manual Vol.2
-#   (#325383-040US, October 2011)
-# - Intel(R) Advanced Vector Extensions Programming Reference
-#   (#319433-011,JUNE 2011).
+# - Intel(R) 64 and IA-32 Architectures Software Developer's Manual Vol.2C
+#   (#326018-047US, June 2013)
 #
 #<Opcode maps>
 # Table: table-name
@@ -29,6 +27,7 @@
 #  - (F3): the last prefix is 0xF3
 #  - (F2): the last prefix is 0xF2
 #  - (!F3) : the last prefix is not 0xF3 (including non-last prefix case)
+#  - (66&F2): Both 0x66 and 0xF2 prefixes are specified.
 
 Table: one byte opcode
 Referrer:
@@ -246,8 +245,8 @@ c2: RETN Iw (f64)
 c3: RETN
 c4: LES Gz,Mp (i64) | VEX+2byte (Prefix)
 c5: LDS Gz,Mp (i64) | VEX+1byte (Prefix)
-c6: Grp11 Eb,Ib (1A)
-c7: Grp11 Ev,Iz (1A)
+c6: Grp11A Eb,Ib (1A)
+c7: Grp11B Ev,Iz (1A)
 c8: ENTER Iw,Ib
 c9: LEAVE (d64)
 ca: RETF Iw
@@ -293,8 +292,8 @@ ef: OUT DX,eAX
 # 0xf0 - 0xff
 f0: LOCK (Prefix)
 f1:
-f2: REPNE (Prefix)
-f3: REP/REPE (Prefix)
+f2: REPNE (Prefix) | XACQUIRE (Prefix)
+f3: REP/REPE (Prefix) | XRELEASE (Prefix)
 f4: HLT
 f5: CMC
 f6: Grp3_1 Eb (1A)
@@ -326,7 +325,8 @@ AVXcode: 1
 0a:
 0b: UD2 (1B)
 0c:
-0d: NOP Ev | GrpP
+# AMD's prefetch group. Intel supports prefetchw(/1) only.
+0d: GrpP
 0e: FEMMS
 # 3DNow! uses the last imm byte as opcode extension.
 0f: 3DNow! Pq,Qq,Ib
@@ -729,12 +729,12 @@ dc: VAESENC Vdq,Hdq,Wdq (66),(v1)
 dd: VAESENCLAST Vdq,Hdq,Wdq (66),(v1)
 de: VAESDEC Vdq,Hdq,Wdq (66),(v1)
 df: VAESDECLAST Vdq,Hdq,Wdq (66),(v1)
-f0: MOVBE Gy,My | MOVBE Gw,Mw (66) | CRC32 Gd,Eb (F2)
-f1: MOVBE My,Gy | MOVBE Mw,Gw (66) | CRC32 Gd,Ey (F2)
+f0: MOVBE Gy,My | MOVBE Gw,Mw (66) | CRC32 Gd,Eb (F2) | CRC32 Gd,Eb (66&F2)
+f1: MOVBE My,Gy | MOVBE Mw,Gw (66) | CRC32 Gd,Ey (F2) | CRC32 Gd,Ew (66&F2)
 f2: ANDN Gy,By,Ey (v)
 f3: Grp17 (1A)
 f5: BZHI Gy,Ey,By (v) | PEXT Gy,By,Ey (F3),(v) | PDEP Gy,By,Ey (F2),(v)
-f6: MULX By,Gy,rDX,Ey (F2),(v)
+f6: ADCX Gy,Ey (66) | ADOX Gy,Ey (F3) | MULX By,Gy,rDX,Ey (F2),(v)
 f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By (F3),(v) | SHRX Gy,Ey,By (F2),(v)
 EndTable
 
@@ -861,8 +861,8 @@ EndTable
 
 GrpTable: Grp7
 0: SGDT Ms | VMCALL (001),(11B) | VMLAUNCH (010),(11B) | VMRESUME (011),(11B) | VMXOFF (100),(11B)
-1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001)
-2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B)
+1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001),(11B) | CLAC (010),(11B) | STAC (011),(11B)
+2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B) | XEND (101)(11B) | XTEST (110)(11B)
 3: LIDT Ms
 4: SMSW Mw/Rv
 5:
@@ -880,15 +880,21 @@ EndTable
 GrpTable: Grp9
 1: CMPXCHG8B/16B Mq/Mdq
 6: VMPTRLD Mq | VMCLEAR Mq (66) | VMXON Mq (F3) | RDRAND Rv (11B)
-7: VMPTRST Mq | VMPTRST Mq (F3)
+7: VMPTRST Mq | VMPTRST Mq (F3) | RDSEED Rv (11B)
 EndTable
 
 GrpTable: Grp10
 EndTable
 
-GrpTable: Grp11
-# Note: the operands are given by group opcode
-0: MOV
+# Grp11A and Grp11B are expressed as Grp11 in Intel SDM
+GrpTable: Grp11A
+0: MOV Eb,Ib
+7: XABORT Ib (000),(11B)
+EndTable
+
+GrpTable: Grp11B
+0: MOV Eb,Iz
+7: XBEGIN Jz (000),(11B)
 EndTable
 
 GrpTable: Grp12
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index e6773dc..093a892 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -68,7 +68,7 @@ BEGIN {
 
 	lprefix1_expr = "\\((66|!F3)\\)"
 	lprefix2_expr = "\\(F3\\)"
-	lprefix3_expr = "\\((F2|!F3)\\)"
+	lprefix3_expr = "\\((F2|!F3|66\\&F2)\\)"
 	lprefix_expr = "\\((66|F2|F3)\\)"
 	max_lprefix = 4
 
@@ -83,6 +83,8 @@ BEGIN {
 	prefix_num["Operand-Size"] = "INAT_PFX_OPNDSZ"
 	prefix_num["REPNE"] = "INAT_PFX_REPNE"
 	prefix_num["REP/REPE"] = "INAT_PFX_REPE"
+	prefix_num["XACQUIRE"] = "INAT_PFX_REPNE"
+	prefix_num["XRELEASE"] = "INAT_PFX_REPE"
 	prefix_num["LOCK"] = "INAT_PFX_LOCK"
 	prefix_num["SEG=CS"] = "INAT_PFX_CS"
 	prefix_num["SEG=DS"] = "INAT_PFX_DS"

