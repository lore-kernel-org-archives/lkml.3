Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaDRRgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:36:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbaDRRfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:35:23 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, davem@davemloft.net,
        eparis@redhat.com, netfilter-devel@vger.kernel.org, hadi@mojatatu.com,
        sgrubb@redhat.com
Subject: [PATCH 6/6] audit: send multicast messages only if there are listeners
Date: Fri, 18 Apr 2014 13:34:10 -0400
Message-Id: <6f2cbed195664cc9d50eab61ec85d457e6a3079f.1397831970.git.rgb@redhat.com>
In-Reply-To: <20140324183406.GE28666@madcap2.tricolour.ca>
References: <20140324183406.GE28666@madcap2.tricolour.ca>
In-Reply-To: <cover.1397831970.git.rgb@redhat.com>
References: <cover.1397831970.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test first to see if there are any userspace multicast listeners bound to the
socket before starting the multicast send work.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index d272cc1..33531d7 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -435,6 +435,9 @@ static void kauditd_send_multicast_skb(struct sk_buff *skb)
 	struct audit_net	*aunet = net_generic(&init_net, audit_net_id);
 	struct sock		*sock = aunet->nlsk;
 
+	if (!netlink_has_listeners(sock, AUDIT_NLGRP_READLOG))
+		return;
+
 	/*
 	 * The seemingly wasteful skb_copy() rather than bumping the refcount
 	 * using skb_get() is necessary because non-standard mods are made to
-- 
1.7.1

