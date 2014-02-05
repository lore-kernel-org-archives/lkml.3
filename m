Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbaBEUFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:05:02 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48019 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaBEUEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Cong Wang <xiyou.wangcong@gmail.com>,
        nitin padalia <padalia.nitin@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 046/213] net: prevent setting ttl=0 via IP_TTL
Date: Wed, 5 Feb 2014 15:00:01 -0500
Message-ID: <1391630568-49251-47-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c9be4a5c49cf51cc70a993f004c5bb30067a65ce upstream.

A regression is introduced by the following commit:

	commit 4d52cfbef6266092d535237ba5a4b981458ab171
	Author: Eric Dumazet <eric.dumazet@gmail.com>
	Date:   Tue Jun 2 00:42:16 2009 -0700

	    net: ipv4/ip_sockglue.c cleanups

	    Pure cleanups

but it is not a pure cleanup...

	-               if (val != -1 && (val < 1 || val>255))
	+               if (val != -1 && (val < 0 || val > 255))

Since there is no reason provided to allow ttl=0, change it back.

Reported-by: nitin padalia <padalia.nitin@gmail.com>
Cc: nitin padalia <padalia.nitin@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/ip_sockglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index e4256fe59a30..3ca6fa7d1365 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -573,7 +573,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	case IP_TTL:
 		if (optlen < 1)
 			goto e_inval;
-		if (val != -1 && (val < 0 || val > 255))
+		if (val != -1 && (val < 1 || val > 255))
 			goto e_inval;
 		inet->uc_ttl = val;
 		break;
-- 
1.8.5.2

