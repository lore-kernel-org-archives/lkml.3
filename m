Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3ILR7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:59:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab3ILR7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 08/46] bridge: dont try to update timers in case of broken MLD queries
Date: Thu, 12 Sep 2013 10:58:19 -0700
Message-Id: <20130912175721.965003493@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>

[ Upstream commit 248ba8ec05a2c3b118c2224e57eb10c128176ab1 ]

Currently we are reading an uninitialized value for the max_delay
variable when snooping an MLD query message of invalid length and would
update our timers with that.

Fixing this by simply ignoring such broken MLD queries (just like we do
for IGMP already).

This is a regression introduced by:
"bridge: disable snooping if there is no querier" (b00589af3b04)

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1185,7 +1185,7 @@ static int br_ip6_multicast_query(struct
 		max_delay = msecs_to_jiffies(ntohs(mld->mld_maxdelay));
 		if (max_delay)
 			group = &mld->mld_mca;
-	} else if (skb->len >= sizeof(*mld2q)) {
+	} else {
 		if (!pskb_may_pull(skb, sizeof(*mld2q))) {
 			err = -EINVAL;
 			goto out;


