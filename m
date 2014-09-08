Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaIHQg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:36:59 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:35592 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaIHQg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:36:58 -0400
MIME-Version: 1.0
In-Reply-To: <1410163532-31057-1-git-send-email-lisovy@gmail.com>
References: <1410163532-31057-1-git-send-email-lisovy@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 8 Sep 2014 10:36:36 -0600
Message-ID: <CAErSpo7sOc72V3g5tOov8Yj4nKiuJupaUTKEEecHMcqEUrzh_g@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: PCI: Use PCI_CLASS_* defines for PCI class
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Yijing Wang <wangyijing@huawei.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike.rapoport@ravellosystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Mike]

This doesn't touch drivers/pci or conflict with any PCI-related
changes, so I'll leave this up to Russell.  My comments on this are
just kibbitzing.

On Mon, Sep 8, 2014 at 2:05 AM, Rostislav Lisovy <lisovy@gmail.com> wrote:
> Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
> Reviewed-by: Yijing Wang <wangyijing@huawei.com>
> ---
> The header file include/linux/pci_ids.h defines
> #define PCI_CLASS_BRIDGE_OTHER          0x0680
> #define PCI_CLASS_SYSTEM_DMA            0x0801
>
> ((struct pci_dev*)dev)->class
> corresponds to the 3 bytes Class code in the PCI Configuration space
> header -- 1B Base class, 1B Sub-class, 1B Reg-level interface.
>
> In that case
> (PCI_CLASS_BRIDGE_OTHER << 8)
> is equivalent to 0x68000 (imagine the leading zero)
> and
> ((PCI_CLASS_SYSTEM_DMA << 8) | 0x03))
> is equivalent to 0x80103.

This part looks like it's supposed to be the changelog, which should
be above the Signed-off-by.

>  arch/arm/kernel/bios32.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> index 17a26c1..e511ad1 100644
> --- a/arch/arm/kernel/bios32.c
> +++ b/arch/arm/kernel/bios32.c
> @@ -255,10 +255,9 @@ static void pci_fixup_it8152(struct pci_dev *dev)
>  {
>         int i;
>         /* fixup for ITE 8152 devices */
> -       /* FIXME: add defines for class 0x68000 and 0x80103 */
>         if ((dev->class >> 8) == PCI_CLASS_BRIDGE_HOST ||
> -           dev->class == 0x68000 ||
> -           dev->class == 0x80103) {
> +           dev->class == (PCI_CLASS_BRIDGE_OTHER << 8) ||
> +           dev->class == ((PCI_CLASS_SYSTEM_DMA << 8) | 0x03)) {
>                 for (i = 0; i < PCI_NUM_RESOURCES; i++) {
>                         dev->resource[i].start = 0;
>                         dev->resource[i].end   = 0;

The interesting part to me is the part you didn't change, i.e.,
setting the resource start/end/flags to 0.  That's all from
a8fc0789558d ("[ARM] 4577/1: ITE 8152 PCI bridge support"), which
unfortunately doesn't have any more details about *why* this is
needed.

Presumably these devices have PCI BARs (since that's how dev->resource
got filled in), and we want to somehow ignore them, not assign
resources to them, and not allow drivers to use whatever is mapped by
the BARs.  But clearing out the struct resources isn't really safe by
itself.  The hardware BAR still contains some value, and may still be
enabled, which means that it may conflict with other devices.

I guess you're not making a functional change, so maybe we don't need
to worry about this.  But it does leave me scratching my head a bit.

Bjorn
