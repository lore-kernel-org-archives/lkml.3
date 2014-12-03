Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaLCLh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:37:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbaLCL1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:44 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 078/101] pcmcia: pxa2xx: fix logic for lubbock
Date: Wed,  3 Dec 2014 12:26:40 +0100
Message-Id: <2948ce57731969aa662e0192d2df0749f1f21462.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f1674f213ec81c55c909bb6805d3502b5883754d upstream.

The lubbock platform uses the sa1111 companion chip with a pxa250
CPU, which means it requires both the PCMCIA_SA1111 and the
PCMCIA_PXA2XX code to be built into the kernel. Unfortunately,
the Makefile and Kconfig don't agree on how this is accomplished,
leading to a situation where you get this link error when building
a lubbock kernel with PCMCIA_SA1111 enabled but PCMCIA_PXA2XX
disabled:

ERROR: "pxa2xx_configure_sockets" [drivers/pcmcia/sa1111_cs.ko] undefined!
ERROR: "pxa2xx_drv_pcmcia_ops" [drivers/pcmcia/sa1111_cs.ko] undefined!
ERROR: "pxa2xx_drv_pcmcia_add_one" [drivers/pcmcia/sa1111_cs.ko] undefined!

This patch changes the Kconfig code to disallow that particular
configuration.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pcmcia/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 0c657d6af03d..51cf8083b299 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -202,6 +202,7 @@ config PCMCIA_SA1111
 	depends on ARM && SA1111 && PCMCIA
 	select PCMCIA_SOC_COMMON
 	select PCMCIA_SA11XX_BASE if ARCH_SA1100
+	select PCMCIA_PXA2XX if ARCH_LUBBOCK && SA1111
 	help
 	  Say Y  here to include support for SA1111-based PCMCIA or CF
 	  sockets, found on the Jornada 720, Graphicsmaster and other
@@ -217,7 +218,6 @@ config PCMCIA_PXA2XX
 		    || ARCOM_PCMCIA || ARCH_PXA_ESERIES || MACH_STARGATE2 \
 		    || MACH_VPAC270 || MACH_BALLOON3 || MACH_COLIBRI \
 		    || MACH_COLIBRI320 || MACH_H4700)
-	select PCMCIA_SA1111 if ARCH_LUBBOCK && SA1111
 	select PCMCIA_SOC_COMMON
 	help
 	  Say Y here to include support for the PXA2xx PCMCIA controller
-- 
2.1.3

