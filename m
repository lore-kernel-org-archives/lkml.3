Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3BGKtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:49:18 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:35327 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757265Ab3BGKtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:49:16 -0500
Date: Thu, 7 Feb 2013 11:49:08 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Emmanuel Thierry <emmanuel.thierry@telecom-bretagne.eu>
Cc: jamal <j.hadi123@gmail.com>, Romain KUNTZ <r.kuntz@ipflavors.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        herbert@gondor.hengli.com.au,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jamal Hadi Salim <hadi@cyberus.ca>
Subject: Re: [RFC PATCH] xfrm: fix handling of XFRM policies mark and mask.
Message-ID: <20130207104908.GA17794@secunet.com>
References: <9E57ADA1-5770-47A8-8EBF-7FC262EEF1C7@ipflavors.com>
 <20130205081232.GF23291@secunet.com>
 <51125744.3030905@gmail.com>
 <D4563759-CEC5-4F33-BF0A-9FA10716F8DF@telecom-bretagne.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D4563759-CEC5-4F33-BF0A-9FA10716F8DF@telecom-bretagne.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 07 Feb 2013 10:49:13.0620 (UTC) FILETIME=[C49F7540:01CE0520]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 02:53:48PM +0100, Emmanuel Thierry wrote:
> 
> Hello,
> 
> Le 6 févr. 2013 à 14:14, jamal a écrit :
> 
> > 
> > On 13-02-05 03:12 AM, Steffen Klassert wrote:
> >>> For example, executing the below commands in that order succeed:
> >>>  ip -6 xfrm policy flush
> >>>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir out mark 1 mask 0xffffffff
> >>>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir out
> >> The policy with mark 1 is the first we find. The policy passes the
> >> mark check and if the flow matches the selectors, we use this policy.
> >> 
> >>> But it fails in the reverse order:
> >>>  ip -6 xfrm policy flush
> >>>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir out
> >>>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir out mark 1 mask 0xffffffff
> >>>  RTNETLINK answers: File exists
> >> With this scenario, we would find the policy with mark and mask 0 first.
> >> This policy passes the mark check too. So we would use this policy if the
> >> flow matches the selectors, but the flow asked for a policy with mark 1.
> > 
> > I think the intent Romain is expressing is reasonable and should resolved at
> > insertion time(xfrm_policy_insert()).
> > i.e even though the policy (such as mark=1) is inserted afterwards, at
> > insertion time if it proves it is more specific and not duplicate, it should be
> > inserted ahead of the mark=0.
> > The runtime check will work then.
> 
> Actually, we didn't think about this problem since we work with priorities, putting the default policy (without a mark) at a minor priority than the marked one.
> Your remark makes clearer the ideas behind the design of XFRM, but this leads to an interesting concern. If on policy insertion, the policy were inserted depending on the accuracy of the mark (the more the mask is specific, the more the mark must be put at the beginning of the list), how would we decide which is the more specific between these ones ?
> 
> ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir out mark 0x00000001 mask 0x00000005
> 
> ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir out mark 0x00000001 mask 0x00000003
> 

We can't decide on the order of these two policies, so we should not
allow to insert both. At least not if the have the same priority,
but we could insert both if they have different priorities.

Would the patch below meet your requirements?

---
 net/xfrm/xfrm_policy.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 6c9aa64..b169a69 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -562,6 +562,21 @@ static inline int selector_cmp(struct xfrm_selector *s1, struct xfrm_selector *s
 	return 0;
 }
 
+static bool xfrm_mark_match(struct xfrm_policy *policy,
+			    struct xfrm_policy *pol)
+{
+	u32 mark = policy->mark.v & policy->mark.m;
+
+	if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
+		return true;
+
+	if ((mark & pol->mark.m) == pol->mark.v &&
+	    policy->priority == pol->priority)
+		return true;
+
+	return false;
+}
+
 int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 {
 	struct net *net = xp_net(policy);
@@ -569,7 +584,6 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 	struct xfrm_policy *delpol;
 	struct hlist_head *chain;
 	struct hlist_node *entry, *newpos;
-	u32 mark = policy->mark.v & policy->mark.m;
 
 	write_lock_bh(&xfrm_policy_lock);
 	chain = policy_hash_bysel(net, &policy->selector, policy->family, dir);
@@ -578,7 +592,7 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 	hlist_for_each_entry(pol, entry, chain, bydst) {
 		if (pol->type == policy->type &&
 		    !selector_cmp(&pol->selector, &policy->selector) &&
-		    (mark & pol->mark.m) == pol->mark.v &&
+		    xfrm_mark_match(policy, pol) &&
 		    xfrm_sec_ctx_match(pol->security, policy->security) &&
 		    !WARN_ON(delpol)) {
 			if (excl) {
-- 
1.7.2.5

