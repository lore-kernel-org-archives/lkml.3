Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3FZMy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:54:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab3FZMyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:54:53 -0400
Date: Wed, 26 Jun 2013 15:52:40 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        habanero@linux.vnet.ibm.com, mingo@redhat.com, jeremy@goop.org,
        x86@kernel.org, konrad.wilk@oracle.com, hpa@zytor.com,
        pbonzini@redhat.com, linux-doc@vger.kernel.org,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephan.diestelhorst@amd.com, riel@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
Message-ID: <20130626125240.GY18508@redhat.com>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
 <1372171802.3804.30.camel@oc2024037011.ibm.com>
 <51CAAA26.4090204@linux.vnet.ibm.com>
 <20130626113744.GA6300@hawk.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626113744.GA6300@hawk.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 01:37:45PM +0200, Andrew Jones wrote:
> On Wed, Jun 26, 2013 at 02:15:26PM +0530, Raghavendra K T wrote:
> > On 06/25/2013 08:20 PM, Andrew Theurer wrote:
> > >On Sun, 2013-06-02 at 00:51 +0530, Raghavendra K T wrote:
> > >>This series replaces the existing paravirtualized spinlock mechanism
> > >>with a paravirtualized ticketlock mechanism. The series provides
> > >>implementation for both Xen and KVM.
> > >>
> > >>Changes in V9:
> > >>- Changed spin_threshold to 32k to avoid excess halt exits that are
> > >>    causing undercommit degradation (after PLE handler improvement).
> > >>- Added  kvm_irq_delivery_to_apic (suggested by Gleb)
> > >>- Optimized halt exit path to use PLE handler
> > >>
> > >>V8 of PVspinlock was posted last year. After Avi's suggestions to look
> > >>at PLE handler's improvements, various optimizations in PLE handling
> > >>have been tried.
> > >
> > >Sorry for not posting this sooner.  I have tested the v9 pv-ticketlock
> > >patches in 1x and 2x over-commit with 10-vcpu and 20-vcpu VMs.  I have
> > >tested these patches with and without PLE, as PLE is still not scalable
> > >with large VMs.
> > >
> > 
> > Hi Andrew,
> > 
> > Thanks for testing.
> > 
> > >System: x3850X5, 40 cores, 80 threads
> > >
> > >
> > >1x over-commit with 10-vCPU VMs (8 VMs) all running dbench:
> > >----------------------------------------------------------
> > >						Total
> > >Configuration				Throughput(MB/s)	Notes
> > >
> > >3.10-default-ple_on			22945			5% CPU in host kernel, 2% spin_lock in guests
> > >3.10-default-ple_off			23184			5% CPU in host kernel, 2% spin_lock in guests
> > >3.10-pvticket-ple_on			22895			5% CPU in host kernel, 2% spin_lock in guests
> > >3.10-pvticket-ple_off			23051			5% CPU in host kernel, 2% spin_lock in guests
> > >[all 1x results look good here]
> > 
> > Yes. The 1x results look too close
> > 
> > >
> > >
> > >2x over-commit with 10-vCPU VMs (16 VMs) all running dbench:
> > >-----------------------------------------------------------
> > >						Total
> > >Configuration				Throughput		Notes
> > >
> > >3.10-default-ple_on			 6287			55% CPU  host kernel, 17% spin_lock in guests
> > >3.10-default-ple_off			 1849			2% CPU in host kernel, 95% spin_lock in guests
> > >3.10-pvticket-ple_on			 6691			50% CPU in host kernel, 15% spin_lock in guests
> > >3.10-pvticket-ple_off			16464			8% CPU in host kernel, 33% spin_lock in guests
> > 
> > I see 6.426% improvement with ple_on
> > and 161.87% improvement with ple_off. I think this is a very good sign
> >  for the patches
> > 
> > >[PLE hinders pv-ticket improvements, but even with PLE off,
> > >  we still off from ideal throughput (somewhere >20000)]
> > >
> > 
> > Okay, The ideal throughput you are referring is getting around atleast
> > 80% of 1x throughput for over-commit. Yes we are still far away from
> > there.
> > 
> > >
> > >1x over-commit with 20-vCPU VMs (4 VMs) all running dbench:
> > >----------------------------------------------------------
> > >						Total
> > >Configuration				Throughput		Notes
> > >
> > >3.10-default-ple_on			22736			6% CPU in host kernel, 3% spin_lock in guests
> > >3.10-default-ple_off			23377			5% CPU in host kernel, 3% spin_lock in guests
> > >3.10-pvticket-ple_on			22471			6% CPU in host kernel, 3% spin_lock in guests
> > >3.10-pvticket-ple_off			23445			5% CPU in host kernel, 3% spin_lock in guests
> > >[1x looking fine here]
> > >
> > 
> > I see ple_off is little better here.
> > 
> > >
> > >2x over-commit with 20-vCPU VMs (8 VMs) all running dbench:
> > >----------------------------------------------------------
> > >						Total
> > >Configuration				Throughput		Notes
> > >
> > >3.10-default-ple_on			 1965			70% CPU in host kernel, 34% spin_lock in guests		
> > >3.10-default-ple_off			  226			2% CPU in host kernel, 94% spin_lock in guests
> > >3.10-pvticket-ple_on			 1942			70% CPU in host kernel, 35% spin_lock in guests
> > >3.10-pvticket-ple_off			 8003			11% CPU in host kernel, 70% spin_lock in guests
> > >[quite bad all around, but pv-tickets with PLE off the best so far.
> > >  Still quite a bit off from ideal throughput]
> > 
> > This is again a remarkable improvement (307%).
> > This motivates me to add a patch to disable ple when pvspinlock is on.
> > probably we can add a hypercall that disables ple in kvm init patch.
> > but only problem I see is what if the guests are mixed.
> > 
> >  (i.e one guest has pvspinlock support but other does not. Host
> > supports pv)
> 
> How about reintroducing the idea to create per-kvm ple_gap,ple_window
> state. We were headed down that road when considering a dynamic window at
> one point. Then you can just set a single guest's ple_gap to zero, which
> would lead to PLE being disabled for that guest. We could also revisit
> the dynamic window then.
> 
Can be done, but lets understand why ple on is such a big problem. Is it
possible that ple gap and SPIN_THRESHOLD are not tuned properly?

--
			Gleb.
