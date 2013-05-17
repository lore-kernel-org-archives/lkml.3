Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab3EQWZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:25:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab3EQVhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Robert Richter <robert.richter@calxeda.com>
Subject: [ 012/102] DMA: OF: Check properties value before running be32_to_cpup() on it
Date: Fri, 17 May 2013 14:35:27 -0700
Message-Id: <20130517213245.613466537@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 9a188eb126aa7bf27077ee46fcb914898d6fc281 upstream.

In of_dma_controller_register() routine we are calling of_get_property() as an
parameter to be32_to_cpup(). In case the property doesn't exist we will get a
crash.

This patch changes this code to check if we got a valid property first and then
runs be32_to_cpup() on it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Robert Richter <robert.richter@calxeda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/of-dma.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -93,6 +93,7 @@ int of_dma_controller_register(struct de
 {
 	struct of_dma	*ofdma;
 	int		nbcells;
+	const __be32	*prop;
 
 	if (!np || !of_dma_xlate) {
 		pr_err("%s: not enough information provided\n", __func__);
@@ -103,8 +104,11 @@ int of_dma_controller_register(struct de
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


