Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3IPOlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab3IPOlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:41:22 -0400
Date: Mon, 16 Sep 2013 17:41:18 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] x86: kvm: remove KVM_SOFT_MAX_VCPUS
Message-ID: <20130916144118.GB906@redhat.com>
References: <1379161011-28239-1-git-send-email-drjones@redhat.com>
 <20130915090322.GV17294@redhat.com>
 <20130916082208.GA2101@hawk.usersys.redhat.com>
 <20130916085517.GK17294@redhat.com>
 <20130916114725.GA14981@hawk.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916114725.GA14981@hawk.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 01:47:26PM +0200, Andrew Jones wrote:
> On Mon, Sep 16, 2013 at 11:55:17AM +0300, Gleb Natapov wrote:
> > On Mon, Sep 16, 2013 at 10:22:09AM +0200, Andrew Jones wrote:
> > > > > [1] Actually, until 972fc544b6034a in uq/master is merged there won't be
> > > > >     any warnings either.
> > > > > 
> > > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > > > ---
> > > > >  arch/x86/include/asm/kvm_host.h | 1 -
> > > > >  arch/x86/kvm/x86.c              | 2 +-
> > > > >  2 files changed, 1 insertion(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > > index c76ff74a98f2e..9236c63315a9b 100644
> > > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > > @@ -32,7 +32,6 @@
> > > > >  #include <asm/asm.h>
> > > > >  
> > > > >  #define KVM_MAX_VCPUS 255
> > > > > -#define KVM_SOFT_MAX_VCPUS 160
> > > > >  #define KVM_USER_MEM_SLOTS 125
> > > > >  /* memory slots that are not exposed to userspace */
> > > > >  #define KVM_PRIVATE_MEM_SLOTS 3
> > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > index e5ca72a5cdb6d..d9d3e2ed68ee9 100644
> > > > > --- a/arch/x86/kvm/x86.c
> > > > > +++ b/arch/x86/kvm/x86.c
> > > > > @@ -2604,7 +2604,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> > > > >  		r = !kvm_x86_ops->cpu_has_accelerated_tpr();
> > > > >  		break;
> > > > >  	case KVM_CAP_NR_VCPUS:
> > > > > -		r = KVM_SOFT_MAX_VCPUS;
> > > > > +		r = min(num_online_cpus(), KVM_MAX_VCPUS);
> > > > s/KVM_MAX_VCPUS/KVM_SOFT_MAX_VCPUS/.  Also what about hotplug cpus?
> > > 
> > > I'll send a v2 with this change.
> > > 
> > > I thought a bit about hotplug, and thus using num_possible_cpus()
> > > instead, but then decided it made more sense to stick to what's online now
> > > for the recommended number. It's just a recommendation anyway. So as long
> > > as KVM_MAX_VCPUS is >= num_possible_cpus(), then one can still configure
> > > more vcpus to count for all hotplugable cpus, if they wish.
> > > 
> > It is just recommended, but we do warn about it, so it is user visible.
> > Well, the whole point of it existence is to be user visible ;). If user
> > creates a guest with max cpus greater than current number if online
> > cpus, taking into account feature grows, he will get a warning, but we
> > should not warn about it.
> 
> Even it if means the user may end up running, e.g. 128 vcpus on 96 pcpus
> indefinitely? I'd rather warn about it, which could remind them to offline
> 32 vcpus for the time being.
But there are other means to detect number of online cpus:
sysconf(_SC_NPROCESSORS_ONLN). Actually you can determine number of
possible cpus too with _SC_NPROCESSORS_CONF, so returning those values
as KVM_CAP_NR_VCPUS does not provide any additional information. What
if QEMU process is bound to two cores on 64 core host, do you want to
warn if qemu is created with more then 2 vcpus in such case? You can do
that too with pthread_setaffinity_np(). 

>                               Although, as we're just discussing when or
> when not to output a warning, then I'm not really stressed about it either
> way. I can certainly change this to num_possible_cpus(), if all are in
> agreement that that is a better recommendation.
> 
With this patch we only reduce information available to userspace. QEMU
can already obtain all the information it needs to produce meaningful
warning.

--
			Gleb.
