Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab3FCMdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:33:25 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55697 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab3FCMcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:32:00 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 3/6] GPIO: xilinx: Use __raw_readl/__raw_writel IO functions
Date: Mon,  3 Jun 2013 14:31:18 +0200
Message-Id: <06f2fd99878260f42468d607eb7878dd4f59c6ef.1370262666.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25584-1370262717-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25584-1370262717-0001

This driver can be used on Xilinx ARM Zynq platform
where in_be32/out_be32 functions are not implemented.
Use __raw_readl/__raw_writel functions which are
implemented on Microblaze and PowerPC.
For ARM readl/writel functions are used instead.

The correct way how to implement this is to detect
endians directly on IP. But for the gpio case
without interrupt connected(it means without
interrupt logic) there are just 2 registers
data and tristate where auto detection can't be done.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2:
- New patch in this series

I have chosen to use readl/writel for ARM because
of barriers and keep __raw versions for microblaze
and ppc where this is not a problem.
The reason why in_be32/out_be32 can't be used
is that it won't work on Microblaze LE when
I fix Microblaze IO function implementation which
is broken right now.

---
 drivers/gpio/gpio-xilinx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 626eaa8..791ddae 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -30,8 +30,13 @@
 #define XGPIO_CHANNEL_OFFSET	0x8

 /* Read/Write access to the GPIO registers */
-#define xgpio_readreg(offset)		in_be32(offset)
-#define xgpio_writereg(offset, val)	out_be32(offset, val)
+#ifdef CONFIG_ARCH_ZYNQ
+# define xgpio_readreg(offset)		readl(offset)
+# define xgpio_writereg(offset, val)	writel(val, offset)
+#else
+# define xgpio_readreg(offset)		__raw_readl(offset)
+# define xgpio_writereg(offset, val)	__raw_writel(val, offset)
+#endif

 /**
  * struct xgpio_instance - Stores information about GPIO device
--
1.8.2.3


--=_mimegpg-monstr-desktop-25584-1370262717-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsjL0ACgkQykllyylKDCFT6ACdH6mBeqYzTWPegfmEAAG0pDKG
U10An2hoINaRcmaU3tfizR8J/aiLGsJH
=+XsH
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25584-1370262717-0001--
