Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaAIGmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 01:42:31 -0500
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:57245 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751183AbaAIGm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 01:42:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2904:3138:3139:3140:3141:3142:3353:3865:3866:3867:3870:3871:3872:4385:4419:4605:5007:7652:8603:9592:10004:10400:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13138:13231,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bone88_6ccb9419d2c46
X-Filterd-Recvd-Size: 3489
Message-ID: <1389249745.24222.20.camel@joe-AO722>
Subject: [PATCH net-next] qlcnic: Convert vmalloc/memset to kcalloc
From: Joe Perches <joe@perches.com>
To: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
Cc: linux-driver <linux-driver@qlogic.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 08 Jan 2014 22:42:25 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc is a limited resource.  Don't use it unnecessarily.

It seems this allocation should work with kcalloc.

Remove unnecessary memset(,0,) of buf as it's completely
overwritten as the previously only unset field in
struct qlcnic_pci_func_cfg is now set to 0.

Use kfree instead of vfree.
Use ETH_ALEN instead of 6.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h       |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c | 16 ++++++----------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
index 35d4876..8d7aa4c 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
@@ -1267,7 +1267,7 @@ struct qlcnic_pci_func_cfg {
 	u16	port_num;
 	u8	pci_func;
 	u8	func_state;
-	u8	def_mac_addr[6];
+	u8	def_mac_addr[ETH_ALEN];
 };
 
 struct qlcnic_npar_func_cfg {
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
index b529667..c9b704d 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/interrupt.h>
 
 #include "qlcnic.h"
@@ -927,38 +926,35 @@ static ssize_t qlcnic_sysfs_read_pci_config(struct file *file,
 	u32 pci_func_count = qlcnic_get_pci_func_count(adapter);
 	struct qlcnic_pci_func_cfg *pci_cfg;
 	struct qlcnic_pci_info *pci_info;
-	size_t pci_info_sz, pci_cfg_sz;
+	size_t pci_cfg_sz;
 	int i, ret;
 
 	pci_cfg_sz = pci_func_count * sizeof(*pci_cfg);
 	if (size != pci_cfg_sz)
 		return QL_STATUS_INVALID_PARAM;
 
-	pci_info_sz = pci_func_count * sizeof(*pci_info);
-	pci_info = vmalloc(pci_info_sz);
+	pci_info = kcalloc(pci_func_count, sizeof(*pci_info), GFP_KERNEL);
 	if (!pci_info)
 		return -ENOMEM;
 
-	memset(pci_info, 0, pci_info_sz);
-	memset(buf, 0, pci_cfg_sz);
-	pci_cfg = (struct qlcnic_pci_func_cfg *)buf;
-
 	ret = qlcnic_get_pci_info(adapter, pci_info);
 	if (ret) {
-		vfree(pci_info);
+		kfree(pci_info);
 		return ret;
 	}
 
+	pci_cfg = (struct qlcnic_pci_func_cfg *)buf;
 	for (i = 0; i < pci_func_count; i++) {
 		pci_cfg[i].pci_func = pci_info[i].id;
 		pci_cfg[i].func_type = pci_info[i].type;
+		pci_cfg[i].func_state = 0;
 		pci_cfg[i].port_num = pci_info[i].default_port;
 		pci_cfg[i].min_bw = pci_info[i].tx_min_bw;
 		pci_cfg[i].max_bw = pci_info[i].tx_max_bw;
 		memcpy(&pci_cfg[i].def_mac_addr, &pci_info[i].mac, ETH_ALEN);
 	}
 
-	vfree(pci_info);
+	kfree(pci_info);
 	return size;
 }
 


