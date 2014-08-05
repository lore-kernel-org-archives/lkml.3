Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbaHESvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:51:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbaHESOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Fritz <chf.fritz@googlemail.com>, Pekon Gupta <pekon@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.15 05/42] ARM: OMAP2+: gpmc: fix gpmc_hwecc_bch_capable()
Date: Tue,  5 Aug 2014 11:13:19 -0700
Message-Id: <20140805181321.183369124@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Fritz <chf.fritz@googlemail.com>

commit 33753cd2ba41c72a0756edc5dc094d91602deda5 upstream.

This patch adds bch8 ecc software fallback which is mostly used by
omap3s because they lack hardware elm support.

Fixes: 0611c41934ab35ce84dea34ab291897ad3cbc7be (ARM: OMAP2+: gpmc:
update gpmc_hwecc_bch_capable() for new platforms and ECC schemes)
Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Reviewed-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/gpmc-nand.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -50,6 +50,16 @@ static bool gpmc_hwecc_bch_capable(enum
 		 soc_is_omap54xx() || soc_is_dra7xx())
 		return 1;
 
+	if (ecc_opt == OMAP_ECC_BCH4_CODE_HW_DETECTION_SW ||
+		 ecc_opt == OMAP_ECC_BCH8_CODE_HW_DETECTION_SW) {
+		if (cpu_is_omap24xx())
+			return 0;
+		else if (cpu_is_omap3630() && (GET_OMAP_REVISION() == 0))
+			return 0;
+		else
+			return 1;
+	}
+
 	/* OMAP3xxx do not have ELM engine, so cannot support ECC schemes
 	 * which require H/W based ECC error detection */
 	if ((cpu_is_omap34xx() || cpu_is_omap3630()) &&
@@ -57,14 +67,6 @@ static bool gpmc_hwecc_bch_capable(enum
 		 (ecc_opt == OMAP_ECC_BCH8_CODE_HW)))
 		return 0;
 
-	/*
-	 * For now, assume 4-bit mode is only supported on OMAP3630 ES1.x, x>=1
-	 * and AM33xx derivates. Other chips may be added if confirmed to work.
-	 */
-	if ((ecc_opt == OMAP_ECC_BCH4_CODE_HW_DETECTION_SW) &&
-	    (!cpu_is_omap3630() || (GET_OMAP_REVISION() == 0)))
-		return 0;
-
 	/* legacy platforms support only HAM1 (1-bit Hamming) ECC scheme */
 	if (ecc_opt == OMAP_ECC_HAM1_CODE_HW)
 		return 1;


