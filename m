Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3GAUKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:10:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab3GAUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 05/13] dlci: acquire rtnl_lock before calling __dev_get_by_name()
Date: Mon,  1 Jul 2013 13:10:24 -0700
Message-Id: <20130701200523.736024242@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200523.096669485@linuxfoundation.org>
References: <20130701200523.096669485@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zefan Li <lizefan@huawei.com>

commit 11eb2645cbf38a08ae491bf6c602eea900ec0bb5 upstream.

Otherwise the net device returned can be freed at anytime.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wan/dlci.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -385,20 +385,24 @@ static int dlci_del(struct dlci_add *dlc
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
@@ -407,8 +411,8 @@ static int dlci_del(struct dlci_add *dlc
 
 		dev_put(slave);
 	}
+out:
 	rtnl_unlock();
-
 	return err;
 }
 


