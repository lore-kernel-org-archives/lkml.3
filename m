Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3KGDOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:14:41 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39857 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984Ab3KGDN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:13:57 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>,
        <kernel@pengutronix.de>, <baohua@kernel.org>, <dinguyen@altera.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v5 2/3] bus: mvebu: add missing of_node_put() to fix reference leak
Date: Thu, 7 Nov 2013 11:08:37 +0800
Message-ID: <1383793720-4643-5-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383793720-4643-1-git-send-email-jszhang@marvell.com>
References: <1383793720-4643-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_01:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060260
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to properly decrement the refcount when we are
done using a given node.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 drivers/bus/mvebu-mbus.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mvebu-mbus.c b/drivers/bus/mvebu-mbus.c
index 33c6947..20da90f 100644
--- a/drivers/bus/mvebu-mbus.c
+++ b/drivers/bus/mvebu-mbus.c
@@ -837,6 +837,7 @@ int __init mvebu_mbus_init(const char *soc, phys_addr_t mbuswins_phys_base,
 {
 	struct mvebu_mbus_state *mbus = &mbus_state;
 	const struct of_device_id *of_id;
+	struct device_node *np;
 	int win;
 
 	for (of_id = of_mvebu_mbus_ids; of_id->compatible; of_id++)
@@ -860,8 +861,11 @@ int __init mvebu_mbus_init(const char *soc, phys_addr_t mbuswins_phys_base,
 		return -ENOMEM;
 	}
 
-	if (of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric"))
+	np = of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric");
+	if (np) {
 		mbus->hw_io_coherency = 1;
+		of_node_put(np);
+	}
 
 	for (win = 0; win < mbus->soc->num_wins; win++)
 		mvebu_mbus_disable_window(mbus, win);
-- 
1.8.4.rc3

