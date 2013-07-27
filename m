Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3G0Xrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 19:47:53 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:62640 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3G0Xrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 19:47:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130726173956.GA14078@google.com>
References: <51F23D0F.7090909@oracle.com>
	<20130726173956.GA14078@google.com>
Date: Sun, 28 Jul 2013 07:47:50 +0800
Message-ID: <CABawtvOBpqjupVYzc3TS2BGwARmutKi-phcdKHd5bBbiPr2Ceg@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: MMCONFIG: cleanup and add address warning to pci_mmconfig_insert
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ethan zhao <ethan.zhao@oracle.com>, jbarnes@virtuousgeek.org,
        yinghai@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 1:39 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Jiang, linux-pci, -cc bjorn.helgaas@hp.com (dead address)]
>
> On Fri, Jul 26, 2013 at 05:10:39PM +0800, ethan zhao wrote:
>> Cleanup the -EINVAL return value handling and add warning message
>> for invalid
>> start,end,addr parameters.
>>
>> Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
>
> This patch was corrupted, so I couldn't apply it directly.  See
> Documentation/SubmittingPatches, sections 5-7.
>
>> ---
>>  arch/x86/pci/mmconfig-shared.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
>> index 082e881..37f6c7f 100644
>> --- a/arch/x86/pci/mmconfig-shared.c
>> +++ b/arch/x86/pci/mmconfig-shared.c
>> @@ -700,8 +700,13 @@ int pci_mmconfig_insert(struct device *dev, u16
>> seg, u8 start, u8 end,
>>      if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
>>          return -ENODEV;
>>
>> -    if (start > end)
>> +    if (start > end || !addr) {
>> +        dev_warn(dev, FW_WARN
>> +                                 "Invalid address to add MMCONFIG"
>> +                                 "start %02x end %02x addr %pR\n",
>> +                                  start, end, addr);
>>          return -EINVAL;
>> +    }
>
> I like the "!addr" cleanup.
>
> Did you actually see this problem on a machine?
>
> I expect this would be a BIOS bug, and one that should be found
> early in development, long before a machine is released.
> Therefore, I doubt that it's worth adding another printk for it.
> If an end-user sees this problem, I think we'll already get a
> generic message from check_segment().
>

Yes, Maybe I met a BIOS bug, but the mmconfig just yelled a failed message like
this, no other information

"fail to add MMCONFIG information, xx--xx can't access extended PCI
configuration space under this bridge"

While I look into the code, found there are detail messages for other
return values in pci_mmconfig_insert(),
But no for -EINVAL, that is not fair and force me to add more code to
debug  the cause.


> I propose the patch below; what do you think?
>
>>
>>      mutex_lock(&pci_mmcfg_lock);
>>      cfg = pci_mmconfig_lookup(seg, start);
>> @@ -716,11 +721,6 @@ int pci_mmconfig_insert(struct device *dev, u16
>> seg, u8 start, u8 end,
>>          return -EEXIST;
>>      }
>>
>> -    if (!addr) {
>> -        mutex_unlock(&pci_mmcfg_lock);
>> -        return -EINVAL;
>> -    }
>> -
>>      rc = -EBUSY;
>>      cfg = pci_mmconfig_alloc(seg, start, end, addr);
>>      if (cfg == NULL) {
>
>
>
> Author: ethan.zhao <ethan.zhao@oracle.com>
> Date:   Fri Jul 26 11:21:24 2013 -0600
>
>     x86/PCI: MMCONFIG: Check earlier for MMCONFIG region at address zero
>
>     We can check for addr being zero earlier and thus avoid the mutex_unlock()
>     cleanup path.
>
>     [bhelgaas: changelog, drop printk]
>     Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Acked-by: Yinghai Lu <yinghai@kerne.org>
>
> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> index 082e881..5596c7b 100644
> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -700,7 +700,7 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
>         if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
>                 return -ENODEV;
>
> -       if (start > end)
> +       if (start > end || !addr)
>                 return -EINVAL;
>
>         mutex_lock(&pci_mmcfg_lock);
> @@ -716,11 +716,6 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
>                 return -EEXIST;
>         }
>
> -       if (!addr) {
> -               mutex_unlock(&pci_mmcfg_lock);
> -               return -EINVAL;
> -       }
> -
>         rc = -EBUSY;
>         cfg = pci_mmconfig_alloc(seg, start, end, addr);
>         if (cfg == NULL) {
