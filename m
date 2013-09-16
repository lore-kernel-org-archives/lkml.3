Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3IPIWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:22:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab3IPIWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:22:15 -0400
Date: Mon, 16 Sep 2013 10:22:09 +0200
From: Andrew Jones <drjones@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] x86: kvm: remove KVM_SOFT_MAX_VCPUS
Message-ID: <20130916082208.GA2101@hawk.usersys.redhat.com>
References: <1379161011-28239-1-git-send-email-drjones@redhat.com>
 <20130915090322.GV17294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130915090322.GV17294@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 12:03:22PM +0300, Gleb Natapov wrote:
> On Sat, Sep 14, 2013 at 02:16:51PM +0200, Andrew Jones wrote:
> > This patch removes KVM_SOFT_MAX_VCPUS and uses num_online_cpus() for
> > KVM_CAP_NR_VCPUS instead, as ARM does. While the API doc simply says
> > KVM_CAP_NR_VCPUS should return the recommended maximum number of vcpus,
> > it has been returning KVM_SOFT_MAX_VCPUS, which was defined as the
> > maximum tested number of vcpus. As that concept could be
> > distro-specific, this patch uses the other recommended maximum, the
> > number of physical cpus, as we never recommend configuring a guest that
> > has more vcpus than the host has pcpus. Of course a guest can always
> > still be configured with up to KVM_CAP_MAX_VCPUS though anyway.
> > 
> > I've put RFC on this patch because I'm not sure if there are any gotchas
> > lurking with this change. The change now means hosts no longer return
> > the same number for KVM_CAP_NR_VCPUS, and that number is likely going to
> > generally be quite a bit less than what KVM_SOFT_MAX_VCPUS was (160). I
> > can't think of anything other than generating more warnings[1] from qemu
> > with guests that configure more vcpus than pcpus though.
> > 
> Another gotcha is that on a host with more then 160 cpus recommended
> value will grow which is not a good idea without appropriate testing.

Good point. Of course the objective could be to test a guest with
vcpus > 160 on that host, and then the potential warning messages would
need to be ignored. Probably the best place to set the cap on the number
of vcpus used in a stable environment would be in KVM_MAX_VCPUS. That said,
then at least until KVM_SOFT_MAX_VCPUS catches up to KVM_MAX_VCPUS, I guess
we should keep them both to avoid breaking anything.

> 
> > [1] Actually, until 972fc544b6034a in uq/master is merged there won't be
> >     any warnings either.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 1 -
> >  arch/x86/kvm/x86.c              | 2 +-
> >  2 files changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index c76ff74a98f2e..9236c63315a9b 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -32,7 +32,6 @@
> >  #include <asm/asm.h>
> >  
> >  #define KVM_MAX_VCPUS 255
> > -#define KVM_SOFT_MAX_VCPUS 160
> >  #define KVM_USER_MEM_SLOTS 125
> >  /* memory slots that are not exposed to userspace */
> >  #define KVM_PRIVATE_MEM_SLOTS 3
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e5ca72a5cdb6d..d9d3e2ed68ee9 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2604,7 +2604,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> >  		r = !kvm_x86_ops->cpu_has_accelerated_tpr();
> >  		break;
> >  	case KVM_CAP_NR_VCPUS:
> > -		r = KVM_SOFT_MAX_VCPUS;
> > +		r = min(num_online_cpus(), KVM_MAX_VCPUS);
> s/KVM_MAX_VCPUS/KVM_SOFT_MAX_VCPUS/.  Also what about hotplug cpus?

I'll send a v2 with this change.

I thought a bit about hotplug, and thus using num_possible_cpus()
instead, but then decided it made more sense to stick to what's online now
for the recommended number. It's just a recommendation anyway. So as long
as KVM_MAX_VCPUS is >= num_possible_cpus(), then one can still configure
more vcpus to count for all hotplugable cpus, if they wish.

drew
