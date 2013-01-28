Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab3A1SKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:10:18 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:34015 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab3A1SKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:10:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130128101135.GD7168@gmail.com>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
	<FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
	<CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
	<20130128101135.GD7168@gmail.com>
Date: Mon, 28 Jan 2013 10:10:14 -0800
X-Google-Sender-Auth: HHJkbPQ4T_CWQvU5zcgTPKiXxTo
Message-ID: <CAE9FiQUtQ4uaBZxndV+acHW55JL5-nb0EnuXHhwiB-mK8Swtag@mail.gmail.com>
Subject: Re: [PATCH] x86/apic: check FADT settings after enable x2apic
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 2:11 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>> HP has systems that work with x2apic phys mode and BIOS set
>> ACPI_FADT_APIC_PHYSICAL in FADT table, and all cpuid < 255,
>> the spec requires BIOS only put system on xapic mode. Kernel
>
> Which spec?
>
>> will set to x2apic logical mode instead of x2apic phys mode.
>
> Which has exactly what bad effect on users of these systems?
>
> You left out the most important information from the changelog:
> why do users care, what good does the patch do?

please check you are happy with this:

---
From:   Stoney Wang <song-bo.wang@hp.com>
Subject: [PATCH] x86, apic: Check fadt x2apic phys in x2apic_phys_probe()

HP has systems that only work with x2apic phys mode and BIOS set
ACPI_FADT_APIC_PHYSICAL in FADT table. But all apicid < 255,
according to x2apic-spec, chapter 2.9, BIOS need to pass the control
to the OS with xapic mode.
Kernel will set apic driver wrong to x2apic cluster instead of x2apic phys.

The user will have to append nox2apic in boot command line to stay xapic mode,
or append x2apic_phys to switch to x2apic phys mode.

That is kernel bug about handling fadt phys bit.

Current code handle x2apic as:
1. When BIOS set x2apic mode:
When user specify x2apic_phys, or FADT indicates PHYSICAL.
During madt oem check, apic driver is set correctly to x2apic phys driver.

2. When BIOS does NOT set x2apic mode:
When user specify x2apic_phys, or FADT indicates PHYSICAL.
During madt oem check, apic driver is set with xapic logical or
xapic phys driver at first.
Later enable_IR_x2apic() will enable x2apic_mode.
After that, x2apic_phys_probe() will install right x2apic phys driver
when user specify x2apic_phys,
but will skip and let x2apic_cluster_probe to take over to install
wrong apic driver (x2apic cluster) when FADT indicates
PHYSICAL, because x2apic_phys_probe does not check FADT PHYSICAL.

Fix that by adding check x2apic_fadt_phys in x2apic_phys_probe().

[ changelog, and simplify code - Yinghai Lu ]
Signed-off-by: Stoney Wang <song-bo.wang@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
