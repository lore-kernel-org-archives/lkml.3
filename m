Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaHMLfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:35:05 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53375 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaHMLfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:35:00 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, grant.likely@linaro.org,
        khilman@linaro.org, haojian.zhuang@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Guodong Xu <guodong.xu@linaro.org>
Subject: [PATCH v5 1/7] regulator: core: add const qualifier to ops in struct regulator_desc
Date: Wed, 13 Aug 2014 19:33:38 +0800
Message-Id: <1407929624-8737-2-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407929624-8737-1-git-send-email-guodong.xu@linaro.org>
References: <1407929624-8737-1-git-send-email-guodong.xu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct regulator_ops *ops is a member in struct regulator_desc, which gets
its value from individual regulator driver upon regulator_register() and
is used by regulator core APIs. It's not allowed for regulator core to
modify any of these callbacks in *ops. Add 'const' qualifier to enforce that.

Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
---
 drivers/regulator/core.c         | 24 ++++++++++++------------
 include/linux/regulator/driver.h |  2 +-
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4c1f999..eb6f172 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -838,7 +838,7 @@ static void print_constraints(struct regulator_dev *rdev)
 static int machine_constraints_voltage(struct regulator_dev *rdev,
 	struct regulation_constraints *constraints)
 {
-	struct regulator_ops *ops = rdev->desc->ops;
+	const struct regulator_ops *ops = rdev->desc->ops;
 	int ret;
 
 	/* do we need to apply the constraint voltage */
@@ -935,7 +935,7 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 static int machine_constraints_current(struct regulator_dev *rdev,
 	struct regulation_constraints *constraints)
 {
-	struct regulator_ops *ops = rdev->desc->ops;
+	const struct regulator_ops *ops = rdev->desc->ops;
 	int ret;
 
 	if (!constraints->min_uA && !constraints->max_uA)
@@ -979,7 +979,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	const struct regulation_constraints *constraints)
 {
 	int ret = 0;
-	struct regulator_ops *ops = rdev->desc->ops;
+	const struct regulator_ops *ops = rdev->desc->ops;
 
 	if (constraints)
 		rdev->constraints = kmemdup(constraints, sizeof(*constraints),
@@ -2196,9 +2196,9 @@ EXPORT_SYMBOL_GPL(regulator_count_voltages);
  */
 int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 {
-	struct regulator_dev	*rdev = regulator->rdev;
-	struct regulator_ops	*ops = rdev->desc->ops;
-	int			ret;
+	struct regulator_dev *rdev = regulator->rdev;
+	const struct regulator_ops *ops = rdev->desc->ops;
+	int ret;
 
 	if (rdev->desc->fixed_uV && rdev->desc->n_voltages == 1 && !selector)
 		return rdev->desc->fixed_uV;
@@ -2484,8 +2484,8 @@ EXPORT_SYMBOL_GPL(regulator_set_voltage);
 int regulator_set_voltage_time(struct regulator *regulator,
 			       int old_uV, int new_uV)
 {
-	struct regulator_dev	*rdev = regulator->rdev;
-	struct regulator_ops	*ops = rdev->desc->ops;
+	struct regulator_dev *rdev = regulator->rdev;
+	const struct regulator_ops *ops = rdev->desc->ops;
 	int old_sel = -1;
 	int new_sel = -1;
 	int voltage;
@@ -3246,9 +3246,9 @@ EXPORT_SYMBOL_GPL(regulator_mode_to_status);
  */
 static int add_regulator_attributes(struct regulator_dev *rdev)
 {
-	struct device		*dev = &rdev->dev;
-	struct regulator_ops	*ops = rdev->desc->ops;
-	int			status = 0;
+	struct device *dev = &rdev->dev;
+	const struct regulator_ops *ops = rdev->desc->ops;
+	int status = 0;
 
 	/* some attributes need specific methods to be displayed */
 	if ((ops->get_voltage && ops->get_voltage(rdev) >= 0) ||
@@ -3815,7 +3815,7 @@ core_initcall(regulator_init);
 static int __init regulator_init_complete(void)
 {
 	struct regulator_dev *rdev;
-	struct regulator_ops *ops;
+	const struct regulator_ops *ops;
 	struct regulation_constraints *c;
 	int enabled, ret;
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index bbe03a1..4b62813 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -245,7 +245,7 @@ struct regulator_desc {
 	int id;
 	bool continuous_voltage_range;
 	unsigned n_voltages;
-	struct regulator_ops *ops;
+	const struct regulator_ops *ops;
 	int irq;
 	enum regulator_type type;
 	struct module *owner;
-- 
1.9.1

