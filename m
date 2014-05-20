Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaETKMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:12:30 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:49606 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaETKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:12:29 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH v2] regulator: core: Fix the init of DT defined fixed regulators
Date: Tue, 20 May 2014 12:12:16 +0200
Message-Id: <1400580736-29410-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.9.3
X-Provags-ID: V02:K0:9IJXdcVKG2gsrxBooUCm2DBQ9kLJF0ldQeWmFaGPvf+
 nieQBYxO7B/vnaXGadf/cHZQGzFs+8dL6SHUStY2M6Q35a2p0l
 jTGMvXpwdrJE8TL3s1+Q2ZD4LQ1MJ2q/fSIobr7RQl1ll5UqpF
 fX+dYmW9C8Vkf+iQpBI7hNWIHdcTpJUzU6JIdukBjp61gSYX7G
 VAjsOLODtEN5HMWRUz2yIJBfLmidQwHpZzIz8y3tdA1rxeV6/+
 QyWS/jWFk/6BB0AIUtYd4pgRnem5l6vQPHw0axtpcPXHRAJSS7
 cM9Jr4zfL/nM8UTVPugEG/DZsJ4rOgQKZW0tqliq/QfLKWufT0
 4tTeWWIpezKB30us7BckiVwEvwjKpWRw6nnzCSnj4hSysvxYnU
 I5SBrgZKlsPnUeMwEvlQAJLswu5UU3TLHmaLWbtOxFaEGd5zVd
 FtIAU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a regulator is defined using DT and it has a single voltage the
regulator init always tries to apply this voltage. However it fails if
the regulator isn't settable because it is using an internal low level
function. To overcome this we now first query the regulator and only
set it if needed.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/regulator/core.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9a09f3c..7375997 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -844,13 +844,22 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 	/* do we need to apply the constraint voltage */
 	if (rdev->constraints->apply_uV &&
 	    rdev->constraints->min_uV == rdev->constraints->max_uV) {
-		ret = _regulator_do_set_voltage(rdev,
-						rdev->constraints->min_uV,
-						rdev->constraints->max_uV);
-		if (ret < 0) {
-			rdev_err(rdev, "failed to apply %duV constraint\n",
-				 rdev->constraints->min_uV);
-			return ret;
+		int current_uV = _regulator_get_voltage(rdev);
+		if (current_uV < 0) {
+			rdev_err(rdev, "failed to get the current voltage\n");
+			return current_uV;
+		}
+		if (current_uV < rdev->constraints->min_uV ||
+		    current_uV > rdev->constraints->max_uV) {
+			ret = _regulator_do_set_voltage(
+				rdev, rdev->constraints->min_uV,
+				rdev->constraints->max_uV);
+			if (ret < 0) {
+				rdev_err(rdev,
+					"failed to apply %duV constraint\n",
+					rdev->constraints->min_uV);
+				return ret;
+			}
 		}
 	}
 
-- 
1.9.3

