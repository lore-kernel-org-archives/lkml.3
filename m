Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaGHTLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:11:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54314 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805AbaGHTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.919414242@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 060/125] powerpc/serial: Use saner flags when creating
 legacy ports
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/legacy_serial.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -48,6 +48,9 @@ static struct __initdata of_device_id le
 static unsigned int legacy_serial_count;
 static int legacy_serial_console = -1;
 
+static const upf_t legacy_port_flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST |
+	UPF_SHARE_IRQ | UPF_FIXED_PORT;
+
 static unsigned int tsi_serial_in(struct uart_port *p, int offset)
 {
 	unsigned int tmp;
@@ -153,8 +156,6 @@ static int __init add_legacy_soc_port(st
 {
 	u64 addr;
 	const u32 *addrp;
-	upf_t flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_SHARE_IRQ
-		| UPF_FIXED_PORT;
 	struct device_node *tsi = of_get_parent(np);
 
 	/* We only support ports that have a clock frequency properly
@@ -185,9 +186,11 @@ static int __init add_legacy_soc_port(st
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
@@ -228,7 +231,7 @@ static int __init add_legacy_isa_port(st
 
 	/* Add port, irq will be dealt with later */
 	return add_legacy_port(np, index, UPIO_PORT, be32_to_cpu(reg[1]), taddr,
-			       NO_IRQ, UPF_BOOT_AUTOCONF, 0);
+			       NO_IRQ, legacy_port_flags, 0);
 
 }
 
@@ -301,7 +304,7 @@ static int __init add_legacy_pci_port(st
 	 * IO port value. It will be fixed up later along with the irq
 	 */
 	return add_legacy_port(np, index, iotype, base, addr, NO_IRQ,
-			       UPF_BOOT_AUTOCONF, np != pci_dev);
+			       legacy_port_flags, np != pci_dev);
 }
 #endif
 

