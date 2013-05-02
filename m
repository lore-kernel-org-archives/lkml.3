Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3EBITr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:19:47 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:2245 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3EBITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:19:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4146064"
Message-ID: <1367482772.21869.26.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/3] arm_arch_timer: introduce
 arch_timer_stolen_ticks
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Christopher Covington <cov@codeaurora.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 2 May 2013 09:19:32 +0100
In-Reply-To: <51817CBE.4050003@codeaurora.org>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
	 <1367436460-10183-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <51817CBE.4050003@codeaurora.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-01 at 21:36 +0100, Christopher Covington wrote:
> Hi Stefano,
> 
> On 05/01/2013 03:27 PM, Stefano Stabellini wrote:
> > Introduce a function, called arch_timer_stolen_ticks, called from the
> > arch_timer interrupt handler to account for stolen ticks.
> 
> [...]
> 
> > diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
> > index 7ade91d..30db413 100644
> > --- a/arch/arm/include/asm/arch_timer.h
> > +++ b/arch/arm/include/asm/arch_timer.h
> > @@ -13,6 +13,11 @@
> >  int arch_timer_of_register(void);
> >  int arch_timer_sched_clock_init(void);
> >  
> > +/* per-platform function to calculate stolen ticks (clock cycles stolen
> > + * to the vcpu by the hypervisor).
> 
> Stolen from the vcpu by the hypervisor?

Stolen is time where the VCPU wants to be running bit isn't because the
hypervisor has descheduled it, e.g. because another VCPU is being run.
So yes, Stefano meant "from".

> Is the hypervisor adjusting the Virtual Offset Register?

The virtual offset register is useful when a VCPU is migrated to another
system to account for the differences in physical time on the two hosts
but isn't useful for accounting for stolen time while running on a
single host.

e.g. if a VCPU sets a timer for NOW+5, but 3 are stolen in the middle it
would not make sense (from the guests PoV) for NOW'==NOW+2 at the point
where the timer goes off. Nor does it make sense to require that the
guest actually be running for 5 before injecting the timer because that
would mean real time elapsed time for the timer would be 5+3 in the case
where 3 are stolen.

So the virtual timer should appear to have been running even while time
is being stolen and therefore stolen time needs to be accounted via some
other means.

Ian.

