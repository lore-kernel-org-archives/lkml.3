Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab3JKUMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:12:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab3JKTlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 029/135] vxlan: Avoid creating fdb entry with NULL destination
Date: Fri, 11 Oct 2013 12:38:30 -0700
Message-Id: <20131011193948.399277401@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sridhar Samudrala <sri@us.ibm.com>

[ Upstream commit 2936b6ab455433a5ad14c7a1d2473afe1fa3faa7 ]

Commit afbd8bae9c798c5cdbe4439d3a50536b5438247c
   vxlan: add implicit fdb entry for default destination
creates an implicit fdb entry for default destination. This results
in an invalid fdb entry if default destination is not specified.
For ex:
  ip link add vxlan1 type vxlan id 100
creates the following fdb entry
  00:00:00:00:00:00 dev vxlan1 dst 0.0.0.0 self permanent

This patch fixes this issue by creating an fdb entry only if a
valid default destination is specified.

Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1767,15 +1767,17 @@ static int vxlan_newlink(struct net *net
 
 	SET_ETHTOOL_OPS(dev, &vxlan_ethtool_ops);
 
-	/* create an fdb entry for default destination */
-	err = vxlan_fdb_create(vxlan, all_zeros_mac,
-			       vxlan->default_dst.remote_ip,
-			       NUD_REACHABLE|NUD_PERMANENT,
-			       NLM_F_EXCL|NLM_F_CREATE,
-			       vxlan->dst_port, vxlan->default_dst.remote_vni,
-			       vxlan->default_dst.remote_ifindex, NTF_SELF);
-	if (err)
-		return err;
+	/* create an fdb entry for a valid default destination */
+	if (vxlan->default_dst.remote_ip != htonl(INADDR_ANY)) {
+		err = vxlan_fdb_create(vxlan, all_zeros_mac,
+				       vxlan->default_dst.remote_ip,
+				       NUD_REACHABLE|NUD_PERMANENT,
+				       NLM_F_EXCL|NLM_F_CREATE,
+				       vxlan->dst_port, vxlan->default_dst.remote_vni,
+				       vxlan->default_dst.remote_ifindex, NTF_SELF);
+		if (err)
+			return err;
+	}
 
 	err = register_netdevice(dev);
 	if (err) {


