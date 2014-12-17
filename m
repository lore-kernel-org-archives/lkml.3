Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaLQPuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:50:51 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44270 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:50:49 -0500
From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: "Suzuki K. Poulose" <suzuki.poulose@arm.com>, catalin.marinas@arm.com,
        will.deacon@arm.com, Lorenzo.Pieralisi@arm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: Fix SCTLR_EL1 initialisation
Date: Wed, 17 Dec 2014 15:50:21 +0000
Message-Id: <1418831421-19370-1-git-send-email-suzuki.poulose@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 17 Dec 2014 15:50:46.0091 (UTC) FILETIME=[38A5F1B0:01D01A11]
X-MC-Unique: 114121715504700201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sBHFoxiN011788

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

We initialise the SCTLR_EL1 value by read-modify-writeback
of the desired bits, leaving the other bits (including reserved
bits(RESx)) untouched. However, sometimes the boot monitor could
leave garbage values in the RESx bits which could have different
implications. This patch makes sure that all the bits, including
the RESx bits, are set to the proper state, except for the
'endianness' control bits, EE(25) & E0E(24)- which are set early
in the el2_setup.

Updated the state of the Bit[6] in the comment to RES0 in the
comment.

Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/mm/proc.S |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 4e778b1..f1bb1fc 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -244,14 +244,18 @@ ENTRY(__cpu_setup)
 ENDPROC(__cpu_setup)
 
 	/*
+	 * We set the desired value explicitly, including those of the 
+	 * reserved bits. The values of bits EE & E0E were set early in
+	 * el2_setup, which are left untouched below.
+	 *
 	 *                 n n            T
 	 *       U E      WT T UD     US IHBS
 	 *       CE0      XWHW CZ     ME TEEA S
 	 * .... .IEE .... NEAI TE.I ..AD DEN0 ACAM
-	 * 0011 0... 1101 ..0. ..0. 10.. .... .... < hardware reserved
-	 * .... .1.. .... 01.1 11.1 ..01 0001 1101 < software settings
+	 * 0011 0... 1101 ..0. ..0. 10.. .0.. .... < hardware reserved
+	 * .... .1.. .... 01.1 11.1 ..01 0.01 1101 < software settings
 	 */
 	.type	crval, #object
 crval:
-	.word	0x000802e2			// clear
-	.word	0x0405d11d			// set
+	.word	0xfcffffff			// clear
+	.word	0x34d5d91d			// set
-- 
1.7.9.5


