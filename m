Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab3FRTNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:13:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37583 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab3FRTNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:13:06 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 2/5] MIPS: OCTEON: Set proper UART clock in internal device trees.
Date: Tue, 18 Jun 2013 12:12:52 -0700
Message-Id: <1371582775-12141-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Following patch to use generic 8250 drivers will need proper clock
information.  So when using the internal device tree, populate the
"clock-frequency" property with the correct value.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/cavium-octeon/octeon-platform.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index 389512e..7b746e7 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -490,8 +490,15 @@ int __init octeon_prune_device_tree(void)
 
 		if (alias_prop) {
 			uart = fdt_path_offset(initial_boot_params, alias_prop);
-			if (uart_mask & (1 << i))
+			if (uart_mask & (1 << i)) {
+				__be32 f;
+
+				f = cpu_to_be32(octeon_get_io_clock_rate());
+				fdt_setprop_inplace(initial_boot_params,
+						    uart, "clock-frequency",
+						    &f, sizeof(f));
 				continue;
+			}
 			pr_debug("Deleting uart%d\n", i);
 			fdt_nop_node(initial_boot_params, uart);
 			fdt_nop_property(initial_boot_params, aliases,
-- 
1.7.11.7

