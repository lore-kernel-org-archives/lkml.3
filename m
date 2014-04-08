Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbaDHLR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:17:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62725 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756126AbaDHLR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:17:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>
Subject: Re: [PATCH] arm, kvm: fix double lock on cpu_add_remove_lock
Date: Tue, 08 Apr 2014 13:33:55 +0200
Message-ID: <2948858.2iSmOgt3H2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53424946.4000504@linux.vnet.ibm.com>
References: <1396805768-18669-1-git-send-email-tom.leiming@gmail.com> <53424946.4000504@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 07, 2014 12:14:22 PM Srivatsa S. Bhat wrote:
> On 04/06/2014 11:06 PM, Ming Lei wrote:
> > The patch of "arm, kvm: Fix CPU hotplug callback registration"
> > in -next tree holds the lock before calling the two functions:
> > 
> > 	kvm_vgic_hyp_init()
> > 	kvm_timer_hyp_init()
> > 
> > and both the two functions are calling register_cpu_notifier()
> > to register cpu notifier, so cause double lock on cpu_add_remove_lock.
> > 
> > Considered that both two functions are only called inside
> > kvm_arch_init() with holding cpu_add_remove_lock, so simply use
> > __register_cpu_notifier() to fix the problem.
> > 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Christoffer Dall <christoffer.dall@linaro.org>
> > Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> 
> Sorry for missing that, and thank you for the fix!
> 
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied, thanks!

I'm going to include this into my next pull request.

> > ---
> >  virt/kvm/arm/arch_timer.c |    2 +-
> >  virt/kvm/arm/vgic.c       |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index 5081e80..22fa819 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -277,7 +277,7 @@ int kvm_timer_hyp_init(void)
> > 
> >  	host_vtimer_irq = ppi;
> > 
> > -	err = register_cpu_notifier(&kvm_timer_cpu_nb);
> > +	err = __register_cpu_notifier(&kvm_timer_cpu_nb);
> >  	if (err) {
> >  		kvm_err("Cannot register timer CPU notifier\n");
> >  		goto out_free;
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index 8ca405c..47b2983 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -1496,7 +1496,7 @@ int kvm_vgic_hyp_init(void)
> >  		goto out;
> >  	}
> > 
> > -	ret = register_cpu_notifier(&vgic_cpu_nb);
> > +	ret = __register_cpu_notifier(&vgic_cpu_nb);
> >  	if (ret) {
> >  		kvm_err("Cannot register vgic CPU notifier\n");
> >  		goto out_free_irq;
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
