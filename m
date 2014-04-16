Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaDPKtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:49:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51683 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbaDPKcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Peter=20Bostr=C3=B6m?= <peter.bostrom@netrounds.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 17/46] vlan: Set correct source MAC address with TX VLAN offload enabled
Date: Wed, 16 Apr 2014 11:31:33 +0100
Message-Id: <1397644322-13905-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Peter=20Bostr=C3=B6m?= <peter.bostrom@netrounds.com>

commit dd38743b4cc2f86be250eaf156cf113ba3dd531a upstream.

With TX VLAN offload enabled the source MAC address for frames sent using the
VLAN interface is currently set to the address of the real interface. This is
wrong since the VLAN interface may be configured with a different address.

The bug was introduced in commit 2205369a314e12fcec4781cc73ac9c08fc2b47de
("vlan: Fix header ops passthru when doing TX VLAN offload.").

This patch sets the source address before calling the create function of the
real interface.

Signed-off-by: Peter Boström <peter.bostrom@netrounds.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/8021q/vlan_dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 4af64af..48db858 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -557,6 +557,9 @@ static int vlan_passthru_hard_header(struct sk_buff *skb, struct net_device *dev
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
 	struct net_device *real_dev = vlan->real_dev;
 
+	if (saddr == NULL)
+		saddr = dev->dev_addr;
+
 	return dev_hard_header(skb, real_dev, type, daddr, saddr, len);
 }
 
-- 
1.9.1

