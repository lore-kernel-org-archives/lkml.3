Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaIYSXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:23:16 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:43879 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaIYSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:23:14 -0400
MIME-Version: 1.0
In-Reply-To: <54243978.3030501@canonical.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
	<1386546869-31900-3-git-send-email-yinghai@kernel.org>
	<CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>
	<CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
	<CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
	<CAE9FiQXf6w0u+JLu-JHd45ofSTShaB0MoMNbck9EE-y3u6B98w@mail.gmail.com>
	<52A8BAC5.70006@canonical.com>
	<CAE9FiQV8mfF6SMTbZN5H+DmyuM0663wQyoKYJDa7MiBR4i7XQg@mail.gmail.com>
	<52D01D82.5070202@canonical.com>
	<CAE9FiQUD0XvPJNFNMoqX6J67TKuGcj+pSbj+iPUf=fvC-4UXOQ@mail.gmail.com>
	<54189BCE.2010206@canonical.com>
	<CAE9FiQX1pfciTcuF3_eggQLCn=LvTSLTT0UZxTb+z_RaLHwgJQ@mail.gmail.com>
	<54243978.3030501@canonical.com>
Date: Thu, 25 Sep 2014 11:23:13 -0700
X-Google-Sender-Auth: cd_HM_Z9r_-GSC_5OBLxINZvOP0
Message-ID: <CAE9FiQX0jt2Y8WQ5Ydx4u-3=ewtumcYxn0QhTZR4mRVOv945Fg@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio
From: Yinghai Lu <yinghai@kernel.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 8:49 AM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> On 09/16/2014 06:27 PM, Yinghai Lu wrote:
>> On Tue, Sep 16, 2014 at 1:21 PM, Joseph Salisbury
>> <joseph.salisbury@canonical.com> wrote:
>>> A new bug[0] was opened due to enabling PCI_REALLOC_ENABLE_AUTO, which
>>> is similar to the original bug[1] we discussed.
>>>
>>> Just wondering if there have been any additional ideas on realloc since
>>> this was last discussed?
>>>
>>> [0] http://pad.lv/1363313
>>> [1] http://pad.lv/1245938
>> This one looks different, that LSI card support SRIOV, but BIOS does not
>> allocate resource to SRIOV bar.
>> We release old resource and ...reallocate resource to them with two retries.
>
> The user collected earlydump data, which can be found here:
> https://launchpadlibrarian.net/185141163/dmesg-pci%3Dearlydump

Did you ask the user to test reset_lsi_pci_devices.patch?

> ---
>  drivers/pci/setup-bus.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> Index: linux-2.6/drivers/pci/setup-
bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -1615,6 +1615,22 @@ again:
>                                                fail_res->flags & type_mask,
>                                                rel_type);
>
> +     /* reset LSI device */
> +     list_for_each_entry(fail_res, &fail_head, list) {
> +             struct pci_dev *pdev;
> +             struct pci_bus *pbus = fail_res->dev->bus;
> +
> +             if (pci_is_root_bus(pbus) || !pbus->self)
> +                     continue;
> +
> +             /* LSI device firmware is not happy with changing BAR value */
> +             list_for_each_entry(pdev, &pbus->devices, bus_list)
> +                     if (pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC) {
> +                             pci_reset_secondary_bus(pbus->self);
> +                             break;
> +                     }
> +     }
> +
>       /* restore size and flags */
>       list_for_each_entry(fail_res, &fail_head, list) {
>               struct resource *res = fail_res->res;

Thanks

Yinghai
