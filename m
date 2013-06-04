Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab3FDScW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:32:22 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:60053 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3FDScS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:32:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130604083644.GD20448@gchen.bj.intel.com>
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
 <1369924769-17183-4-git-send-email-betty.dall@hp.com> <20130604083644.GD20448@gchen.bj.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 4 Jun 2013 12:31:58 -0600
Message-ID: <CAErSpo6nsstQJZwZ_Rtaik_a0OvL840h5E4T99bFtYDMg3geMQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] PCI/AER: Provide reset_link for firmware first
 root port
To: Betty Dall <betty.dall@hp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>, Huang Ying <ying.huang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 2:36 AM, Chen Gong <gong.chen@linux.intel.com> wrote:
> On Thu, May 30, 2013 at 08:39:29AM -0600, Betty Dall wrote:
>> Date: Thu, 30 May 2013 08:39:29 -0600
>> From: Betty Dall <betty.dall@hp.com>
>> To: rjw@sisk.pl, bhelgaas@google.com
>> Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
>>  linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Betty Dall
>>  <betty.dall@hp.com>
>> Subject: [PATCH v2 3/3] PCI/AER: Provide reset_link for firmware first root
>>  port
>> X-Mailer: git-send-email 1.7.7.6
>>
>> The firmware first path does not install the aerdrv root port
>> service driver, so the firmware first root port does not have
>> a reset_link callback. When a firmware first root port does not have
>> a reset_link callback, use a new default reset_link similar to what
>> we already do for the default_downstream_reset_link(). The firmware
>> first default reset_link brings the root port out of SBR if firmware
>> left it in SBR.
>>
>> Changes since v1:
>> Removed incorrect setting of p2p_ctrl after the read.
>>
>> Signed-off-by: Betty Dall <betty.dall@hp.com>
>> ---
>>
>>  drivers/pci/pcie/aer/aerdrv_core.c |   36 ++++++++++++++++++++++++++++++++++++
>>  1 files changed, 36 insertions(+), 0 deletions(-)
>>
>>
>> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
>> index 8ec8b4f..72f76cd 100644
>> --- a/drivers/pci/pcie/aer/aerdrv_core.c
>> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
>> @@ -413,6 +413,39 @@ static pci_ers_result_t default_downstream_reset_link(struct pci_dev *dev)
>>       return PCI_ERS_RESULT_RECOVERED;
>>  }
>>
>> +/**
>> + * default_ff_root_port_reset_link - default reset function for firmware
>> + *           first Root Port
>> + * @dev: pointer to root port's pci_dev data structure
>> + *
>> + * Invoked when performing link reset at Root Port w/ no aer driver.
>> + * This happens through the firmware first path. Firmware may leave
>> + * the Root Port in SBR and it is the OS responsiblity to bring it out
>> + * of SBR.
>> + */
>> +static pci_ers_result_t default_ff_root_port_reset_link(struct pci_dev *dev)
>> +{
>> +     u16 p2p_ctrl;
>> +
>> +     /* Read Secondary Bus Reset */
>> +     pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &p2p_ctrl);
>> +
>> +     /* De-assert Secondary Bus Reset, if it is set */
>> +     if (p2p_ctrl & PCI_BRIDGE_CTL_BUS_RESET) {
>> +             p2p_ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
>> +             pci_write_config_word(dev, PCI_BRIDGE_CONTROL, p2p_ctrl);
>> +
>> +             /*
>> +              * System software must wait for at least 100ms from the end
>> +              * of a reset of one or more device before it is permitted
>> +              * to issue Configuration Requests to those devices.
>> +              */
>> +             msleep(200);
>> +             dev_dbg(&dev->dev, "Root Port link has been reset\n");
>> +     }
>> +     return PCI_ERS_RESULT_RECOVERED;
>> +}
>
> I don't think this function is OK.
> 1) You don't really reset the 2nd Bus but just checking its status.
> I think you should have following steps to reset 2nd Bus:
>
> a. Assert 2nd Bus Reset
> b. wait for some time until this message has been broadcasted well
> c. De-assert 2nd Bus Reset
> d. wait for Trst time
>
> IOW, since we have aer_do_secondary_bus_reset to perform secondary bus
> reset, why you repeat it again?
>
> 2) msleep(200) is too long for kernel. You'd better yield the CPU when
> sleep.
>
>> +
>>  static int find_aer_service_iter(struct device *device, void *data)
>>  {
>>       struct pcie_port_service_driver *service_driver, **drv;
>> @@ -460,6 +493,9 @@ static pci_ers_result_t reset_link(struct pci_dev *dev)
>>               status = driver->reset_link(udev);
>>       } else if (pci_pcie_type(udev) == PCI_EXP_TYPE_DOWNSTREAM) {
>>               status = default_downstream_reset_link(udev);
>> +     } else if (pci_pcie_type(udev) == PCI_EXP_TYPE_ROOT_PORT &&
>> +             pcie_aer_get_firmware_first(udev)) {
>> +             status = default_ff_root_port_reset_link(udev);

Can we just handle Root Ports the same as Downstream Ports, e.g.,

    if (pci_pcie_type(udev) == PCI_EXP_TYPE_DOWNSTREAM ||
        pci_pcie_type(udev) == PCI_EXP_TYPE_ROOT_PORT)
            status = default_downstream_reset_link(udev);

>>       } else {
>>               dev_printk(KERN_DEBUG, &dev->dev,
>>                       "no link-reset support at upstream device %s\n",
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
