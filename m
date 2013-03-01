Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3CATje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:39:34 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54127 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3CATjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:39:32 -0500
Message-ID: <1362166753.9158.169.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Fri, 01 Mar 2013 14:39:13 -0500
In-Reply-To: <20130301184027.GB3457@redhat.com>
References: <20130228151333.GB11360@redhat.com>
	 <1362079419.2908.390.camel@falcor1.watson.ibm.com>
	 <20130228213534.GF11360@redhat.com>
	 <CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
	 <1362102544.9158.35.camel@falcor1> <1362140107.9158.101.camel@falcor1>
	 <20130301152839.GA3457@redhat.com> <20130301184027.GB3457@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030119-5406-0000-0000-000005D1C2FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 13:40 -0500, Vivek Goyal wrote:
> On Fri, Mar 01, 2013 at 10:28:40AM -0500, Vivek Goyal wrote:
> > On Fri, Mar 01, 2013 at 07:15:07AM -0500, Mimi Zohar wrote:
> > > On Thu, 2013-02-28 at 20:49 -0500, Mimi Zohar wrote:
> > > > On Thu, 2013-02-28 at 17:20 -0500, Eric Paris wrote:
> > > 
> > > > > The ima_tcb policy was meant to be larger than needed to determine a
> > > > > trusted computing base, but it is clearly not a superset of what he is
> > > > > hoping to accomplish.
> > > 
> > > The builtin measurement and appraisal policies are different.  In order
> > > not to miss a measurement, the measurement policy measures everything
> > > read/executed by root.   Userspace can constrain the policy by defining
> > > rules based on LSM labels.  The appraisal policy measures everything
> > > owned by root.  Userspace might want to add rules to appraise additional
> > > files.
> > > 
> > > We can not OR the measurement builtin and userspace policies, as the
> > > userspace policy constrains the builtin policy, but for appraisal we
> > > could.  Perhaps we should define two rule chains, one for the builtin
> > > appraisal rules and another for all other rules.
> > 
> > Ok, just to make sure that I understand it right, I will summarize above.
> > 
> > So a user can overide/replace "measure and audit" rules but it can not
> > overide replace kernel's "appraise" rules and it can only append to
> > existing appraise rules.
> > 
> > So we internally define two rule chanins. All the appraisal rules
> > go in one rule chain and all other rules (measure and audit) go in
> > separate chain.
> > 
> > When user writes an "appraise" rule to "policy" file, it gets *appended*
> > to internal appraise rule chain and if user writes  a "measure or audit"
> > rule to "policy" file, it replaces the kernel's rules with user's rules. 

I was suggesting that a builtin appraise rule chain and everything else
on the other chain.  Userspace could replace the other chain with
whatever they wanted, including additional appraisal rules.

> > Given the fact that policy file ABI is still in testing we should be
> > able to change semantics. (As currently user's appraise rules override
> > kernel's appraisal rules).

The userspace policy could only extend the appraisal rules.  We OR the
result of both chains, and use the more restrictive rule.

> > > 
> > > When secure boot is defined, instead of having a NULL policy, the
> > > default policy would be the secureboot integrity policy.  These rules
> > > would be added to the builtin appraisal rule chain.  If the
> > > 'ima_appraise_tcb'  boot commandline option is specified, these rules
> > > would also be added to the builtin appraisal rule chain, but at the head
> > > of the chain, as they are more restrictive than the secureboot policy
> > > for root owned files.
> > > 
> > > Vivek, would this work?
> > 
> > This should work except the result caching issue. If we are running a
> > partially signed user space, then unsigned process can write to disk
> > directly (of course with right permisions). So secureboot policy can not
> > cache appraisal results.
> > 
> > In fact thinking more about it, I think ima_appraise_tcb policy also
> > is vulnerable. This policy will not appraise files which are not
> > owned by root. And users belonging to group "disk" have write permission
> > to disks.
> > 
> > So if I create a user "foo" and add it to group "disk", it can now launch
> > its own processes and write to disk. And write to root owned files and
> > ima_appraise_tcb policy will not detect the change.
> > 
> > Hence, if ima_appraise_tcb rules are put in front of secureboot rules,
> > caching appraisal results opens a security hole.

We've already spoken about needing an additional hook or moving the
existing bprm hook.  Can we defer the memory caching requirements for
now?

> To avoid clashes between multiple built-in policies can we keep it
> simpler. And that is only one built-in appraisal policy can be effective
> a time. So if secureboot policy is effective, one can not use
> ima_appraise_tcb.

After thinking about it some more and discussing it with Dave, the
built-in appraisal policy would be a fixed policy.   For now, secureboot
would use it to define their policy.  For now, there is no need to
include the ima_appraise_tcb rules in the builtin/fixed chain.  They
could continue to be defined in the other chain.

> We can provide one command line option to disable secureboot policy
> (which works only if platform has secureboot disabled).  So if a user
> wants to use ima_appraise_tcb, he needs to pass two command line options.
> 
> "ima_apprise_secureboot=disable ima_appraise_tcb".
> 
> User can still append its appraise policies using "policy" interface. 

Right, so with the changes suggested above, this wouldn't be needed.

> These
> new rules take affect only if existing kernel policy does not apply to the
> hook.

As mentioned above, the more restrictive policy would be used.

thanks,

Mimi

