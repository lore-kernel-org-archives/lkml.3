Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3EZUf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 16:35:56 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:60310 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab3EZUfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 16:35:55 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 2/2] MIPS: cavium-octeon: enable interfaces on EdgeRouter Lite
Date: Sun, 26 May 2013 23:35:43 +0300
Message-Id: <1369600543-21558-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369600543-21558-1-git-send-email-aaro.koskinen@iki.fi>
References: <1369600543-21558-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable interfaces on EdgeRouter Lite. Tested with cavium_octeon_defconfig
and busybox shell. DHCP & ping works with eth0, eth1 and eth2.

The board type "UBNT_E100" is taken from the sources of the vendor kernel
shipped with the product.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/cavium-octeon/executive/cvmx-helper-board.c |   13 +++++++++++++
 arch/mips/include/asm/octeon/cvmx-bootinfo.h          |    2 ++
 2 files changed, 15 insertions(+)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
index e0451a0..f489667 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
@@ -183,6 +183,11 @@ int cvmx_helper_board_get_mii_address(int ipd_port)
 			return ipd_port - 16 + 4;
 		else
 			return -1;
+	case CVMX_BOARD_TYPE_UBNT_E100:
+		if (ipd_port >= 0 && ipd_port <= 2)
+			return 7 - ipd_port;
+		else
+			return -1;
 	}
 
 	/* Some unknown board. Somebody forgot to update this function... */
@@ -707,6 +712,14 @@ int __cvmx_helper_board_hardware_enable(int interface)
 				}
 			}
 		}
+	} else if (cvmx_sysinfo_get()->board_type ==
+			CVMX_BOARD_TYPE_UBNT_E100) {
+		cvmx_write_csr(CVMX_ASXX_RX_CLK_SETX(0, interface), 0);
+		cvmx_write_csr(CVMX_ASXX_TX_CLK_SETX(0, interface), 0x10);
+		cvmx_write_csr(CVMX_ASXX_RX_CLK_SETX(1, interface), 0);
+		cvmx_write_csr(CVMX_ASXX_TX_CLK_SETX(1, interface), 0x10);
+		cvmx_write_csr(CVMX_ASXX_RX_CLK_SETX(2, interface), 0);
+		cvmx_write_csr(CVMX_ASXX_TX_CLK_SETX(2, interface), 0x10);
 	}
 	return 0;
 }
diff --git a/arch/mips/include/asm/octeon/cvmx-bootinfo.h b/arch/mips/include/asm/octeon/cvmx-bootinfo.h
index 284fa8d..7b7818d 100644
--- a/arch/mips/include/asm/octeon/cvmx-bootinfo.h
+++ b/arch/mips/include/asm/octeon/cvmx-bootinfo.h
@@ -227,6 +227,7 @@ enum cvmx_board_types_enum {
 	 * use any numbers in this range.
 	 */
 	CVMX_BOARD_TYPE_CUST_PRIVATE_MIN = 20001,
+	CVMX_BOARD_TYPE_UBNT_E100 = 20002,
 	CVMX_BOARD_TYPE_CUST_PRIVATE_MAX = 30000,
 
 	/* The remaining range is reserved for future use. */
@@ -325,6 +326,7 @@ static inline const char *cvmx_board_type_to_string(enum
 
 		    /* Customer private range */
 		ENUM_BRD_TYPE_CASE(CVMX_BOARD_TYPE_CUST_PRIVATE_MIN)
+		ENUM_BRD_TYPE_CASE(CVMX_BOARD_TYPE_UBNT_E100)
 		ENUM_BRD_TYPE_CASE(CVMX_BOARD_TYPE_CUST_PRIVATE_MAX)
 	}
 	return "Unsupported Board";
-- 
1.7.10.4

