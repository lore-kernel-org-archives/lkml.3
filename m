Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3LLN2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:28:30 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12571 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3LLN20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:28:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Dec 2013 05:30:04 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <grant.likely@linaro.org>
CC: <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <swarren@nvidia.com>, <kerwinw@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, <david@gibson.dropbear.id.au>
Subject: [PATCH 1/2] of: add support for reading s32 property value
Date: Thu, 12 Dec 2013 18:54:52 +0530
Message-ID: <1386854693-10871-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_property_read_s32() to read the signed 32bit number
from dt property value. This supports to pass the -ve numbers
from dt. Use 2's complement method for represnting negative number
and passed as u32 from dts. When reading back the value, again
converted to 2's complement if msb shows as 1.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
CC: david@gibson.dropbear.id.au
CC: swarren@nvidia.com
---
We required to pass the -ve value from DT and after looking the discussion
http://www.mail-archive.com/linux-arm-msm@vger.kernel.org/msg05108.html
I created this patch.
I CCed to David and Stephen on this.


 include/linux/of.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 276c546..17c0327 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -601,6 +601,22 @@ static inline int of_property_read_u32(const struct device_node *np,
 	return of_property_read_u32_array(np, propname, out_value, 1);
 }
 
+static inline int of_property_read_s32(const struct device_node *np,
+				       const char *propname,
+				       s32 *out_value)
+{
+	u32 val;
+	int ret;
+
+	ret = of_property_read_u32(np, propname, &val);
+	if (ret < 0)
+		return ret;
+
+	/* 2's complement if MSB is 1 */
+	*out_value = (val & 0x80000000U) ? -((val ^ 0xFFFFFFFFU) + 1) : val;
+	return ret;
+}
+
 #define of_property_for_each_u32(np, propname, prop, p, u)	\
 	for (prop = of_find_property(np, propname, NULL),	\
 		p = of_prop_next_u32(prop, NULL, &u);		\
-- 
1.7.0.4

