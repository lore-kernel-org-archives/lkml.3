Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab3HMQC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:02:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18888 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712Ab3HMP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:36 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0yPl6j-_S4YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=IePWN1iTp2sA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=5Pn3WvucamdcCeGSDr0A:9 a=hPjdaMEvmhQA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155830.665686473@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, "David S. Miller" <davem@davemloft.net>
Subject: [45/88] dlci: acquire rtnl_lock before calling __dev_get_by_name()
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0045-dlci-acquire-rtnl_lock-before-calling-__dev_get_by_n.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Zefan Li <lizefan@huawei.com>

[ Upstream commit 11eb2645cbf38a08ae491bf6c602eea900ec0bb5 ]

Otherwise the net device returned can be freed at anytime.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wan/dlci.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 147614e..1f6e053 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -385,20 +385,24 @@ static int dlci_del(struct dlci_add *dlci)
 	struct net_device	*master, *slave;
 	int			err;
 
+	rtnl_lock();
+
 	/* validate slave device */
 	master = __dev_get_by_name(&init_net, dlci->devname);
-	if (!master)
-		return -ENODEV;
+	if (!master) {
+		err = -ENODEV;
+		goto out;
+	}
 
 	if (netif_running(master)) {
-		return -EBUSY;
+		err = -EBUSY;
+		goto out;
 	}
 
 	dlp = netdev_priv(master);
 	slave = dlp->slave;
 	flp = netdev_priv(slave);
 
-	rtnl_lock();
 	err = (*flp->deassoc)(slave, master);
 	if (!err) {
 		list_del(&dlp->list);
@@ -407,8 +411,8 @@ static int dlci_del(struct dlci_add *dlci)
 
 		dev_put(slave);
 	}
+out:
 	rtnl_unlock();
-
 	return err;
 }
 
-- 
1.7.10.4


