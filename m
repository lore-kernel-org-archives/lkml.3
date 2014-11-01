Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaKAXDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:03:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60060 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.648083507@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 009/102] regmap: if format_write is used, declare all
 registers as "unreadable"
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 4191f19792bf91267835eb090d970e9cd6277a65 upstream.

Using .format_write means, we have a custom function to write to the
chip, but not to read back. Also, mark registers as "not precious" and
"not volatile" which is implicit because we cannot read them. Make those
functions use 'regmap_readable' to reuse the checks done there.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/base/regmap/regmap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -36,6 +36,9 @@ bool regmap_readable(struct regmap *map,
 	if (map->max_register && reg > map->max_register)
 		return false;
 
+	if (map->format.format_write)
+		return false;
+
 	if (map->readable_reg)
 		return map->readable_reg(map->dev, reg);
 
@@ -44,7 +47,7 @@ bool regmap_readable(struct regmap *map,
 
 bool regmap_volatile(struct regmap *map, unsigned int reg)
 {
-	if (map->max_register && reg > map->max_register)
+	if (!regmap_readable(map, reg))
 		return false;
 
 	if (map->volatile_reg)
@@ -55,7 +58,7 @@ bool regmap_volatile(struct regmap *map,
 
 bool regmap_precious(struct regmap *map, unsigned int reg)
 {
-	if (map->max_register && reg > map->max_register)
+	if (!regmap_readable(map, reg))
 		return false;
 
 	if (map->precious_reg)

