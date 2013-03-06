Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab3CFPy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:54:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab3CFPy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:54:56 -0500
Date: Wed, 6 Mar 2013 10:54:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130306155452.GB18337@redhat.com>
References: <20130301184027.GB3457@redhat.com>
 <1362166753.9158.169.camel@falcor1>
 <20130301213329.GC3457@redhat.com>
 <1362346944.18325.1.camel@falcor1>
 <20130304152919.GA15199@redhat.com>
 <1362423581.4392.46.camel@falcor1>
 <20130304191546.GF15199@redhat.com>
 <1362446491.4392.133.camel@falcor1>
 <20130305151829.GB4519@redhat.com>
 <1362516018.4392.233.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362516018.4392.233.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 03:40:18PM -0500, Mimi Zohar wrote:

[..]
> > The fact that we are able to replace ima_mem_exec policy using command
> > line, binary loader will need a way to query IMA to find what's the
> > current policy. If ima_mem_exec has been replaced, then binary loader
> > will not memlock files and will not raise extra capability to binary. And
> > this will disable kdump functionality on secureboot platforms. (Something
> > which I don't like much).
> 
> Ok

Hi Mimi,

Again, throwing out another idea and see if it has any merit. 

I think there are quite a few issues with trying to use IMA only with
the help of policy interface. Different subsystems might have different
needs and we don't have a way to support multiple policies. How about
if we extend IMA to also provide callable function interface and
subsystems can directly call into IMA for integrity verification.

Following are some of the problems I am facing with trying to
scale policy based interface.

- Being able to support only one policy at a time creates conflict
  between various users of IMA subsystem. Creating a policy which
  meets the needs of all subsystem is not practical. And retaining
  on policy only serves select use case and disable rest of the
  use cases. What we want is to be able to serve multiple use cases
  at the same time.

  For example, in above case, very soon I might want to also create
  a mechanism to verify signature of bzImage loaded by kexec. Say,
  mmap() system call is extended to verify signature of mapped file,
  or a new system call is created. In that case there will be another
  set of rules and cramming them into mem_exec policy will be odd.

- Because policy can be replaced easily, some of the functionality
  will automatically be disabled. (because associated policy is not
  there any more). And this can be very unintutive.

  For example, even if we do put new rules in mem_exec policy, this
  policy can easily be replaced. And kernel loses the capability to
  verify signatures of mmaped files. It will be kind of big surprise
  where a system call feature disappears because somebody wrote a very
  simple policy through "policy" interface. If nothing else, it is
  unintutive to me.

- One more issue with "policy" based interface is that rules get
  evaluated for every security hook. So though I might want to only
  appraise files on exec() but on every security hook (file open, mmap etc),
  IMA will go through the rule list and see if some rule matches. This can
  add to performance overhead.

- There are other optimization opportunities. For example, in case of
  exec() verification, initially I just want to find out if file being
  executed has digital signatures or not. But bprm_check() will go ahead
  and appraise the file. The appraisal which matters to us is the one
  which happens in post_load(). So there is double appraisal for every
  executable.

- In an attempt to meet new requirements, we are quickly eating all
  the flag space and very few bits are left and further scaling can
  become very difficult.

I am beginning to get the feeling that probably using "policy" based
interface is not the best to cater to wide variety of needs. What
if we can provide a set of functions which can be directly called
by various subsystem. That way we will make reuse of IMA code and
at the same time not worry about clash with other policies.  Policy
based interface will continue to work as it.

New set of callable functions will primarily be for appraise purposes.
These will retrieive security.ima (and security.evm if EVM is configured),
do integrity verification and return the result to caller. There will
be no caching of results involved.

This should simplify things. It should reduce policy contentions. On
every hook we don't have to go through all the policy rules. Internal
of IMA subsystems remain less complicated etc.

There will be no need for extensions like appraise_type = optional. Caller
of IMA function will decide whether to allow access or not based on 
return result. Whether access is optional or not will depend on caller.
IMA will just provide integrity result and will not mandate whether to
allow access or not.

By default interface will not cache results. So there is no need to
worry about providing cache_result=no extensions.

Mimi, what do you think. Does it make any sense?

Thanks
Vivek
