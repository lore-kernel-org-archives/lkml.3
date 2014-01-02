Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaABR2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:28:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40208 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaABRFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:05:32 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@redhat.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 12/91] bonding: fix two race conditions in bond_store_updelay/downdelay
Date: Thu,  2 Jan 2014 09:03:47 -0800
Message-Id: <1388682306-30859-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@redhat.com>

[ Upstream commit b869ccfab1e324507fa3596e3e1308444fb68227 ]

This patch fixes two race conditions between bond_store_updelay/downdelay
and bond_store_miimon which could lead to division by zero as miimon can
be set to 0 while either updelay/downdelay are being set and thus miss the
zero check in the beginning, the zero div happens because updelay/downdelay
are stored as new_value / bond->params.miimon. Use rtnl to synchronize with
miimon setting.

CC: Jay Vosburgh <fubar@us.ibm.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Acked-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/bonding/bond_sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index da7b379..f0a65ed 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -693,6 +693,8 @@ static ssize_t bonding_store_downdelay(struct device *d,
 	int new_value, ret = count;
 	struct bonding *bond = to_bond(d);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (!(bond->params.miimon)) {
 		pr_err("%s: Unable to set down delay as MII monitoring is disabled\n",
 		       bond->dev->name);
@@ -726,6 +728,7 @@ static ssize_t bonding_store_downdelay(struct device *d,
 	}
 
 out:
+	rtnl_unlock();
 	return ret;
 }
 static DEVICE_ATTR(downdelay, S_IRUGO | S_IWUSR,
@@ -748,6 +751,8 @@ static ssize_t bonding_store_updelay(struct device *d,
 	int new_value, ret = count;
 	struct bonding *bond = to_bond(d);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (!(bond->params.miimon)) {
 		pr_err("%s: Unable to set up delay as MII monitoring is disabled\n",
 		       bond->dev->name);
@@ -781,6 +786,7 @@ static ssize_t bonding_store_updelay(struct device *d,
 	}
 
 out:
+	rtnl_unlock();
 	return ret;
 }
 static DEVICE_ATTR(updelay, S_IRUGO | S_IWUSR,
-- 
1.8.3.2

