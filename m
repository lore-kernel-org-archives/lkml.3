Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaJ1RpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:45:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42048 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaJ1Ro7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:44:59 -0400
Date: Tue, 28 Oct 2014 18:44:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, rui.zhang@intel.com,
        linux-pm@vger.kernel.org
Subject: Re: [Patch v7 01/18] ACPI, irq: fix regression casued by 6b9fb7082409
Message-ID: <20141028174456.GA9134@amd>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
 <1414387308-27148-2-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414387308-27148-2-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> When IOAPIC is disabled, acpi_gsi_to_irq() should return gsi directly
> instead of calling mp_map_gsi_to_irq() to translate gsi to IRQ by IOAPIC.
> It fixes https://bugzilla.kernel.org/show_bug.cgi?id=84381.
> 
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
> -	int irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
> +	int irq;
>  
> -	if (irq >= 0) {
> +	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
> +		*irqp = gsi;

As you have multiple return points, anyway, I'd do return 0; here

> +	} else {
> +		irq = mp_map_gsi_to_irq(gsi,
> +					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
> +		if (irq < 0)
> +			return -1;
>  		*irqp = irq;
> -		return 0;
>  	}

...so that one level of nesting is avoided, and there are no problems
with fiting to 80 colums.

With that,

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
