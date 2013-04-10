Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084Ab3DJMyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:54:31 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52800 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934484Ab3DJMya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:54:30 -0400
Message-ID: <1365598464.24689.1.camel@phoenix>
Subject: [RFT][PATCH 1/3] regulator: ab8500-ext: Don't allow set idle mode
 if info->cfg->hwreq is set
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 20:54:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator always on with high power mode if info->cfg->hwreq is set.

If we allow set idle mode when info->cfg->hwreq is set, get_mode() returns
REGULATOR_MODE_IDLE but the regulator actually is in REGULATOR_MODE_NORMAL mode.
This patch avoid inconsistent status return by get_mode().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500-ext.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 9aee21c..f0a1bbf 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -192,6 +192,10 @@ static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
 		info->update_val = info->update_val_hp;
 		break;
 	case REGULATOR_MODE_IDLE:
+		/* Always on with high power mode if info->cfg->hwreq is set */
+		if (info->cfg && info->cfg->hwreq)
+			return -EINVAL;
+
 		info->update_val = info->update_val_lp;
 		break;
 
-- 
1.7.10.4



