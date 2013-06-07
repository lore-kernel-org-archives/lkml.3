Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3FGPu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:50:59 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51013 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3FGPu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:50:57 -0400
Message-ID: <51B20159.6090208@gmail.com>
Date: Fri, 07 Jun 2013 23:50:49 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH v2, part3 07/11] PCI, xen-pcifront: use new PCI interfaces
 to simplify implementation
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com> <1368719459-24800-8-git-send-email-jiang.liu@huawei.com> <20130607145024.GA16631@phenom.dumpdata.com>
In-Reply-To: <20130607145024.GA16631@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07 Jun 2013 10:50:24 PM CST, Konrad Rzeszutek Wilk wrote:
> On Thu, May 16, 2013 at 11:50:55PM +0800, Jiang Liu wrote:
>> Use new PCI interfaces to simplify xen-pcifront implementation:
>> 1) Use pci_create_root_bus() instead of pci_scan_bus_parented()
>>    because pci_scan_bus_parented() is marked as __deprecated.This
>>    also gets rid of a duplicated call of pci_bus_start_devices().
>> 2) Use pci_stop_root_bus() and pci_remove_root_bus() instead of
>>    open-coded private implementation.
>> 3) Use pci_set_host_bridge_release() to release data structures
>>    associated with PCI root buses.
>> 4) Use pci_bus_get()/pci_bus_put() to manage PCI root bus reference
>>    count.
>>
>> This is also a preparation for coming PCI bus lock enhancement.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> Cc: xen-devel@lists.xensource.com
>> Cc: virtualization@lists.linux-foundation.org
>> Cc: linux-pci@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  drivers/pci/xen-pcifront.c | 81 ++++++++++++++++++++++------------------------
>>  1 file changed, 39 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
>> index 816cf94..6aa2c0f 100644
>> --- a/drivers/pci/xen-pcifront.c
>> +++ b/drivers/pci/xen-pcifront.c
......
>> @@ -480,12 +490,14 @@ static int pcifront_scan_root(struct pcifront_device *pdev,
>>  		goto err_out;
>>  	}
>>
>> -	bus_entry->bus = b;
>> +	pci_set_host_bridge_release(to_pci_host_bridge(b->bridge),
>> +				    pcifront_release_sd, sd);
>>
>> -	list_add(&bus_entry->list, &pdev->root_buses);
>> -
>> -	/* pci_scan_bus_parented skips devices which do not have a have
>> -	* devfn==0. The pcifront_scan_bus enumerates all devfn. */
>> +	/*
>> +	 * Every PCI physical device should have function 0, but that's not
>> +	 * true for xen.
>
> That is incorrect. There are two types of backends - one of them will
> start at zero, but the other might not.
Hi Konrad,
      Forgive my poor knowledge about Xen:(, so I will skip this change.
Regards!
Gerry
