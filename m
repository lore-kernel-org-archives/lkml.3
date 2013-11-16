Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3KPUaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 15:30:30 -0500
Received: from mail.qboosh.pl ([217.73.31.61]:48221 "EHLO mail.qboosh.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab3KPUaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 15:30:22 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Nov 2013 15:30:22 EST
Date: Sat, 16 Nov 2013 21:20:48 +0100
From: Jakub Bogusz <qboosh@pld-linux.org>
To: Miloslav Trmac <mitr@volny.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix NX-related Oops in wistron_btns module
Message-ID: <20131116202048.GA8688@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The attached patch fixes "kernel tried to execute NX-protected page"
Oops when loading wistron_btns module, occurring since at least 3.4.x;
still applies to Linux 3.12.


-- 
Jakub Bogusz    http://qboosh.pl/

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-wistron-nx.patch"

This patch fixes "kernel tried to execute NX-protected page" oops when
loading winstron-btns module.

Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>

--- linux-3.10/drivers/input/misc/wistron_btns.c.orig	2013-11-16 09:05:55.612742472 +0100
+++ linux-3.10/drivers/input/misc/wistron_btns.c	2013-11-16 09:24:37.356028732 +0100
@@ -33,6 +33,7 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
+#include <asm/cacheflush.h>
 
 /* How often we poll keys - msecs */
 #define POLL_INTERVAL_DEFAULT	500 /* when idle */
@@ -124,6 +125,7 @@
 	if (entry_point >= 0xF0000) {
 		bios_code_map_base = base;
 		bios_entry_point = bios_code_map_base + (entry_point & 0xFFFF);
+		set_memory_x((unsigned long)bios_code_map_base, 0x10000 >> PAGE_SHIFT);
 	} else {
 		iounmap(base);
 		bios_code_map_base = ioremap(entry_point & ~0x3FFF, 0x4000);
@@ -134,6 +136,7 @@
 			goto err;
 		}
 		bios_entry_point = bios_code_map_base + (entry_point & 0x3FFF);
+		set_memory_x((unsigned long)bios_code_map_base, 0x4000 >> PAGE_SHIFT);
 	}
 	/* The Windows driver maps 0x10000 bytes, we keep only one page... */
 	bios_data_map_base = ioremap(0x400, 0xc00);

--17pEHd4RhPHOinZp--
