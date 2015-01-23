Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbbAWJtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:49:04 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:64281 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbbAWJs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:48:57 -0500
Date: Fri, 23 Jan 2015 10:48:58 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Mario Smarduch <m.smarduch@samsung.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: KVM: HAVE_KVM_ARCH_DIRTY_LOG_PROTECT?
Message-ID: <20150123094858.GJ15076@cbox>
References: <1421918381.13638.43.camel@x220>
 <54C101B9.1050804@redhat.com>
 <1421938175.13638.58.camel@x220>
 <54C11815.8070501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C11815.8070501@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 04:32:37PM +0100, Paolo Bonzini wrote:
> 
> 
> On 22/01/2015 15:49, Paul Bolle wrote:
> >> > Ah, there are two Kconfig symbols added by mistake.
> >> > 
> >> > +config HAVE_KVM_ARCH_DIRTY_LOG_PROTECT
> >> > + bool
> >> > +
> >> > +config KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >> > + bool
> > This one is actually used (so my 800 line perl monster didn't bark):
> >     $ git grep -n KVM_GENERIC_DIRTYLOG_READ_PROTECT next-20150122
> >     next-20150122:arch/arm/kvm/Kconfig:27:  select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >     next-20150122:arch/arm64/kvm/Kconfig:30:        select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >     next-20150122:arch/x86/kvm/Kconfig:42:  select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >     next-20150122:virt/kvm/Kconfig:47:config KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >     next-20150122:virt/kvm/kvm_main.c:998:#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > 
> 
> Yes, the mistake is adding two symbols instead of one. :)
> 
Yes, I'm fixing it up with this patch:

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index eb94597..74aeaba 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1042,8 +1042,8 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 		/*
 		 * Release kvm_mmu_lock periodically if the memory region is
 		 * large. Otherwise, we may see kernel panics with
-		 * CONFIG_DETECT_HUNG_TASK, CONFIG_LOCK_DETECTOR,
-		 * CONFIG_LOCK_DEP. Additionally, holding the lock too long
+		 * CONFIG_DETECT_HUNG_TASK, CONFIG_LOCKUP_DETECTOR,
+		 * CONFIG_LOCKDEP. Additionally, holding the lock too long
 		 * will also starve other vCPUs.
 		 */
 		if (need_resched() || spin_needbreak(&kvm->mmu_lock))
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 314950c..50d1106 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -41,8 +41,5 @@ config KVM_VFIO
 config HAVE_KVM_ARCH_TLB_FLUSH_ALL
        bool
 
-config HAVE_KVM_ARCH_DIRTY_LOG_PROTECT
-       bool
-
 config KVM_GENERIC_DIRTYLOG_READ_PROTECT
        bool


Thanks,
-Christoffer
