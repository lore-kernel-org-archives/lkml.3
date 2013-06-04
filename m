Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3FDWob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:44:31 -0400
Received: from 1wt.eu ([62.212.114.60]:35893 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab3FDWo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:26 -0400
Message-Id: <20130604172133.868987403@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Brad Spengler <spender@grsecurity.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 086/184] xfrm_user: fix info leak in copy_to_user_tmpl()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 1f86840f897717f86d523a13e99a447e6a5d2fa5 ]

The memory used for the template copy is a local stack variable. As
struct xfrm_user_tmpl contains multiple holes added by the compiler for
alignment, not initializing the memory will lead to leaking stack bytes
to userland. Add an explicit memset(0) to avoid the info leak.

Initial version of the patch by Brad Spengler.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Brad Spengler <spender@grsecurity.net>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 3de81fe..a8d83c4 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1178,6 +1178,7 @@ static int copy_to_user_tmpl(struct xfrm_policy *xp, struct sk_buff *skb)
 		struct xfrm_user_tmpl *up = &vec[i];
 		struct xfrm_tmpl *kp = &xp->xfrm_vec[i];
 
+		memset(up, 0, sizeof(*up));
 		memcpy(&up->id, &kp->id, sizeof(up->id));
 		up->family = kp->encap_family;
 		memcpy(&up->saddr, &kp->saddr, sizeof(up->saddr));
-- 
1.7.12.2.21.g234cd45.dirty



