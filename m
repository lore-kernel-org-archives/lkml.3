Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaA3AIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:08:38 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:57841 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaA3AIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:08:34 -0500
Date: Wed, 29 Jan 2014 17:08:31 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: eiichiro.oiwa.nm@hitachi.com, Dave Airlie <airlied@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: In "pci_fixup_video" check if this is or should be the primary
 video devi
Message-ID: <20140130000831.GJ16825@google.com>
References: <1389499841-6097-1-git-send-email-linux@eikelenboom.it>
 <XNM1$9$0$4$$3$3$7$A$9006858U52d4d109@hitachi.com>
 <6310129377.20140114162641@eikelenboom.it>
 <XNM1$9$0$4$$3$3$7$A$9006860U52d614ca@hitachi.com>
 <126550032.20140115203605@eikelenboom.it>
 <CAErSpo7Bjo3rVCnuf9fkKc=T33Z5ZBzS+nHOBqDDKt1j4u0yWg@mail.gmail.com>
 <1524137311.20140115232528@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524137311.20140115232528@eikelenboom.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 11:25:28PM +0100, Sander Eikelenboom wrote:
> Date: Sun, 12 Jan 2014 04:49:44 +0100
> Subject: [PATCH] In "pci_fixup_video" check if this is or should be the
>  primary video device to prevent setting the
>  IORESOURCE_ROM_SHADOW flag on a secondary VGA card
> To: Dave Airlie <airlied@redhat.com>,
>     Eiichiro Oiwa <eiichiro.oiwa.nm@hitachi.com>,
>     Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
>     linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> 
> Setting the IORESOURCE_ROM_SHADOW flag on a secondary VGA card prevents if from
> reading it's own rom. It will get the content of the shadowrom at C000 instead,
> which is of the primary VGA card and the driver of the secondary card will bail
> out.
> 
> Fix this by checking if this is or should be the primary video device before
> applying the fix and let the comment reflect this.
> 
> Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
> ---
>  arch/x86/pci/fixup.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
> index b046e07..525e49a 100644
> --- a/arch/x86/pci/fixup.c
> +++ b/arch/x86/pci/fixup.c
> @@ -314,9 +314,9 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,        PCI_DEVICE_ID_INTEL_MCH_PC1,    pcie_r
>   * IORESOURCE_ROM_SHADOW is used to associate the boot video
>   * card with this copy. On laptops this copy has to be used since
>   * the main ROM may be compressed or combined with another image.
> - * See pci_map_rom() for use of this flag. IORESOURCE_ROM_SHADOW
> - * is marked here since the boot video device will be the only enabled
> - * video device at this point.
> + * See pci_map_rom() for use of this flag. Before we mark the device
> + * with IORESOURCE_ROM_SHADOW we have to check if this is or should become
> + * the primary video card, since this quirk is ran for all video devices.
>   */
>  
>  static void pci_fixup_video(struct pci_dev *pdev)
> @@ -347,12 +347,13 @@ static void pci_fixup_video(struct pci_dev *pdev)
>                 }
>                 bus = bus->parent;
>         }
> -       pci_read_config_word(pdev, PCI_COMMAND, &config);
> -       if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
> -               pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
> -               dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
> -               if (!vga_default_device())
> +       if (!vga_default_device() || pdev == vga_default_device()) {
> +               pci_read_config_word(pdev, PCI_COMMAND, &config);
> +               if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
> +                       pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
> +                       dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
>                         vga_set_default_device(pdev);
> +               }

ia64 also has a pci_fixup_video() that is essentially the same.  Can you
fix that one as well, unless there is a reason why the fix applies only to
x86 and not to ia64?

>         }
>  }
>  DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
> -- 
> 1.7.10.4


