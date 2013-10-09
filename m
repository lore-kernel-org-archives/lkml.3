Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3JIQw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 12:52:57 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.149]:30994 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596Ab3JIQw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 12:52:56 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Oct 2013 12:52:55 EDT
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-7.tower-180.messagelabs.com!1381337166!11113055!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201310091646.r99Gk3N9015896@swsrvapps-02.lan>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Wed, 9 Oct 2013 17:44:38 +0100
Subject: [PATCH V1] Fix Regmap Block Write single-rw Mutex Deadlock
To: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is relative to linux-next repository tag next-20130927

When regmap_bulk_write() is called with the map->use_single_rw flag set
an immediate mutex deadlock happens because regmap_raw_write() is called
after obtaining the mutex and regmap_raw_write() itself then tries to
obtain the mutex as well.

It is obvious that no one other than myself tried it with a real device.
I did, but only for the purposes of an experiment and demonstration.

But even if this situation will never ever happen with a real device, it
is a bug and therefore should be fixed.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
---
 drivers/base/regmap/regmap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 00152bf..6bd9294 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1488,10 +1488,11 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	 */
 	if (map->use_single_rw) {
 		for (i = 0; i < val_count; i++) {
-			ret = regmap_raw_write(map,
-					       reg + (i * map->reg_stride),
-					       val + (i * val_bytes),
-					       val_bytes);
+			ret = _regmap_raw_write(map,
+						reg + (i * map->reg_stride),
+						val + (i * val_bytes),
+						val_bytes,
+						false);
 			if (ret != 0)
 				return ret;
 		}
-- 
end-of-patch for Fix Regmap Block Write single-rw Mutex Deadlock V1

