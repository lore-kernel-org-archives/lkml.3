Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3LCTrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:47:06 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63191 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3LCTrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:47:04 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 1/2] MIPS: OCTEON: Supply OCTEON+ USB nodes in internal device trees.
Date: Tue,  3 Dec 2013 11:46:51 -0800
Message-Id: <1386100012-6077-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386100012-6077-1-git-send-email-ddaney.cavm@gmail.com>
References: <1386100012-6077-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This will be needed by the next patch to use said nodes for probing
via the device tree.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 .../cavium-octeon/executive/cvmx-helper-board.c    | 27 ++++++++++++++++++
 arch/mips/cavium-octeon/octeon-platform.c          | 32 ++++++++++++++++++++++
 arch/mips/cavium-octeon/octeon_3xxx.dts            | 19 +++++++++++++
 arch/mips/include/asm/octeon/cvmx-helper-board.h   |  9 ++++++
 4 files changed, 87 insertions(+)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
index 0a1283c..b764df6 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
@@ -722,3 +722,30 @@ int __cvmx_helper_board_hardware_enable(int interface)
 	}
 	return 0;
 }
+
+/**
+ * Get the clock type used for the USB block based on board type.
+ * Used by the USB code for auto configuration of clock type.
+ *
+ * Return USB clock type enumeration
+ */
+enum cvmx_helper_board_usb_clock_types __cvmx_helper_board_usb_get_clock_type(void)
+{
+	switch (cvmx_sysinfo_get()->board_type) {
+	case CVMX_BOARD_TYPE_BBGW_REF:
+	case CVMX_BOARD_TYPE_LANAI2_A:
+	case CVMX_BOARD_TYPE_LANAI2_U:
+	case CVMX_BOARD_TYPE_LANAI2_G:
+	case CVMX_BOARD_TYPE_NIC10E_66:
+	case CVMX_BOARD_TYPE_UBNT_E100:
+		return USB_CLOCK_TYPE_CRYSTAL_12;
+	case CVMX_BOARD_TYPE_NIC10E:
+		return USB_CLOCK_TYPE_REF_12;
+	default:
+		break;
+	}
+	/* Most boards except NIC10e use a 12MHz crystal */
+	if (OCTEON_IS_MODEL(OCTEON_FAM_2))
+		return USB_CLOCK_TYPE_CRYSTAL_12;
+	return USB_CLOCK_TYPE_REF_48;
+}
diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index 1830874..cd4fd6b 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -171,6 +171,7 @@ device_initcall(octeon_ohci_device_init);
 static struct of_device_id __initdata octeon_ids[] = {
 	{ .compatible = "simple-bus", },
 	{ .compatible = "cavium,octeon-6335-uctl", },
+	{ .compatible = "cavium,octeon-5750-usbn", },
 	{ .compatible = "cavium,octeon-3860-bootbus", },
 	{ .compatible = "cavium,mdio-mux", },
 	{ .compatible = "gpio-leds", },
@@ -682,6 +683,37 @@ end_led:
 		}
 	}
 
+	/* DWC2 USB */
+	alias_prop = fdt_getprop(initial_boot_params, aliases,
+				 "usbn", NULL);
+	if (alias_prop) {
+		int usbn = fdt_path_offset(initial_boot_params, alias_prop);
+
+		if (usbn >= 0 && (current_cpu_type() == CPU_CAVIUM_OCTEON2 ||
+				  !octeon_has_feature(OCTEON_FEATURE_USB))) {
+			pr_debug("Deleting usbn\n");
+			fdt_nop_node(initial_boot_params, usbn);
+			fdt_nop_property(initial_boot_params, aliases, "usbn");
+		} else  {
+			__be32 new_f[1];
+			enum cvmx_helper_board_usb_clock_types c;
+			c = __cvmx_helper_board_usb_get_clock_type();
+			switch (c) {
+			case USB_CLOCK_TYPE_REF_48:
+				new_f[0] = cpu_to_be32(48000000);
+				fdt_setprop_inplace(initial_boot_params, usbn,
+						    "refclk-frequency",  new_f, sizeof(new_f));
+				/* Fall through ...*/
+			case USB_CLOCK_TYPE_REF_12:
+				/* Missing "refclk-type" defaults to external. */
+				fdt_nop_property(initial_boot_params, usbn, "refclk-type");
+				break;
+			default:
+				break;
+			}
+		}
+	}
+
 	return 0;
 }
 
diff --git a/arch/mips/cavium-octeon/octeon_3xxx.dts b/arch/mips/cavium-octeon/octeon_3xxx.dts
index 88cb42d..fa33115 100644
--- a/arch/mips/cavium-octeon/octeon_3xxx.dts
+++ b/arch/mips/cavium-octeon/octeon_3xxx.dts
@@ -550,6 +550,24 @@
 				big-endian-regs;
 			};
 		};
+
+		usbn: usbn@1180068000000 {
+			compatible = "cavium,octeon-5750-usbn";
+			reg = <0x11800 0x68000000 0x0 0x1000>;
+			ranges; /* Direct mapping */
+			#address-cells = <2>;
+			#size-cells = <2>;
+			/* 12MHz, 24MHz and 48MHz allowed */
+			refclk-frequency = <12000000>;
+			/* Either "crystal" or "external" */
+			refclk-type = "crystal";
+
+			usbc@16f0010000000 {
+				compatible = "cavium,octeon-5750-usbc";
+				reg = <0x16f00 0x10000000 0x0 0x80000>;
+				interrupts = <0 56>;
+			};
+		};
 	};
 
 	aliases {
@@ -566,6 +584,7 @@
 		flash0 = &flash0;
 		cf0 = &cf0;
 		uctl = &uctl;
+		usbn = &usbn;
 		led0 = &led0;
 	};
  };
diff --git a/arch/mips/include/asm/octeon/cvmx-helper-board.h b/arch/mips/include/asm/octeon/cvmx-helper-board.h
index 41785dd..8933203 100644
--- a/arch/mips/include/asm/octeon/cvmx-helper-board.h
+++ b/arch/mips/include/asm/octeon/cvmx-helper-board.h
@@ -36,6 +36,13 @@
 
 #include <asm/octeon/cvmx-helper.h>
 
+enum cvmx_helper_board_usb_clock_types {
+	USB_CLOCK_TYPE_REF_12,
+	USB_CLOCK_TYPE_REF_24,
+	USB_CLOCK_TYPE_REF_48,
+	USB_CLOCK_TYPE_CRYSTAL_12,
+};
+
 typedef enum {
 	set_phy_link_flags_autoneg = 0x1,
 	set_phy_link_flags_flow_control_dont_touch = 0x0 << 1,
@@ -154,4 +161,6 @@ extern int __cvmx_helper_board_interface_probe(int interface,
  */
 extern int __cvmx_helper_board_hardware_enable(int interface);
 
+enum cvmx_helper_board_usb_clock_types __cvmx_helper_board_usb_get_clock_type(void);
+
 #endif /* __CVMX_HELPER_BOARD_H__ */
-- 
1.7.11.7

