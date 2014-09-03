Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaICSnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 14:43:22 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49764 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaICSnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 14:43:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v3 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
Date: Wed, 03 Sep 2014 20:42:44 +0200
Message-ID: <2893693.4bZJXXENof@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409583475-6978-14-git-send-email-hanjun.guo@linaro.org>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-14-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6ejRh+hdWAs67lPLNSO2Zbkr5MyxYZ8Uq9lcZmCAL89
 M0jrEtCYhThiphPG95rw8lWrrzSAIY2lajE2aS7ZBV02XT8PZj
 9RC15UM3gRcSc5EUXszLHv9a8ziRbxHbGK+cw+dVq1/ZD2krru
 0hyFSrX9UjWnpA/feMwbU7PXWwTwkLSrloEip9KfZ0na3Hun6G
 jXgt/UlkZptWdSaJpzh47s3bmaHTHcOFRIN7lLTMZwxDM1Qc/s
 CFybuFggjUtGeYfsuENBnqsugc6mLB+a+h2JDr39gOyF0E3oU0
 QOheF5wEGX2XoA3SuZ6OwVFpMkNgF9AOzb3RuM1jHqAmUrZum0
 Tc/xJCCRBKFbXuSS+bss=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 22:57:51 Hanjun Guo wrote:
> +       /* Collect CPU base addresses */
> +       count = acpi_parse_entries(sizeof(struct acpi_table_madt),
> +                                  gic_acpi_parse_madt_cpu, table,
> +                                  ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +                                  ACPI_MAX_GIC_CPU_INTERFACE_ENTRIES);
> +       if (count < 0) {
> +               pr_err("Error during GICC entries parsing\n");
> +               return -EFAULT;
> +       } else if (!count) {
> +               /* No GICC entries provided, use address from MADT header */
> +               struct acpi_table_madt *madt = (struct acpi_table_madt *)table;
> +
> +               if (!madt->address)
> +                       return -EFAULT;
> +
> +               cpu_phy_base = (u64)madt->address;
> +       }

After I read through ACPI-5.1 section 5.2.12.14, I wonder if this is the
best way to treat a missing ACPI_MADT_TYPE_GENERIC_INTERRUPT table.

Do we expect to see those in practice? It seems like using the x86 local
APIC address as a fallback for the GIC address is not something we
should do unless we absolutely have to support a system that doesn't
have the GIC table.

	Arnd
