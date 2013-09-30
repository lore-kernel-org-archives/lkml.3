Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab3I3GvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 02:51:10 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:57907 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3I3GvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 02:51:08 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu, vinod.koul@intel.com
Cc: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] dma: pl330: Support per channel irq allocation
Date: Mon, 30 Sep 2013 08:50:48 +0200
Message-Id: <08a752258a021feb91eba25eafd28ea2bacf72e4.1380523844.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-15625-1380523848-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-15625-1380523848-0001

Some pl330 have per channel irq and it is necessary
to allocate all of them. Loop over irq assigned for this
device to support these pl330 IPs.

For example this IP is available on Xilinx Zynq platform.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Hi Vinod,

this is the patch I told you about it. I have tested it
just on Zynq(8 dma channels) but it shouldn't break
any other pl330 clones.
One more change has to be done to support all 8 dma channels
which is to extend AMBA_NR_IRQS which is still 2.
But I will send separate patch for it directly to Russell.

Thanks,
Michal

---
 drivers/dma/pl330.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 58623dc..96de393 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2922,11 +2922,18 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)

 	amba_set_drvdata(adev, pdmac);

-	irq = adev->irq[0];
-	ret = devm_request_irq(&adev->dev, irq, pl330_irq_handler, 0,
-			dev_name(&adev->dev), pi);
-	if (ret)
-		return ret;
+	for (i = 0; i <= AMBA_NR_IRQS; i++) {
+		irq = adev->irq[i];
+		if (irq) {
+			ret = devm_request_irq(&adev->dev, irq,
+					       pl330_irq_handler, 0,
+					       dev_name(&adev->dev), pi);
+			if (ret)
+				return ret;
+		} else {
+			break;
+		}
+	}

 	pi->pcfg.periph_id = adev->periphid;
 	ret = pl330_add(pi);
--
1.8.2.3


--=_mimegpg-monstr-desktop-15625-1380523848-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJJH0kACgkQykllyylKDCGjBgCcCTcWpXT70TCgzEnbZqsLj0Ab
hvMAn2TS5ko3HRRYct+Ac1jo88SZlo/o
=XXvS
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-15625-1380523848-0001--
