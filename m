Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3FENi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:38:56 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58773 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3FENix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:38:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130605024823.GC27550@gchen.bj.intel.com>
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
 <1369924769-17183-2-git-send-email-betty.dall@hp.com> <20130604131324.GA4829@google.com>
 <20130605024823.GC27550@gchen.bj.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Jun 2013 07:38:32 -0600
Message-ID: <CAErSpo7jea4ZTJ+ZnaX277BqEMv-PUeB1TyWDodSXEDYW-E7Xw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] PCI/AER: Fix incorrect return from aer_hest_parse()
To: Bjorn Helgaas <bhelgaas@google.com>, Betty Dall <betty.dall@hp.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 8:48 PM, Chen Gong <gong.chen@linux.intel.com> wrote:
> On Tue, Jun 04, 2013 at 07:13:24AM -0600, Bjorn Helgaas wrote:
>> Date: Tue, 4 Jun 2013 07:13:24 -0600
>> From: Bjorn Helgaas <bhelgaas@google.com>
>> To: Betty Dall <betty.dall@hp.com>
>> Cc: rjw@sisk.pl, ying.huang@intel.com, linux-acpi@vger.kernel.org,
>>  linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
>>  gong.chen@linux.intel.com
>> Subject: Re: [PATCH v2 1/3] PCI/AER: Fix incorrect return from
>>  aer_hest_parse()
>> User-Agent: Mutt/1.5.21 (2010-09-15)
>>
>> On Thu, May 30, 2013 at 08:39:27AM -0600, Betty Dall wrote:
>> > The function aer_hest_parse() is called to determine if the given
>> > PCI device is firmware first or not. The code loops through each
>> > section of the HEST table to look for a match. The bug is that
>> > the function always returns whether the last HEST section is firmware
>> > first. The fix stops the iteration once the info.firmware_first
>> > variable is set.  This is similar to how the function aer_hest_parse_aff()
>> > stops the iteration.
>> >
>> > Signed-off-by: Betty Dall <betty.dall@hp.com>
>> > ---
>> >
>> >  drivers/pci/pcie/aer/aerdrv_acpi.c |    3 +++
>> >  1 files changed, 3 insertions(+), 0 deletions(-)
>> >
>> >
>> > diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
>> > index 5194a7d..39b8671 100644
>> > --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
>> > +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
>> > @@ -42,6 +42,9 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
>> >     u8 bridge = 0;
>> >     int ff = 0;
>> >
>> > +   if (info->firmware_first)
>> > +           return 0;
>> > +
>> >     switch (hest_hdr->type) {
>> >     case ACPI_HEST_TYPE_AER_ROOT_PORT:
>> >             pcie_type = PCI_EXP_TYPE_ROOT_PORT;
>>
>>
>> 1) I think dev->__aer_firmware_first should be initialized somewhere in the
>> pci_scan_single_device() path, e.g., maybe pci_init_capabilities().  It's
>> known at device add-time and never changes, so there's no point in doing
>> the lazy setup we do now.  That would let us get rid of
>> __aer_firmware_first_valid, too (along with the pointless "__" prefix).
>> This is just an observation, not a requirement for this patch set.
>>
>> 2) This is a band-aid that covers up the real problem, which is that we
>> update info->firmware_first even for non-matching devices.  I think we
>> should do something like the following instead:
>>
>>
>> commit c67612f272f1792a08f012f1b5ca37d5cfde5de4
>> Author: Bjorn Helgaas <bhelgaas@google.com>
>> Date:   Mon Jun 3 16:49:12 2013 -0600
>>
>>     PCI/AER: Don't parse HEST table for non-PCIe devices
>>
>>     AER is a PCIe-only capability, so there's no point in trying to match
>>     a HEST PCIe structure with a non-PCIe device.
>>
>>     Previously, a HEST global AER bridge entry (type 8) could incorrectly
>>     match *any* bridge, even a legacy PCI-PCI bridge, and a non-global
>>     HEST entry could match a legacy PCI device.
>>
> If so, it should be a BIOS bug, right? (BIOS should not contain PCI device
> for AER structure).

There are two cases here:

1) HEST contains AER_BRIDGE structure with "global" bit set.  The
current code will set firmware_first for any P2P bridge, even non-PCIe
ones.  This is a Linux bug, not a BIOS problem.

2) HEST contains a non-global entry with bus/dev/fn matching a
non-PCIe device.  This is indeed a BIOS bug.

> And I agree that your patch tries to avoid this scenario, but even one PCI
> device is set FFM enabled, as you mentioned above, AER is only for PCIe,
> which means a PCI device will not trigger such an event, so it should be
> harmless, in principle. But in practice, I totally agree with you that
> should be fixed.

I think I agree.  Setting firmware_first for a non-PCIe device should
be harmless because we only use firmware_first in
pci_enable_pcie_error_reporting().  There, we return an error if
firmware_first is set.  We also return an error if the device doesn't
have the AER capability.  So setting firmware_first on a PCI
(non-PCIe) device just means we'll return the error a little sooner.

Thanks for reviewing all this stuff!

Bjorn

