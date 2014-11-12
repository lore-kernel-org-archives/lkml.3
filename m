Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaKLWJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:09:33 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:40299 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaKLWJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:09:28 -0500
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2014 17:09:26 EST
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH] bq27x00_battery: fix register offset for bq27425
Date: Wed, 12 Nov 2014 23:04:08 +0100
Message-Id: <1415829848-29730-1-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- SOC is at 0x1C so we must add 0x4 as stated in the comment to read the
  right value.
- DCAP is at 0x3c so we also must use a value with the right offset to get
  the correct design capacity.

Actually testing on a bq27410 which has the same register map as bq27425
(but adds new registers).

Signed-off-by: Eric Bénard <eric@eukrea.com>
---
 drivers/power/bq27x00_battery.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index e3bacfe..ab18e96 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -76,7 +76,8 @@
 
 /* bq27425 register addresses are same as bq27x00 addresses minus 4 */
 #define BQ27425_REG_OFFSET		0x04
-#define BQ27425_REG_SOC			0x18 /* Register address plus offset */
+#define BQ27425_REG_SOC		(0x1C + BQ27425_REG_OFFSET)
+#define BQ27425_REG_DCAP		(0x3C + BQ27425_REG_OFFSET)
 
 #define BQ27000_RS			20 /* Resistor sense */
 #define BQ27x00_POWER_CONSTANT		(256 * 29200 / 1000)
@@ -282,9 +283,12 @@ static int bq27x00_battery_read_ilmd(struct bq27x00_device_info *di)
 {
 	int ilmd;
 
-	if (bq27xxx_is_chip_version_higher(di))
-		ilmd = bq27x00_read(di, BQ27500_REG_DCAP, false);
-	else
+	if (bq27xxx_is_chip_version_higher(di)) {
+		if (di->chip == BQ27425)
+			ilmd = bq27x00_read(di, BQ27425_REG_DCAP, false);
+		else
+			ilmd = bq27x00_read(di, BQ27500_REG_DCAP, false);
+	} else
 		ilmd = bq27x00_read(di, BQ27000_REG_ILMD, true);
 
 	if (ilmd < 0) {
-- 
2.1.1

