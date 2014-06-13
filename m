Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaFMEyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 00:54:16 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:44109 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaFMEyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 00:54:14 -0400
Message-ID: <539A83F3.2060407@gmail.com>
Date: Fri, 13 Jun 2014 00:54:11 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH 1/5] kernel/rcu/tree.c:1272 fix a sparse warning
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com> <1402519183-12752-2-git-send-email-bobby.prani@gmail.com> <20140612231609.GG4581@linux.vnet.ibm.com>
In-Reply-To: <20140612231609.GG4581@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 07:16 PM, Paul E. McKenney wrote:
> On Wed, Jun 11, 2014 at 04:39:39PM -0400, Pranith Kumar wrote:
>> kernel/rcu/tree.c:1272:9: warning: context imbalance in 'rcu_start_future_gp' - different lock contexts for basic block
>>
>> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
>> index f1ba773..9ab84d3 100644
>> --- a/kernel/rcu/tree.c
>> +++ b/kernel/rcu/tree.c
>> @@ -1234,49 +1234,54 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
>>  	}
>>
>>  	/*
>> -	 * There might be no grace period in progress.  If we don't already
>> +	 * There is be no grace period in progress.  If we don't already
> 
> We actually don't know at this point, unless rnp==rnp_root.  Otherwise,
> the grace period might have started, but initialization might not yet
> have reached rnp.

I should have mentioned that I wrote this on top of the previous patch where we
were checking the root node for presence of a grace period 
	ACCESS_ONCE(rnp_root->gpnum) != ACCESS_ONCE(rnp_root->completed)

But, I realize that even this does not guarantee that a grace period is in
progress as we do not yet have the lock for the root.

> 
>>  	 * hold it, acquire the root rcu_node structure's lock in order to
>> -	 * start one (if needed).
>> +	 * start one.
>>  	 */
>>  	if (rnp != rnp_root) {
>>  		raw_spin_lock(&rnp_root->lock);
>>  		smp_mb__after_unlock_lock();
> 
> I am not convinced that this transformation is correct, especially in
> the rnp==rnp_root case.  For one thing, I don't see the need for a
> future grace period being recorded in that case.
> 
> And I believe that if this transformation is fixed, there will be some
> duplicate code, which scares me more than sparse false positives.  So I
> am not willing to take this sort of transformation.  Or am I missing
> something?
> 
 
You are right. I knew I missed something! Even though this started as an
exercise to remove the sparse warning, I thought I could simplify the function
since I could see that we are doing some things twice.

Please find v2 below which takes care of the issues you mentioned. RFC please!

simplify the rcu_start_future_gp function. fix sparse warning as an added bonus :)

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 80 +++++++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 43 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f1ba773..ee98d0b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1192,44 +1192,60 @@ static void trace_rcu_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
 }
 
 /*
+ * Adjust callbacks as needed.  Note that even no-CBs CPUs
+ * have a ->nxtcompleted[] array, so no no-CBs checks needed.
+ */
+static void rcu_adjust_callbacks(unsigned long c, struct rcu_data *rdp)
+{
+	int i;
+	for (i = RCU_DONE_TAIL; i < RCU_NEXT_TAIL; i++)
+		if (ULONG_CMP_LT(c, rdp->nxtcompleted[i]))
+			rdp->nxtcompleted[i] = c;
+}
+
+/*
  * Start some future grace period, as needed to handle newly arrived
  * callbacks.  The required future grace periods are recorded in each
  * rcu_node structure's ->need_future_gp field.  Returns true if there
  * is reason to awaken the grace-period kthread.
  *
  * The caller must hold the specified rcu_node structure's ->lock.
+ *
+ * This is called recursively at-most twice, once with a rcu_node and 
+ * once with the root rcu_node.
  */
 static bool __maybe_unused
 rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
 		    unsigned long *c_out)
 {
 	unsigned long c;
-	int i;
 	bool ret = false;
 	struct rcu_node *rnp_root = rcu_get_root(rdp->rsp);
+	bool is_root = (rnp_root == rnp);
 
 	/*
 	 * Pick up grace-period number for new callbacks.  If this
 	 * grace period is already marked as needed, return to the caller.
 	 */
 	c = rcu_cbs_completed(rdp->rsp, rnp);
-	trace_rcu_future_gp(rnp, rdp, c, TPS("Startleaf"));
+	trace_rcu_future_gp(rnp, rdp, c, 
+			is_root ? TPS("Startedroot") : TPS("Startleaf"));
 	if (rnp->need_future_gp[c & 0x1]) {
-		trace_rcu_future_gp(rnp, rdp, c, TPS("Prestartleaf"));
+		trace_rcu_future_gp(rnp, rdp, c, 
+				is_root ? TPS("Prestartroot") :	TPS("Prestartleaf"));
 		goto out;
 	}
 
 	/*
-	 * If either this rcu_node structure or the root rcu_node structure
-	 * believe that a grace period is in progress, then we must wait
-	 * for the one following, which is in "c".  Because our request
-	 * will be noticed at the end of the current grace period, we don't
-	 * need to explicitly start one.
+	 * If this rcu_node structure believes that a grace period is in progress,
+	 * then we must wait for the one following, which is in "c".  
+	 * Because our request will be noticed at the end of the current grace
+	 * period, we don't need to explicitly start one.
 	 */
-	if (rnp->gpnum != rnp->completed ||
-	    ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
+	if (rnp->gpnum != rnp->completed) {
 		rnp->need_future_gp[c & 0x1]++;
-		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleaf"));
+		trace_rcu_future_gp(rnp, rdp, c, 
+			is_root ? TPS("Startedleafroot") : TPS("Startleaf"));
 		goto out;
 	}
 
@@ -1241,41 +1257,19 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
 	if (rnp != rnp_root) {
 		raw_spin_lock(&rnp_root->lock);
 		smp_mb__after_unlock_lock();
-	}
-
-	/*
-	 * Get a new grace-period number.  If there really is no grace
-	 * period in progress, it will be smaller than the one we obtained
-	 * earlier.  Adjust callbacks as needed.  Note that even no-CBs
-	 * CPUs have a ->nxtcompleted[] array, so no no-CBs checks needed.
-	 */
-	c = rcu_cbs_completed(rdp->rsp, rnp_root);
-	for (i = RCU_DONE_TAIL; i < RCU_NEXT_TAIL; i++)
-		if (ULONG_CMP_LT(c, rdp->nxtcompleted[i]))
-			rdp->nxtcompleted[i] = c;
 
-	/*
-	 * If the needed for the required grace period is already
-	 * recorded, trace and leave.
-	 */
-	if (rnp_root->need_future_gp[c & 0x1]) {
-		trace_rcu_future_gp(rnp, rdp, c, TPS("Prestartedroot"));
-		goto unlock_out;
+		/*
+		 * Start a new grace period using the root node
+		 */
+		ret = rcu_start_future_gp(rnp_root, rdp, &c);
+		raw_spin_unlock(&rnp_root->lock);
+		goto out;
 	}
 
-	/* Record the need for the future grace period. */
-	rnp_root->need_future_gp[c & 0x1]++;
-
-	/* If a grace period is not already in progress, start one. */
-	if (rnp_root->gpnum != rnp_root->completed) {
-		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleafroot"));
-	} else {
-		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedroot"));
-		ret = rcu_start_gp_advanced(rdp->rsp, rnp_root, rdp);
-	}
-unlock_out:
-	if (rnp != rnp_root)
-		raw_spin_unlock(&rnp_root->lock);
+	rcu_adjust_callbacks(c, rdp);
+	/* rnp == rnp_root, we already hold the lock */
+	trace_rcu_future_gp(rnp, rdp, c, TPS("Startedroot"));
+	ret = rcu_start_gp_advanced(rdp->rsp, rnp, rdp);
 out:
 	if (c_out != NULL)
 		*c_out = c;
-- 
1.9.1
