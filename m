Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbbA1Bbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:31:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759724AbbA1B2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.18 54/61] netfilter: conntrack: fix race between confirmation and flush
Date: Tue, 27 Jan 2015 17:27:06 -0800
Message-Id: <20150128012642.862609562@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 8ca3f5e974f2b4b7f711589f4abff920db36637a upstream.

Commit 5195c14c8b27c ("netfilter: conntrack: fix race in
__nf_conntrack_confirm against get_next_corpse") aimed to resolve the
race condition between the confirmation (packet path) and the flush
command (from control plane). However, it introduced a crash when
several packets race to add a new conntrack, which seems easier to
reproduce when nf_queue is in place.

Fix this race, in __nf_conntrack_confirm(), by removing the CT
from unconfirmed list before checking the DYING bit. In case
race occured, re-add the CT to the dying list

This patch also changes the verdict from NF_ACCEPT to NF_DROP when
we lose race. Basically, the confirmation happens for the first packet
that we see in a flow. If you just invoked conntrack -F once (which
should be the common case), then this is likely to be the first packet
of the flow (unless you already called flush anytime soon in the past).
This should be hard to trigger, but better drop this packet, otherwise
we leave things in inconsistent state since the destination will likely
reply to this packet, but it will find no conntrack, unless the origin
retransmits.

The change of the verdict has been discussed in:
https://www.marc.info/?l=linux-netdev&m=141588039530056&w=2

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_core.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -611,16 +611,15 @@ __nf_conntrack_confirm(struct sk_buff *s
 	 */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
 	pr_debug("Confirming conntrack %p\n", ct);
-	/* We have to check the DYING flag inside the lock to prevent
-	   a race against nf_ct_get_next_corpse() possibly called from
-	   user context, else we insert an already 'dead' hash, blocking
-	   further use of that particular connection -JM */
-
-	if (unlikely(nf_ct_is_dying(ct))) {
-		nf_conntrack_double_unlock(hash, reply_hash);
-		local_bh_enable();
-		return NF_ACCEPT;
-	}
+	/* We have to check the DYING flag after unlink to prevent
+	 * a race against nf_ct_get_next_corpse() possibly called from
+	 * user context, else we insert an already 'dead' hash, blocking
+	 * further use of that particular connection -JM.
+	 */
+	nf_ct_del_from_dying_or_unconfirmed_list(ct);
+
+	if (unlikely(nf_ct_is_dying(ct)))
+		goto out;
 
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
@@ -636,8 +635,6 @@ __nf_conntrack_confirm(struct sk_buff *s
 		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
 			goto out;
 
-	nf_ct_del_from_dying_or_unconfirmed_list(ct);
-
 	/* Timer relative to confirmation time, not original
 	   setting time, otherwise we'd get timer wrap in
 	   weird delay cases. */
@@ -673,6 +670,7 @@ __nf_conntrack_confirm(struct sk_buff *s
 	return NF_ACCEPT;
 
 out:
+	nf_ct_add_to_dying_list(ct);
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert_failed);
 	local_bh_enable();


