Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3E1VwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:52:15 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45337 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab3E1VwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:52:13 -0400
MIME-Version: 1.0
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 28 May 2013 15:51:52 -0600
Message-ID: <CAErSpo7onNaU5mquJ_a7kwGPgzs3Q_7U89__HT9DbJFkUX4fsQ@mail.gmail.com>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 3:05 AM, Alexander Gordeev <agordeev@redhat.com> wrote:

The subject would make more sense as "Allocate *only* as many MSIs as
requested."

> When multiple MSIs are enabled with pci_enable_msi_block(), the
> requested number of interrupts 'nvec' is rounded up to the nearest
> power-of-two value.

This rounding is just a consequence of the encodings of the Multiple
Message Enable field in the Message Control register (PCI spec r3.0,
sec 6.8.1.3), isn't it?

> The result is then used for setting up the
> number of MSI messages in the PCI device and allocation of
> interrupt resources in the operating system (i.e. vector numbers).
> Thus, in cases when a device driver requests some number of MSIs
> and this number is not a power-of-two value, the extra operating
> system resources (allocated as the result of rounding) are wasted.
>
> This fix introduces 'msi_desc::nvec' field to address the above
> issue. When non-zero, it will report the actual number of MSIs the
> device will send, as requested by the device driver. This value
> should be used by architectures to properly set up and tear down
> associated interrupt resources.

This name needs a little more context, like "nvec_used" or something.

I think the idea is that the Message Control register can only tell
the OS that the device requires 1, 2, 4, 8, 16, or 32 vectors, and
similarly the OS can only tell the device that 1, 2, 4, 8, 16, or 32
vectors are assigned.  If a device can only make use of 18 vectors, it
must advertise the next larger value (32 vectors).  As far as I can
tell, a device *could* advertise 32 vectors in Multiple Message
Capable even if it can only use 1 vector.

These patches are to avoid allocating resources for the unused
vectors, i.e., the ones between the last one the driver requested and
the last one advertised in Multiple Message Capable.  The driver might
request fewer than the maximum either because it knows the device
isn't capable of using them all, or because the driver author decided
not to use them all.

(Sorry, just thinking out loud above, let me know if I'm not
understanding this correctly.)

> Note, although the existing 'msi_desc::multiple' field might seem
> redundant, in fact in does not. In general case the number of MSIs a
> PCI device is initialized with is not necessarily the closest power-
> of-two value of the number of MSIs the device will send. Thus, in
> theory it would not be always possible to derive the former from the
> latter and we need to keep them both, to stress this corner case.
> Besides, since 'msi_desc::multiple' is a bitfield, throwing it out
> would not save us any space.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/pci/msi.c   |   10 ++++++++--
>  include/linux/msi.h |    1 +
>  2 files changed, 9 insertions(+), 2 deletions(-)

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I'd be happy to push these though my tree (given an Ack from Joerg),
or they can go another way.  Let me know if you want me to take them.

> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 00cc78c7..014b9d5 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -79,7 +79,10 @@ void default_teardown_msi_irqs(struct pci_dev *dev)
>                 int i, nvec;
>                 if (entry->irq == 0)
>                         continue;
> -               nvec = 1 << entry->msi_attrib.multiple;
> +               if (entry->nvec)
> +                       nvec = entry->nvec;
> +               else
> +                       nvec = 1 << entry->msi_attrib.multiple;
>                 for (i = 0; i < nvec; i++)
>                         arch_teardown_msi_irq(entry->irq + i);
>         }
> @@ -340,7 +343,10 @@ static void free_msi_irqs(struct pci_dev *dev)
>                 int i, nvec;
>                 if (!entry->irq)
>                         continue;
> -               nvec = 1 << entry->msi_attrib.multiple;
> +               if (entry->nvec)
> +                       nvec = entry->nvec;
> +               else
> +                       nvec = 1 << entry->msi_attrib.multiple;
>  #ifdef CONFIG_GENERIC_HARDIRQS
>                 for (i = 0; i < nvec; i++)
>                         BUG_ON(irq_has_action(entry->irq + i));
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index ce93a34..0e20dfc 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -35,6 +35,7 @@ struct msi_desc {
>
>         u32 masked;                     /* mask bits */
>         unsigned int irq;
> +       unsigned int nvec;              /* number of messages */
>         struct list_head list;
>
>         union {
> --
> 1.7.7.6
>
>
> --
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
