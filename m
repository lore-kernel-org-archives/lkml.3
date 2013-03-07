Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab3CGO5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:57:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932972Ab3CGO5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:57:38 -0500
Date: Thu, 7 Mar 2013 09:57:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130307145733.GB2790@redhat.com>
References: <20130304152919.GA15199@redhat.com>
 <1362423581.4392.46.camel@falcor1>
 <20130304191546.GF15199@redhat.com>
 <1362446491.4392.133.camel@falcor1>
 <20130305151829.GB4519@redhat.com>
 <1362516018.4392.233.camel@falcor1>
 <20130306155452.GB18337@redhat.com>
 <1362610081.4392.364.camel@falcor1>
 <20130306233837.GA29229@redhat.com>
 <1362663507.4392.422.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362663507.4392.422.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:38:27AM -0500, Mimi Zohar wrote:
> On Wed, 2013-03-06 at 18:38 -0500, Vivek Goyal wrote:
> > On Wed, Mar 06, 2013 at 05:48:01PM -0500, Mimi Zohar wrote:
> > > On Wed, 2013-03-06 at 10:54 -0500, Vivek Goyal wrote:
> 
> [...]
> > > > - Because policy can be replaced easily, some of the functionality
> > > >   will automatically be disabled. (because associated policy is not
> > > >   there any more). And this can be very unintutive.
> > > 
> > > Limiting the additional functionality to a single policy, is wrong. A
> > > new policy option (eg. memlock) or even action primitive (eg.
> > > appraise_memlock) should be defined, allowing any policy to achieve the
> > > same results.
> > 
> > Sorry I did not get this part. How does any policy achieve the same
> > results.
> 
> This discussion has gone through many twists and turns - original direct
> crypto calls to verify appended signature, 'optional' policy flag,
> locking memory, fixing appraisal results, differentiating ima vs. evm
> appraisal results, iint caching, merging policies vs. either/or policy, 
> new policy memory lock option/action, separating policy from locking
> memory, and now exporting integrity calls.
> 
> Once you resolve the 'special' processing (eg. memory locking issue)
> being tied to the policy, either by removing the requirement

I don't think requirement can be removed. Otherwise one can easily
modify the file after measurement in memory and doing integrity
verification is effectively of no use.

> or by
> defining a new policy option/action primitive,

Memory locking should not belong to IMA subsystem. It is up to the caller
whether it wants to lock file in memory or not. And whether a file should
be locked in memory or not is not a file specific property also.

Think of a signed file being sent on another system (assume cpio has been 
modified to take care of xattr). Then this other system might be running
a fully signed user space and one might not have to lock the files. Or
this other system might not have any swap and disabled ptrace()
capability, then there is no need to lock files.

Hence locking a file is not file specific property hence should not be a
file attribute. And it does not fall into the Integrity area too. It all
depends on caller and in what context integrity is being verified. So I
don't think that IMA is right place to take care of this issue. IMA should
just export functions to enable caller to achieve what it wants to.

> you'll be able to resolve
> your policy requirements, without merging rules or limiting
> functionality for other policies.

Even if I define above as policy option, then there will still be another
appraise policy. So how multiple appraise policies will co-exist together?

> 
> Limiting functionality (eg. kexec) to a single builtin policy is
> unacceptable.

Sure that's why I am saying trying to build more polices is not a good
idea. Just export functions.

>  The same mechanism, that the builtin kmem_lock policy
> uses to make kexec permissible, should be available to all policies.

Locking a file does not fall into IMA area. It is up to the file loader.
In case of binary, it is up to the binary loader. IMA can not dictate
or lock the file based on policy.

Thanks
Vivek
