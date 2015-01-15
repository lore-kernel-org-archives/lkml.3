Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbbAONMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:12:47 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:17913 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbbAONMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:12:44 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH v3 06/15] MIPS: OCTEON: Implement the core-16057 workaround
Date: Thu, 15 Jan 2015 16:11:10 +0300
Message-ID: <1421327487-28679-7-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
References: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Disable ICache prefetch for certian Octeon II processors.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 .../asm/mach-cavium-octeon/kernel-entry-init.h     | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h b/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
index 1668ee5..21732c3 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
@@ -63,6 +63,28 @@ skip:
 	li	v1, ~(7 << 7)
 	and	v0, v0, v1
 	ori	v0, v0, (6 << 7)
+
+	mfc0	v1, CP0_PRID_REG
+	and	t1, v1, 0xfff8
+	xor	t1, t1, 0x9000		# 63-P1
+	beqz	t1, 4f
+	and	t1, v1, 0xfff8
+	xor	t1, t1, 0x9008		# 63-P2
+	beqz	t1, 4f
+	and	t1, v1, 0xfff8
+	xor	t1, t1, 0x9100		# 68-P1
+	beqz	t1, 4f
+	and	t1, v1, 0xff00
+	xor	t1, t1, 0x9200		# 66-PX
+	bnez	t1, 5f			# Skip WAR for others.
+	and	t1, v1, 0x00ff
+	slti	t1, t1, 2		# 66-P1.2 and later good.
+	beqz	t1, 5f
+
+4:	# core-16057 work around
+	or	v0, v0, 0x2000		# Set IPREF bit.
+
+5:	# No core-16057 work around
 	# Write the cavium control register
 	dmtc0	v0, CP0_CVMCTL_REG
 	sync
-- 
2.2.2

