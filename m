Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3ILRaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:30:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab3ILR0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:26:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 11/19] net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_delay
Date: Thu, 12 Sep 2013 10:26:20 -0700
Message-Id: <20130912172525.398561480@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912172524.135620246@linuxfoundation.org>
References: <20130912172524.135620246@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 2d98c29b6fb3de44d9eaa73c09f9cf7209346383 ]

While looking into MLDv1/v2 code, I noticed that bridging code does
not convert it's max delay into jiffies for MLDv2 messages as we do
in core IPv6' multicast code.

RFC3810, 5.1.3. Maximum Response Code says:

  The Maximum Response Code field specifies the maximum time allowed
  before sending a responding Report. The actual time allowed, called
  the Maximum Response Delay, is represented in units of milliseconds,
  and is derived from the Maximum Response Code as follows: [...]

As we update timers that work with jiffies, we need to convert it.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Linus Lüssing <linus.luessing@web.de>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1155,7 +1155,8 @@ static int br_ip6_multicast_query(struct
 		mld2q = (struct mld2_query *)icmp6_hdr(skb);
 		if (!mld2q->mld2q_nsrcs)
 			group = &mld2q->mld2q_mca;
-		max_delay = mld2q->mld2q_mrc ? MLDV2_MRC(mld2q->mld2q_mrc) : 1;
+
+		max_delay = max(msecs_to_jiffies(MLDV2_MRC(ntohs(mld2q->mld2q_mrc))), 1UL);
 	}
 
 	if (!group)


