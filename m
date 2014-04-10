Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935195AbaDJJaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:30:13 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:15039 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933785AbaDJJaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:30:08 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat4jNPvwo0=
X-RZG-CLASS-ID: mo00
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] bq270x0: minor improvements for daily operation
Date: Thu, 10 Apr 2014 11:30:07 +0200
Message-Id: <021160A5-3CD7-4F39-BEF9-96B99DEC7463@goldelico.com>
Cc: Marek Belisko <marek@goldelico.com>, LKML <linux-kernel@vger.kernel.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Mime-Version: 1.0 (Apple Message framework v1085)
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve operation on OpenPhoenux GTA04 board:
* treat receiving 0xff from the 1-wire layer as a missing battery
* print calibration warning only in debug mode to keep dmesg clean

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/power/bq27x00_battery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index b309713..fa15dc9 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -415,10 +415,13 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 	bool is_bq27425 = di->chip == BQ27425;
 
 	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
+	if ((cache.flags & 0xff) == 0xff)
+		/* read error */
+		cache.flags = -1;
 	if (cache.flags >= 0) {
 		if (!is_bq27500 && !is_bq27425
 				&& (cache.flags & BQ27000_FLAG_CI)) {
-			dev_info(di->dev, "battery is not calibrated! ignoring capacity values\n");
+			dev_dbg(di->dev, "battery is not calibrated! ignoring capacity values\n");
 			cache.capacity = -ENODATA;
 			cache.energy = -ENODATA;
 			cache.time_to_empty = -ENODATA;
-- 
1.9.1


