Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaI3M1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:27:31 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:40474 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaI3M02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:26:28 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org
Subject: [PATCH/RFC v2 4/4] ARM: shmobile: r8a7740 dtsi: Add minimal device node for Coresight-ETM
Date: Tue, 30 Sep 2014 14:26:27 +0200
Message-Id: <1412079987-1827-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412079987-1827-1-git-send-email-geert+renesas@glider.be>
References: <1412079987-1827-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If power area D4, which contains the Coresight-ETM hardware block, is
powered down on R-Mobile A1 (r8a7740), the kernel crashes when
suspending from s2ram with:

    Internal error: Oops - undefined instruction: 0 [#1] ARM

This happens because dbg_cpu_pm_notify() calls reset_ctrl_regs(), which
can't access the debug registers as the debug module is powered down.

Add a minimal device node for the Coresight-ETM hardware block, and hook
it up to the D4 PM domain, so the R-Mobile System Controller driver can
keep the arm_dbg_regs_available flag in sync with the state of the D4 PM
domain.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: devicetree@vger.kernel.org
---
This is a fix on top of series "[PATCH 00/13] ARM: shmobile: R-Mobile:
DT PM domain support" (https://lkml.org/lkml/2014/9/25/452), to be
folded into "[PATCH v3 10/13] ARM: shmobile: r8a7740 dtsi: Add PM domain
support" (https://lkml.org/lkml/2014/9/25/450).

v2:
  - New

---
 arch/arm/boot/dts/r8a7740.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index 0fb93df46af4ce08..2ae08fc99be678c3 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -44,6 +44,11 @@
 		interrupts = <0 83 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
+	ptm {
+		compatible = "arm,coresight-etm3x";
+		power-domains = <&pd_d4>;
+	};
+
 	cmt1: timer@e6138000 {
 		compatible = "renesas,cmt-48-r8a7740", "renesas,cmt-48";
 		reg = <0xe6138000 0x170>;
-- 
1.9.1

