Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaDYJia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:38:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:47008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbaDYJi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:38:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,926,1389772800"; 
   d="scan'208";a="528191449"
Date: Fri, 25 Apr 2014 12:45:16 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "Jin, Yao" <yao.jin@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>
Subject: Re: [PATCH] pinctrl-baytrail: workaround for irq descriptor conflict
 on ASUS T100TA
Message-ID: <20140425094516.GL30677@intel.com>
References: <1397443272-31467-1-git-send-email-yao.jin@linux.intel.com>
 <534B4C6D.5070003@linux.intel.com>
 <CACRpkdYXD-Fd0tFJtir8ifsTqdBvA0Rznc4Hmzoq_ByBjTahdw@mail.gmail.com>
 <5357A594.6050404@linux.intel.com>
 <CACRpkdYztACye5Xht3f4UuaWDA0gB7t2rgRmpTaL330YcxYhfQ@mail.gmail.com>
 <alpine.DEB.2.02.1404240918110.4704@ionos.tec.linutronix.de>
 <CACRpkdaHP4sp8fomE_7-2KaHAmBmTYv-cMSA=As04V54OZMo-g@mail.gmail.com>
 <alpine.DEB.2.02.1404241617360.28206@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404241617360.28206@ionos.tec.linutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 04:40:25PM +0200, Thomas Gleixner wrote:
> On Thu, 24 Apr 2014, Linus Walleij wrote:
> > On Thu, Apr 24, 2014 at 9:25 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > I'm traveling until friday, so please wait before you commit that
> > > fugly hack. I'll have a closer look how we can handle that at the core
> > > level.
> > 
> > Thanks a *lot* Thomas, I'll stand by for action.
> 
> Find an untested patch below. It should cure the issue.
> 
> I went through all code which can be affected by this and except for
> some other places, which might erroneously allocate inside the
> hardwired space, I can't see any possible fallout.
> 
> Thanks,
> 
> 	tglx
> 
> -------------------->
> 
> Subject: genirq: x86: Ensure that dynamic irq allocation does not conflict
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Thu, 24 Apr 2014 09:50:53 +0200
> 
> On x86 the allocation of irq descriptors may allocate interrupts which
> are in the range of the GSI interrupts. That's wrong as those
> interrupts are hardwired and we don't have the irq domain translation
> like PPC. So one of these interrupts can be hooked up later to one of
> the devices which are hard wired to it and the io_apic init code for
> that particular interrupt line happily reuses that descriptor with a
> completely different configuration so hell breaks lose.
> 
> Inside x86 we allocate dynamic interrupts from above nr_gsi_irqs,
> except for a few usage sites which have not yet blown up in our face
> for whatever reason. But for drivers which need an irq range, like the
> GPIO drivers, we have no limit in place and we don't want to expose
> such a detail to a driver.
> 
> To cure this introduce a function which an architecture can implement
> to impose a lower bound on the dynamic interrupt allocations.
> 
> Implement it for x86 and set the lower bound to nr_gsi_irqs, which is
> the end of the hardwired interrupt space, so all dynamic allocations
> happen above.
> 
> That not only allows the GPIO driver to work sanely, it also protects
> the bogus callsites of create_irq_nr() in hpet, uv, irq_remapping and
> htirq code. They need to be cleaned up as well, but that's a separate
> issue.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Works here on my T100,

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
