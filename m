Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaESLMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:12:48 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:53525 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaESLMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:12:46 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH] regulator: core: Fix the init of DT defined fixed regulators
Date: Mon, 19 May 2014 13:12:34 +0200
Message-Id: <1400497954-1012-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.9.3
X-Provags-ID: V02:K0:KNiMHyo3Dz6SjDyVxbVy2xUJIvA+6BgAmSPfcELvDnh
 DAXwKf2/GAgYsa6enArcV65+t1g/UxWBtHXURT+oF6xAeHYbhQ
 PD+hG0GwHWzKCn7PKk48arOzDd5dgj4Y64aI4rbZVzu0a/LoiL
 ndCrEZford69CAMxcvxvk3wF4frCr5hvX3P5kMoWHGaV7QooLq
 yqz1Suvzxo4UylMvx8GMBCdkRlFoKKb4agvodUZ5szRb1PhLXx
 NmYuAnFgXUFkWS1YJCwsLF7lTPGbDMAYML+T52YwjaXC9N7e9s
 TXvHD7dvcnb6dTZ/p2hD2XrtNDU8nm2FYzChUiYLXOElKW9RE3
 qI+TNWUaxcyBWPDdyvWiJoVsy7/7sd4q/5RFO8YdlmQDvQBiFJ
 MUq2X69xRgjxSTBL+eKgOTAKNMoQz/5MBWSaC5IYmkWSWXtvJ8
 FDsn5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a regulator is defined using DT and it has a single voltage the
regulator init always tries to apply this voltage. However this fails
if the regulator isn't settable. So skip this step if the regulator
doesn't provides any set method.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/regulator/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9a09f3c..e57450f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -843,7 +843,9 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 	/* do we need to apply the constraint voltage */
 	if (rdev->constraints->apply_uV &&
-	    rdev->constraints->min_uV == rdev->constraints->max_uV) {
+	    rdev->constraints->min_uV == rdev->constraints->max_uV &&
+	    (rdev->desc->ops->set_voltage ||
+	     rdev->desc->ops->set_voltage_sel)) {
 		ret = _regulator_do_set_voltage(rdev,
 						rdev->constraints->min_uV,
 						rdev->constraints->max_uV);
-- 
1.9.3

