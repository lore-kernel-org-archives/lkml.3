Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3HOXYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 19:24:25 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:55158 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3HOXYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 19:24:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4rvankxEA-wQ-yGg2MRVtS49dKctEGdn08GVFt8PdjeQ@mail.gmail.com>
References: <20130808200444.2932.17381.stgit@bling.home>
	<20130808200943.2932.42781.stgit@bling.home>
	<CAErSpo4rvankxEA-wQ-yGg2MRVtS49dKctEGdn08GVFt8PdjeQ@mail.gmail.com>
Date: Fri, 16 Aug 2013 07:24:22 +0800
Message-ID: <CANVTcTbH9ZkM8GErc2e=t-1a=F5hdyf9UnSZMyONk7G1NVX2+Q@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] pci: Add slot reset option to pci_dev_reset
From: rui wang <ruiv.wang@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        Don Dutile <ddutile@redhat.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/13, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Aug 8, 2013 at 2:09 PM, Alex Williamson
<snip>
> I don't think this is hotplug-safe.  It looks like pci_bus_sem might
> be the right semaphore to hold while verifying that we won't reset any
> unintended devices.

Something like pci_bus_sem locks all the buses, which may pose a big
overhead. So it doesn't seem like an ideal solution. A better approach
is to lock only one parent to protect only a sub-tree. At least that's
what I've seen in some other operating systems dealing with PCI
hotplug. But that requires a significant amount of change.

Thanks
Rui

  But I think most users of the bus->devices list
> are unprotected, so there's no point in trying to fix just this one.
>
>> +}
>> +
>>  static int __pci_dev_reset(struct pci_dev *dev, int probe)
>>  {
>>         int rc;
>> @@ -3278,6 +3308,10 @@ static int __pci_dev_reset(struct pci_dev *dev, int
>> probe)
>>         if (rc != -ENOTTY)
>>                 goto done;
>>
>> +       rc = pci_dev_reset_slot_function(dev, probe);
>> +       if (rc != -ENOTTY)
>> +               goto done;
>> +
>>         rc = pci_parent_bus_reset(dev, probe);
>>  done:
>>         return rc;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
