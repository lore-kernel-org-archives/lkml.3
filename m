Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3EaM5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:57:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45591 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3EaM4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:56:09 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH v3 6/8] video: xilinxfb: Add support for little endian accesses
Date: Fri, 31 May 2013 14:55:36 +0200
Message-Id: <c1791574b211528b9f59af634018b7c83678f963.1370004925.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8184-1370004964-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8184-1370004964-0001

Dynamically detect endianess on IP and use
ioread/iowrite functions instead of powerpc and microblaze
specific out_be32.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v3:
- New patch in this patchset based on discussions

Changes in v2: None

 drivers/video/xilinxfb.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index bd3b85d..f3d4a69 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -117,6 +117,7 @@ static struct fb_var_screeninfo xilinx_fb_var = {


 #define BUS_ACCESS_FLAG		0x1 /* 1 = BUS, 0 = DCR */
+#define LITTLE_ENDIAN_ACCESS	0x2 /* LITTLE ENDIAN IO functions */

 struct xilinxfb_drvdata {

@@ -153,14 +154,33 @@ struct xilinxfb_drvdata {
 static void xilinx_fb_out32(struct xilinxfb_drvdata *drvdata, u32 offset,
 				u32 val)
 {
-	if (drvdata->flags & BUS_ACCESS_FLAG)
-		out_be32(drvdata->regs + (offset << 2), val);
+	if (drvdata->flags & BUS_ACCESS_FLAG) {
+		if (drvdata->flags & LITTLE_ENDIAN_ACCESS)
+			iowrite32(val, drvdata->regs + (offset << 2));
+		else
+			iowrite32be(val, drvdata->regs + (offset << 2));
+	}
 #ifdef CONFIG_PPC_DCR
 	else
 		dcr_write(drvdata->dcr_host, offset, val);
 #endif
 }

+static u32 xilinx_fb_in32(struct xilinxfb_drvdata *drvdata, u32 offset)
+{
+	if (drvdata->flags & BUS_ACCESS_FLAG) {
+		if (drvdata->flags & LITTLE_ENDIAN_ACCESS)
+			return ioread32(drvdata->regs + (offset << 2));
+		else
+			return ioread32be(drvdata->regs + (offset << 2));
+	}
+#ifdef CONFIG_PPC_DCR
+	else
+		return dcr_read(drvdata->dcr_host, offset);
+#endif
+	return 0;
+}
+
 static int
 xilinx_fb_setcolreg(unsigned regno, unsigned red, unsigned green, unsigned blue,
 	unsigned transp, struct fb_info *fbi)
@@ -271,6 +291,12 @@ static int xilinxfb_assign(struct platform_device *pdev,

 	/* Tell the hardware where the frame buffer is */
 	xilinx_fb_out32(drvdata, REG_FB_ADDR, drvdata->fb_phys);
+	rc = xilinx_fb_in32(drvdata, REG_FB_ADDR);
+	/* Endianess detection */
+	if (rc != drvdata->fb_phys) {
+		drvdata->flags |= LITTLE_ENDIAN_ACCESS;
+		xilinx_fb_out32(drvdata, REG_FB_ADDR, drvdata->fb_phys);
+	}

 	/* Turn on the display */
 	drvdata->reg_ctrl_default = REG_CTRL_ENABLE;
--
1.8.2.3


--=_mimegpg-monstr-desktop-8184-1370004964-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGoneQACgkQykllyylKDCHlvQCfUJeVvclOTtNGWXWG4hARYe5H
KN0AnjBlbpR/46i5sr0OBtDX/T5kmtR+
=ARGb
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8184-1370004964-0001--
