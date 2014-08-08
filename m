Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbaHHVuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:50:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933508AbaHHVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 3.15 02/26] xfrm: Fix refcount imbalance in xfrm_lookup
Date: Fri,  8 Aug 2014 14:35:09 -0700
Message-Id: <20140808213413.746931745@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213413.648794968@linuxfoundation.org>
References: <20140808213413.648794968@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit b7eea4545ea775df957460f58eb56085a8892856 ]

xfrm_lookup must return a dst_entry with a refcount for the caller.
Git commit 1a1ccc96abb ("xfrm: Remove caching of xfrm_policy_sk_bundles")
removed this refcount for the socket policy case accidentally.
This patch restores it and sets DST_NOCACHE flag to make sure
that the dst_entry is freed when the refcount becomes null.

Fixes: 1a1ccc96abb ("xfrm: Remove caching of xfrm_policy_sk_bundles")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_policy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2107,6 +2107,8 @@ struct dst_entry *xfrm_lookup(struct net
 				goto no_transform;
 			}
 
+			dst_hold(&xdst->u.dst);
+			xdst->u.dst.flags |= DST_NOCACHE;
 			route = xdst->route;
 		}
 	}


