Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab3HJOCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 10:02:12 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45157 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab3HJOCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 10:02:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130809185036.GG25111@titan.lakedaemon.net>
References: <20130808170822.82bf33d3cf5100f5e2646815@canb.auug.org.au>
 <5203F978.2050504@infradead.org> <20130809145939.GE25111@titan.lakedaemon.net>
 <52051BC2.2060004@infradead.org> <20130809185036.GG25111@titan.lakedaemon.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 10 Aug 2013 08:01:49 -0600
Message-ID: <CAErSpo6S9uYTEhoS-+4EZv41pc0bu6jvcMaGX7WR9hY4o+2dsA@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 8 (not CONFIG_PCI_MSI conflict)
To: Jason Cooper <jason@lakedaemon.net>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next list <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 12:50 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> Randy,
>
> On Fri, Aug 09, 2013 at 09:41:38AM -0700, Randy Dunlap wrote:
>> On 08/09/13 07:59, Jason Cooper wrote:
>> > Randy,
>> >
>> > On Thu, Aug 08, 2013 at 01:03:04PM -0700, Randy Dunlap wrote:
>> >> On 08/08/13 00:08, Stephen Rothwell wrote:
>> >>> Hi all,
>> >>>
>> >>> Changes since 20130807:
>> >>>
>> >>
>> >> on i386 and x86_64:
>> >> when CONFIG_PCI_MSI is not enabled:
>> >>
>> >> There are many of these errors:
>> >> include/linux/msi.h:65:6: error: expected identifier or '(' before 'void'
>> >> include/linux/msi.h:65:6: error: expected ')' before numeric constant
>> >>
>> >> because arch/x86/include/asm/pci.h defines:
>> >> #define default_teardown_msi_irqs  NULL
>> >
>> > Do you have an example config you used?
>>
>> Sure, attached. (or I have 14 of them)
>
> Thanks, I was able to reproduce the error.  I'm not real familiar with
> this area of the code, but the relief is it doesn't appear to be caused
> by the mvebu changes (well, relief for us ;-) ).
>
> At any rate, give this a spin and see if it works for you
>
> If it's acceptable, I'll do an official patch for Bjorn.
>
> thx,
>
> Jason.
>
> ---------->8----------
> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> index d9e9e6c..6169414 100644
> --- a/arch/x86/include/asm/pci.h
> +++ b/arch/x86/include/asm/pci.h
> @@ -138,8 +138,8 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq);
>  #else
>  #define native_setup_msi_irqs          NULL
>  #define native_teardown_msi_irq                NULL
> -#define default_teardown_msi_irqs      NULL
> -#define default_restore_msi_irqs       NULL
> +void __weak default_teardown_msi_irqs(struct pci_dev *dev) { }
> +void __weak default_restore_msi_irqs(struct pci_dev *dev, int irq) { }

I don't really like this solution of putting the empty implementation
in the header file, because then a weak body is generated in the
object of every source file that includes the header.

default_teardown_msi_irqs() and default_restore_msi_irqs() seem like
fairly internal MSI functions, so I wonder why we need them defined at
all when CONFIG_PCI_MSI=n.  It seems like any uses of them should be
in code that's only compiled when CONFIG_PCI_MSI=y.  But I haven't
reproduced the problem and investigated yet.

>  #endif
>
>  #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
