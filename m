Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbaIRQAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:00:43 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34291 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbaIRQAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:00:41 -0400
Date: Thu, 18 Sep 2014 17:00:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "jcm@redhat.com" <jcm@redhat.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 14/18] ARM64 / ACPI: Add GICv2 specific ACPI boot
 support
Message-ID: <20140918160029.GB25330@e104818-lin.cambridge.arm.com>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <54193AD8.3090301@linaro.org>
 <20140917151445.GF10392@e104818-lin.cambridge.arm.com>
 <201409180425.29391.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409180425.29391.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 03:25:29AM +0100, Arnd Bergmann wrote:
> On Wednesday 17 September 2014, Catalin Marinas wrote:
> > > > I think it gets worse, this function is called from irqchip_init(). I
> > > > would have been slightly happier if it was called from the arm64
> > > > init_IRQ(). But putting an ARM specific GIC initialisation call in a
> > > > generic irqchip_init() just looks weird. Can we do anything better here?
> > > 
> > > Yes this was discussed, please have a look at: 
> > > https://lkml.org/lkml/2014/9/1/555
> > > We had this in init_IRQ() in previous patch set, then we got feedback 
> > > irqchip_init() is more appropriate. We can move it back to init_IRQ() 
> > > and I am sold on this.
> > 
> > The irqchip_init() is indeed the place to call other interrupt
> > controller initialisation functions but what I don't particularly like
> > is calling the GIC one directly while the OF ones are checked against a
> > match string. For GICv3 and later, do you plan to use the same
> > acpi_gic_init() functions? Otherwise we could do something like
> > ACPI_IRQCHIP_DECLARE() similar to the OF ones and a common function that
> > probes whatever is built into the kernel.
> 
> I talked abouto this with Marc Z the other day, and I think it really
> comes down to how we expect this to develop in the future:
> 
> If this is going to stay with the GICv2/v3/v4 line of interrupt controllers,
> I see the ACPI_IRQCHIP_DECLARE() as total overdesign, since we wouldn't
> ever need more than two entry points.

I agree, if we are going to have a single acpi_gic_init() function
handling all versions of GIC then a macro isn't needed.

> Doing ACPI_IRQCHIP_DECLARE() makes it possible to deal with other
> incompatible irqchips as they come along, but also seems to invite
> those.
> 
> Marc believes that it's inevitable that people will add lots of crazy
> interrupt controllers to systems using ACPI and at that point I agree
> it would be the right way to deal with it. However, I also think that
> as long as people expect to be able to add lots of crazy interrupt
> controller drivers, we are not ready to merge ACPI in the first place,
> because it must first be clear to everybody that we are not going to
> allow those nonstandard controller drivers to get merged.

Sounds fine to me. So we leave this call in irqchip_init() and ignore
ACPI for platforms with non-standard interrupt controllers.

-- 
Catalin
