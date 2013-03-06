Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3CFWuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:50:02 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:37824 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3CFWt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:49:58 -0500
Message-ID: <1362610081.4392.364.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Wed, 06 Mar 2013 17:48:01 -0500
In-Reply-To: <20130306155452.GB18337@redhat.com>
References: <20130301184027.GB3457@redhat.com>
	 <1362166753.9158.169.camel@falcor1> <20130301213329.GC3457@redhat.com>
	 <1362346944.18325.1.camel@falcor1> <20130304152919.GA15199@redhat.com>
	 <1362423581.4392.46.camel@falcor1> <20130304191546.GF15199@redhat.com>
	 <1362446491.4392.133.camel@falcor1> <20130305151829.GB4519@redhat.com>
	 <1362516018.4392.233.camel@falcor1> <20130306155452.GB18337@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030622-2876-0000-0000-00000611E262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 10:54 -0500, Vivek Goyal wrote:
> On Tue, Mar 05, 2013 at 03:40:18PM -0500, Mimi Zohar wrote:
> 
> [..]
> > > The fact that we are able to replace ima_mem_exec policy using command
> > > line, binary loader will need a way to query IMA to find what's the
> > > current policy. If ima_mem_exec has been replaced, then binary loader
> > > will not memlock files and will not raise extra capability to binary. And
> > > this will disable kdump functionality on secureboot platforms. (Something
> > > which I don't like much).
> > 
> > Ok
> 
> Hi Mimi,
> 
> Again, throwing out another idea and see if it has any merit. 
> 
> I think there are quite a few issues with trying to use IMA only with
> the help of policy interface. Different subsystems might have different
> needs and we don't have a way to support multiple policies. How about
> if we extend IMA to also provide callable function interface and
> subsystems can directly call into IMA for integrity verification.

The original IMA design included such an interface, but it was rejected.
The conclusion was that LSMs would enforce access control and defer  
file integrity enforcement to IMA.  IMA policies could be written in
terms of LSM labels.  As that decision was made a very long time ago,
and a lot has changed since, perhaps we should to revisit this decision.

> Following are some of the problems I am facing with trying to
> scale policy based interface.
> 
> - Being able to support only one policy at a time creates conflict
>   between various users of IMA subsystem. Creating a policy which
>   meets the needs of all subsystem is not practical. And retaining
>   on policy only serves select use case and disable rest of the
>   use cases. What we want is to be able to serve multiple use cases
>   at the same time.

Our posts must have crossed again.  I already addressed this issue in
the post https://lkml.org/lkml/2013/3/6/340.
  
Your design overloads the existence of a file signature with additional
meaning to indicate these files not only need to be appraised, but also
need 'special' handling.  I don't think you can use this example to
claim that only one policy can be supported at a time.

>   For example, in above case, very soon I might want to also create
>   a mechanism to verify signature of bzImage loaded by kexec. 

Absolutely no problem there.  Defining a new bzImage hook will allow
measuring, hash audit logging, and integrity appraisal of the bzImage.

> Say,
>   mmap() system call is extended to verify signature of mapped file,
>   or a new system call is created. 

The mmap hook already exists.  Just as the new kernel module hook was
recently added, other hooks can be defined just as easily.  With the
definition of a new hook, all integrity subystem uses get the benefit.

> In that case there will be another
>   set of rules and cramming them into mem_exec policy will be odd.

The mm_exec policy is odd.  It mixes identifying a file for appraising
and setting up additional system requirements.

> - Because policy can be replaced easily, some of the functionality
>   will automatically be disabled. (because associated policy is not
>   there any more). And this can be very unintutive.

Limiting the additional functionality to a single policy, is wrong. A
new policy option (eg. memlock) or even action primitive (eg.
appraise_memlock) should be defined, allowing any policy to achieve the
same results.

>   For example, even if we do put new rules in mem_exec policy, this
>   policy can easily be replaced. And kernel loses the capability to
>   verify signatures of mmaped files.

The capability of verifying the integrity of an mmaped file has nothing
to do with the mem_exec policy, but with the mmap hook.

>  It will be kind of big surprise
>   where a system call feature disappears because somebody wrote a very
>   simple policy through "policy" interface. If nothing else, it is
>   unintutive to me.

> - One more issue with "policy" based interface is that rules get
>   evaluated for every security hook. So though I might want to only
>   appraise files on exec() but on every security hook (file open, mmap etc),
>   IMA will go through the rule list and see if some rule matches. This can
>   add to performance overhead.

The policies that I'm aware of, have been minimal in size (eg. one
policy doesn't measure anything, but appraises everything). Dmitry has
made a number of performance improvements and has suggested others,
which were rejected for lack of userspace impact.  Please feel free to
post performance improvement patches, indicating userspace impact.

> - There are other optimization opportunities. For example, in case of
>   exec() verification, initially I just want to find out if file being
>   executed has digital signatures or not. But bprm_check() will go ahead
>   and appraise the file. The appraisal which matters to us is the one
>   which happens in post_load(). So there is double appraisal for every
>   executable.

Nothing is stopping you from changing the policy from appraising at
bprm_check() to post_load().

> - In an attempt to meet new requirements, we are quickly eating all
>   the flag space and very few bits are left and further scaling can
>   become very difficult.np
> 
> I am beginning to get the feeling that probably using "policy" based
> interface is not the best to cater to wide variety of needs. What
> if we can provide a set of functions which can be directly called
> by various subsystem. That way we will make reuse of IMA code and
> at the same time not worry about clash with other policies.  Policy
> based interface will continue to work as it.
> 
> New set of callable functions will primarily be for appraise purposes.
> These will retrieive security.ima (and security.evm if EVM is configured),
> do integrity verification and return the result to caller. There will
> be no caching of results involved.

> This should simplify things. It should reduce policy contentions. On
> every hook we don't have to go through all the policy rules. Internal
> of IMA subsystems remain less complicated etc.
> 
> There will be no need for extensions like appraise_type = optional. Caller
> of IMA function will decide whether to allow access or not based on 
> return result. Whether access is optional or not will depend on caller.
> IMA will just provide integrity result and will not mandate whether to
> allow access or not.
> 
> By default interface will not cache results. So there is no need to
> worry about providing cache_result=no extensions.
> 
> Mimi, what do you think. Does it make any sense?

This sounds like your original patches, with a minor difference -
calling the exported IMA functions, instead of calling the crypto
directly.  Although it resolves the code duplication, the same issues
that were discussed back then, apply here.  Policy should not be
hard-coded into the kernel.  Hooks should be defined and accessible for
all uses (eg. measurement, audit hash logging, integrity appraisal) and
any new uses going into the future.

Mimi