> Reviewed-by: Chen Gong <gong.chen@linux.intel.com>
>
>>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
>> index 5194a7d..4f798ab 100644
>> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
>> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
>> @@ -59,8 +59,7 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
>>
>>       p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
>>       if (p->flags & ACPI_HEST_GLOBAL) {
>> -             if ((pci_is_pcie(info->pci_dev) &&
>> -                  pci_pcie_type(info->pci_dev) == pcie_type) || bridge)
>> +             if ((pci_pcie_type(info->pci_dev) == pcie_type) || bridge)
>>                       ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
>>       } else
>>               if (hest_match_pci(p, info->pci_dev))
>> @@ -89,6 +88,9 @@ static void aer_set_firmware_first(struct pci_dev *pci_dev)
>>
>>  int pcie_aer_get_firmware_first(struct pci_dev *dev)
>>  {
>> +     if (!pci_is_pcie(dev))
>> +             return 0;
>> +
>>       if (!dev->__aer_firmware_first_valid)
>>               aer_set_firmware_first(dev);
>>       return dev->__aer_firmware_first;
>>
>> commit 947da50270686b0d70f4bc2f7323ef7229489ecb
>> Author: Bjorn Helgaas <bhelgaas@google.com>
>> Date:   Mon Jun 3 15:42:00 2013 -0600
>>
>>     PCI/AER: Factor out HEST device type matching
>>
>>     This factors out the matching of HEST structure type and PCIe device type
>>     to improve readability.  No functional change.
>>
>>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>
> Reviewed-by: Chen Gong <gong.chen@linux.intel.com>
>
>> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
>> index 4f798ab..56e2d94 100644
>> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
>> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
>> @@ -29,6 +29,22 @@ static inline int hest_match_pci(struct acpi_hest_aer_common *p,
>>                p->function == PCI_FUNC(pci->devfn));
>>  }
>>
>> +static inline bool hest_match_type(struct acpi_hest_header *hest_hdr,
>> +                                struct pci_dev *dev)
>> +{
>> +     u16 hest_type = hest_hdr->type;
>> +     u8 pcie_type = pci_pcie_type(dev);
>> +
>> +     if ((hest_type == ACPI_HEST_TYPE_AER_ROOT_PORT &&
>> +          pcie_type == PCI_EXP_TYPE_ROOT_PORT) ||
>> +         (hest_type == ACPI_HEST_TYPE_AER_ENDPOINT &&
>> +          pcie_type == PCI_EXP_TYPE_ENDPOINT) ||
>> +         (hest_type == ACPI_HEST_TYPE_AER_BRIDGE &&
>> +          (dev->class >> 16) == PCI_BASE_CLASS_BRIDGE))
>> +             return true;
>> +     return false;
>> +}
>> +
>>  struct aer_hest_parse_info {
>>       struct pci_dev *pci_dev;
>>       int firmware_first;
>> @@ -38,28 +54,11 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
>>  {
>>       struct aer_hest_parse_info *info = data;
>>       struct acpi_hest_aer_common *p;
>> -     u8 pcie_type = 0;
>> -     u8 bridge = 0;
>>       int ff = 0;
>>
>> -     switch (hest_hdr->type) {
>> -     case ACPI_HEST_TYPE_AER_ROOT_PORT:
>> -             pcie_type = PCI_EXP_TYPE_ROOT_PORT;
>> -             break;
>> -     case ACPI_HEST_TYPE_AER_ENDPOINT:
>> -             pcie_type = PCI_EXP_TYPE_ENDPOINT;
>> -             break;
>> -     case ACPI_HEST_TYPE_AER_BRIDGE:
>> -             if ((info->pci_dev->class >> 16) == PCI_BASE_CLASS_BRIDGE)
>> -                     bridge = 1;
>> -             break;
>> -     default:
>> -             return 0;
>> -     }
>> -
>>       p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
>>       if (p->flags & ACPI_HEST_GLOBAL) {
>> -             if ((pci_pcie_type(info->pci_dev) == pcie_type) || bridge)
>> +             if (hest_match_type(hest_hdr, info->pci_dev))
>>                       ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
>>       } else
>>               if (hest_match_pci(p, info->pci_dev))
>>
>> commit e9f977a04d96a54c4f6aa0b831e725dab2154364
>> Author: Bjorn Helgaas <bhelgaas@google.com>
>> Date:   Mon Jun 3 19:47:27 2013 -0600
>>
>>     PCI/AER: Set dev->__aer_firmware_first only for matching devices
>>
>>     Previously, we always updated info->firmware_first, even for HEST entries
>>     that didn't match the device.  Therefore, if the last HEST descriptor was
>>     a PCIe structure that didn't match the device, we always cleared
>>     dev->__aer_firmware_first.
>>
>>     Based-on-patch-by: Betty Dall <betty.dall@hp.com>
>>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>
> Reviewed-by: Chen Gong <gong.chen@linux.intel.com>
>
>> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
>> index 56e2d94..2bedad8 100644
>> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
>> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
>> @@ -54,16 +54,16 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
>>  {
>>       struct aer_hest_parse_info *info = data;
>>       struct acpi_hest_aer_common *p;
>> -     int ff = 0;
>> +     int ff;
>>
>>       p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
>> -     if (p->flags & ACPI_HEST_GLOBAL) {
>> +     ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
>> +     if (p->flags & ACPI_HEST_GLOBAL)
>>               if (hest_match_type(hest_hdr, info->pci_dev))
>> -                     ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
>> -     } else
>> +                     info->firmware_first = ff;
>> +     else
>>               if (hest_match_pci(p, info->pci_dev))
>> -                     ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
>> -     info->firmware_first = ff;
>> +                     info->firmware_first = ff;
>>
>>       return 0;
>>  }
