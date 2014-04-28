Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaD1BdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42822 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "=?UTF-8?q?Peter=20Bostr=C3=B6m?=" <peter.bostrom@netrounds.com>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.273722047@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 04/94] vlan: Set correct source MAC address with TX
 VLAN  offload enabled
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Boström <peter.bostrom@netrounds.com>

[ Upstream commit dd38743b4cc2f86be250eaf156cf113ba3dd531a ]

With TX VLAN offload enabled the source MAC address for frames sent using the
VLAN interface is currently set to the address of the real interface. This is
wrong since the VLAN interface may be configured with a different address.

The bug was introduced in commit 2205369a314e12fcec4781cc73ac9c08fc2b47de
("vlan: Fix header ops passthru when doing TX VLAN offload.").

This patch sets the source address before calling the create function of the
real interface.

Signed-off-by: Peter Boström <peter.bostrom@netrounds.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/8021q/vlan_dev.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -529,6 +529,9 @@ static int vlan_passthru_hard_header(str
 {
 	struct net_device *real_dev = vlan_dev_info(dev)->real_dev;
 
+	if (saddr == NULL)
+		saddr = dev->dev_addr;
+
 	return dev_hard_header(skb, real_dev, type, daddr, saddr, len);
 }
 

