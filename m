Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3AUQTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:19:03 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52561 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3AUQTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:19:00 -0500
Message-ID: <50FD6A6F.1080408@gmail.com>
Date: Tue, 22 Jan 2013 00:18:55 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 3/8] PCI: add a blocking notifier chain for PCI
 bus addition/removal
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <1358525267-14268-4-git-send-email-jiang.liu@huawei.com> <3583141.yG8QGivRYt@vostro.rjw.lan>
In-Reply-To: <3583141.yG8QGivRYt@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 07:54 AM, Rafael J. Wysocki wrote:
> On Saturday, January 19, 2013 12:07:41 AM Jiang Liu wrote:
>> When adding/removing a PCI bus, some other components want to be
snip
>> +
>> +void pci_bus_call_notifier(struct pci_bus *bus, unsigned long code)
>> +{
>> +	int ret;
>> +
>> +	ret = blocking_notifier_call_chain(&pci_bus_notifier_chain,
>> +					   code, bus);
>> +	WARN_ON(ret != NOTIFY_DONE && ret != NOTIFY_OK);
> 
> I'm not sure if this is a good idea.  WARN_ON() is quite a heavy tool.
Hi Rafael,
	How about WARN_ONCE() here?

> 
>> +}
>> +
>>  void pci_add_resource_offset(struct list_head *resources, struct resource *res,
>>  			     resource_size_t offset)
>>  {
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index ee21795..12e5447 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -1033,6 +1033,18 @@ const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
>>  int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
>>  		    int pass);
>>  
>> +/*
>> + * All notifiers below get called with the target struct pci_bus *bus as
>> + * an argument.
>> + * Note: all PCI bus notifier must return success. Currently there's no
>> + * error handling if any notifier returns error code.
>> + */
>> +#define	PCI_NOTIFY_POST_BUS_ADD		0x00000001 /* PCI bus has been added */
>> +#define	PCI_NOTIFY_PRE_BUS_DEL		0x00000002 /* PCI bus will be deleted */
> 
> I would call them PCI_EVENT_BUS_ADDED and PCI_EVENT_BUS_REMOVE, respectively.
Sure, will use them in next version.

> 
>> +
>> +int pci_bus_register_notifier(struct notifier_block *nb);
>> +int pci_bus_unregister_notifier(struct notifier_block *nb);
>> +
>>  void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
>>  		  void *userdata);
>>  int pci_cfg_space_size_ext(struct pci_dev *dev);
> 
> Apart from the nitpicks above, looks good.
Thanks for review!

Regards!
Gerry
> 
> Thanks,
> Rafael
> 
> 

