Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3HFCNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 22:13:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46026 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3HFCNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 22:13:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52005BA3.9020303@jp.fujitsu.com>
Date: Tue, 6 Aug 2013 11:12:51 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Toshi Kani <toshi.kani@hp.com>, <rafael.j.wysocki@intel.com>,
        <vasilis.liaskovitis@profitbricks.com>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <wency@cn.fujitsu.com>
Subject: Re: Cannot hot remove a memory device (patch, updated)
References: <51FA1E41.20304@jp.fujitsu.com> <1456797.BR6oLAipWK@vostro.rjw.lan> <1375744796.10300.175.camel@misato.fc.hp.com> <4117925.f4JeZH8kGN@vostro.rjw.lan>
In-Reply-To: <4117925.f4JeZH8kGN@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/06 9:15), Rafael J. Wysocki wrote:
> On Monday, August 05, 2013 05:19:56 PM Toshi Kani wrote:
>> On Mon, 2013-08-05 at 15:14 +0200, Rafael J. Wysocki wrote:
>>    :
>>> Can you please test the appended patch?  I tested it somewhat, but since the
>>> greatest number of physical nodes per ACPI device object I can get on my test
>>> machines is 2 (and even that after hacking the kernel somewhat), that was kind
>>> of unconclusive.
>>>
>>> Thanks,
>>> Rafael
>>>
>>>
>>> ---
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> Subject: ACPI: Drop physical_node_id_bitmap from struct acpi_device
>>>
>>> The physical_node_id_bitmap in struct acpi_device is only used for
>>> looking up the first currently unused phyiscal dependent node ID
>>> by acpi_bind_one().  It is not really necessary, however, because
>>> acpi_bind_one() walks the entire physical_node_list of the given
>>> device object for sanity checking anyway and if that list is always
>>> sorted by node_id, it is straightforward to find the first gap
>>> between the currently used node IDs and use that number as the ID
>>> of the new list node.
>>>
>>> This also removes the artificial limit of the maximum number of
>>> dependent physical devices per ACPI device object, which now depends
>>> only on the capacity of unsigend int.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> I like the change. Much better :-)
>>
>> Acked-by: Toshi Kani <toshi.kani@hp.com>
>
> However, it introduces a bug in acpi_unbind_one(), because the size of the name
> array in there has to be increased too.  Updated patch follows.
>
> Thanks,
> Rafael
>
>
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI: Drop physical_node_id_bitmap from struct acpi_device
>
> The physical_node_id_bitmap in struct acpi_device is only used for
> looking up the first currently unused dependent phyiscal node ID
> by acpi_bind_one().  It is not really necessary, however, because
> acpi_bind_one() walks the entire physical_node_list of the given
> device object for sanity checking anyway and if that list is always
> sorted by node_id, it is straightforward to find the first gap
> between the currently used node IDs and use that number as the ID
> of the new list node.
>
> This also removes the artificial limit of the maximum number of
> dependent physical devices per ACPI device object, which now depends
> only on the capacity of unsigend int.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

I confirmed that I can add and remove a memory device correctly.

Thanks,
Yasuaki Ishimatsu

