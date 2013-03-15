Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3COIs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:48:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57683 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab3COIs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:48:27 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: vinod.koul@intel.com
Cc: linaro-kernel@lists.linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] DMA: OF: Check properties value before running be32_to_cpup() on it
Date: Fri, 15 Mar 2013 14:18:20 +0530
Message-Id: <0a0ef15d47393fe9d24a395c38068b871f913776.1363337257.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 15 Mar 2013 08:48:22.0646 (UTC) FILETIME=[D993A160:01CE2159]
X-MC-Unique: 113031508482408001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2F8mWiS003172

In of_dma_controller_register() routine we are calling of_get_property() as an
parameter to be32_to_cpup(). In case the property doesn't exist we will get a
crash.

This patch changes this code to check if we got a valid property first and then
runs be32_to_cpup() on it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

My mails are broken, i have pushed this patch here:

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/dma-of-fix

 drivers/dma/of-dma.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 69d04d2..09c7ad1 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -93,6 +93,7 @@ int of_dma_controller_register(struct device_node *np,
 {
 	struct of_dma	*ofdma;
 	int		nbcells;
+	const __be32	*prop;
 
 	if (!np || !of_dma_xlate) {
 		pr_err("%s: not enough information provided\n", __func__);
@@ -103,8 +104,11 @@ int of_dma_controller_register(struct device_node *np,
 	if (!ofdma)
 		return -ENOMEM;
 
-	nbcells = be32_to_cpup(of_get_property(np, "#dma-cells", NULL));
-	if (!nbcells) {
+	prop = of_get_property(np, "#dma-cells", NULL);
+	if (prop)
+		nbcells = be32_to_cpup(prop);
+
+	if (!prop || !nbcells) {
 		pr_err("%s: #dma-cells property is missing or invalid\n",
 		       __func__);
 		kfree(ofdma);
-- 
1.7.12.rc2.18.g61b472e


