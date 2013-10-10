Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab3JJQK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:10:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52585 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab3JJPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 006/104] bonding: modify only neigh_parms owned by us
Date: Thu, 10 Oct 2013 08:40:54 -0700
Message-Id: <1381419752-29733-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 9918d5bf329d0dc5bb2d9d293bcb772bdb626e65 ]

Otherwise, on neighbour creation, bond_neigh_init() will be called with a
foreign netdev.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/bonding/bond_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 045dc53..fe48472 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3810,11 +3810,17 @@ static int bond_neigh_init(struct neighbour *n)
  * The bonding ndo_neigh_setup is called at init time beofre any
  * slave exists. So we must declare proxy setup function which will
  * be used at run time to resolve the actual slave neigh param setup.
+ *
+ * It's also called by master devices (such as vlans) to setup their
+ * underlying devices. In that case - do nothing, we're already set up from
+ * our init.
  */
 static int bond_neigh_setup(struct net_device *dev,
 			    struct neigh_parms *parms)
 {
-	parms->neigh_setup   = bond_neigh_init;
+	/* modify only our neigh_parms */
+	if (parms->dev == dev)
+		parms->neigh_setup = bond_neigh_init;
 
 	return 0;
 }
-- 
1.8.1.2

