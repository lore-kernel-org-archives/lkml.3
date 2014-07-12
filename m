Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaGLAGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:06:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:62867 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754506AbaGLAGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:06:01 -0400
Date: Fri, 11 Jul 2014 20:06:15 -0400
From: "Daniel M. Weeks" <dan@danweeks.net>
To: Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: piix4: Continue probing for auxiliary SMBus without main
Message-ID: <20140712000607.GA25787@turkey.danweeks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOS may only allow access to the AMD auxiliary SMBus - reserving
the main SMBus for system functions only. Probing should continue even
if the main bus is not available so at least the auxiliary can be added.

Signed-off-by: Daniel M. Weeks <dan@danweeks.net>
---
This patch may warrant some discussion. I ran across this problem on an
AMD Hudson board where the main SMBus is hard-wired for debugging but
the auxiliary bus is exposed for expansion. Either purposefully or
because the BIOS is a little broken, loading this module used to result
in an ACPI conflict for the main bus and neither was usable. With the
patch I'm able to use the auxiliary bus regardless of the conflict on
the main bus. I'm not 100% convinced it's the correct fix - someone with
more ACPI experience than me is going to need to review this.

drivers/i2c/busses/i2c-piix4.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index a6f54ba..d4bac64 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -628,14 +628,16 @@ static int piix4_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	else
 		retval = piix4_setup(dev, id);
 
-	/* If no main SMBus found, give up */
-	if (retval < 0)
-		return retval;
-
-	/* Try to register main SMBus adapter, give up if we can't */
-	retval = piix4_add_adapter(dev, retval, &piix4_main_adapter);
-	if (retval < 0)
-		return retval;
+	/* If no main SMBus found, do not give up
+	 * some BIOS purposely only expose aux bus */
+	if (retval < 0) {
+		dev_info(&dev->dev, "No main SMBus; checking auxiliary\n");
+	} else {
+		/* Try to register main SMBus adapter, give up if we can't */
+		retval = piix4_add_adapter(dev, retval, &piix4_main_adapter);
+		if (retval < 0)
+			return retval;
+	}
 
 	/* Check for auxiliary SMBus on some AMD chipsets */
 	retval = -ENODEV;
-- 
Daniel M. Weeks

