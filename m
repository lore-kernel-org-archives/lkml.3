Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab3BMCgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:36:19 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:63823 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3BMCgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:36:18 -0500
MIME-Version: 1.0
In-Reply-To: <5119DCCD.70709@zytor.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
	<20130211093417.GC23932@gmail.com>
	<5119DCCD.70709@zytor.com>
Date: Tue, 12 Feb 2013 18:36:17 -0800
X-Google-Sender-Auth: tk0R_P-WkqSz9T6wZH0MsZpix7w
Message-ID: <CAE9FiQWcD8U9YaKQojbRW07rqUjqRQcJw6t9y0Si81tgk-V98Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/26] x86, irq: support ioapic device hotplug
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 10:10 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/11/2013 01:34 AM, Ingo Molnar wrote:
>>
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> Hi,
>>>
>>> Current x86 code does not support iapic hotplug yet.
>>
>> Please give a better high-level description: outline how an
>> IO-APIC will be hotplugged physically and what changes the
>> user will experience.

Intel cpu (from IVB) include cpu, mem controller, and IIO.
When hotadd cpu physically, it will involve cpu hotplug, mem hotplug,
and pci root hotplug.

IIO includes pci host bridge, ioapic controller and iommu.
pci devices will need to use ioapic and iommu.
So to make pci hotplug working, we need to add ioapic hotplug support.

>>
>> That needs at least 2 paragraphs, not one cursory sentence. Then
>> should come technical descriptions - but even those need
>> improvements, please first explain the current status quo, then
>> explain how that is inadequate for IO-APIC hot-plugging, *then*
>> only explain what you are doing in the patch ...

Now ioapics are with ACPI MADT table. During booting, kernel will parse
MADT and put info into ioapic arrays.
Also Bjorn added one pci device based driver, but it is not wired in yet,
as it need to call acpi_register_ioapic, and that is TBD.

This patchset will
1. extend genirq to support reserve/realloc method.
   because we want to irqs for one ioapic controller to be linear mapping
   to the gsi range.
2. change ioapic array operation code so we could insert new ioapic and
   remove one leave the blank slot.
3. record irq_base in gsi_config in ioapic struct, and use it to convert gsi
    to irq for pci device using that ioapic controller
4. make static ioapic path (from MADT) use same code as hotadd path,
   with reserve/realloc.
5. change ioapic add/removing to acpi way, as that is only need when
   pci root bus hotplug. Also it will make it support the case that ioapic
   controller is hiding in pci controller space or ioapic address is not
   managed by pci reallocation system.

>>
>
> A few more notes:
>
> Please explain what you mean with pre-reserve IRQ blocks, and in
> particular, how do you know what to reserve and for what?

For each ioapic controller, and we should get gsi range already.
So we could keep irq to gsi mapping linear for each ioapic controller.

>
> Second, some of the things in this patchset seems to overlap with what
> we would need to support MSI (as opposed to MSI-X), and you have several
> patches related to MSI vs MSI-X.  Are you also supporting multivector
> MSI (I believe the answer is no) or could some of this work make
> multivector MSI practical (possible)?

Patches that is related to MSI/MSI-X, is just print out clean up.
Now we don't tell if it is MSI or MSI-X in /proc/interrupts or dmesg.

Patches from multivector MSI support from Alex are already put in
x86/apic branch by Ingo.

And my v2 patches are on top of x86/apic and pci/next.

Thanks

Yinghai
