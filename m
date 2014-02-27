Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaB0OM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:12:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbaB0OM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:12:27 -0500
Date: Thu, 27 Feb 2014 15:12:22 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 2/2] x86: kvm: introduce periodic global clock updates
Message-ID: <20140227141221.GB4688@hawk.usersys.redhat.com>
References: <1393438512-21273-1-git-send-email-drjones@redhat.com>
 <1393438512-21273-3-git-send-email-drjones@redhat.com>
 <20140226202857.GB9218@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226202857.GB9218@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 05:28:57PM -0300, Marcelo Tosatti wrote:
> On Wed, Feb 26, 2014 at 07:15:12PM +0100, Andrew Jones wrote:
> > commit 0061d53daf26f introduced a mechanism to execute a global clock
> > update for a vm. We can apply this periodically in order to propagate
> > host NTP corrections. Also, if all vcpus of a vm are pinned, then
> > without an additional trigger, no guest NTP corrections can propagate
> > either, as the current trigger is only vcpu cpu migration.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/x86.c              | 65 +++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 63 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 9aa09d330a4b5..77c69aa4756f9 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -599,6 +599,7 @@ struct kvm_arch {
> >  	u64 master_kernel_ns;
> >  	cycle_t master_cycle_now;
> >  	struct delayed_work kvmclock_update_work;
> > +	bool clocks_synced;
> >  
> >  	struct kvm_xen_hvm_config xen_hvm_config;
> >  
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a2d30de597b7d..5cba20b446aac 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1620,6 +1620,60 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> >  	return 0;
> >  }
> >  
> > +static void kvm_schedule_kvmclock_update(struct kvm *kvm, bool now);
> > +static void clock_sync_fn(struct work_struct *work);
> > +static DECLARE_DELAYED_WORK(clock_sync_work, clock_sync_fn);
> > +
> > +#define CLOCK_SYNC_PERIOD_SECS	300
> > +#define CLOCK_SYNC_BUMP_SECS	30
> > +#define CLOCK_SYNC_STEP_MSECS	100
> > +
> > +#define __steps(s) (((s) * MSEC_PER_SEC) / CLOCK_SYNC_STEP_MSECS)
> > +
> > +static void clock_sync_fn(struct work_struct *work)
> > +{
> > +	static unsigned reset_step = __steps(CLOCK_SYNC_PERIOD_SECS);
> > +	static unsigned step = 0;
> > +	struct kvm *kvm;
> > +	bool sync = false;
> > +
> > +	spin_lock(&kvm_lock);
> 
> Better have it per vm to avoid kvm_lock?

We could, but the way it is now guarantees we never update more than
one vm at a time. Updates can generate a lot of scheduling and IPIs
when the vms have lots of vcpus. That said, I guess it's pretty
unlikely that more one vm's 5 minute period would ever get scheduled
at the same time. I can rework this to avoid the lock.

> 
> > +	if (step == 0)
> > +		list_for_each_entry(kvm, &vm_list, vm_list)
> > +			kvm->arch.clocks_synced = false;
> > +
> > +	list_for_each_entry(kvm, &vm_list, vm_list) {
> > +		if (!kvm->arch.clocks_synced) {
> > +			kvm_get_kvm(kvm);
> > +			sync = true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	spin_unlock(&kvm_lock);
> > +
> > +	if (sync) {
> > +		kvm_schedule_kvmclock_update(kvm, true);
> > +		kvm_put_kvm(kvm);
> > +
> > +		if (++step == reset_step) {
> > +			reset_step += __steps(CLOCK_SYNC_BUMP_SECS);
> > +			pr_warn("kvmclock: reducing VM clock sync frequency "
> > +				"to every %ld seconds.\n", (reset_step
> > +					* CLOCK_SYNC_STEP_MSECS)/MSEC_PER_SEC);
> > +		}
> 
> Can you explain the variable sync frequency? To be based on NTP
> frequency correction?
> 

NTP correction polling time is variable, but commonly ends up being close
to the max polling time (1024s). We choose 300s for this periodic update
because even if the host is polling at a higher rate it's ok to leave the
guest clocks uncorrected a bit longer, and for the common case it's a few
times more frequent. The variability (bumping) I have in this function is
actually not related to ntp correction though. Here I'm just ensuring that
if we ever had more than 3000 vms running at the same time that we could
get to each of their updates before clearing all clocks_synced flags.
I chose 30 seconds (300 vms) as the amount to bump by arbitrarily, but
it seems reasonable to me. Reworking this patch so each vm has its own
periodic work removes the need for this bumping too.

drew
