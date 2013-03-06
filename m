Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab3CFXiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:38:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab3CFXim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:38:42 -0500
Date: Wed, 6 Mar 2013 18:38:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130306233837.GA29229@redhat.com>
References: <20130301213329.GC3457@redhat.com>
 <1362346944.18325.1.camel@falcor1>
 <20130304152919.GA15199@redhat.com>
 <1362423581.4392.46.camel@falcor1>
 <20130304191546.GF15199@redhat.com>
 <1362446491.4392.133.camel@falcor1>
 <20130305151829.GB4519@redhat.com>
 <1362516018.4392.233.camel@falcor1>
 <20130306155452.GB18337@redhat.com>
 <1362610081.4392.364.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362610081.4392.364.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 05:48:01PM -0500, Mimi Zohar wrote:
> On Wed, 2013-03-06 at 10:54 -0500, Vivek Goyal wrote:
> > On Tue, Mar 05, 2013 at 03:40:18PM -0500, Mimi Zohar wrote:
> > 
> > [..]
> > > > The fact that we are able to replace ima_mem_exec policy using command
> > > > line, binary loader will need a way to query IMA to find what's the
> > > > current policy. If ima_mem_exec has been replaced, then binary loader
> > > > will not memlock files and will not raise extra capability to binary. And
> > > > this will disable kdump functionality on secureboot platforms. (Something
> > > > which I don't like much).
> > > 
> > > Ok
> > 
> > Hi Mimi,
> > 
> > Again, throwing out another idea and see if it has any merit. 
> > 
> > I think there are quite a few issues with trying to use IMA only with
> > the help of policy interface. Different subsystems might have different
> > needs and we don't have a way to support multiple policies. How about
> > if we extend IMA to also provide callable function interface and
> > subsystems can directly call into IMA for integrity verification.
> 
> The original IMA design included such an interface, but it was rejected.
> The conclusion was that LSMs would enforce access control and defer  
> file integrity enforcement to IMA.  IMA policies could be written in
> terms of LSM labels.  As that decision was made a very long time ago,
> and a lot has changed since, perhaps we should to revisit this decision.

I think it is worth having a discussion on this again. Whether old
decision is still good in the light of new requirements.

> 
> > Following are some of the problems I am facing with trying to
> > scale policy based interface.
> > 
> > - Being able to support only one policy at a time creates conflict
> >   between various users of IMA subsystem. Creating a policy which
> >   meets the needs of all subsystem is not practical. And retaining
> >   on policy only serves select use case and disable rest of the
> >   use cases. What we want is to be able to serve multiple use cases
> >   at the same time.
> 
> Our posts must have crossed again.  I already addressed this issue in
> the post https://lkml.org/lkml/2013/3/6/340.

I did go through that mail and frankly speaking did not understand well.
I will go through it again and respond separately.

>   
> Your design overloads the existence of a file signature with additional
> meaning to indicate these files not only need to be appraised, but also
> need 'special' handling.  I don't think you can use this example to
> claim that only one policy can be supported at a time.

Well measure and appraise policy co-exist. But writing to "policy"
interface replaces that. So either kernel default policy can exist
or the one specified using "policy" interface.

Even if we allow multiple policies to co-exist, then first matching
rule will be executed. So a IMA subsystem user can never be sure
whether its rule got executed or not. (Because rule imposed by some
other policy will not serve the purpose).

If we go in the direction of running the more restrictive rule, that
quickly becomes complicated and opens possibility for bugs.

> 
> >   For example, in above case, very soon I might want to also create
> >   a mechanism to verify signature of bzImage loaded by kexec. 
> 
> Absolutely no problem there.  Defining a new bzImage hook will allow
> measuring, hash audit logging, and integrity appraisal of the bzImage.

Defining hook does not say anything about rules. So a hook might return
success but there might not be any rule executed (Because a root user
simply replaced the kernel default policy). Now calling code will assume
that file integrity is fine and go ahead and load the unsigned bzImage.
But the fact is that no integrity measurement was done.

So always allowing root user to load policy does not fit well in
secureboot environment.

> 
> > Say,
> >   mmap() system call is extended to verify signature of mapped file,
> >   or a new system call is created. 
> 
> The mmap hook already exists.  Just as the new kernel module hook was
> recently added, other hooks can be defined just as easily.  With the
> definition of a new hook, all integrity subystem uses get the benefit.

New module hook is racy. It does file integrity verification before
module get copied into kernel memory. So after integrity verification
there is a window where a root user can change the module.

So far I was assuming that not caching the results itself is sufficient
to avoid the direct writes to disk problem. But hash calculation seems
to be happening in ima_collect_measurement(). So once the measurement
has been collected, even if I call the hook again, file will not be
measured again. And when I call hook second time, I want measurement
to be collected again (as I have locked the file in memory and further
reads will come from page cache and disk).

So current IMA in general has not worried about direct writes to disk
problem and it is getting into the way. IMA is just ensuring integrity
of file on disk and now requirement is that verify integrity of file
after it has been loaded into the memory. 

> 
> > In that case there will be another
> >   set of rules and cramming them into mem_exec policy will be odd.
> 
> The mm_exec policy is odd.  It mixes identifying a file for appraising
> and setting up additional system requirements.

We can name this policy something else. Additional requirements is
a problem. That's why I think that IMA should expose functions directly
and let the caller decide what to do (based on requirements). IMA
can just limit itself to looking for signature xattr, verify the signature
and return results. It makes things simple.

> 
> > - Because policy can be replaced easily, some of the functionality
> >   will automatically be disabled. (because associated policy is not
> >   there any more). And this can be very unintutive.
> 
> Limiting the additional functionality to a single policy, is wrong. A
> new policy option (eg. memlock) or even action primitive (eg.
> appraise_memlock) should be defined, allowing any policy to achieve the
> same results.

Sorry I did not get this part. How does any policy achieve the same
results.

> 
> >   For example, even if we do put new rules in mem_exec policy, this
> >   policy can easily be replaced. And kernel loses the capability to
> >   verify signatures of mmaped files.
> 
> The capability of verifying the integrity of an mmaped file has nothing
> to do with the mem_exec policy, but with the mmap hook.

hook just calls into IMA. It does not guarantee anything else. So if a 
user never enables any policy, then no rule gets executed. And 

If we replace the policy with a policy with a rule "don_appraise
bprm_check", then nothing gets appraised. So mmap() hook will call
into IMA but IMA will say no rule matches and IMA will return success.

        action = ima_get_action(inode, mask, function);
        if (!action)
                return 0;

In this new requirement, just calling into the hook is not sufficient.
Success does not mean file integrity was verified. And that's where
the biggest problem is with hook based interface. Hooks can return
success even if nothing was ever verified.

> 
> >  It will be kind of big surprise
> >   where a system call feature disappears because somebody wrote a very
> >   simple policy through "policy" interface. If nothing else, it is
> >   unintutive to me.
> 
> > - One more issue with "policy" based interface is that rules get
> >   evaluated for every security hook. So though I might want to only
> >   appraise files on exec() but on every security hook (file open, mmap etc),
> >   IMA will go through the rule list and see if some rule matches. This can
> >   add to performance overhead.
> 
> The policies that I'm aware of, have been minimal in size (eg. one
> policy doesn't measure anything, but appraises everything). Dmitry has
> made a number of performance improvements and has suggested others,
> which were rejected for lack of userspace impact.  Please feel free to
> post performance improvement patches, indicating userspace impact.

Sure. I think it is much more efficient to not call into hooks at all.
Directly use IMA functions on need basis. If I don't need to verify
integrity of file on mmap() and other hooks, then I should not go
through rules from all hook paths. If we create direct callable functions
then it makes it effiecient automatically.

> 
> > - There are other optimization opportunities. For example, in case of
> >   exec() verification, initially I just want to find out if file being
> >   executed has digital signatures or not. But bprm_check() will go ahead
> >   and appraise the file. The appraisal which matters to us is the one
> >   which happens in post_load(). So there is double appraisal for every
> >   executable.
> 
> Nothing is stopping you from changing the policy from appraising at
> bprm_check() to post_load().

Before I call post_load, I need to know whether file is digitally signed
or not. Given the fact IMA stores the signing information I need to call
into IMA for this info. Given the fact that there are no other interface
to IMA, one kludge is that call bprm_check(). It will appraise file,
set IMA_DIGSIG flag in iint->flags. Propogate that flag in bprm->unsafe
And calling code can read it. 

If file is signed, then caller can lock the file and call post_load()
again to verify signature.

So not calling bprm_check() is not an option.

Here again, calling into IMA functions will help. There can be one 
function just to give information whether file is digitally signed
or not (no appraisal).


> 
> > - In an attempt to meet new requirements, we are quickly eating all
> >   the flag space and very few bits are left and further scaling can
> >   become very difficult.np
> > 
> > I am beginning to get the feeling that probably using "policy" based
> > interface is not the best to cater to wide variety of needs. What
> > if we can provide a set of functions which can be directly called
> > by various subsystem. That way we will make reuse of IMA code and
> > at the same time not worry about clash with other policies.  Policy
> > based interface will continue to work as it.
> > 
> > New set of callable functions will primarily be for appraise purposes.
> > These will retrieive security.ima (and security.evm if EVM is configured),
> > do integrity verification and return the result to caller. There will
> > be no caching of results involved.
> 
> > This should simplify things. It should reduce policy contentions. On
> > every hook we don't have to go through all the policy rules. Internal
> > of IMA subsystems remain less complicated etc.
> > 
> > There will be no need for extensions like appraise_type = optional. Caller
> > of IMA function will decide whether to allow access or not based on 
> > return result. Whether access is optional or not will depend on caller.
> > IMA will just provide integrity result and will not mandate whether to
> > allow access or not.
> > 
> > By default interface will not cache results. So there is no need to
> > worry about providing cache_result=no extensions.
> > 
> > Mimi, what do you think. Does it make any sense?
> 
> This sounds like your original patches, with a minor difference -
> calling the exported IMA functions, instead of calling the crypto
> directly.  Although it resolves the code duplication, the same issues
> that were discussed back then, apply here.  Policy should not be
> hard-coded into the kernel.  Hooks should be defined and accessible for
> all uses (eg. measurement, audit hash logging, integrity appraisal) and
> any new uses going into the future.

Seriously I think this needs to be revisited. First of all this does not
disable any of the current functionality and interfaces. What I am
questioning is that new requirements are making it much harder to use
policy based interface. It probably is much simpler to call into some
IMA functions directly.

IMA is not hardcoding anything here. Only thing caller is doing using
IMA functionality to meet its needs. I think IMA should not be concerned
with what to do if file is not signed. IMA should just return integrity
results and let caller decide what to do with it. Similar, IMA should not
be concerned whether file is memlocked or not. It depends on whehther
all of the user space is signed or not.

I don't know, but more I try to make policy based interface, more I get
the feeling that it is not right thing to do. It is unnecessarily
complicating the IMA code and maintenance of code will become harder. It
will become hard for a user to figure out what's going on. What does
integrity success mean, what file actually appraised and there is no
way to query it.

IMHO, we should continue with current policy based interface but to
meet new requirements in less complicated way, we should also export
some directly callable funcations and they take care of not coming with
a new way to sign a file and reusing existing coe.

Thanks
Vivek

> 
> Mimi
