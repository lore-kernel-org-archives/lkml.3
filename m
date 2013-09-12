Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab3ILS2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:28:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3ILR7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 02/46] net: rtm_to_ifaddr: free ifa if ifa_cacheinfo processing fails
Date: Thu, 12 Sep 2013 10:58:13 -0700
Message-Id: <20130912175721.335357755@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 446266b0c742a2c9ee8f0dce759a0117bce58a86 ]

Commit 5c766d642 ("ipv4: introduce address lifetime") leaves the ifa
resource that was allocated via inet_alloc_ifa() unfreed when returning
the function with -EINVAL. Thus, free it first via inet_free_ifa().

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Reviewed-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/devinet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -771,7 +771,7 @@ static struct in_ifaddr *rtm_to_ifaddr(s
 		ci = nla_data(tb[IFA_CACHEINFO]);
 		if (!ci->ifa_valid || ci->ifa_prefered > ci->ifa_valid) {
 			err = -EINVAL;
-			goto errout;
+			goto errout_free;
 		}
 		*pvalid_lft = ci->ifa_valid;
 		*pprefered_lft = ci->ifa_prefered;
@@ -779,6 +779,8 @@ static struct in_ifaddr *rtm_to_ifaddr(s
 
 	return ifa;
 
+errout_free:
+	inet_free_ifa(ifa);
 errout:
 	return ERR_PTR(err);
 }


