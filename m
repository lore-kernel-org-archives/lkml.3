Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab3JKKnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:43:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58613 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3JKKna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 054/100] bridge: Clamp forward_delay when enabling STP
Date: Fri, 11 Oct 2013 11:41:24 +0100
Message-Id: <1381488130-30235-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit be4f154d5ef0ca147ab6bcd38857a774133f5450 upstream.

At some point limits were added to forward_delay.  However, the
limits are only enforced when STP is enabled.  This created a
scenario where you could have a value outside the allowed range
while STP is disabled, which then stuck around even after STP
is enabled.

This patch fixes this by clamping the value when we enable STP.

I had to move the locking around a bit to ensure that there is
no window where someone could insert a value outside the range
while we're in the middle of enabling STP.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bridge/br_private.h |  1 +
 net/bridge/br_stp.c     | 21 +++++++++++++++------
 net/bridge/br_stp_if.c  | 12 ++++++++++--
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a768b24..68d9266 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -512,6 +512,7 @@ extern struct net_bridge_port *br_get_port(struct net_bridge *br,
 extern void br_init_port(struct net_bridge_port *p);
 extern void br_become_designated_port(struct net_bridge_port *p);
 
+extern void __br_set_forward_delay(struct net_bridge *br, unsigned long t);
 extern int br_set_forward_delay(struct net_bridge *br, unsigned long x);
 extern int br_set_hello_time(struct net_bridge *br, unsigned long x);
 extern int br_set_max_age(struct net_bridge *br, unsigned long x);
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 2e46d07..73920c2 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -517,18 +517,27 @@ int br_set_max_age(struct net_bridge *br, unsigned long val)
 
 }
 
+void __br_set_forward_delay(struct net_bridge *br, unsigned long t)
+{
+	br->bridge_forward_delay = t;
+	if (br_is_root_bridge(br))
+		br->forward_delay = br->bridge_forward_delay;
+}
+
 int br_set_forward_delay(struct net_bridge *br, unsigned long val)
 {
 	unsigned long t = clock_t_to_jiffies(val);
+	int err = -ERANGE;
 
+	spin_lock_bh(&br->lock);
 	if (br->stp_enabled != BR_NO_STP &&
 	    (t < BR_MIN_FORWARD_DELAY || t > BR_MAX_FORWARD_DELAY))
-		return -ERANGE;
+		goto unlock;
 
-	spin_lock_bh(&br->lock);
-	br->bridge_forward_delay = t;
-	if (br_is_root_bridge(br))
-		br->forward_delay = br->bridge_forward_delay;
+	__br_set_forward_delay(br, t);
+	err = 0;
+
+unlock:
 	spin_unlock_bh(&br->lock);
-	return 0;
+	return err;
 }
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 9d5a414..7ba2ed5 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -129,6 +129,14 @@ static void br_stp_start(struct net_bridge *br)
 	char *envp[] = { NULL };
 
 	r = call_usermodehelper(BR_STP_PROG, argv, envp, UMH_WAIT_PROC);
+
+	spin_lock_bh(&br->lock);
+
+	if (br->bridge_forward_delay < BR_MIN_FORWARD_DELAY)
+		__br_set_forward_delay(br, BR_MIN_FORWARD_DELAY);
+	else if (br->bridge_forward_delay < BR_MAX_FORWARD_DELAY)
+		__br_set_forward_delay(br, BR_MAX_FORWARD_DELAY);
+
 	if (r == 0) {
 		br->stp_enabled = BR_USER_STP;
 		br_debug(br, "userspace STP started\n");
@@ -137,10 +145,10 @@ static void br_stp_start(struct net_bridge *br)
 		br_debug(br, "using kernel STP\n");
 
 		/* To start timers on any ports left in blocking */
-		spin_lock_bh(&br->lock);
 		br_port_state_selection(br);
-		spin_unlock_bh(&br->lock);
 	}
+
+	spin_unlock_bh(&br->lock);
 }
 
 static void br_stp_stop(struct net_bridge *br)
-- 
1.8.3.2

