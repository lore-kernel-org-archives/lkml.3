Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaIDKPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:15:18 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:65147 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaIDKPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:15:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, linaro-acpi@lists.linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, Charles.Garcia-Tobin@arm.com,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
Date: Thu, 04 Sep 2014 12:14:58 +0200
Message-ID: <3046890.jAXAYeBPWQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54083A94.2040105@linaro.org>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <2893693.4bZJXXENof@wuerfel> <54083A94.2040105@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:EuWztPpMtT7DIH7XdKbBwmW4vDrkue2VuAPnA4gJjPX
 sB9PWfkN0+wRTaAdgHzOyEtQc/ivNbLySAioIpRtgMu59iYd20
 bJLNd2Ovg7OrMO8x5rZri2SxxiQwXBxIWhHkKqZrn4cIXGq4+w
 oOWloy6jWCVkwXz+SmondUZgllr4DNm8UANEVne5f5/qQADxku
 J8GReG5BFQEsaVc6Rl/LHINAZS3vdLaInYKQc1dX0gyT2OFIML
 /qsOU3uRAO/kE0Z7yrV5hddB7lI9mrDbaWYhBtlcTcAPzJmCke
 aF7IYJH83PR3mtqXm70B+zxdvEVR6aUgRgo4xSsXfj5GaMFbP1
 IKM+LwuBmIC6uJ50kO2U=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 September 2014 12:10:28 Tomasz Nowicki wrote:
> On 03.09.2014 20:42, Arnd Bergmann wrote:
> > On Monday 01 September 2014 22:57:51 Hanjun Guo wrote:
> >> +       /* Collect CPU base addresses */
> >> +       count = acpi_parse_entries(sizeof(struct acpi_table_madt),
> >> +                                  gic_acpi_parse_madt_cpu, table,
> >> +                                  ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> >> +                                  ACPI_MAX_GIC_CPU_INTERFACE_ENTRIES);
> >> +       if (count < 0) {
> >> +               pr_err("Error during GICC entries parsing\n");
> >> +               return -EFAULT;
> >> +       } else if (!count) {
> >> +               /* No GICC entries provided, use address from MADT header */
> >> +               struct acpi_table_madt *madt = (struct acpi_table_madt *)table;
> >> +
> >> +               if (!madt->address)
> >> +                       return -EFAULT;
> >> +
> >> +               cpu_phy_base = (u64)madt->address;
> >> +       }
> >
> > After I read through ACPI-5.1 section 5.2.12.14, I wonder if this is the
> > best way to treat a missing ACPI_MADT_TYPE_GENERIC_INTERRUPT table.
> >
> > Do we expect to see those in practice? It seems like using the x86 local
> > APIC address as a fallback for the GIC address is not something we
> > should do unless we absolutely have to support a system that doesn't
> > have the GIC table.
> 
> No, we do not expect and hopefully there will be no such 
> 
> But, we are trying to be as much as possible inline with 5.1 spec, 
> 5.2.12.14 says:
> [...]
> If provided here (CPU physical base address), the "Local Interrupt 
> Controller Address" field in the MADT must be ignored by the OSPM.
> [...]
> 

Yes, that's what I saw. So ignoring it all the time is fine, right?
Presumably the madt->address field is only referenced here because
some pre-5.1 implementations used to do that.

	Arnd
