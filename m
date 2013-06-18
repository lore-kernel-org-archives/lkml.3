Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab3FRQXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:23:33 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35413 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab3FRQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:23:30 -0400
Message-ID: <51C0897B.9050300@gmail.com>
Date: Wed, 19 Jun 2013 00:23:23 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3, part2 01/20] PCI: introduce hotplug-safe PCI bus iterators
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com> <1369583597-3801-2-git-send-email-jiang.liu@huawei.com> <20130617200639.GA7877@google.com>
In-Reply-To: <20130617200639.GA7877@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 04:06 AM, Bjorn Helgaas wrote:
> On Sun, May 26, 2013 at 11:52:58PM +0800, Jiang Liu wrote:
>> Introduce hotplug-safe PCI bus iterators as below, which hold a
>> reference on the returned PCI bus object.
>> bool pci_bus_exists(int domain, int busnr);
>> struct pci_bus *pci_get_bus(int domain, int busnr);
>> struct pci_bus *pci_get_next_bus(struct pci_bus *from);
>> struct pci_bus *pci_get_next_root_bus(struct pci_bus *from);
>> #define for_each_pci_bus(b) for (b = NULL; (b = pci_get_next_bus(b)); )
>> #define for_each_pci_root_bus(b)  \
>> 		for (b = NULL; (b = pci_get_next_root_bus(b)); )
>>
>> The long-term goal is to remove hotplug-unsafe pci_find_bus(),
>> pci_find_next_bus() and the global pci_root_buses list.
> 
> I think you should mark the unsafe interfaces as __deprecated so
> users will get compile-time warnings.
> 
> I don't think pci_bus_exists() is a safe interface, because the value
> it returns may be incorrect before the caller can look at it.  The
> only safe thing would be to make it so we try to create the bus
> and return failure if it already exists.  Then the mutex can be in
> the code that creates the bus.
> 
> I don't see any uses of for_each_pci_bus(), so please remove that.
> 
> It sounds like we don't have a consensus on how to iterate over
> PCI root buses.  If you separate that from the pci_get_bus()
> changes, maybe we can at least move forward on the pci_get_bus()
> stuff.
Hi Bjorn,
	Thanks for review, will send out next version according to your
suggestions. And need more investigation about pci_bus_exists() interface.
Regards!
Gerry

