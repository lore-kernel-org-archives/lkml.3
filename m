Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaHRNJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:09:13 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41704 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaHRNJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:09:11 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xiubo Li <Li.Xiubo@freescale.com>, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/1] regmap: Fix DT endianess parsing logic
Date: Mon, 18 Aug 2014 15:09:02 +0200
Message-Id: <1408367342-16413-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d647c199510c ("regmap: add DT endianness binding support.")
added support to parse the device endianness from the device tree
but unfortunately the added logic doesn't have the same semantics
than the old code. This leads to a NULL dereference pointer error
when these properties are not provided by the Device Tree:

Unable to handle kernel NULL pointer dereference at virtual address 00000044
pgd = c0004000
[00000044] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 5 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc1-next-20140818ccu #671
task: ea412800 ti: ea484000 task.ti: ea484000
PC is at regmap_update_bits+0xc/0x5c

The problem is that platforms that rely on the default value now
gets different values due two related issues in the current code:

a) It only parses the endianness from DT for the regmap registers
   and not for the regmap values but it checks unconditionally in
   both cases if the resulting endiannes is REGMAP_ENDIAN_NATIVE.

b) REGMAP_ENDIAN_NATIVE is not even a valid DT property according
   to the regmap DT binding documentation so it shouldn't be set.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/base/regmap/regmap.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e4e567e..055a9c3 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -499,7 +499,6 @@ static int of_regmap_get_endian(struct device *dev,
 	 * From the DT node the endianness value maybe:
 	 *   REGMAP_ENDIAN_BIG,
 	 *   REGMAP_ENDIAN_LITTLE,
-	 *   REGMAP_ENDIAN_NATIVE,
 	 */
 	switch (type) {
 	case REGMAP_ENDIAN_VAL:
@@ -507,8 +506,10 @@ static int of_regmap_get_endian(struct device *dev,
 			*endian = REGMAP_ENDIAN_BIG;
 		else if (of_property_read_bool(np, "little-endian"))
 			*endian = REGMAP_ENDIAN_LITTLE;
-		else
-			*endian = REGMAP_ENDIAN_NATIVE;
+
+		if (*endian != REGMAP_ENDIAN_DEFAULT)
+			return 0;
+
 		break;
 	case REGMAP_ENDIAN_REG:
 		break;
@@ -517,15 +518,6 @@ static int of_regmap_get_endian(struct device *dev,
 	}
 
 	/*
-	 * If the endianness parsed from DT node is REGMAP_ENDIAN_NATIVE, that
-	 * maybe means the DT does not care the endianness or it should use
-	 * the regmap bus's default endianness, then we should try to check
-	 * whether the regmap bus has specified the default endianness.
-	 */
-	if (*endian != REGMAP_ENDIAN_NATIVE)
-		return 0;
-
-	/*
 	 * Finally, try to parse the endianness from regmap bus config
 	 * if in device's DT node the endianness property is absent.
 	 */
-- 
2.0.1

