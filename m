Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbaH0ESJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:18:09 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37159 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaH0EPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:15:52 -0400
From: Zi Shen Lim <zlim.lnx@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>, Jiang Liu <liuj97@gmail.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCHv2 08/14] arm64: introduce aarch64_insn_gen_movewide()
Date: Tue, 26 Aug 2014 21:15:24 -0700
Message-Id: <1409112930-25677-9-git-send-email-zlim.lnx@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409112930-25677-1-git-send-email-zlim.lnx@gmail.com>
References: <1409112930-25677-1-git-send-email-zlim.lnx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce function to generate move wide (immediate) instructions.

Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/insn.h | 13 +++++++++++++
 arch/arm64/kernel/insn.c      | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 8fd31fc..49dec28 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -172,6 +172,12 @@ enum aarch64_insn_adsb_type {
 	AARCH64_INSN_ADSB_SUB_SETFLAGS
 };
 
+enum aarch64_insn_movewide_type {
+	AARCH64_INSN_MOVEWIDE_ZERO,
+	AARCH64_INSN_MOVEWIDE_KEEP,
+	AARCH64_INSN_MOVEWIDE_INVERSE
+};
+
 enum aarch64_insn_bitfield_type {
 	AARCH64_INSN_BITFIELD_MOVE,
 	AARCH64_INSN_BITFIELD_MOVE_UNSIGNED,
@@ -194,9 +200,12 @@ __AARCH64_INSN_FUNCS(add_imm,	0x7F000000, 0x11000000)
 __AARCH64_INSN_FUNCS(adds_imm,	0x7F000000, 0x31000000)
 __AARCH64_INSN_FUNCS(sub_imm,	0x7F000000, 0x51000000)
 __AARCH64_INSN_FUNCS(subs_imm,	0x7F000000, 0x71000000)
+__AARCH64_INSN_FUNCS(movn,	0x7F800000, 0x12800000)
 __AARCH64_INSN_FUNCS(sbfm,	0x7F800000, 0x13000000)
 __AARCH64_INSN_FUNCS(bfm,	0x7F800000, 0x33000000)
+__AARCH64_INSN_FUNCS(movz,	0x7F800000, 0x52800000)
 __AARCH64_INSN_FUNCS(ubfm,	0x7F800000, 0x53000000)
+__AARCH64_INSN_FUNCS(movk,	0x7F800000, 0x72800000)
 __AARCH64_INSN_FUNCS(b,		0xFC000000, 0x14000000)
 __AARCH64_INSN_FUNCS(bl,	0xFC000000, 0x94000000)
 __AARCH64_INSN_FUNCS(cbz,	0xFE000000, 0x34000000)
@@ -252,6 +261,10 @@ u32 aarch64_insn_gen_bitfield(enum aarch64_insn_register dst,
 			      int immr, int imms,
 			      enum aarch64_insn_variant variant,
 			      enum aarch64_insn_bitfield_type type);
+u32 aarch64_insn_gen_movewide(enum aarch64_insn_register dst,
+			      int imm, int shift,
+			      enum aarch64_insn_variant variant,
+			      enum aarch64_insn_movewide_type type);
 
 bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
 
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index e07d026..7aa2784 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -655,3 +655,46 @@ u32 aarch64_insn_gen_bitfield(enum aarch64_insn_register dst,
 
 	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_S, insn, imms);
 }
+
+u32 aarch64_insn_gen_movewide(enum aarch64_insn_register dst,
+			      int imm, int shift,
+			      enum aarch64_insn_variant variant,
+			      enum aarch64_insn_movewide_type type)
+{
+	u32 insn;
+
+	switch (type) {
+	case AARCH64_INSN_MOVEWIDE_ZERO:
+		insn = aarch64_insn_get_movz_value();
+		break;
+	case AARCH64_INSN_MOVEWIDE_KEEP:
+		insn = aarch64_insn_get_movk_value();
+		break;
+	case AARCH64_INSN_MOVEWIDE_INVERSE:
+		insn = aarch64_insn_get_movn_value();
+		break;
+	default:
+		BUG_ON(1);
+	}
+
+	BUG_ON(imm & ~(SZ_64K - 1));
+
+	switch (variant) {
+	case AARCH64_INSN_VARIANT_32BIT:
+		BUG_ON(shift != 0 && shift != 16);
+		break;
+	case AARCH64_INSN_VARIANT_64BIT:
+		insn |= AARCH64_INSN_SF_BIT;
+		BUG_ON(shift != 0 && shift != 16 && shift != 32 &&
+		       shift != 48);
+		break;
+	default:
+		BUG_ON(1);
+	}
+
+	insn |= (shift >> 4) << 21;
+
+	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RD, insn, dst);
+
+	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_16, insn, imm);
+}
-- 
1.9.1

