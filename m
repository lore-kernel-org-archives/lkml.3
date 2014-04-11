Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbaDKQyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:54:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422761AbaDKQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Peter=20Bostr=C3=B6m?= <peter.bostrom@netrounds.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 17/65] vlan: Set correct source MAC address with TX VLAN offload enabled
Date: Fri, 11 Apr 2014 09:10:49 -0700
Message-Id: <20140411161000.040236268@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan_dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -538,6 +538,9 @@ static int vlan_passthru_hard_header(str
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
 	struct net_device *real_dev = vlan->real_dev;
 
+	if (saddr == NULL)
+		saddr = dev->dev_addr;
+
 	return dev_hard_header(skb, real_dev, type, daddr, saddr, len);
 }
 


