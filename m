Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbaDKQsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:48:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759561AbaDKQI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 27/65] bonding: set correct vlan id for alb xmit path
Date: Fri, 11 Apr 2014 09:10:59 -0700
Message-Id: <20140411161001.465894873@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: dingtianhong <dingtianhong@huawei.com>

[ Upstream commit fb00bc2e6cd2046282ba4b03f4fe682aee70b2f8 ]

The commit d3ab3ffd1d728d7ee77340e7e7e2c7cfe6a4013e
(bonding: use rlb_client_info->vlan_id instead of ->tag)
remove the rlb_client_info->tag, but occur some issues,
The vlan_get_tag() will return 0 for success and -EINVAL for
error, so the client_info->vlan_id always be set to 0 if the
vlan_get_tag return 0 for success, so the client_info would
never get a correct vlan id.

We should only set the vlan id to 0 when the vlan_get_tag return error.

Fixes: d3ab3ffd1d7 (bonding: use rlb_client_info->vlan_id instead of ->tag)

CC: Ding Tianhong <dingtianhong@huawei.com>
CC: Jay Vosburgh <fubar@us.ibm.com>
CC: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Acked-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_alb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -731,7 +731,7 @@ static struct slave *rlb_choose_channel(
 			client_info->ntt = 0;
 		}
 
-		if (!vlan_get_tag(skb, &client_info->vlan_id))
+		if (vlan_get_tag(skb, &client_info->vlan_id))
 			client_info->vlan_id = 0;
 
 		if (!client_info->assigned) {


