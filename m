Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaANA2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:28:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaANA2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Golle <daniel.golle@gmail.com>,
        Stefan Tomanek <stefan.tomanek@wertarbyte.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 15/77] inet: fix NULL pointer Oops in fib(6)_rule_suppress
Date: Mon, 13 Jan 2014 16:27:36 -0800
Message-Id: <20140114002752.931740206@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Tomanek <stefan.tomanek@wertarbyte.de>

[ Upstream commit 673498b8ed4c4d4b7221c5309d891c5eac2b7528 ]

This changes ensures that the routing entry investigated by the suppress
function actually does point to a device struct before following that pointer,
fixing a possible kernel oops situation when verifying the interface group
associated with a routing table entry.

According to Daniel Golle, this Oops can be triggered by a user process trying
to establish an outgoing IPv6 connection while having no real IPv6 connectivity
set up (only autoassigned link-local addresses).

Fixes: 6ef94cfafba15 ("fib_rules: add route suppression based on ifgroup")

Reported-by: Daniel Golle <daniel.golle@gmail.com>
Tested-by: Daniel Golle <daniel.golle@gmail.com>
Signed-off-by: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_rules.c  |    5 ++++-
 net/ipv6/fib6_rules.c |    6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -104,7 +104,10 @@ errout:
 static bool fib4_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg)
 {
 	struct fib_result *result = (struct fib_result *) arg->result;
-	struct net_device *dev = result->fi->fib_dev;
+	struct net_device *dev = NULL;
+
+	if (result->fi)
+		dev = result->fi->fib_dev;
 
 	/* do not accept result if the route does
 	 * not meet the required prefix length
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -122,7 +122,11 @@ out:
 static bool fib6_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg)
 {
 	struct rt6_info *rt = (struct rt6_info *) arg->result;
-	struct net_device *dev = rt->rt6i_idev->dev;
+	struct net_device *dev = NULL;
+
+	if (rt->rt6i_idev)
+		dev = rt->rt6i_idev->dev;
+
 	/* do not accept result if the route does
 	 * not meet the required prefix length
 	 */


