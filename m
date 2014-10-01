Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaJAO25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:28:57 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42441 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJAO2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:28:55 -0400
MIME-Version: 1.0
In-Reply-To: <1412172233.7360.203.camel@ul30vt.home>
References: <1412170733-7187-1-git-send-email-andre.o.richter@gmail.com>
	<1412172233.7360.203.camel@ul30vt.home>
Date: Wed, 1 Oct 2014 16:28:54 +0200
Message-ID: <CAKqeN2-_Sb=f6Q1CGz2VPfuO2YmsQeCbM-mieoykYwRYDv=+GQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] vfio-pci: Add SR-IOV VF configuration via sysfs
From: Andre Richter <andre.o.richter@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I currently use it for early development/debugging work (SR-IOV
capable FPGA boards) where I test both PFs and VFs from userspace.
But I see your point that this may not be relevant for anything you
can buy off the shelf.

Cheers,
Andre

2014-10-01 16:03 GMT+02:00 Alex Williamson <alex.williamson@redhat.com>:
> On Wed, 2014-10-01 at 15:38 +0200, Andre Richter wrote:
>> If a PCIe device bound to vfio-pci happens to be SR-IOV capabale,
>> there is no possibility to bring up/shutdown the device's VFs.
>>
>> This patch adds a generic callback for the sysfs sriov_numvfs attribute.
>> The attribute will only show up for SR-IOV devices. Additionally,
>> each utilized pci_* function checks if the device is a PF.
>>
>> Signed-off-by: Andre Richter <andre.o.richter@gmail.com>
>> ---
>>  drivers/vfio/pci/vfio_pci.c | 25 ++++++++++++++++++++-----
>>  1 file changed, 20 insertions(+), 5 deletions(-)
>
> I don't understand why you'd want to do this.  The PF is typically
> managed by a host driver.  By allowing vfio-pci to manage SR-IOV, don't
> we potentially have assign-able PFs managing assign-able VFs?  That
> seems like a bad idea.  What use case do you have in mind?  Thanks,
>
> Alex
>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index f782533..2f6dfb3 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -919,12 +919,27 @@ static struct pci_error_handlers vfio_err_handlers = {
>>       .error_detected = vfio_pci_aer_err_detected,
>>  };
>>
>> +static int vfio_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
>> +{
>> +     int ret = 0;
>> +
>> +     if (num_vfs > 0) {
>> +             ret = pci_enable_sriov(pdev, num_vfs);
>> +             if (!ret)
>> +                     ret = pci_num_vf(pdev);
>> +     } else
>> +             pci_disable_sriov(pdev);
>> +
>> +     return ret;
>> +}
>> +
>>  static struct pci_driver vfio_pci_driver = {
>> -     .name           = "vfio-pci",
>> -     .id_table       = NULL, /* only dynamic ids */
>> -     .probe          = vfio_pci_probe,
>> -     .remove         = vfio_pci_remove,
>> -     .err_handler    = &vfio_err_handlers,
>> +     .name                   = "vfio-pci",
>> +     .id_table               = NULL, /* only dynamic ids */
>> +     .probe                  = vfio_pci_probe,
>> +     .remove                 = vfio_pci_remove,
>> +     .sriov_configure        = vfio_pci_sriov_configure,
>> +     .err_handler            = &vfio_err_handlers,
>>  };
>>
>>  /*
>
>
>
