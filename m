Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3ILSWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:22:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILR7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Asbjoern Sloth Toennesen <ast@fiberby.net>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/46] rtnetlink: rtnl_bridge_getlink: Call nlmsg_find_attr() with ifinfomsg header
Date: Thu, 12 Sep 2013 10:58:29 -0700
Message-Id: <20130912175723.015181731@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjoern Sloth Toennesen <ast@fiberby.net>

[ Upstream commit 3e805ad288c524bb65aad3f1e004402223d3d504 ]

Fix the iproute2 command `bridge vlan show`, after switching from
rtgenmsg to ifinfomsg.

Let's start with a little history:

Feb 20:   Vlad Yasevich got his VLAN-aware bridge patchset included in
          the 3.9 merge window.
          In the kernel commit 6cbdceeb, he added attribute support to
          bridge GETLINK requests sent with rtgenmsg.

Mar 6th:  Vlad got this iproute2 reference implementation of the bridge
          vlan netlink interface accepted (iproute2 9eff0e5c)

Apr 25th: iproute2 switched from using rtgenmsg to ifinfomsg (63338dca)
          http://patchwork.ozlabs.org/patch/239602/
          http://marc.info/?t=136680900700007

Apr 28th: Linus released 3.9

Apr 30th: Stephen released iproute2 3.9.0

The `bridge vlan show` command haven't been working since the switch to
ifinfomsg, or in a released version of iproute2. Since the kernel side
only supports rtgenmsg, which iproute2 switched away from just prior to
the iproute2 3.9.0 release.

I haven't been able to find any documentation, about neither rtgenmsg
nor ifinfomsg, and in which situation to use which, but kernel commit
88c5b5ce seams to suggest that ifinfomsg should be used.

Fixing this in kernel will break compatibility, but I doubt that anybody
have been using it due to this bug in the user space reference
implementation, at least not without noticing this bug. That said the
functionality is still fully functional in 3.9, when reversing iproute2
commit 63338dca.

This could also be fixed in iproute2, but thats an ugly patch that would
reintroduce rtgenmsg in iproute2, and from searching in netdev it seams
like rtgenmsg usage is discouraged. I'm assuming that the only reason
that Vlad implemented the kernel side to use rtgenmsg, was because
iproute2 was using it at the time.

Signed-off-by: Asbjoern Sloth Toennesen <ast@fiberby.net>
Reviewed-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2374,7 +2374,7 @@ static int rtnl_bridge_getlink(struct sk
 	struct nlattr *extfilt;
 	u32 filter_mask = 0;
 
-	extfilt = nlmsg_find_attr(cb->nlh, sizeof(struct rtgenmsg),
+	extfilt = nlmsg_find_attr(cb->nlh, sizeof(struct ifinfomsg),
 				  IFLA_EXT_MASK);
 	if (extfilt)
 		filter_mask = nla_get_u32(extfilt);


