Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3JDRhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:37:17 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39064 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3JDRgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:36:54 -0400
MIME-Version: 1.0
In-Reply-To: <1380794354-9079-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <20130930171849.GW3106@phenom.dumpdata.com> <1380794354-9079-1-git-send-email-thomas.petazzoni@free-electrons.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 Oct 2013 11:36:33 -0600
Message-ID: <CAErSpo4a+LeJ=bok+idNHEFw96ySxYA2JywRwTq0VDMtL0d=5A@mail.gmail.com>
Subject: Re: [PATCH] x86: fix PCI_MSI build on !SMP
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        daniel.price@gmail.com, Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Konrad]

On Thu, Oct 3, 2013 at 3:59 AM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:
> Commit ebd97be635 ('PCI: remove ARCH_SUPPORTS_MSI kconfig option')
> removed the ARCH_SUPPORTS_MSI option which architectures could select
> to indicate that they support MSI. Now, all architectures are supposed
> to build fine when MSI support is enabled: instead of having the
> architecture tell *when* MSI support can be used, it's up to the
> architecture code to ensure that MSI support can be enabled.
>
> On x86, commit ebd97be635 removed the following line:
>
>   select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
>
> Which meant that MSI support was only available when the local APIC
> and I/O APIC were enabled. While this is always true on SMP or x86-64,
> it is not necessarily the case on i386 !SMP.
>
> The below patch makes sure that the local APIC and I/O APIC support is
> always enabled when MSI support is enabled. To do so, it:
>
>  * Ensures the X86_UP_APIC option is not visible when PCI_MSI is
>    enabled. This is the option that allows, on UP machines, to enable
>    or not the APIC support. It is already not visible on SMP systems,
>    or x86-64 systems, for example. We're simply also making it
>    invisible on i386 MSI systems.
>
>  * Ensures that the X86_LOCAL_APIC and X86_IO_APIC options are 'y'
>    when PCI_MSI is enabled.
>
> Notice that this change requires a change in drivers/iommu/Kconfig to
> avoid a recursive Kconfig dependencey. The AMD_IOMMU option selects
> PCI_MSI, but was depending on X86_IO_APIC. This dependency is no
> longer needed: as soon as PCI_MSI is selected, the presence of
> X86_IO_APIC is guaranteed. Moreover, the AMD_IOMMU already depended on
> X86_64, which already guaranteed that X86_IO_APIC was enabled, so this
> dependency was anyway redundant.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: bhelgaas@google.com
> Cc: benh@kernel.crashing.org
> Cc: daniel.price@gmail.com
> Cc: thierry.reding@gmail.com
> Cc: linux-kernel@vger.kernel.org
> Cc: jason@lakedaemon.net
> Cc: x86@kernel.org

FWIW,

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

x86 maintainers, I assume you'll pick this up.  Let me know if you
want me to do it.

Bjorn
