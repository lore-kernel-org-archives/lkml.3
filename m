Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbaBDVC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:02:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442AbaBDVCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Engelmayer <cengelma@gmx.at>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 076/104] ieee802154: Fix memory leak in ieee802154_add_iface()
Date: Tue,  4 Feb 2014 13:02:19 -0800
Message-Id: <20140204210224.863006715@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Engelmayer <cengelma@gmx.at>

[ Upstream commit 267d29a69c6af39445f36102a832b25ed483f299 ]

Fix a memory leak in the ieee802154_add_iface() error handling path.
Detected by Coverity: CID 710490.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl-phy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ieee802154/nl-phy.c
+++ b/net/ieee802154/nl-phy.c
@@ -224,8 +224,10 @@ static int ieee802154_add_iface(struct s
 
 	if (info->attrs[IEEE802154_ATTR_DEV_TYPE]) {
 		type = nla_get_u8(info->attrs[IEEE802154_ATTR_DEV_TYPE]);
-		if (type >= __IEEE802154_DEV_MAX)
-			return -EINVAL;
+		if (type >= __IEEE802154_DEV_MAX) {
+			rc = -EINVAL;
+			goto nla_put_failure;
+		}
 	}
 
 	dev = phy->add_iface(phy, devname, type);


