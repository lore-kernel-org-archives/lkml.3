Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3CZXNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:13:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3CZXB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:01:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlad Yasevich <vyasevic@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/49] rtnetlink: Mask the rta_type when range checking
Date: Tue, 26 Mar 2013 16:01:04 -0700
Message-Id: <20130326225840.330927046@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit a5b8db91442fce9c9713fcd656c3698f1adde1d6 ]

Range/validity checks on rta_type in rtnetlink_rcv_msg() do
not account for flags that may be set.  This causes the function
to return -EINVAL when flags are set on the type (for example
NLA_F_NESTED).

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2011,7 +2011,7 @@ static int rtnetlink_rcv_msg(struct sk_b
 		struct rtattr *attr = (void *)nlh + NLMSG_ALIGN(min_len);
 
 		while (RTA_OK(attr, attrlen)) {
-			unsigned flavor = attr->rta_type;
+			unsigned int flavor = attr->rta_type & NLA_TYPE_MASK;
 			if (flavor) {
 				if (flavor > rta_max[sz_idx])
 					return -EINVAL;


