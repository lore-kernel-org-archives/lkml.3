Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaJ1SN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:13:29 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:59909 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbaJ1SNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <1414387308-27148-2-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com> <1414387308-27148-2-git-send-email-jiang.liu@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 28 Oct 2014 12:13:01 -0600
Message-ID: <CAErSpo5Dh8rx42HkS3cPoJ1=oQq2qsFAut5LK83obbghy+OsFA@mail.gmail.com>
Subject: Re: [Patch v7 01/18] ACPI, irq: fix regression casued by 6b9fb7082409
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject should describe the change you're making.  "Fix regression
caused by xxx" doesn't say anything about what the patch does.

On Sun, Oct 26, 2014 at 11:21 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> When IOAPIC is disabled, acpi_gsi_to_irq() should return gsi directly
> instead of calling mp_map_gsi_to_irq() to translate gsi to IRQ by IOAPIC.

I don't know what the convention is or if there even is one, but "GSI"
is even more of an acronym than "IRQ", so I'd capitalize it.

> It fixes https://bugzilla.kernel.org/show_bug.cgi?id=84381.

A line like the following may be useful to those who have to backport this.

Fixes: 6b9fb7082409 ("x86, ACPI, irq: Consolidate algorithm of mapping
(ioapic, pin) to IRQ number")

> Reported-by: Thomas Richter <thor@math.tu-berlin.de>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: rui.zhang@intel.com
> Cc: <stable@vger.kernel.org> # 3.17
> ---
>  arch/x86/kernel/acpi/boot.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index b436fc735aa4..eceba9d9e116 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -604,14 +604,19 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
>
>  int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
>  {
> -       int irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
> +       int irq;
>
> -       if (irq >= 0) {
> +       if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
> +               *irqp = gsi;
> +       } else {
> +               irq = mp_map_gsi_to_irq(gsi,
> +                                       IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
> +               if (irq < 0)
> +                       return -1;
>                 *irqp = irq;
> -               return 0;
>         }
>
> -       return -1;
> +       return 0;
>  }
>  EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
>
> --
> 1.7.10.4
>
