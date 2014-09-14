Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaINPlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:41:03 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60906 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaINPk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:40:58 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 02/17] ARM64 / ACPI: Get RSDP and ACPI boot-time
 tables
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "guohanjun@huawei.com" <guohanjun@huawei.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140911110146.GB5814@localhost>
References: <1409583475-6978-3-git-send-email-hanjun.guo@linaro.org>
	<20140909162648.GE2910@arm.com> <540F2DCF.1010104@redhat.com>
	<20140909171541.GD3896@leverpostej>
	<20140909175010.GF4948@e102568-lin.cambridge.arm.com>
	<540F4155.4090200@arm.com> <540F4FCF.1090508@redhat.com>
	<5410326F.8080104@huawei.com> <20140910123352.GA31237@localhost>
	<20140910215130.6D448C411AA@trevor.secretlab.ca>
	<20140911110146.GB5814@localhost>
Date: Sun, 14 Sep 2014 08:40:56 -0700
Message-Id: <20140914154056.84AA3C40FCB@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 12:01:46 +0100, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Wed, Sep 10, 2014 at 10:51:30PM +0100, Grant Likely wrote:
> > On Wed, 10 Sep 2014 13:33:52 +0100, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Wed, Sep 10, 2014 at 12:13:51PM +0100, Hanjun Guo wrote:
> > > > I agree that we should rework the ACPI core to make sleep/cache related
> > > > stuff compatible with ARM, but I think we may not do this in one go, it will
> > > > need incremental changes over the next couple of years as real hardware
> > > > starts to appear and we finalise the standards to support this.
> > > > 
> > > > Now, as we list in the arm-acpi.txt doc, power management of sleep states
> > > > and CPU power/frequency control are not well defined in ACPI spec for ARM,
> > > > we need some time to finalize the standard and then we know how to implement
> > > > that in a good shape.
> > > > 
> > > > ACPI 5.1 already fixed lots missing features for ARM64 and provide the
> > > > fundamental needs to bring up the basic system for ARM server, power
> > > > management is not critical at now, so why not fix/implement it later?
> > > 
> > > I don't have a problem with implementing (rather than fixing) power
> > > management later, once the ACPI spec covers it. But the point a few of
> > > us were trying to make is that even when ACPI spec is updated, the
> > > current power management code and hooks still won't make sense on ARM.
> > > The best is to avoid compiling it for ARM now and look at refactoring it
> > > later to accommodate ARM ACPI.
> > 
> > I disagree strongly here. We're talking about a library of code that is
> > working on x86 and ia64, but hasn't been tuned for ARM.
> 
> I think where we disagree is the "tuning" part. If it's just that, it
> would be fine, but there are fundamental differences in the
> architectures that the above would not even make sense on ARM (so it's
> more like rewriting than tuning).
> 
> > Trying to
> > refactor it first, and then get it compiling for ARM is entirely the
> > wrong way around.
> 
> Note that I explicitly stated "refactoring it later". I have not asked
> for the existing code to be refactored _now_ as it's not even clear how
> it would look like on ARM (what's clear though is that its behaviour is
> _undefined_).
> 
> > The best way to get that code refactored for
> > ARM is to get it compiling first, and then refactor it to remove the
> > unnecessary stubs. That makes it a whole lot easier to make the
> > arguements about why the changes are needed. Otherwise it just shows
> > churn on the ACPICA side without any evidence of why the change is
> > good. Trying to refactor first also has the risk of breaking things
> > that work now in the name of "refactoring" and not being able to easily
> > bisect it for ARM. That's just madness.
> 
> I agree with not starting the refactoring now. But is it difficult to
> make it compilable based on something like CONFIG_ACPI_SLEEP and the
> latter depend on !ARM64 until the spec is clear?

This particular issue is pretty much moot now. The latest series was
able to compile out the sleep functions. If they hadn't however, we
weren't at any risk. Empty hooks have no impact, and even if the
behaviour is defined in a future revision of the spec, they will remain
noops for ACPI 5.1 systems.
> 
> > Aside from a slightly larger kernel, there is no downside to using
> > stubs for now.
> 
> There is a serious downside - code with _undefined_ behaviour on arm64
> that may get executed depending on the content of the ACPI tables. I'm
> sure it's a lot of fun debugging this.

It's really easy for us to deal with this. For ACPI 5.1, we don't do
anything, and we should never try to do anything with those states.  If
and when a future revision of the ACPI spec appears that does define
those states, then we will use them, but only if the reported ACPI
version is high enough.

g.
