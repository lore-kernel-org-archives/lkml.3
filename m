Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3IQKDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:03:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab3IQKDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:03:15 -0400
Date: Tue, 17 Sep 2013 12:03:09 +0200
From: Andrew Jones <drjones@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] x86: kvm: remove KVM_SOFT_MAX_VCPUS
Message-ID: <20130917100308.GA2169@hawk.usersys.redhat.com>
References: <1379161011-28239-1-git-send-email-drjones@redhat.com>
 <20130915090322.GV17294@redhat.com>
 <20130916082208.GA2101@hawk.usersys.redhat.com>
 <20130916085517.GK17294@redhat.com>
 <20130916114725.GA14981@hawk.usersys.redhat.com>
 <20130916144118.GB906@redhat.com>
 <20130916152226.GA17256@hawk.usersys.redhat.com>
 <20130917093619.GW17294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917093619.GW17294@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 12:36:19PM +0300, Gleb Natapov wrote:
> On Mon, Sep 16, 2013 at 05:22:26PM +0200, Andrew Jones wrote:
> > On Mon, Sep 16, 2013 at 05:41:18PM +0300, Gleb Natapov wrote:
> > > On Mon, Sep 16, 2013 at 01:47:26PM +0200, Andrew Jones wrote:
> > > > On Mon, Sep 16, 2013 at 11:55:17AM +0300, Gleb Natapov wrote:
> > > > > On Mon, Sep 16, 2013 at 10:22:09AM +0200, Andrew Jones wrote:
> > > > > > > > [1] Actually, until 972fc544b6034a in uq/master is merged there won't be
> > > > > > > >     any warnings either.
> > > > > > > > 
> > > > > > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > > > > > > ---
> > > > > > > >  arch/x86/include/asm/kvm_host.h | 1 -
> > > > > > > >  arch/x86/kvm/x86.c              | 2 +-
> > > > > > > >  2 files changed, 1 insertion(+), 2 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > > > > > index c76ff74a98f2e..9236c63315a9b 100644
> > > > > > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > > > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > > > > > @@ -32,7 +32,6 @@
> > > > > > > >  #include <asm/asm.h>
> > > > > > > >  
> > > > > > > >  #define KVM_MAX_VCPUS 255
> > > > > > > > -#define KVM_SOFT_MAX_VCPUS 160
> > > > > > > >  #define KVM_USER_MEM_SLOTS 125
> > > > > > > >  /* memory slots that are not exposed to userspace */
> > > > > > > >  #define KVM_PRIVATE_MEM_SLOTS 3
> > > > > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > > > > index e5ca72a5cdb6d..d9d3e2ed68ee9 100644
> > > > > > > > --- a/arch/x86/kvm/x86.c
> > > > > > > > +++ b/arch/x86/kvm/x86.c
> > > > > > > > @@ -2604,7 +2604,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> > > > > > > >  		r = !kvm_x86_ops->cpu_has_accelerated_tpr();
> > > > > > > >  		break;
> > > > > > > >  	case KVM_CAP_NR_VCPUS:
> > > > > > > > -		r = KVM_SOFT_MAX_VCPUS;
> > > > > > > > +		r = min(num_online_cpus(), KVM_MAX_VCPUS);
> > > > > > > s/KVM_MAX_VCPUS/KVM_SOFT_MAX_VCPUS/.  Also what about hotplug cpus?
> > > > > > 
> > > > > > I'll send a v2 with this change.
> > > > > > 
> > > > > > I thought a bit about hotplug, and thus using num_possible_cpus()
> > > > > > instead, but then decided it made more sense to stick to what's online now
> > > > > > for the recommended number. It's just a recommendation anyway. So as long
> > > > > > as KVM_MAX_VCPUS is >= num_possible_cpus(), then one can still configure
> > > > > > more vcpus to count for all hotplugable cpus, if they wish.
> > > > > > 
> > > > > It is just recommended, but we do warn about it, so it is user visible.
> > > > > Well, the whole point of it existence is to be user visible ;). If user
> > > > > creates a guest with max cpus greater than current number if online
> > > > > cpus, taking into account feature grows, he will get a warning, but we
> > > > > should not warn about it.
> > > > 
> > > > Even it if means the user may end up running, e.g. 128 vcpus on 96 pcpus
> > > > indefinitely? I'd rather warn about it, which could remind them to offline
> > > > 32 vcpus for the time being.
> > > But there are other means to detect number of online cpus:
> > > sysconf(_SC_NPROCESSORS_ONLN). Actually you can determine number of
> > > possible cpus too with _SC_NPROCESSORS_CONF, so returning those values
> > > as KVM_CAP_NR_VCPUS does not provide any additional information. What
> > > if QEMU process is bound to two cores on 64 core host, do you want to
> > > warn if qemu is created with more then 2 vcpus in such case? You can do
> > > that too with pthread_setaffinity_np(). 
> > > 
> > > >                               Although, as we're just discussing when or
> > > > when not to output a warning, then I'm not really stressed about it either
> > > > way. I can certainly change this to num_possible_cpus(), if all are in
> > > > agreement that that is a better recommendation.
> > > > 
> > > With this patch we only reduce information available to userspace. QEMU
> > > can already obtain all the information it needs to produce meaningful
> > > warning.
> > 
> > All good points. We're still left with the fact that KVM_CAP_NR_VCPU
> > currently returns a distro-specific number though, which can only be
> > modified by changing a constant embedded in the source. So I still believe
> > that a config option is in order, but now you're convincing me that the
> > option should adjust KVM_SOFT_MAX_VCPUS instead. The default should also
> > remain distro-neutral, so I vote 255. We'd then change the defines to be
> > 
> > #define KVM_SOFT_MAX_VCPUS CONFIG_KVM_SOFT_MAX_VCPUS
> > #define KVM_MAX_VCPUS KVM_SOFT_MAX_VCPUS
> > 
> So you make KVM_MAX_VCPUS same as KVM_SOFT_MAX_VCPUS, what's the point
> to have both then? KVM_MAX_VCPUS is max number of cpu that KVM supports

I actually didn't believe there was a good point, until...

> because of architectural and/or implementation reasons. Current maximum
> is 255 because this is what X2APIC supports without interrupt remapping
> and we cannot grow this number without additional coding.
> KVM_SOFT_MAX_VCPUS is the number we (upstream) feel single VM can

...learning this. I didn't know that KVM_SOFT_MAX_VCPUS was an upstream
agreement. I thought that number came out of distro-specific testing (indeed
that's what the commit message says), and thus I wanted to move it into
distro-configurable territory. I also didn't know that the 255 limit
serves to document the maximum the x2apic supports. Should we add a
comment for that define stating that?

Anyway, now that'd you've clarified all this for me, please disregard both
this and the other patch.

drew
