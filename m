Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3HOK6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:58:17 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:24064
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755378Ab3HOK6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:58:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/3] of: add update device node status via cmdline feature
Date: Thu, 15 Aug 2013 18:55:32 +0800
Message-ID: <1376564133-11286-3-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1376564133-11286-1-git-send-email-b29396@freescale.com>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some boards may have a lot of pin conflicts between different devices,
only one of them can be enabled to run at one time.
Instead of changing dts manually or adding a lot dts files according to
different device availability, we provide feature to dynamically update the
device node status via command line, then those devices involved with
pin conflict can be enabled or disabled dynamically.

Signed-off-by: Dong Aisheng <b29396@freescale.com>
---
 Documentation/kernel-parameters.txt |    9 +++++
 drivers/of/fdt.c                    |   69 +++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 15356ac..65f3be2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -128,6 +128,7 @@ In addition, the following text indicates that the option:
 	BUGS=	Relates to possible processor bugs on the said processor.
 	KNL	Is a kernel start-up parameter.
 	BOOT	Is a boot loader parameter.
+	FDT	Is a flattened device tree paramter.
 
 Parameters denoted with BOOT are actually interpreted by the boot
 loader, and have no meaning to the kernel directly.
@@ -895,6 +896,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			General fault injection mechanism.
 			Format: <interval>,<probability>,<space>,<times>
 			See also Documentation/fault-injection/.
+	fdt.enable=
+	fdt.disable=
+			[KNL,FDT]
+			update device tree node status before populating devices
+			Format: fdt.<enable|disable>=<path>[,<path>]
+			enable    := update the device node to a enabled state
+			disable   := update the device node to a disabled state
+			<path>    := node path or node full name in device tree
 
 	floppy=		[HW]
 			See Documentation/blockdev/floppy.txt.
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 6bb7cf2..423624b 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -25,6 +25,11 @@
 
 #include <asm/page.h>
 
+static char *enable;
+module_param(enable, charp, 0444);
+static char *disable;
+module_param(disable, charp, 0444);
+
 char *of_fdt_get_string(struct boot_param_header *blob, u32 offset)
 {
 	return ((char *)blob) +
@@ -713,4 +718,68 @@ void __init unflatten_device_tree(void)
 	of_alias_scan(early_init_dt_alloc_memory_arch);
 }
 
+/*
+ * The format for the command line is as follows:
+ *
+ * fdt.<enable|disable>=<path>[,<path>]
+ * enable    := update the device node to a enabled state
+ * disable   := update the device node to a disabled state
+ * <path>    := node path or node full name in device tree
+ *
+ * e.g:
+ *	fdt.enable=/soc/aips-bus@02100000/i2c@021a8000,/soc/aips-bus@02100000/weim@021b8000
+ *	fdt.disable=/soc/aips-bus@02100000/weim@021b8000
+ */
+static int __init __of_flat_parse_param(char *s, bool enable)
+{
+	char path[256], *p;
+
+	if (!s)
+		return 0;
+
+	p = s;
+	while (*s != '\0') {
+		p = strchr(s, ',');
+		if (p != NULL) {
+			BUG_ON((p - s) >= 256);
+			strncpy(path, s, p - s);
+			path[p - s] = '\0';
+			if (enable)
+				of_node_status_enable_by_path(path);
+			else
+				of_node_status_disable_by_path(path);
+			/* search for next node */
+			s = p + 1;
+		} else {
+			/* last node */
+			if (enable)
+				of_node_status_enable_by_path(s);
+			else
+				of_node_status_disable_by_path(s);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static inline void __init of_flat_parse_param(void)
+{
+	__of_flat_parse_param(enable, 1);
+	__of_flat_parse_param(disable, 0);
+}
+
+/*
+ * handle device node status update
+ */
+static int __init of_flat_late_init(void)
+{
+	of_flat_parse_param();
+
+	return 0;
+}
+
+/* we use postcore_init to run before mach code populate platform devices */
+postcore_initcall(of_flat_late_init);
+
 #endif /* CONFIG_OF_EARLY_FLATTREE */
-- 
1.7.1


