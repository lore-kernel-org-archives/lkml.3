Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaBSSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:09:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbaBSSJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:09:25 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: netdev@oss.sgi.com, davem@davemloft.net, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH 3/5] audit: add netlink audit protocol bind to check capabilities on multicast join
Date: Wed, 19 Feb 2014 13:08:21 -0500
Message-Id: <2ead1dbcbb241075feafb2d88656b48761168491.1392831003.git.rgb@redhat.com>
In-Reply-To: <cover.1392831003.git.rgb@redhat.com>
References: <cover.1392831003.git.rgb@redhat.com>
In-Reply-To: <cover.1392831003.git.rgb@redhat.com>
References: <cover.1392831003.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register a netlink per-protocol bind fuction for audit to check userspace
process capabilities before allowing a multicast group connection.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index b5b2f72..f2d2d61 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1050,10 +1050,20 @@ static void audit_receive(struct sk_buff  *skb)
 	mutex_unlock(&audit_cmd_mutex);
 }
 
+/* Run custom bind function on netlink socket group connect or bind requests. */
+static int audit_bind(int group)
+{
+	if (!capable(CAP_AUDIT_READ))
+		return -EPERM;
+
+	return 0;
+}
+
 static int __net_init audit_net_init(struct net *net)
 {
 	struct netlink_kernel_cfg cfg = {
 		.input	= audit_receive,
+		.bind	= audit_bind,
 	};
 
 	struct audit_net *aunet = net_generic(net, audit_net_id);
-- 
1.7.1

