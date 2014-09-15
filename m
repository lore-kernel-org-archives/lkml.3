Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbaIOJPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:15:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36649 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaIOJP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:15:28 -0400
Date: Mon, 15 Sep 2014 10:15:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Message-ID: <20140915091515.GA1577@arm.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
 <20140911132935.068DCC408F6@trevor.secretlab.ca>
 <20140911153739.GA24416@localhost>
 <20140915043116.9985CC407E8@trevor.secretlab.ca>
MIME-Version: 1.0
In-Reply-To: <20140915043116.9985CC407E8@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 15 Sep 2014 09:15:22.0800 (UTC) FILETIME=[940C4300:01CFD0C5]
X-MC-Unique: 114091510152330801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 05:31:16AM +0100, Grant Likely wrote:
> On Thu, 11 Sep 2014 16:37:39 +0100, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Thu, Sep 11, 2014 at 02:29:34PM +0100, Grant Likely wrote:
> > > Regarding the requests to refactor ACPICA to work better for ARM. I
> > > completely agree that it should be done, but I do not think it should be
> > > a prerequisite to getting this core support merged. That kind of
> > > refactoring is far easier to justify when it has immediate improvement
> > > on the mainline codebase, and it gives us a working baseline to test
> > > against. Doing it the other way around just makes things harder.
> > 
> > I have to disagree here. As I said, I'm perfectly fine with refactoring
> > happening later but I'm not happy with compiling in code with undefined
> > behaviour on ARM that may actually be executed at run-time.
> > 
> > I'm being told one of the main advantages of ACPI is forward
> > compatibility: running older kernels on newer hardware (potentially with
> > newer ACPI version tables). ACPI 5.1 includes partial support for ARM
> > but the S and C states are not defined yet. We therefore assume that
> > hardware vendors deploying servers using ACPI would not provide such
> > yet to be defined information in ACPI 5.1 tables.
> 
> We're good on this front. ACPI-future platforms aren't allowed to use
> new features when booting an older kernel.

Do you mean ACPI-future firmware should not provide new information to
older kernels? The firmware must not care which kernel version (not even
which OS) runs on top. That's the whole point of an OS-agnostic
standardisation body).

> ACPI has a mechanism to check version numbers.

I assume you are referring to the kernel checking of the ACPI version
the tables are compatible with (acpi_parse_fadt() in patch 7/17 in the
v3 series). With these patches, it currently assumes that it is
compatible with anything 5.1 and later.

> Similarly, when ACPI-future defines those states, the kernel shouldn't
> expose them to an older platform.

When the kernel implements ACPI-future, all is fine, it should still be
backwards compatible with 5.1.

> > What if in a year time we get ACPI 5.2 or 6 (or an errata update)
> > covering the S and C states for ARM? I would expect hardware vendors
> > to take advantage and provide such information in ACPI tables. Can we
> > guarantee that a kernel with the current ACPI patches wouldn't blow up
> > when it tries to interpret the new tables?
> 
> Yes - at least as much as we can guarantee anything in systems
> programming.

No, we don't. Once you define some sleep states in ACPI-future and
the firmware provides such tables to an older kernel, it is possible
that the current (x86-centric) ACPI sleep code will fault. Just look at
the acpi_suspend_enter() (and you also seemed OK to define
ACPI_FLUSH_CPU_CACHE as BUG).

Even if v4 of these patches removed the sleep code, given uncertainties
like above I'm thinking more and more that we should actually make the
acpi_parse_fadt() version check succeed only on ACPI 5.1 and no later
version (apart from ACPI sleep, is there anything else we would expect
to blow up when additional information is provided via ACPI-future
tables?).

-- 
Catalin

