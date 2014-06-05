Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaFEEUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaFEEUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 030/214] act_mirred: do not drop packets when fails to mirror it
Date: Wed,  4 Jun 2014 21:16:33 -0700
Message-Id: <20140605041643.884107395@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_mirred.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -201,13 +201,12 @@ static int tcf_mirred(struct sk_buff *sk
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


