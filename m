Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3I3Ka3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:30:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43534 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab3I3KMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 041/104] bonding: modify only neigh_parms owned by us
Date: Mon, 30 Sep 2013 11:10:18 +0100
Message-Id: <1380535881-9239-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

commit 9918d5bf329d0dc5bb2d9d293bcb772bdb626e65 upstream.

Otherwise, on neighbour creation, bond_neigh_init() will be called with a
foreign netdev.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/bonding/bond_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1e1ae64..c7fd229c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3759,11 +3759,17 @@ static int bond_neigh_init(struct neighbour *n)
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
1.8.3.2

