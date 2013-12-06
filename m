Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab3LFVwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:52:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3LFVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florent Fourcot <florent.fourcot@enst-bretagne.fr>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 09/83] ipv6: protect for_each_sk_fl_rcu in mem_check with rcu_read_lock_bh
Date: Fri,  6 Dec 2013 13:50:59 -0800
Message-Id: <20131206214640.943397462@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit f8c31c8f80dd882f7eb49276989a4078d33d67a7 ]

Fixes a suspicious rcu derference warning.

Cc: Florent Fourcot <florent.fourcot@enst-bretagne.fr>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_flowlabel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -453,8 +453,10 @@ static int mem_check(struct sock *sk)
 	if (room > FL_MAX_SIZE - FL_MAX_PER_SOCK)
 		return 0;
 
+	rcu_read_lock_bh();
 	for_each_sk_fl_rcu(np, sfl)
 		count++;
+	rcu_read_unlock_bh();
 
 	if (room <= 0 ||
 	    ((count >= FL_MAX_PER_SOCK ||


