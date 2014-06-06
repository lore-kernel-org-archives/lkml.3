Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaFFS16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:27:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbaFFS15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:27:57 -0400
Date: Fri, 6 Jun 2014 14:27:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: ego@linux.vnet.ibm.com, matt@ozlabs.org, mahesh@linux.vnet.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        suzuki@in.ibm.com, ebiederm@xmission.com, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] powerpc, kexec: Fix "Processor X is stuck" issue during
 kexec from ST mode
Message-ID: <20140606182720.GL1526@redhat.com>
References: <20140527105511.24309.74320.stgit@srivatsabhat.in.ibm.com>
 <20140528133143.GK14863@redhat.com>
 <538E2FF8.8060707@linux.vnet.ibm.com>
 <1401833365.3247.36.camel@pasglop>
 <20140604134649.GB27557@redhat.com>
 <5391B473.2050809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5391B473.2050809@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 06:00:43PM +0530, Srivatsa S. Bhat wrote:
> On 06/04/2014 07:16 PM, Vivek Goyal wrote:
> > On Wed, Jun 04, 2014 at 08:09:25AM +1000, Benjamin Herrenschmidt wrote:
> >> On Wed, 2014-06-04 at 01:58 +0530, Srivatsa S. Bhat wrote:
> >>> Yep, that makes sense. But unfortunately I don't have enough insight into
> >>> why exactly powerpc has to online the CPUs before doing a kexec. I just
> >>> know from the commit log and the comment mentioned above (and from my own
> >>> experiments) that the CPUs will get stuck if they were offline. Perhaps
> >>> somebody more knowledgeable can explain this in detail and suggest a proper
> >>> long-term solution.
> >>>
> >>> Matt, Ben, any thoughts on this?
> >>
> >> The problem is with our "soft offline" which we do on some platforms. When we
> >> offline we don't actually send the CPUs back to firmware or anything like that.
> >>
> >> We put them into a very low low power loop inside Linux.
> >>
> >> The new kernel has no way to extract them from that loop. So we must re-"online"
> >> them before we kexec so they can be passed to the new kernel normally (or returned
> >> to firmware like we do on powernv).
> > 
> > Srivatsa,
> > 
> > Looks like your patch has been merged.
> > 
> > I don't like the following change in arch independent code.
> > 
> > /*
> >  * migrate_to_reboot_cpu() disables CPU hotplug assuming  that
> >  * no further code needs to use CPU hotplug (which is true in
> >  * the reboot case). However, the kexec path depends on  using
> >  * CPU hotplug again; so re-enable it here. 
> >  */
> >                cpu_hotplug_enable();
> > 
> > As it is very powerpc specific requirement, can you enable hotplug in powerpc
> > arch dependent code as a short term solution.
> > 
> 
> I didn't do that because that would mean that the _disable() would be
> performed inside kernel/kexec.c and the corresponding _enable() would
> be performed in arch/powerpc/kernel/machine_kexec_64.c -- with no apparent
> connection between them, which would have made them hard to relate.

Which we are doing anyway. The difference is that now we are doing it
for all arches.

If this is powerpc specific requirement, then we should limit this to
powerpc only and not let spill over in generic code.

And putting a big fat comment should take care of being able to figure
out why arch code is overwriting the generic code's decision. By putting
it in generic code and enforcing this on all arches does not buy us
anything, IMHO.


> 
> > Ideally one needs to fix the requirement of online all cpus in powerpc
> > as a long term solution and then get rid of hotplug enable call.
> > 
> 
> Yes, I agree. I'm trying out a solution at the moment (see the 4
> preliminary patches I sent in my reply to Ben). If that works, we won't
> need the enable call on powerpc.

Thanks. This will help.

Thanks
Vivek
