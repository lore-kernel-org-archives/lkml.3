Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaDVUPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:15:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36106 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbaDVUPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Peter=20Bostr=C3=B6m?= <peter.bostrom@netrounds.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 006/133] vlan: Set correct source MAC address with TX VLAN offload enabled
Date: Tue, 22 Apr 2014 13:12:24 -0700
Message-Id: <1398197671-12786-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Peter=20Bostr=C3=B6m?= <peter.bostrom@netrounds.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/8021q/vlan_dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index bd0ba90..4c87317 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -546,6 +546,9 @@ static int vlan_passthru_hard_header(struct sk_buff *skb, struct net_device *dev
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
 	struct net_device *real_dev = vlan->real_dev;
 
+	if (saddr == NULL)
+		saddr = dev->dev_addr;
+
 	return dev_hard_header(skb, real_dev, type, daddr, saddr, len);
 }
 
-- 
1.9.1

