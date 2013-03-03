Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab3CCVmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 16:42:33 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39419 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3CCVma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 16:42:30 -0500
Message-ID: <1362346944.18325.1.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Sun, 03 Mar 2013 16:42:24 -0500
In-Reply-To: <20130301213329.GC3457@redhat.com>
References: <20130228151333.GB11360@redhat.com>
	 <1362079419.2908.390.camel@falcor1.watson.ibm.com>
	 <20130228213534.GF11360@redhat.com>
	 <CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
	 <1362102544.9158.35.camel@falcor1> <1362140107.9158.101.camel@falcor1>
	 <20130301152839.GA3457@redhat.com> <20130301184027.GB3457@redhat.com>
	 <1362166753.9158.169.camel@falcor1> <20130301213329.GC3457@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030321-3620-0000-0000-00000172A8C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 16:33 -0500, Vivek Goyal wrote:
> On Fri, Mar 01, 2013 at 02:39:13PM -0500, Mimi Zohar wrote:
> 
> [..]
> > I was suggesting that a builtin appraise rule chain and everything else
> > on the other chain.  Userspace could replace the other chain with
> > whatever they wanted, including additional appraisal rules.
> > 
> > > > Given the fact that policy file ABI is still in testing we should be
> > > > able to change semantics. (As currently user's appraise rules override
> > > > kernel's appraisal rules).
> > 
> > The userspace policy could only extend the appraisal rules.  We OR the
> > result of both chains, and use the more restrictive rule.
> 
> 
> So secureboot rules will go in builtin policy. tcb appraise rules and
> others will go in other policy. This other policy is replacable by
> user.
> 
> We OR the results of both chains and instead of using first matching
> rule, we choose a rule which is more restrictive and use that.
> 
> Is there always a clear relationship between rules. I mean one is more
> restrictive than other. There can not be part-overlapping rules?
> 
> [..]
> > We've already spoken about needing an additional hook or moving the
> > existing bprm hook.  Can we defer the memory caching requirements for
> > now?
> 
> Sure, additional hook is not a concern.
> 
> I can defer caching discussion but I think it is important to discuss
> it now. Because it might very well affect how do we decide to handle
> multiple appraise rules/policies. So please, if possible, let us not
> defer the caching requirement discussion.
> 
> My biggest concern is what if we decide to rule based caching option
> and rule gets skipped because of more restrictive rule present.
> 
> appraise func=bprm_check cache_status=no
> appraise fowner=root 
> 
> In above case second rule will override first one and that's not what
> we want.

I was thinking more in terms of merging flags.  Merging the flags in
your example would work.

appraise func=bprm_check appraise_type=optional cache_status=no
appraise fowner=root
example 2:  merging the flags results in the 'optional' flag being set

Unfortunately, in some cases, like in your example, the flag needs to be
set if either rule enables it.  In other cases, like in the second
example, the flag should be set only if both rules enable it.

As the 'ima_tcb' and 'ima_appraise_tcb' policies are also builtin, we
should probably use a different term to identify these new rules.  This
code snippet is only for illustration.

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 399433a..acc455b 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -288,6 +288,15 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 			break;
 	}
 
+	list_for_each_entry(entry, ima_builtin_rules, list) {
+		if (!ima_match_rules(entry, inode, func, mask))
+			continue;
+		action |= entry->flags & IMA_ACTION_FLAGS;      <=== can't do blindly
+		action |= IMA_APPRAISE;
+		action &= ~IMA_FILE_APPRAISE; /* remove default subaction */
+		action |= get_subaction(entry, func);
+	}
+
 	return action;
 }
 

thanks,

Mimi




