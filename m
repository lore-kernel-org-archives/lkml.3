Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816Ab3LFWCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:02:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759517Ab3LFVyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:54:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 06/32] bonding: fix two race conditions in bond_store_updelay/downdelay
Date: Fri,  6 Dec 2013 13:52:16 -0800
Message-Id: <20131206214957.434926719@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214956.830407026@linuxfoundation.org>
References: <20131206214956.830407026@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@redhat.com>

[ Upstream commit b869ccfab1e324507fa3596e3e1308444fb68227 ]

This patch fixes two race conditions between bond_store_updelay/downdelay
and bond_store_miimon which could lead to division by zero as miimon can
be set to 0 while either updelay/downdelay are being set and thus miss the
zero check in the beginning, the zero div happens because updelay/downdelay
are stored as new_value / bond->params.miimon. Use rtnl to synchronize with
miimon setting.

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
CC: Jay Vosburgh <fubar@us.ibm.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_sysfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -693,6 +693,8 @@ static ssize_t bonding_store_downdelay(s
 	int new_value, ret = count;
 	struct bonding *bond = to_bond(d);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (!(bond->params.miimon)) {
 		pr_err("%s: Unable to set down delay as MII monitoring is disabled\n",
 		       bond->dev->name);
@@ -726,6 +728,7 @@ static ssize_t bonding_store_downdelay(s
 	}
 
 out:
+	rtnl_unlock();
 	return ret;
 }
 static DEVICE_ATTR(downdelay, S_IRUGO | S_IWUSR,
@@ -748,6 +751,8 @@ static ssize_t bonding_store_updelay(str
 	int new_value, ret = count;
 	struct bonding *bond = to_bond(d);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (!(bond->params.miimon)) {
 		pr_err("%s: Unable to set up delay as MII monitoring is disabled\n",
 		       bond->dev->name);
@@ -781,6 +786,7 @@ static ssize_t bonding_store_updelay(str
 	}
 
 out:
+	rtnl_unlock();
 	return ret;
 }
 static DEVICE_ATTR(updelay, S_IRUGO | S_IWUSR,


