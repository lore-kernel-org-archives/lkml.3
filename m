Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbbAXEBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 23:01:19 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:38331 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbbAXEBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 23:01:17 -0500
Message-ID: <1422072072.17456.1.camel@phoenix>
Subject: [PATCH] regulator: qcom_rpm: Don't update vreg->uV/mV if
 rpm_reg_write fails
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 24 Jan 2015 12:01:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure get_voltage return correct voltage if set_voltage fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/qcom_rpm-regulator.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
index edd0a17..f48b3de 100644
--- a/drivers/regulator/qcom_rpm-regulator.c
+++ b/drivers/regulator/qcom_rpm-regulator.c
@@ -228,9 +228,11 @@ static int rpm_reg_set_mV_sel(struct regulator_dev *rdev,
 		return uV;
 
 	mutex_lock(&vreg->lock);
-	vreg->uV = uV;
 	if (vreg->is_enabled)
-		ret = rpm_reg_write(vreg, req, vreg->uV / 1000);
+		ret = rpm_reg_write(vreg, req, uV / 1000);
+
+	if (!ret)
+		vreg->uV = uV;
 	mutex_unlock(&vreg->lock);
 
 	return ret;
@@ -253,9 +255,11 @@ static int rpm_reg_set_uV_sel(struct regulator_dev *rdev,
 		return uV;
 
 	mutex_lock(&vreg->lock);
-	vreg->uV = uV;
 	if (vreg->is_enabled)
-		ret = rpm_reg_write(vreg, req, vreg->uV);
+		ret = rpm_reg_write(vreg, req, uV);
+
+	if (!ret)
+		vreg->uV = uV;
 	mutex_unlock(&vreg->lock);
 
 	return ret;
-- 
1.9.1



