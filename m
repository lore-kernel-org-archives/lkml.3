Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab3JKUMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:12:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab3JKTlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 027/135] net: sctp: rfc4443: do not report ICMP redirects to user space
Date: Fri, 11 Oct 2013 12:38:28 -0700
Message-Id: <20131011193948.185120014@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/input.c |    3 +--
 net/sctp/ipv6.c  |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -648,8 +648,7 @@ void sctp_v4_err(struct sk_buff *skb, __
 		break;
 	case ICMP_REDIRECT:
 		sctp_icmp_redirect(sk, transport, skb);
-		err = 0;
-		break;
+		/* Fall through to out_unlock. */
 	default:
 		goto out_unlock;
 	}
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -189,7 +189,7 @@ static void sctp_v6_err(struct sk_buff *
 		break;
 	case NDISC_REDIRECT:
 		sctp_icmp_redirect(sk, transport, skb);
-		break;
+		goto out_unlock;
 	default:
 		break;
 	}


