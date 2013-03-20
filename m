Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab3CTP1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:27:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933099Ab3CTP1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:27:09 -0400
Date: Wed, 20 Mar 2013 11:21:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dmitry.kasatkin@intel.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 4/4] binfmt_elf: Elf executable signature verification
Message-ID: <20130320152134.GA2273@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
 <1363379758-10071-5-git-send-email-vgoyal@redhat.com>
 <1363703941.2532.27.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363703941.2532.27.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:39:01AM -0400, Mimi Zohar wrote:

[..]
> > +#ifdef CONFIG_BINFMT_ELF_SIG
> > +	/* If executable is digitally signed. Lock down in memory */
> > +	/* Get file signature, if any */
> > +	retval = ima_file_signature_alloc(bprm->file, &signature);
> > +
> > +	/*
> > +	 * If there is an error getting signature, bail out. Having
> > +	 * no signature is fine though.
> > +	 */
> > +	if (retval < 0 && retval != -ENODATA && retval != -EOPNOTSUPP)
> > +		goto out_free_dentry;
> > +
> > +	if (signature != NULL) {
> > +		siglen = retval;
> > +		retval = ima_signature_type(signature, &sig_type);
> > +		if (!retval && sig_type == EVM_IMA_XATTR_DIGSIG_ASYMMETRIC)
> > +			mlock_mappings = true;
> > +	}
> > +
> > +	if (mlock_mappings)
> > +		current->mm->def_flags |= VM_LOCKED;
> 
> Vivek, we've already discussed this.  Hard coding policy in the kernel
> is unacceptable, whether it is inlined, here, or as part of IMA.
> Defining a policy, that mlocks all signed ELF executables, does not
> scale.  The 'ima_appraise_tcb' policy requires all files owned by root
> to be signed.  Please define some other mechanism, other than a
> signature, for identifying files that you want to mlock.
> (Recommendations were previously made, which you rejected.)

Hi Mimi,

How about just just defining another config option CONFIG_BINFMT_MEMLOCK_SIGNED.

So CONFIG_BINFMT_ELF_SIG takes care of signature verification and
CONFIG_BINFMT_MEMLOCK_SIGNED will determine whether executable is locked
in memory or not.

If I define any command line options to enable/disable it, then root can
easily bypass this. And that's the problem I am trying to solve. In
secureboot environment we don't trust root.

And what's the use case for some of the signed executables locked but
not others. I am able to visualize only two states. Either we lock down
every signed process  or we don't lock anything in (Assuming we have
signed all the user space and no unsigned process can execute now so
hopefully it is safe to not lock down process memory).

That's why I think it is not per file attribute. It is in general system
attribute whether on this system signed files should be locked or not. And
given the fact we don't trust root in secureboot environment, we can't
define external mechanism to trigger policy and it has to be built-in.

So it is not same as ima_appraise_tcb as there you trust root. Even if you
don't there are ways to detect that things are not right (by remote
attestation). But in case of secureboot no such mechanism is there. So one
can not trust root to configure a policy.

> 
> Lastly, adding 'VM_LOCKED' here seems to change existing, expected
> behavior.  According to the mlock(2) man pages, "Memory locks are not
> inherited by a child created via fork(2) and are automatically removed
> (unlocked) during an execve(2) or when the process terminates."  Someone
> else needs to comment on this sort of change.  Andrew?  Al?

I will read more about it. I know that some more work is needed here. For
example, one can say munlock()/munlockall() on already locked pages. I
was thinkingof defining a new flag say VM_LOCKED_PERM. So any pages which
have been locked by kernel are permanent and can not be unlocked by user
space until and unless process exits.

I just need to spend more time in this memory locking area to cover all
the corner cases and make sure kernel mlocked pages are not unlocked.

Thanks
Vivek
