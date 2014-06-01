Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbaFAKLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 06:11:35 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:54853 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaFAKLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 06:11:33 -0400
MIME-Version: 1.0
In-Reply-To: <1401580281.7663.14.camel@x230>
References: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com> <1401580281.7663.14.camel@x230>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Sun, 1 Jun 2014 12:11:11 +0200
Message-ID: <CAMxnaaURVhZ_SiJW7Qy1bsye1bcPE=J=vjL5MgTN5znP15WnXw@mail.gmail.com>
Subject: Re: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2014 at 1:51 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Sat, 2014-05-31 at 16:27 +0200, Andreas Noever wrote:
>> Hi
>>
>> This is version 4 of my Thunderbolt driver for Apple hardware (see [1] for v3).
>>
>> Changes since v3:
>>  - Fix typos and style problems caught by Bjorn.
>>  - Changed the #ifdef CONFIG_ACPI block to cover the whole pci quirk.
>
> Hi Andreas,
>
> This seems to be working well on my MBP. It appears to broadly work on
> my Mac Pro, which has Thunderbolt 2 hardware - I added the PCI ID, and
> loading the thunderbolt driver after the device is plugged in works, but
> it won't recognise hotplug events. I don't appear to get any interrupts
> from the Thunderbolt controller. Any idea what might be happening there?
So the communication with the controller works (dmesg dumps a list of
ports etc.)? Do you get plug events ("resetting error on port ...")?
You could try to play around with tb_plug_events_active, if you want
to experiment. I can also take another look at what OS X does once I
get back to my workstation (when I worked on this part falcon ridge
was not jet released, so maybe they do things differently now).

> As far as the quirks go - perhaps something like this would be
> reasonable, rather than maintaining a list of machines?
I have obtained ACPI dumps from a late 2013 MBP and from a MacPro
(both are falcon ridge devices) and these contain a few firmware
changes. For example SXIO, SXIL and SXLV are gone so the shutdown
quirk will fail. With some luck that means that the shutdown quirk is
no longer required for falcon ridge hardware.

Can you try the following on your MacPro?
 - Boot with your ACPI patch, nothing plugged in, no thunderbolt driver
 - Verify that NHI is present (lspci)
 - Plug in a tb device
 - Suspend and resume
 - Check that the NHI is still responding using lspci -vv
On my cactus ridge MBP the device id of the NHI now reads 0xffff (the
device is gone, Linux just doesn't know). If the NHI is still alive
then they fixed their hardware :)

Andreas


> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index c9d6b90..c3170d4 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2993,35 +2993,6 @@ DECLARE_PCI_FIXUP_HEADER(0x1814, 0x0601, /*
> Ralink RT2800 802.11n PCI */
>                          quirk_broken_intx_masking);
>
>  #ifdef CONFIG_ACPI
> -/* Apple systems with a Cactus Ridge Thunderbolt controller. */
> -static struct dmi_system_id apple_thunderbolt_whitelist[] = {
> -       {
> -               .matches = {
> -                       DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> -                       DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro9"),
> -               },
> -       },
> -       {
> -               .matches = {
> -                       DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> -                       DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro10"),
> -               },
> -       },
> -       {
> -               .matches = {
> -                       DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> -                       DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir5"),
> -               },
> -       },
> -       {
> -               .matches = {
> -                       DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> -                       DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir6"),
> -               },
> -       },
> -       { }
> -};
> -
>  /*
>   * Apple: Shutdown Cactus Ridge Thunderbolt controller.
>   *
> @@ -3041,7 +3012,7 @@ static void
> quirk_apple_poweroff_thunderbolt(struct pci_dev *dev)
>  {
>         acpi_handle bridge, SXIO, SXFP, SXLV;
>
> -       if (!dmi_check_system(apple_thunderbolt_whitelist))
> +       if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc."))
>                 return;
>         if (pci_pcie_type(dev) != PCI_EXP_TYPE_UPSTREAM)
>                 return;
> @@ -3084,7 +3055,7 @@ static void
> quirk_apple_wait_for_thunderbolt(struct pci_dev *dev)
>         struct pci_dev *sibling = NULL;
>         struct pci_dev *nhi = NULL;
>
> -       if (!dmi_check_system(apple_thunderbolt_whitelist))
> +       if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc."))
>                 return;
>         if (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)
>                 return;
>
>
> --
> Matthew Garrett <matthew.garrett@nebula.com>
