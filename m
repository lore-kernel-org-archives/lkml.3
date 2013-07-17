Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3GQMqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab3GQMqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:46:21 -0400
Date: Wed, 17 Jul 2013 15:45:11 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: mingo@redhat.com, jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        ouyang@cs.pitt.edu, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
Message-ID: <20130717124511.GW11772@redhat.com>
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com>
 <20130624124342.27508.44656.sendpatchset@codeblue.in.ibm.com>
 <20130714131241.GA11772@redhat.com>
 <51E3C5CE.7000009@linux.vnet.ibm.com>
 <20130715103648.GN11772@redhat.com>
 <51E4C011.4060803@linux.vnet.ibm.com>
 <20130716060215.GE11772@redhat.com>
 <51E5941B.3090300@linux.vnet.ibm.com>
 <20130717093420.GU11772@redhat.com>
 <51E66C71.6020605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E66C71.6020605@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 03:35:37PM +0530, Raghavendra K T wrote:
> >>Instead of halt we started with a sleep hypercall in those
> >>  versions. Changed to halt() once Avi suggested to reuse existing sleep.
> >>
> >>If we use older hypercall with few changes like below:
> >>
> >>kvm_pv_wait_for_kick_op(flags, vcpu, w->lock )
> >>{
> >>  // a0 reserved for flags
> >>if (!w->lock)
> >>return;
> >>DEFINE_WAIT
> >>...
> >>end_wait
> >>}
> >>
> >How would this help if NMI takes lock in critical section. The thing
> >that may happen is that lock_waiting->want may have NMI lock value, but
> >lock_waiting->lock will point to non NMI lock. Setting of want and lock
> >have to be atomic.
> 
> True. so we are here
> 
>         non NMI lock(a)
>         w->lock = NULL;
>         smp_wmb();
>         w->want = want;
>                                NMI
>                          <---------------------
>                           NMI lock(b)
>                           w->lock = NULL;
>                           smp_wmb();
>                           w->want = want;
>                           smp_wmb();
>                           w->lock = lock;
>                          ---------------------->
>         smp_wmb();
>         w->lock = lock;
> 
> so how about fixing like this?
> 
> again:
>         w->lock = NULL;
>         smp_wmb();
>         w->want = want;
>         smp_wmb();
>         w->lock = lock;
> 
> if (!lock || w->want != want) goto again;
> 
NMI can happen after the if() but before halt and the same situation
we are trying to prevent with IRQs will occur. But if NMI handler do not
take locks we shouldn't worry.

--
			Gleb.
