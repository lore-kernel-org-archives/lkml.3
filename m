Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab3FRSHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:07:38 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:48772 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab3FRSHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:07:35 -0400
MIME-Version: 1.0
In-Reply-To: <1678257.RBpxK26BQQ@vostro.rjw.lan>
References: <1371543734-14148-1-git-send-email-wangyijing@huawei.com> <1678257.RBpxK26BQQ@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Jun 2013 12:07:14 -0600
Message-ID: <CAErSpo6KX8971qYX65f95RBeZMrMCUbixtiLLZU8w3rxO7tZ9Q@mail.gmail.com>
Subject: Re: [PATCH 7/9] PCI: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 7:44 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, June 18, 2013 04:22:14 PM Yijing Wang wrote:
>> Pci pm cap register offset has been saved in pci_pm_init(),
>> so we can use pdev->pm_cap instead of using pci_find_capability(..)
>> here.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> Cc: linux-pci@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Applied to my pci/misc branch for v3.11, thanks!

>> ---
>>  drivers/pci/pci.c    |    2 +-
>>  drivers/pci/quirks.c |    6 ++----
>>  2 files changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index a899d8b..1117f2c 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -805,7 +805,7 @@ pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state)
>>  {
>>       pci_power_t ret;
>>
>> -     if (!pci_find_capability(dev, PCI_CAP_ID_PM))
>> +     if (!dev->pm_cap)
>>               return PCI_D0;
>>
>>       ret = platform_pci_choose_state(dev);
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index 7d68aee..422812b 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -1832,7 +1832,6 @@ static void quirk_e100_interrupt(struct pci_dev *dev)
>>       u16 command, pmcsr;
>>       u8 __iomem *csr;
>>       u8 cmd_hi;
>> -     int pm;
>>
>>       switch (dev->device) {
>>       /* PCI IDs taken from drivers/net/e100.c */
>> @@ -1870,9 +1869,8 @@ static void quirk_e100_interrupt(struct pci_dev *dev)
>>        * Check that the device is in the D0 power state. If it's not,
>>        * there is no point to look any further.
>>        */
>> -     pm = pci_find_capability(dev, PCI_CAP_ID_PM);
>> -     if (pm) {
>> -             pci_read_config_word(dev, pm + PCI_PM_CTRL, &pmcsr);
>> +     if (dev->pm_cap) {
>> +             pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
>>               if ((pmcsr & PCI_PM_CTRL_STATE_MASK) != PCI_D0)
>>                       return;
>>       }
>>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