> 
> Bjorn
> 
>> These new interfaces may be a littler slower than existing interfaces,
>> but it should be acceptable because they are not used on hot paths.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Acked-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: linux-pci@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  drivers/pci/pci.h    |   1 +
>>  drivers/pci/probe.c  |   2 +-
>>  drivers/pci/search.c | 159 +++++++++++++++++++++++++++++++++++++++++----------
>>  include/linux/pci.h  |  23 +++++++-
>>  4 files changed, 153 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
>> index 68678ed..8fe15f6 100644
>> --- a/drivers/pci/pci.h
>> +++ b/drivers/pci/pci.h
>> @@ -126,6 +126,7 @@ static inline void pci_remove_legacy_files(struct pci_bus *bus) { return; }
>>  
>>  /* Lock for read/write access to pci device and bus lists */
>>  extern struct rw_semaphore pci_bus_sem;
>> +extern struct class pcibus_class;
>>  
>>  extern raw_spinlock_t pci_lock;
>>  
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index 2830070..1004a05 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -93,7 +93,7 @@ static void release_pcibus_dev(struct device *dev)
>>  	kfree(pci_bus);
>>  }
>>  
>> -static struct class pcibus_class = {
>> +struct class pcibus_class = {
>>  	.name		= "pci_bus",
>>  	.dev_release	= &release_pcibus_dev,
>>  	.dev_attrs	= pcibus_dev_attrs,
>> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
>> index d0627fa..16ccaf8 100644
>> --- a/drivers/pci/search.c
>> +++ b/drivers/pci/search.c
>> @@ -52,20 +52,27 @@ pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
>>  	return tmp;
>>  }
>>  
>> -static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
>> +struct pci_bus_match_arg {
>> +	int domain;
>> +	int bus;
>> +};
>> +
>> +static int pci_match_bus(struct device *dev, const void *data)
>>  {
>> -	struct pci_bus* child;
>> -	struct list_head *tmp;
>> +	struct pci_bus *bus = to_pci_bus(dev);
>> +	const struct pci_bus_match_arg *arg = data;
>>  
>> -	if(bus->number == busnr)
>> -		return bus;
>> +	return (pci_domain_nr(bus) == arg->domain && bus->number == arg->bus);
>> +}
>>  
>> -	list_for_each(tmp, &bus->children) {
>> -		child = pci_do_find_bus(pci_bus_b(tmp), busnr);
>> -		if(child)
>> -			return child;
>> -	}
>> -	return NULL;
>> +static int pci_match_next_bus(struct device *dev, const void *data)
>> +{
>> +	return 1;
>> +}
>> +
>> +static int pci_match_next_root_bus(struct device *dev, const void *data)
>> +{
>> +	return pci_is_root_bus(to_pci_bus(dev));
>>  }
>>  
>>  /**
>> @@ -76,20 +83,19 @@ static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
>>   * Given a PCI bus number and domain number, the desired PCI bus is located
>>   * in the global list of PCI buses.  If the bus is found, a pointer to its
>>   * data structure is returned.  If no bus is found, %NULL is returned.
>> + *
>> + * Note: it's not hotplug safe, the returned bus may be destroyed at any time.
>> + * Please use pci_get_bus() instead which holds a reference on the returned
>> + * PCI bus.
>>   */
>> -struct pci_bus * pci_find_bus(int domain, int busnr)
>> +struct pci_bus *pci_find_bus(int domain, int busnr)
>>  {
>> -	struct pci_bus *bus = NULL;
>> -	struct pci_bus *tmp_bus;
>> +	struct pci_bus *bus;
>>  
>> -	while ((bus = pci_find_next_bus(bus)) != NULL)  {
>> -		if (pci_domain_nr(bus) != domain)
>> -			continue;
>> -		tmp_bus = pci_do_find_bus(bus, busnr);
>> -		if (tmp_bus)
>> -			return tmp_bus;
>> -	}
>> -	return NULL;
>> +	bus = pci_get_bus(domain, busnr);
>> +	pci_bus_put(bus);
>> +
>> +	return bus;
>>  }
>>  
>>  /**
>> @@ -100,21 +106,114 @@ struct pci_bus * pci_find_bus(int domain, int busnr)
>>   * initiated by passing %NULL as the @from argument.  Otherwise if
>>   * @from is not %NULL, searches continue from next device on the
>>   * global list.
>> + *
>> + * Note: it's not hotplug safe, the returned bus may be destroyed at any time.
>> + * Please use pci_get_next_root_bus() instead which holds a reference
>> + * on the returned PCI root bus.
>>   */
>>  struct pci_bus * 
>>  pci_find_next_bus(const struct pci_bus *from)
>>  {
>> -	struct list_head *n;
>> -	struct pci_bus *b = NULL;
>> +	struct device *dev = from ? (struct device *)&from->dev : NULL;
>> +
>> +	dev = class_find_device(&pcibus_class, dev, NULL,
>> +				&pci_match_next_root_bus);
>> +	if (dev) {
>> +		put_device(dev);
>> +		return to_pci_bus(dev);
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +bool pci_bus_exists(int domain, int busnr)
>> +{
>> +	struct device *dev;
>> +	struct pci_bus_match_arg arg = { domain, busnr };
>>  
>>  	WARN_ON(in_interrupt());
>> -	down_read(&pci_bus_sem);
>> -	n = from ? from->node.next : pci_root_buses.next;
>> -	if (n != &pci_root_buses)
>> -		b = pci_bus_b(n);
>> -	up_read(&pci_bus_sem);
>> -	return b;
>> +	dev = class_find_device(&pcibus_class, NULL, &arg, &pci_match_bus);
>> +	if (dev)
>> +		put_device(dev);
>> +
>> +	return dev != NULL;
>> +}
>> +EXPORT_SYMBOL(pci_bus_exists);
>> +
>> +/**
>> + * pci_get_bus - locate PCI bus from a given domain and bus number
>> + * @domain: number of PCI domain to search
>> + * @busnr: number of desired PCI bus
>> + *
>> + * Given a PCI bus number and domain number, the desired PCI bus is located.
>> + * If the bus is found, a pointer to its data structure is returned.
>> + * If no bus is found, %NULL is returned.
>> + * Caller needs to release the returned bus by calling pci_bus_put().
>> + */
>> +struct pci_bus *pci_get_bus(int domain, int busnr)
>> +{
>> +	struct device *dev;
>> +	struct pci_bus_match_arg arg = { domain, busnr };
>> +
>> +	WARN_ON(in_interrupt());
>> +	dev = class_find_device(&pcibus_class, NULL, &arg, &pci_match_bus);
>> +	if (dev)
>> +		return to_pci_bus(dev);
>> +
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL(pci_get_bus);
>> +
>> +/**
>> + * pci_get_next_bus - begin or continue searching for a PCI bus
>> + * @from: Previous PCI bus found, or %NULL for new search.
>> + *
>> + * Iterates through the list of known PCI busses. If a PCI bus is found,
>> + * the reference count to the bus is incremented and a pointer to it is
>> + * returned. Otherwise, %NULL is returned. A new search is initiated by
>> + * passing %NULL as the @from argument. Otherwise if @from is not %NULL,
>> + * searches continue from next bus on the global list. The reference count
>> + * for @from is always decremented if it is not %NULL.
>> + */
>> +struct pci_bus *pci_get_next_bus(struct pci_bus *from)
>> +{
>> +	struct device *dev = from ? &from->dev : NULL;
>> +
>> +	WARN_ON(in_interrupt());
>> +	dev = class_find_device(&pcibus_class, dev, NULL, &pci_match_next_bus);
>> +	pci_bus_put(from);
>> +	if (dev)
>> +		return to_pci_bus(dev);
>> +
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL(pci_get_next_bus);
>> +
>> +/**
>> + * pci_find_next_root_bus - begin or continue searching for a PCI root bus
>> + * @from: Previous PCI bus found, or %NULL for new search.
>> + *
>> + * Iterates through the list of known PCI root busses. If a PCI bus is found,
>> + * the reference count to the root bus is incremented and a pointer to it is
>> + * returned. Otherwise, %NULL is returned. A new search is initiated by
>> + * passing %NULL as the @from argument. Otherwise if @from is not %NULL,
>> + * searches continue from next root bus on the global list. The reference
>> + * count for @from is always decremented if it is not %NULL.
>> + */
>> +struct pci_bus *pci_get_next_root_bus(struct pci_bus *from)
>> +{
>> +	struct device *dev = from ? &from->dev : NULL;
>> +
>> +	WARN_ON(in_interrupt());
>> +	dev = class_find_device(&pcibus_class, dev, NULL,
>> +				&pci_match_next_root_bus);
>> +	pci_bus_put(from);
>> +	if (dev)
>> +		return to_pci_bus(dev);
>> +
>> +	return NULL;
>>  }
>> +EXPORT_SYMBOL(pci_get_next_root_bus);
>>  
>>  /**
>>   * pci_get_slot - locate PCI device for a given PCI slot
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 7b23fa0..1e43423 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -454,6 +454,9 @@ struct pci_bus {
>>  
>>  #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
>>  #define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
>> +#define for_each_pci_bus(b)	for (b = NULL; (b = pci_get_next_bus(b)); )
>> +#define for_each_pci_root_bus(b) \
>> +			for (b = NULL; (b = pci_get_next_root_bus(b)); )
>>  
>>  /*
>>   * Returns true if the pci bus is root (behind host-pci bridge),
>> @@ -718,7 +721,6 @@ void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
>>  void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>>  			     struct pci_bus_region *region);
>>  void pcibios_scan_specific_bus(int busn);
>> -struct pci_bus *pci_find_bus(int domain, int busnr);
>>  void pci_bus_add_devices(const struct pci_bus *bus);
>>  struct pci_bus * __deprecated pci_scan_bus_parented(struct device *parent,
>>  			int bus, struct pci_ops *ops, void *sysdata);
>> @@ -778,8 +780,15 @@ int pci_find_ext_capability(struct pci_dev *dev, int cap);
>>  int pci_find_next_ext_capability(struct pci_dev *dev, int pos, int cap);
>>  int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
>>  int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
>> +
>> +struct pci_bus *pci_find_bus(int domain, int busnr);
>>  struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
>>  
>> +bool pci_bus_exists(int domain, int busnr);
>> +struct pci_bus *pci_get_bus(int domain, int busnr);
>> +struct pci_bus *pci_get_next_bus(struct pci_bus *from);
>> +struct pci_bus *pci_get_next_root_bus(struct pci_bus *from);
>> +
>>  struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
>>  				struct pci_dev *from);
>>  struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
>> @@ -1430,6 +1439,18 @@ static inline void pci_unblock_cfg_access(struct pci_dev *dev)
>>  static inline struct pci_bus *pci_find_next_bus(const struct pci_bus *from)
>>  { return NULL; }
>>  
>> +static inline bool pci_bus_exists(int domain, int busnr)
>> +{ return false; }
>> +
>> +static inline struct pci_bus *pci_get_bus(int domain, int busnr)
>> +{ return NULL; }
>> +
>> +static inline struct pci_bus *pci_get_next_bus(struct pci_bus *from)
>> +{ return NULL; }
>> +
>> +static inline struct pci_bus *pci_get_next_root_bus(struct pci_bus *from)
>> +{ return NULL; }
>> +
>>  static inline struct pci_dev *pci_get_slot(struct pci_bus *bus,
>>  						unsigned int devfn)
>>  { return NULL; }
>> -- 
>> 1.8.1.2
>>

