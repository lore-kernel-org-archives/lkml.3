Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3CRVIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:08:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab3CRVIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:08:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 46/48] rtnl: fix info leak on RTM_GETLINK request for VF devices
Date: Mon, 18 Mar 2013 14:08:54 -0700
Message-Id: <20130318210813.498678407@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 84d73cd3fb142bf1298a8c13fd4ca50fd2432372 ]

Initialize the mac address buffer with 0 as the driver specific function
will probably not fill the whole buffer. In fact, all in-kernel drivers
fill only ETH_ALEN of the MAX_ADDR_LEN bytes, i.e. 6 of the 32 possible
bytes. Therefore we currently leak 26 bytes of stack memory to userland
via the netlink interface.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -975,6 +975,7 @@ static int rtnl_fill_ifinfo(struct sk_bu
 			 * report anything.
 			 */
 			ivi.spoofchk = -1;
+			memset(ivi.mac, 0, sizeof(ivi.mac));
 			if (dev->netdev_ops->ndo_get_vf_config(dev, i, &ivi))
 				break;
 			vf_mac.vf =


