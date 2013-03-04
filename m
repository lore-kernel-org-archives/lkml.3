Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab3CDVsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:48:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562Ab3CDVsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:48:02 -0500
Date: Mon, 4 Mar 2013 16:47:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130304214758.GG15199@redhat.com>
References: <1362079419.2908.390.camel@falcor1.watson.ibm.com>
 <20130228213534.GF11360@redhat.com>
 <CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
 <1362102544.9158.35.camel@falcor1>
 <1362140107.9158.101.camel@falcor1>
 <20130301152839.GA3457@redhat.com>
 <20130301184027.GB3457@redhat.com>
 <1362166753.9158.169.camel@falcor1>
 <20130301213329.GC3457@redhat.com>
 <1362346944.18325.1.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362346944.18325.1.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 04:42:24PM -0500, Mimi Zohar wrote:

[..]
> I was thinking more in terms of merging flags.  Merging the flags in
> your example would work.
> 
> appraise func=bprm_check appraise_type=optional cache_status=no
> appraise fowner=root
> example 2:  merging the flags results in the 'optional' flag being set
> 
> Unfortunately, in some cases, like in your example, the flag needs to be
> set if either rule enables it.  In other cases, like in the second
> example, the flag should be set only if both rules enable it.
> 
> As the 'ima_tcb' and 'ima_appraise_tcb' policies are also builtin, we
> should probably use a different term to identify these new rules.  This
> code snippet is only for illustration.
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 399433a..acc455b 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -288,6 +288,15 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
>  			break;
>  	}
>  
> +	list_for_each_entry(entry, ima_builtin_rules, list) {
> +		if (!ima_match_rules(entry, inode, func, mask))
> +			continue;
> +		action |= entry->flags & IMA_ACTION_FLAGS;      <=== can't do blindly
> +		action |= IMA_APPRAISE;
> +		action &= ~IMA_FILE_APPRAISE; /* remove default subaction */
> +		action |= get_subaction(entry, func);
> +	}
> +
>  	return action;
>  }

Hi Mimi,

Based on your code, I have written code to first go through builtin
appraise rule list and then go through ima_rules list. If there is
a conflict of appraise rule in two lists, then conflict is resolved
and a more restrictive rule is picked.

Please have a look. I have yet to test it. Just wanted to show how
it is shaping up. 

Also this is on top of some other pathces. So please ignore the code
which looks unfamiliar.

Thanks
Vivek

---
 security/integrity/ima/ima_policy.c |   79 ++++++++++++++++++++++++++++++++++--
 1 file changed, 75 insertions(+), 4 deletions(-)

Index: linux-2.6/security/integrity/ima/ima_policy.c
===================================================================
--- linux-2.6.orig/security/integrity/ima/ima_policy.c	2013-03-04 14:11:48.000000000 -0500
+++ linux-2.6/security/integrity/ima/ima_policy.c	2013-03-04 16:35:28.582077167 -0500
@@ -120,6 +120,8 @@ static LIST_HEAD(ima_default_rules);
 static LIST_HEAD(ima_policy_rules);
 static struct list_head *ima_rules;
 
+static LIST_HEAD(ima_builtin_rules);
+
 static DEFINE_MUTEX(ima_rules_mutex);
 
 static bool ima_use_tcb __initdata;
@@ -263,6 +265,40 @@ static int get_subaction(struct ima_rule
 	}
 }
 
+/*
+ * If two appraise rules from two chains apply, then more restrictive rule
+ * properties are retained
+ * @action: action so far after processing first chain
+ * @entry: new conflicting rule
+ * @func: ima hook function
+ */
+static int fix_appraise_rule_conflict(int action, struct ima_rule_entry *entry,
+					enum ima_hooks func)
+{
+	/* Appraisal optional is set only if both rules are optional */
+	if (action & IMA_APPRAISAL_OPT && !(entry->flags & IMA_APPRAISAL_OPT)) {
+		action &= ~IMA_APPRAISAL_OPT;
+		/*
+	 	 * If first rule is optional and second one is not, then more
+	 	 * restrictive rule is second one. Subaction belongs to more
+	 	 * restrictive rule as effectively that's what is being
+	 	 * enforced.
+	 	 */
+		action &= ~IMA_APPRAISE_SUBMASK;
+		action |= get_subaction(entry, func);
+	}
+
+	/* IMA_DIGSIG_REQUIRED gets set if any of the rules has it */
+	if (entry->flags & IMA_DIGSIG_REQUIRED)
+		action |= IMA_DIGSIG_REQUIRED;
+
+	/*
+	 * TODO: If one rule wants result caching and other does not, then
+	 * final result should not be cached.
+	 */
+	return action;
+}
+
 /**
  * ima_match_policy - decision based on LSM and other conditions
  * @inode: pointer to an inode for which the policy decision is being made
@@ -282,8 +318,8 @@ int ima_match_policy(struct inode *inode
 	struct ima_rule_entry *entry;
 	int action = 0, actmask = flags | (flags << 1);
 
-	list_for_each_entry(entry, ima_rules, list) {
-
+	/* First go through builtin appraise rules */
+	list_for_each_entry(entry, &ima_builtin_rules, list) {
 		if (!(entry->action & actmask))
 			continue;
 
@@ -303,6 +339,40 @@ int ima_match_policy(struct inode *inode
 
 		if (!actmask)
 			break;
+
+	}
+
+	/*
+	 * Now go through ima_rules list. If there is an appraise rule conflict
+	 * from previous list, pick more restrictive rule
+	 */
+	actmask = flags | (flags << 1);
+	list_for_each_entry(entry, ima_rules, list) {
+
+		if (!(entry->action & actmask))
+			continue;
+
+		if (!ima_match_rules(entry, inode, func, mask))
+			continue;
+
+		if ((entry->action & IMA_APPRAISE) && (action & IMA_APPRAISE)) {
+			/* appraise rule from two chanins collide */
+			action = fix_appraise_rule_conflict(action, entry,
+								func);
+		} else {
+			action |= entry->flags & IMA_ACTION_FLAGS;
+			action |= entry->action & IMA_DO_MASK;
+			if (entry->action & IMA_APPRAISE)
+				action |= get_subaction(entry, func);
+		}
+
+		if (entry->action & IMA_DO_MASK)
+			actmask &= ~(entry->action | entry->action << 1);
+		else
+			actmask &= ~(entry->action | entry->action >> 1);
+
+		if (!actmask)
+			break;
 	}
 
 	return action;
@@ -335,13 +405,14 @@ void __init ima_init_policy(void)
 		}
 	}
 
+	ima_rules = &ima_default_rules;
+
 	/* Load other built-in poilcies */
 	appraise_entries = ARRAY_SIZE(default_memlock_exec_appraise_rules);
 	for (i = 0; i < appraise_entries; i++) {
 		list_add_tail(&default_memlock_exec_appraise_rules[i].list,
-				      &ima_default_rules);
+				      &ima_builtin_rules);
 	}
-	ima_rules = &ima_default_rules;
 }
 
 /**
