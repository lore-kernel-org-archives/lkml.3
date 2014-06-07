Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaFGBZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:25:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36186 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbaFGBXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        "Jason Wang" <jasowang@redhat.com>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.689414421@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 23/92] act_mirred: do not drop packets when fails to
 mirror it
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 16c0b164bd24d44db137693a36b428ba28970c62 ]

We drop packet unconditionally when we fail to mirror it. This is not intended
in some cases. Consdier for kvm guest, we may mirror the traffic of the bridge
to a tap device used by a VM. When kernel fails to mirror the packet in
conditions such as when qemu crashes or stop polling the tap, it's hard for the
management software to detect such condition and clean the the mirroring
before. This would lead all packets to the bridge to be dropped and break the
netowrk of other virtual machines.

To solve the issue, the patch does not drop packets when kernel fails to mirror
it, and only drop the redirected packets.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/act_mirred.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index e051398..d067ed1 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -201,13 +201,12 @@ static int tcf_mirred(struct sk_buff *skb, const struct tc_action *a,
 out:
 	if (err) {
 		m->tcf_qstats.overlimits++;
-		/* should we be asking for packet to be dropped?
-		 * may make sense for redirect case only
-		 */
-		retval = TC_ACT_SHOT;
-	} else {
+		if (m->tcfm_eaction != TCA_EGRESS_MIRROR)
+			retval = TC_ACT_SHOT;
+		else
+			retval = m->tcf_action;
+	} else
 		retval = m->tcf_action;
-	}
 	spin_unlock(&m->tcf_lock);
 
 	return retval;

