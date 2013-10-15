Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711Ab3JOTW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:22:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41368 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759630Ab3JOTWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:22:17 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, lee.jones@linaro.org, sameo@linux.intel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3 v2] mfd: arizona: Specify supply mappings for Arizona CODECs
Date: Tue, 15 Oct 2013 20:12:36 +0100
Message-Id: <1381864356-26107-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1381864356-26107-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1381864356-26107-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CODEC power supplies should be looked up on the Arizona device as
they will be created here by device tree also update the only user of
non-device tree bindings.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 arch/arm/mach-s3c64xx/mach-crag6410.c |   12 ------------
 drivers/mfd/arizona-core.c            |   32 +++++++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/mach-crag6410.c b/arch/arm/mach-s3c64xx/mach-crag6410.c
index eb8e5a1..f27ca3b 100644
--- a/arch/arm/mach-s3c64xx/mach-crag6410.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410.c
@@ -310,10 +310,6 @@ static struct regulator_consumer_supply wallvdd_consumers[] = {
 
 	REGULATOR_SUPPLY("SPKVDDL", "spi0.1"),
 	REGULATOR_SUPPLY("SPKVDDR", "spi0.1"),
-	REGULATOR_SUPPLY("SPKVDDL", "wm5102-codec"),
-	REGULATOR_SUPPLY("SPKVDDR", "wm5102-codec"),
-	REGULATOR_SUPPLY("SPKVDDL", "wm5110-codec"),
-	REGULATOR_SUPPLY("SPKVDDR", "wm5110-codec"),
 
 	REGULATOR_SUPPLY("DC1VDD", "0-0034"),
 	REGULATOR_SUPPLY("DC2VDD", "0-0034"),
@@ -653,14 +649,6 @@ static struct regulator_consumer_supply pvdd_1v8_consumers[] = {
 	REGULATOR_SUPPLY("DBVDD3", "spi0.1"),
 	REGULATOR_SUPPLY("LDOVDD", "spi0.1"),
 	REGULATOR_SUPPLY("CPVDD", "spi0.1"),
-
-	REGULATOR_SUPPLY("DBVDD2", "wm5102-codec"),
-	REGULATOR_SUPPLY("DBVDD3", "wm5102-codec"),
-	REGULATOR_SUPPLY("CPVDD", "wm5102-codec"),
-
-	REGULATOR_SUPPLY("DBVDD2", "wm5110-codec"),
-	REGULATOR_SUPPLY("DBVDD3", "wm5110-codec"),
-	REGULATOR_SUPPLY("CPVDD", "wm5110-codec"),
 };
 
 static struct regulator_init_data pvdd_1v8 = {
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 5ac3aa4..022b186 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -569,13 +569,25 @@ static struct mfd_cell early_devs[] = {
 	{ .name = "arizona-ldo1" },
 };
 
+static const char *wm5102_supplies[] = {
+	"DBVDD2",
+	"DBVDD3",
+	"CPVDD",
+	"SPKVDDL",
+	"SPKVDDR",
+};
+
 static struct mfd_cell wm5102_devs[] = {
 	{ .name = "arizona-micsupp" },
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
 	{ .name = "arizona-pwm" },
-	{ .name = "wm5102-codec" },
+	{
+		.name = "wm5102-codec",
+		.parent_supplies = wm5102_supplies,
+		.num_parent_supplies = ARRAY_SIZE(wm5102_supplies),
+	},
 };
 
 static struct mfd_cell wm5110_devs[] = {
@@ -584,7 +596,17 @@ static struct mfd_cell wm5110_devs[] = {
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
 	{ .name = "arizona-pwm" },
-	{ .name = "wm5110-codec" },
+	{
+		.name = "wm5110-codec",
+		.parent_supplies = wm5102_supplies,
+		.num_parent_supplies = ARRAY_SIZE(wm5102_supplies),
+	},
+};
+
+static const char *wm8997_supplies[] = {
+	"DBVDD2",
+	"CPVDD",
+	"SPKVDD",
 };
 
 static struct mfd_cell wm8997_devs[] = {
@@ -593,7 +615,11 @@ static struct mfd_cell wm8997_devs[] = {
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
 	{ .name = "arizona-pwm" },
-	{ .name = "wm8997-codec" },
+	{
+		.name = "wm8997-codec",
+		.parent_supplies = wm8997_supplies,
+		.num_parent_supplies = ARRAY_SIZE(wm8997_supplies),
+	},
 };
 
 int arizona_dev_init(struct arizona *arizona)
-- 
1.7.2.5

