Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbaGPLlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:41:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324AbaGPLlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:41:19 -0400
Date: Wed, 16 Jul 2014 08:41:00 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] ensure guest's kvmclock never goes backwards when TSC
 jumps backward
Message-ID: <20140716114100.GA7394@amt.cnet>
References: <1405504368-5581-1-git-send-email-imammedo@redhat.com>
 <53C6517D.9090600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C6517D.9090600@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 12:18:37PM +0200, Paolo Bonzini wrote:
> Il 16/07/2014 11:52, Igor Mammedov ha scritto:
> >There are buggy hosts in the wild that advertise invariant
> >TSC and as result host uses TSC as clocksource, but TSC on
> >such host sometimes sporadically jumps backwards.
> >
> >This causes kvmclock to go backwards if host advertises
> >PVCLOCK_TSC_STABLE_BIT, which turns off aggregated clock
> >accumulator and returns:
> >  pvclock_vcpu_time_info.system_timestamp + offset
> >where 'offset' is calculated using TSC.
> >Since TSC is not virtualized in KVM, it makes guest see
> >TSC jumped backwards and leads to kvmclock going backwards
> >as well.
> >
> >This is defensive patch that keeps per CPU last clock value
> >and ensures that clock will never go backwards even with
> >using PVCLOCK_TSC_STABLE_BIT enabled path.
> 
> I'm not sure that a per-CPU value is enough; your patch can make the
> problem much less frequent of course, but I'm not sure neither
> detection nor correction are 100% reliable.  Your addition is
> basically a faster but less reliable version of the last_value
> logic.
> 
> If may be okay to have detection that is faster but not 100%
> reliable. However, once you find that the host is buggy I think the
> correct thing to do is to write last_value and kill
> PVCLOCK_TSC_STABLE_BIT from valid_flags.
> 
> Did you check that the affected host has the latest microcode?
> Alternatively, could we simply blacklist some CPU steppings?  I'm
> not sure who we could ask at AMD :( but perhaps there is an erratum.
> 
> Paolo

Igor,

Can we move detection to the host TSC clocksource driver ?

Because it is responsability of the host system to provide a non
backwards clock_gettime() interface as well.

How did you prove its the host TSC in fact going backwards?
Is it cross-CPU detection?

