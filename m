Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161384AbaGRN3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:29:20 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17859 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935091AbaGRNQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:16:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 041/170] powerpc/serial: Use saner flags when creating legacy ports
Date: Fri, 18 Jul 2014 14:10:46 +0200
Message-Id: <0c35d0ca33a7acb458a4cddc5897f4248e3ae317.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c4cad90f9e9dcb85afc5e75a02ae3522ed077296 upstream.

We had a mix & match of flags used when creating legacy ports
depending on where we found them in the device-tree. Among others
we were missing UPF_SKIP_TEST for some kind of ISA ports which is
a problem as quite a few UARTs out there don't support the loopback
test (such as a lot of BMCs).

Let's pick the set of flags used by the SoC code and generalize it
which means autoconf, no loopback test, irq maybe shared and fixed
port.

Sending to stable as the lack of UPF_SKIP_TEST is breaking
serial on some machines so I want this back into distros

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/kernel/legacy_serial.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 22e88dd2f34a..a531358f971e 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -48,6 +48,9 @@ static struct __initdata of_device_id legacy_serial_parents[] = {
 static unsigned int legacy_serial_count;
 static int legacy_serial_console = -1;
 
+static const upf_t legacy_port_flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST |
+	UPF_SHARE_IRQ | UPF_FIXED_PORT;
+
 static unsigned int tsi_serial_in(struct uart_port *p, int offset)
 {
 	unsigned int tmp;
@@ -153,8 +156,6 @@ static int __init add_legacy_soc_port(struct device_node *np,
 {
 	u64 addr;
 	const __be32 *addrp;
-	upf_t flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_SHARE_IRQ
-		| UPF_FIXED_PORT;
 	struct device_node *tsi = of_get_parent(np);
 
 	/* We only support ports that have a clock frequency properly
@@ -185,9 +186,11 @@ static int __init add_legacy_soc_port(struct device_node *np,
 	 * IO port value. It will be fixed up later along with the irq
 	 */
 	if (tsi && !strcmp(tsi->type, "tsi-bridge"))
-		return add_legacy_port(np, -1, UPIO_TSI, addr, addr, NO_IRQ, flags, 0);
+		return add_legacy_port(np, -1, UPIO_TSI, addr, addr,
+				       NO_IRQ, legacy_port_flags, 0);
 	else
-		return add_legacy_port(np, -1, UPIO_MEM, addr, addr, NO_IRQ, flags, 0);
+		return add_legacy_port(np, -1, UPIO_MEM, addr, addr,
+				       NO_IRQ, legacy_port_flags, 0);
 }
 
 static int __init add_legacy_isa_port(struct device_node *np,
@@ -233,7 +236,7 @@ static int __init add_legacy_isa_port(struct device_node *np,
 
 	/* Add port, irq will be dealt with later */
 	return add_legacy_port(np, index, UPIO_PORT, be32_to_cpu(reg[1]),
-			       taddr, NO_IRQ, UPF_BOOT_AUTOCONF, 0);
+			       taddr, NO_IRQ, legacy_port_flags, 0);
 
 }
 
@@ -306,7 +309,7 @@ static int __init add_legacy_pci_port(struct device_node *np,
 	 * IO port value. It will be fixed up later along with the irq
 	 */
 	return add_legacy_port(np, index, iotype, base, addr, NO_IRQ,
-			       UPF_BOOT_AUTOCONF, np != pci_dev);
+			       legacy_port_flags, np != pci_dev);
 }
 #endif
 
-- 
2.0.0

