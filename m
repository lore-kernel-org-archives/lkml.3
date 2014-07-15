Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbaGOVcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:32:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54036 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202AbaGOVcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:32:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 097/198] powerpc/serial: Use saner flags when creating legacy ports
Date: Tue, 15 Jul 2014 14:29:27 -0700
Message-Id: <1405459868-15089-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/legacy_serial.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 40bd7bd..8a8b722 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -48,6 +48,9 @@ static struct of_device_id legacy_serial_parents[] __initdata = {
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
1.9.1

