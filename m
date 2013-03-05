Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3CEVxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:53:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab3CEVxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:53:04 -0500
Date: Tue, 5 Mar 2013 16:53:00 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130305215300.GE4519@redhat.com>
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
> On Tue, 2013-03-05 at 10:18 -0500, Vivek Goyal wrote:
> 
> > Can we do following. (Just modifying your proposal little bit).
> > 
> > - Implement a new policy say ima_mem_exec. This policy can vary based on
> >   config options. This will be the default policy. 
> 
> Just to clarify, the default is the existing null policy.  When
> 'secureboot' is enabled, ima_mem_exec will be the default policy.

Ok, I can do that. I will compile in memlock_exec_appraise policy based on
config option. But this policy will take affect only if.

- user enables it using command line option ima_memlock_exec_appraise
- Or secureboot is enabled.

So that way, systems which don't have secureboot enabled, will not see
the overhead of memlock_exec_appraise policy.

> 
> > - ima_mem_exec will be default policy and it can be disabled by passing
> >   a command line option ima_mem_exec_disable.
> > 
> > - If user wants to use ima_apprase_tcb policy, they can pass two command
> >   line option. (ima_mem_exec_disable  and ima_appraise_tcb).
> 
> Both aren't really needed.   Nothing changes for existing users, if
> 'ima_appraise_tcb' replaces the ima_mem_exec policy. 

Ok, I can allow ima_appraise_tcb to replace memlock_exec_appraise policy
(even with secureboot enabled). For the time being this sould not be a
problem as only side effect is that kdump will not be available on
secureboot platoforms.

But if people start building more functionality on user executable
signing policy, then we might have some issues. I guess will handle that
once new use cases come up.

> 
> > - Similary if user wants to put its own policy using "policy" interface,
> >   they need to boot kernel with command line option "ima_mem_exec_disable".
> 
> Not a good idea, as this would be a new requirement for existing users.
> Invert the logic.

Sure. I will allow root to override in-built appraise policy using
"policy" interface.

> 
> > In the end, this is again "either A or B"  mechanism. Both ima_mem_exec
> > and ima_appraise_tcb are not co-existing. Comand line option just enables
> > choosing one over other.
> 
> Does this impact 'ima_tcb' or only 'ima_appraise_tcb'?

I think I can keep ima_tcb and ima_appraise_tcb as it is. That is both
the measure and appraise rules go in single policy (like today).

> 
> > The fact that we are able to replace ima_mem_exec policy using command
> > line, binary loader will need a way to query IMA to find what's the
> > current policy. If ima_mem_exec has been replaced, then binary loader
> > will not memlock files and will not raise extra capability to binary. And
> > this will disable kdump functionality on secureboot platforms. (Something
> > which I don't like much).
> 
> Ok

Mimi, so you like this idea better than the other idea of keeping two 
policy chains and running more restrictive rule while resolving flag
conflicts between two rules?

I have written some patches to maintain two rule chains and running
more restrictive rule. I can change it though.

Thanks
Vivek
