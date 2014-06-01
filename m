Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaFAUms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 16:42:48 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:43711 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaFAUmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 16:42:46 -0400
MIME-Version: 1.0
In-Reply-To: <1401639223-3441-1-git-send-email-matthew.garrett@nebula.com>
References: <1401639223-3441-1-git-send-email-matthew.garrett@nebula.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Sun, 1 Jun 2014 22:42:25 +0200
Message-ID: <CAMxnaaUh0s5A6x=N9VEeHGFkATDsYAtfz3JoLOLYA5jKSVyFwA@mail.gmail.com>
Subject: Re: [PATCH] Thunderbolt: Add support for Thunderbolt 2 host controllers
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2014 at 6:13 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> Adding extra device IDs is enough to get this working on the second-gen
> Thunderbolt controller in the Mac Pro.
>
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  drivers/pci/quirks.c         | 2 ++
>  drivers/thunderbolt/nhi.c    | 5 +++++
>  drivers/thunderbolt/switch.c | 5 ++++-
>  3 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index c3170d4..20e76d0 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3083,6 +3083,8 @@ out:
>  }
>  DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x1547,
>                                quirk_apple_wait_for_thunderbolt);
> +DECLARE_PCI_FIXUP_SUSPEND_LATE(PCI_VENDOR_ID_INTEL, 0x156d,
> +                              quirk_apple_wait_for_thunderbolt);
>  #endif
Just to check: Did they split up the device ids? Is 0x156d for the
bridges and 0x156c for the NHI?

>
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
> diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
> index 6f666fa..85b11d6 100644
> --- a/drivers/thunderbolt/nhi.c
> +++ b/drivers/thunderbolt/nhi.c
> @@ -642,6 +642,11 @@ struct pci_device_id nhi_ids[] = {
>                 .vendor = PCI_VENDOR_ID_INTEL, .device = 0x1547,
>                 .subvendor = 0x2222, .subdevice = 0x1111,
>         },
> +       {
> +               .class = PCI_CLASS_SYSTEM_OTHER << 8, .class_mask = ~0,
> +               .vendor = PCI_VENDOR_ID_INTEL, .device = 0x156c,
> +               .subvendor = 0x2222, .subdevice = 0x1111,
> +       },
>         { 0,}
>  };
>
> diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
> index 2e19045..1fccdbf 100644
> --- a/drivers/thunderbolt/switch.c
> +++ b/drivers/thunderbolt/switch.c
> @@ -294,8 +294,11 @@ static int tb_plug_events_active(struct tb_switch *sw, bool active)
>
>         if (active) {
>                 data = data & 0xFFFFFF83;
> -               if (sw->config.device_id == 0x1547)
> +               switch (sw->config.device_id) {
> +               case 0x1547:
> +               case 0x156d:
>                         data |= 4;
> +               }
>         } else {
>                 data = data | 0x7c;
>         }
> --
> 2.0.0
>

I have had a look at what os x does. They split between:
1513, 151a, 1549 and 1547, 1548, 1567, 1569, 156b, 156d (the latter
group gets bit 3 set)

It looks like the first 3 are legacy devices, so maybe reverse the check?

So far I could decode:
1547: cactus ridge (2 and 4 port?)
1549: ethernet adapter
156b: 2 port falcon ridge
156d: 4 port falcon ridge
