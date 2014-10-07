Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaJGNYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:24:05 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:60400 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753750AbaJGNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:23:48 -0400
From: Seraphin Bonnaffe <seraphin.bonnaffe@st.com>
To: <b29396@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lee.jones@linaro.org>, <maxime.coquelin@st.com>
Cc: <sameo@linux.intel.com>, <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <arnd@arndb.de>, <seraphin.bonnaffe@st.com>
Subject: [RFC PATCH 2/2] mfd: syscon: specify rd_table and wr_table from DT
Date: Tue, 7 Oct 2014 15:22:28 +0200
Message-ID: <1412688148-20835-3-git-send-email-seraphin.bonnaffe@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412688148-20835-1-git-send-email-seraphin.bonnaffe@st.com>
References: <54244655.1090801@st.com>
 <1412688148-20835-1-git-send-email-seraphin.bonnaffe@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-07_05:2014-10-07,2014-10-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscon driver is based on regmap, which offers the possibility to
declare registers as readable/writable or not, thanks to rd_table and
wr_table.

This patch takes register map's holes description from DT, and fills in
the rd_table and wr_table of the corresponding syson instance accordingly.

Signed-off-by: Seraphin Bonnaffe <seraphin.bonnaffe@st.com>
---
 drivers/mfd/syscon.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index ca15878..2bfb45d 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -125,9 +125,15 @@ static int syscon_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct syscon_platform_data *pdata = dev_get_platdata(dev);
+	struct device_node *np = dev->of_node;
+	struct regmap_access_table *syscon_rw_table;
+	struct regmap_range *holes;
 	struct syscon *syscon;
 	struct resource *res;
 	void __iomem *base;
+	const __be32 *hole_prop;
+	u32 min, max, size;
+	u32 i, hlen, ngaps;
 
 	syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
 	if (!syscon)
@@ -141,6 +147,35 @@ static int syscon_probe(struct platform_device *pdev)
 	if (!base)
 		return -ENOMEM;
 
+	hole_prop = of_get_property(np, "holes", &hlen);
+	if (hole_prop) {
+		hlen /= sizeof(*hole_prop);
+		ngaps = hlen / 2;
+
+		holes =  devm_kzalloc(dev, ngaps * sizeof(*holes), GFP_KERNEL);
+		if (!holes)
+			return -ENOMEM;
+
+		for (i = 0; i < ngaps; i++) {
+			min = (u32)of_read_number(&hole_prop[i * 2], 1);
+			size = (u32)of_read_number(&hole_prop[i * 2 + 1], 1);
+			max = min + size - 1;
+
+			holes[i].range_min = min;
+			holes[i].range_max = max;
+		}
+		syscon_rw_table = devm_kzalloc(dev, sizeof(*syscon_rw_table),
+					       GFP_KERNEL);
+		if (!syscon_rw_table)
+			return -ENOMEM;
+
+		syscon_rw_table->no_ranges = holes;
+		syscon_rw_table->n_no_ranges = ngaps;
+
+		syscon_regmap_config.rd_table = syscon_rw_table;
+		syscon_regmap_config.wr_table = syscon_rw_table;
+	}
+
 	syscon_regmap_config.max_register = res->end - res->start - 3;
 	if (pdata)
 		syscon_regmap_config.name = pdata->label;
-- 
1.9.1

