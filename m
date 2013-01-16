Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab3APQa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:30:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36434 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583Ab3APQHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:18 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nikolay Aleksandrov <nikolay@redhat.com>, Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 153/222] bonding: fix race condition in bonding_store_slaves_active
Date: Wed, 16 Jan 2013 13:55:53 -0200
Message-Id: <1358351822-7675-154-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "nikolay@redhat.com" <nikolay@redhat.com>

commit e196c0e579902f42cf72414461fb034e5a1ffbf7 upstream.

Race between bonding_store_slaves_active() and slave manipulation
 functions. The bond_for_each_slave use in bonding_store_slaves_active()
 is not protected by any synchronization mechanism.
 NULL pointer dereference is easy to reach.
 Fixed by acquiring the bond->lock for the slave walk.

 v2: Make description text < 75 columns

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/bonding/bond_sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 485bedb..9ea29aa 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -1582,6 +1582,7 @@ static ssize_t bonding_store_slaves_active(struct device *d,
 		goto out;
 	}
 
+	read_lock(&bond->lock);
 	bond_for_each_slave(bond, slave, i) {
 		if (!bond_is_active_slave(slave)) {
 			if (new_value)
@@ -1590,6 +1591,7 @@ static ssize_t bonding_store_slaves_active(struct device *d,
 				slave->inactive = 1;
 		}
 	}
+	read_unlock(&bond->lock);
 out:
 	return ret;
 }
-- 
1.7.9.5