> ---
>   drivers/acpi/glue.c     |   34 +++++++++++++++++++---------------
>   include/acpi/acpi_bus.h |    8 ++------
>   2 files changed, 21 insertions(+), 21 deletions(-)
>
> Index: linux-pm/drivers/acpi/glue.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/glue.c
> +++ linux-pm/drivers/acpi/glue.c
> @@ -31,6 +31,7 @@ static LIST_HEAD(bus_type_list);
>   static DECLARE_RWSEM(bus_type_sem);
>
>   #define PHYSICAL_NODE_STRING "physical_node"
> +#define PHYSICAL_NODE_NAME_SIZE (sizeof(PHYSICAL_NODE_STRING) + 10)
>
>   int register_acpi_bus_type(struct acpi_bus_type *type)
>   {
> @@ -112,7 +113,9 @@ int acpi_bind_one(struct device *dev, ac
>   	struct acpi_device *acpi_dev;
>   	acpi_status status;
>   	struct acpi_device_physical_node *physical_node, *pn;
> -	char physical_node_name[sizeof(PHYSICAL_NODE_STRING) + 2];
> +	char physical_node_name[PHYSICAL_NODE_NAME_SIZE];
> +	struct list_head *physnode_list;
> +	unsigned int node_id;
>   	int retval = -EINVAL;
>
>   	if (ACPI_HANDLE(dev)) {
> @@ -139,8 +142,14 @@ int acpi_bind_one(struct device *dev, ac
>
>   	mutex_lock(&acpi_dev->physical_node_lock);
>
> -	/* Sanity check. */
> -	list_for_each_entry(pn, &acpi_dev->physical_node_list, node)
> +	/*
> +	 * Keep the list sorted by node_id so that the IDs of removed nodes can
> +	 * be recycled.
> +	 */
> +	physnode_list = &acpi_dev->physical_node_list;
> +	node_id = 0;
> +	list_for_each_entry(pn, &acpi_dev->physical_node_list, node) {
> +		/* Sanity check. */
>   		if (pn->dev == dev) {
>   			dev_warn(dev, "Already associated with ACPI node\n");
>   			if (ACPI_HANDLE(dev) == handle)
> @@ -148,19 +157,15 @@ int acpi_bind_one(struct device *dev, ac
>
>   			goto out_free;
>   		}
> -
> -	/* allocate physical node id according to physical_node_id_bitmap */
> -	physical_node->node_id =
> -		find_first_zero_bit(acpi_dev->physical_node_id_bitmap,
> -		ACPI_MAX_PHYSICAL_NODE);
> -	if (physical_node->node_id >= ACPI_MAX_PHYSICAL_NODE) {
> -		retval = -ENOSPC;
> -		goto out_free;
> +		if (pn->node_id == node_id) {
> +			physnode_list = &pn->node;
> +			node_id++;
> +		}
>   	}
>
> -	set_bit(physical_node->node_id, acpi_dev->physical_node_id_bitmap);
> +	physical_node->node_id = node_id;
>   	physical_node->dev = dev;
> -	list_add_tail(&physical_node->node, &acpi_dev->physical_node_list);
> +	list_add(&physical_node->node, physnode_list);
>   	acpi_dev->physical_node_count++;
>
>   	mutex_unlock(&acpi_dev->physical_node_lock);
> @@ -215,7 +220,7 @@ int acpi_unbind_one(struct device *dev)
>
>   	mutex_lock(&acpi_dev->physical_node_lock);
>   	list_for_each_safe(node, next, &acpi_dev->physical_node_list) {
> -		char physical_node_name[sizeof(PHYSICAL_NODE_STRING) + 2];
> +		char physical_node_name[PHYSICAL_NODE_NAME_SIZE];
>
>   		entry = list_entry(node, struct acpi_device_physical_node,
>   			node);
> @@ -223,7 +228,6 @@ int acpi_unbind_one(struct device *dev)
>   			continue;
>
>   		list_del(node);
> -		clear_bit(entry->node_id, acpi_dev->physical_node_id_bitmap);
>
>   		acpi_dev->physical_node_count--;
>
> Index: linux-pm/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_bus.h
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -284,15 +284,12 @@ struct acpi_device_wakeup {
>   };
>
>   struct acpi_device_physical_node {
> -	u8 node_id;
> +	unsigned int node_id;
>   	struct list_head node;
>   	struct device *dev;
>   	bool put_online:1;
>   };
>
> -/* set maximum of physical nodes to 32 for expansibility */
> -#define ACPI_MAX_PHYSICAL_NODE	32
> -
>   /* Device */
>   struct acpi_device {
>   	int device_type;
> @@ -312,10 +309,9 @@ struct acpi_device {
>   	struct acpi_driver *driver;
>   	void *driver_data;
>   	struct device dev;
> -	u8 physical_node_count;
> +	unsigned int physical_node_count;
>   	struct list_head physical_node_list;
>   	struct mutex physical_node_lock;
> -	DECLARE_BITMAP(physical_node_id_bitmap, ACPI_MAX_PHYSICAL_NODE);
>   	struct list_head power_dependent;
>   	void (*remove)(struct acpi_device *);
>   };
>


