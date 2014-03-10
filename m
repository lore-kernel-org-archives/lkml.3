Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaCJPRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:17:21 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:38586 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaCJPRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:17:19 -0400
Message-ID: <1394464635.27812.7.camel@peter-laptop>
Subject: [PATCH] vlan: Set correct source MAC address with TX VLAN offload
 enabled
From: Peter =?ISO-8859-1?Q?Bostr=F6m?= <peter.bostrom@netrounds.com>
To: kaber@trash.net
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2014 16:17:15 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With TX VLAN offload enabled the source MAC address for frames sent using the
VLAN interface is currently set to the address of the real interface. This is
wrong since the VLAN interface may be configured with a different address.

The bug was introduced in commit 2205369a314e12fcec4781cc73ac9c08fc2b47de
("vlan: Fix header ops passthru when doing TX VLAN offload.").

This patch sets the source address before calling the create function of the
real interface.

Signed-off-by: Peter Boström <peter.bostrom@netrounds.com>
---
 net/8021q/vlan_dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index de51c48..4b65aa4 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -538,6 +538,9 @@ static int vlan_passthru_hard_header(struct sk_buff *skb, struct net_device *dev
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
 	struct net_device *real_dev = vlan->real_dev;
 
+	if (saddr == NULL)
+		saddr = dev->dev_addr;
+
 	return dev_hard_header(skb, real_dev, type, daddr, saddr, len);
 }
 


