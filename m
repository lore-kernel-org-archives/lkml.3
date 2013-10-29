Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab3J2SJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:09:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59550 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab3J2SJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 44/81] net: sctp: rfc4443: do not report ICMP redirects to user space
Date: Tue, 29 Oct 2013 11:04:05 -0700
Message-Id: <1383069882-11437-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 3f96a532113131d5a65ac9e00fc83cfa31b0295f ]

Adapt the same behaviour for SCTP as present in TCP for ICMP redirect
messages. For IPv6, RFC4443, section 2.4. says:

  ...
  (e) An ICMPv6 error message MUST NOT be originated as a result of
      receiving the following:
  ...
       (e.2) An ICMPv6 redirect message [IPv6-DISC].
  ...

Therefore, do not report an error to user space, just invoke dst's redirect
callback and leave, same for IPv4 as done in TCP as well. The implication
w/o having this patch could be that the reception of such packets would
generate a poll notification and in worst case it could even tear down the
whole connection. Therefore, stop updating sk_err on redirects.

Reported-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sctp/input.c | 3 +--
 net/sctp/ipv6.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 8bd3c27..08708c6 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -649,8 +649,7 @@ void sctp_v4_err(struct sk_buff *skb, __u32 info)
 		break;
 	case ICMP_REDIRECT:
 		sctp_icmp_redirect(sk, transport, skb);
-		err = 0;
-		break;
+		/* Fall through to out_unlock. */
 	default:
 		goto out_unlock;
 	}
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index d70cabb..422d8bd 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -189,7 +189,7 @@ SCTP_STATIC void sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		break;
 	case NDISC_REDIRECT:
 		sctp_icmp_redirect(sk, transport, skb);
-		break;
+		goto out_unlock;
 	default:
 		break;
 	}
-- 
1.8.1.2

