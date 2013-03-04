Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3CDPb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:31:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758033Ab3CDPbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:31:25 -0500
Date: Mon, 4 Mar 2013 10:29:19 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130304152919.GA15199@redhat.com>
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
> > > We've already spoken about needing an additional hook or moving the
> > > existing bprm hook.  Can we defer the memory caching requirements for
> > > now?
> > 
> > Sure, additional hook is not a concern.
> > 
> > I can defer caching discussion but I think it is important to discuss
> > it now. Because it might very well affect how do we decide to handle
> > multiple appraise rules/policies. So please, if possible, let us not
> > defer the caching requirement discussion.
> > 
> > My biggest concern is what if we decide to rule based caching option
> > and rule gets skipped because of more restrictive rule present.
> > 
> > appraise func=bprm_check cache_status=no
> > appraise fowner=root 
> > 
> > In above case second rule will override first one and that's not what
> > we want.
> 
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

Hi Mimi,

If we decide to merge flags, then practically we modified the
ima_appraise_tcb policy. ima_appraise_tcb policy expects to cache the
results and we will not do that. And this conflict just grows if we
are forced to add more options in future.

Also as you mentioned that in some cases flag merging is OR operation
and in another cases it might be AND operation. And we will most likely
end up hardcoding all this. I think slowly this is getting complicated
and as people add more complex rules things can quickly get out of hand.

I am wondering that why are we trying to make multiple policies work
together. Can we try to keep it simple and say that at one point of
time only one policy can be effective. It could either be a built in
policy or user defined one. In fact that's how things are working right now.
User defined policy replaces built-in policy.

For the sake of backward compatibility "ima_tcb" and "ima_appraise_tcb"
can co-exist together (like today). But ima_secureboot_policy will not
be compatible with other policies. I understand that there might be a
desire to use multiple policies together down the line, but I guess in
that case policies need to specified using "policy" interface. And
ima_secureboot will be odd man out here as it can not trust the root
to specify policy. So practically ima_secureboot will be disabled.

We just have to provide an IMA interface so that caller can query what's
the effective policy currently. Say, IMA_POLICY_SECUREBOOT,
IMA_POLICY_TCB, or IMA_POLICY_USER. Caller of the bprm_check() or
bprm_post_load() can also check for current policy in force and give
CAP_SIGNED only if desired policy is in effect.  

This reduces our options but trying to make multiple policies co-exist
together is just making it complicated. We can take it up again when
somebody has a strong use case of using secureboot policy along with
other policies. In fact a user can still define a custom policy which
is mix of multiple policies. Just that it is not compatible with
"secureboot" policy because for that we can't trust "root" to define
policy.

Thanks
Vivek
