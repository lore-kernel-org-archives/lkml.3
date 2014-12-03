Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaLCLgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:36:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaLCL1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:44 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        linux-pcmcia@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 079/101] pcmcia: journada720: use sa1100 pin interfaces correctly
Date: Wed,  3 Dec 2014 12:26:41 +0100
Message-Id: <bd66de1b39f7694430862d9637475439be571d62.1417605922.git.jslaby@suse.cz>
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

commit 58409f9d21a9d372e35857b5b8aaf334997b127b upstream.

commit dabd14684bc2 "PCMCIA: sa1111: remove duplicated initializers"
incorrectly moved some code into the pcmcia_jornada720_init, causing
a few build errors, and for unknown reasons, the driver lacks
an inclusion of <linux/io.h>, so we get the build errors, and more:

sa1111_jornada720.c: In function 'pcmcia_jornada720_init':
sa1111_jornada720.c:101:3: error: implicit declaration of function 'IOMEM' [-Werror=implicit-function-declaration]
   GRER |= 0x00000002;
   ^
sa1111_jornada720.c:104:3: warning: passing argument 1 of 'sa1111_set_io_dir' from incompatible pointer type [enabled by default]
   sa1111_set_io_dir(dev, pin, 0, 0);
   ^

This patch uses the SA1111_DEV() to convert the dev pointer to the
correct type before passing it and adds the missing include.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: linux-pcmcia@lists.infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pcmcia/sa1111_jornada720.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pcmcia/sa1111_jornada720.c b/drivers/pcmcia/sa1111_jornada720.c
index 3baa3ef09682..40e040314503 100644
--- a/drivers/pcmcia/sa1111_jornada720.c
+++ b/drivers/pcmcia/sa1111_jornada720.c
@@ -9,6 +9,7 @@
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/io.h>
 
 #include <mach/hardware.h>
 #include <asm/hardware/sa1111.h>
@@ -94,6 +95,7 @@ static struct pcmcia_low_level jornada720_pcmcia_ops = {
 int pcmcia_jornada720_init(struct device *dev)
 {
 	int ret = -ENODEV;
+	struct sa1111_dev *sadev = SA1111_DEV(dev);
 
 	if (machine_is_jornada720()) {
 		unsigned int pin = GPIO_A0 | GPIO_A1 | GPIO_A2 | GPIO_A3;
@@ -101,12 +103,12 @@ int pcmcia_jornada720_init(struct device *dev)
 		GRER |= 0x00000002;
 
 		/* Set GPIO_A<3:1> to be outputs for PCMCIA/CF power controller: */
-		sa1111_set_io_dir(dev, pin, 0, 0);
-		sa1111_set_io(dev, pin, 0);
-		sa1111_set_sleep_io(dev, pin, 0);
+		sa1111_set_io_dir(sadev, pin, 0, 0);
+		sa1111_set_io(sadev, pin, 0);
+		sa1111_set_sleep_io(sadev, pin, 0);
 
 		sa11xx_drv_pcmcia_ops(&jornada720_pcmcia_ops);
-		ret = sa1111_pcmcia_add(dev, &jornada720_pcmcia_ops,
+		ret = sa1111_pcmcia_add(sadev, &jornada720_pcmcia_ops,
 				sa11xx_drv_pcmcia_add_one);
 	}
 
-- 
2.1.3

