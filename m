Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3ILRpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:45:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3ILRp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:45:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 04/23] bonding: modify only neigh_parms owned by us
Date: Thu, 12 Sep 2013 10:45:00 -0700
Message-Id: <20130912174452.254204057@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912174451.748805761@linuxfoundation.org>
References: <20130912174451.748805761@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 9918d5bf329d0dc5bb2d9d293bcb772bdb626e65 ]

Otherwise, on neighbour creation, bond_neigh_init() will be called with a
foreign netdev.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3750,11 +3750,17 @@ static int bond_neigh_init(struct neighb
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


