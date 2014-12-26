Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaLZR1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 12:27:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45943 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751118AbaLZR1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 12:27:05 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, linux-ide@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 1/2] regulator: core: Add a sanity check on the regulator_ enable/disable functions
Date: Fri, 26 Dec 2014 18:26:38 +0100
Message-Id: <1419614799-5770-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419614799-5770-1-git-send-email-gregory.clement@free-electrons.com>
References: <1419614799-5770-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two functions use the pointer passed in parameter without any
check. By adding a NULL pointer check, it allows using those functions
from a driver in a more generic way. It is useful especially for the
disable case if the regulator is optional.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/regulator/core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e225711bb8bc..de29399b5430 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1911,12 +1911,16 @@ static int _regulator_enable(struct regulator_dev *rdev)
  */
 int regulator_enable(struct regulator *regulator)
 {
-	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *rdev;
 	int ret = 0;
 
+	if (!regulator)
+		return 0;
+
 	if (regulator->always_on)
 		return 0;
 
+	rdev = regulator->rdev;
 	if (rdev->supply) {
 		ret = regulator_enable(rdev->supply);
 		if (ret != 0)
@@ -2024,12 +2028,17 @@ static int _regulator_disable(struct regulator_dev *rdev)
  */
 int regulator_disable(struct regulator *regulator)
 {
-	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *rdev;
 	int ret = 0;
 
+	if (!regulator)
+		return 0;
+
 	if (regulator->always_on)
 		return 0;
 
+	rdev = regulator->rdev;
+
 	mutex_lock(&rdev->mutex);
 	ret = _regulator_disable(rdev);
 	mutex_unlock(&rdev->mutex);
-- 
1.9.1

