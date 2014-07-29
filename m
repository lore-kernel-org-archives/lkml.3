Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaG2XJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:09:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53018 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaG2XJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:09:54 -0400
Message-ID: <53D829BF.3040907@codeaurora.org>
Date: Tue, 29 Jul 2014 16:09:51 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/9] drivers: base: support cpu cache information interface
 to userspace via sysfs
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1406306692-7135-1-git-send-email-sudeep.holla@arm.com> <1406306692-7135-3-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1406306692-7135-3-git-send-email-sudeep.holla@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/14 09:44, Sudeep Holla wrote:
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index acb9bfc89b48..832b7f2ed6d2 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -224,3 +224,44 @@ Description:	Parameters for the Intel P-state driver
>  		frequency range.
>  
>  		More details can be found in Documentation/cpu-freq/intel-pstate.txt
> +
> +What:		/sys/devices/system/cpu/cpu*/cache/index*/<set_of_attributes_mentioned_below>
> +Date:		July 2014(documented, existed before August 2008)
> +Contact:	Sudeep Holla <sudeep.holla@arm.com>
> +		Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +Description:	Parameters for the CPU cache attributes
> +
> +		attributes:
> +			- writethrough: data is written to both the cache line
> +					and to the block in the lower-level memory
> +			- writeback: data is written only to the cache line and
> +				     the modified cache line is written to main
> +				     memory only when it is replaced
> +			- writeallocate: allocate a memory location to a cache line
> +					 on a cache miss because of a write
> +			- readallocate: allocate a memory location to a cache line
> +					on a cache miss because of a read
> +
> +		coherency_line_size: the minimum amount of data that gets transferred

Is this in bytes?

> +
> +		level: the cache hierarcy in the multi-level cache configuration
> +
> +		number_of_sets: total number of sets in the cache, a set is a
> +				collection of cache lines with the same cache index
> +
> +		physical_line_partition: number of physical cache line per cache tag
> +
> +		shared_cpu_list: the list of cpus sharing the cache

This is a logical list, not physical right?

> +
> +		shared_cpu_map: logical cpu mask containing the list of cpus sharing
> +				the cache
> +
> +		size: the total cache size in kB
> +
> +		type:
> +			- instruction: cache that only holds instructions
> +			- data: cache that only caches data
> +			- unified: cache that holds both data and instructions
> +
> +		ways_of_associativity: degree of freedom in placing a particular block
> +					of memory in the cache
> diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
> new file mode 100644
> index 000000000000..983728a919ec
> --- /dev/null
> +++ b/drivers/base/cacheinfo.c
> @@ -0,0 +1,539 @@
[...]
> +
> +static int detect_cache_attributes(unsigned int cpu)

Unused if sysfs is disabled? Actually it looks like everything except
the weak functions are unused in such a case.

> +static ssize_t shared_cpumap_show_func(struct device *dev, int type, char *buf)
> +{
> +	struct cacheinfo *this_leaf = dev_get_drvdata(dev);
> +	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
> +	int n = 0;
> +
> +	if (len > 1) {
> +		const struct cpumask *mask = &this_leaf->shared_cpu_map;
> +
> +		n = type ? cpulist_scnprintf(buf, len - 2, mask) :
> +			   cpumask_scnprintf(buf, len - 2, mask);
> +		buf[n++] = '\n';
> +		buf[n] = '\0';
> +	}
> +	return n;
> +}

This looks to be lifted from show_cpumap() (well maybe that function was
lifted from x86, not sure). Perhaps it should be extracted out into an
inline function in cpumask.h? Future work I guess.

> +
> +static ssize_t shared_cpu_map_show(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	return shared_cpumap_show_func(dev, 0, buf);
> +}
> +
> +static ssize_t shared_cpu_list_show(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	return shared_cpumap_show_func(dev, 1, buf);
> +}
> +
> +static ssize_t type_show(struct device *dev,
> +			 struct device_attribute *attr, char *buf)
> +{
> +	struct cacheinfo *this_leaf = dev_get_drvdata(dev);
> +
> +	switch (this_leaf->type) {
> +	case CACHE_TYPE_DATA:
> +		return sprintf(buf, "Data\n");
> +	case CACHE_TYPE_INST:
> +		return sprintf(buf, "Instruction\n");
> +	case CACHE_TYPE_UNIFIED:
> +		return sprintf(buf, "Unified\n");
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static ssize_t attributes_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct cacheinfo *this_leaf = dev_get_drvdata(dev);
> +	unsigned int ci_attr = this_leaf->attributes;
> +	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf - 2;
> +	int n = 0;
> +
> +	if (!ci_attr)
> +		return -EINVAL;
> +
> +	if (ci_attr & CACHE_WRITE_THROUGH)
> +		n += snprintf(buf + n, len - n, "WriteThrough\n");
> +	if (ci_attr & CACHE_WRITE_BACK)
> +		n += snprintf(buf + n, len - n, "WriteBack\n");
> +	if (ci_attr & CACHE_READ_ALLOCATE)
> +		n += snprintf(buf + n, len - n, "ReadAllocate\n");
> +	if (ci_attr & CACHE_WRITE_ALLOCATE)
> +		n += snprintf(buf + n, len - n, "WriteAllocate\n");

I see that ia64 has this attributes file, but in that case only two
attributes exist (write through and write back) and only one value is
ever shown. When we have multiple attributes we'll have multiple lines
to parse here. What if we left attributes around for the ia64 case
(possibly even hiding that entirely within that architecture specific
code) and then have files like "allocation_policy" and "storage_method"
that correspond to whether its read/write allocation and write through
or write back? The goal being to make only one value exist in any sysfs
attribute.

> +	buf[n] = '\0';
> +	return n;
> +}
> +
> +static umode_t
> +cache_default_attrs_is_visible(struct kobject *kobj,
> +			       struct attribute *attr, int unused)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct device_attribute *dev_attr;
> +	umode_t mode = attr->mode;
> +	char *buf;
> +
> +	dev_attr = container_of(attr, struct device_attribute, attr);
> +	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!buf)
> +		return 0;
> +
> +	/* create attributes that provides meaningful value */
> +	if (dev_attr->show && dev_attr->show(dev, dev_attr, buf) < 0)
> +		mode = 0;
> +
> +	kfree(buf);

This is sort of sad. We have to allocate a whole page and call the show
function to figure out if the attribute is visible? Why don't we
actually look at what the attribute is and check for the structure
members we care about? It looks like there are only a few combinations.

> +	return mode;
> +}
> +
> +static DEVICE_ATTR_RO(level);
> +static DEVICE_ATTR_RO(type);
> +static DEVICE_ATTR_RO(coherency_line_size);
> +static DEVICE_ATTR_RO(ways_of_associativity);
> +static DEVICE_ATTR_RO(number_of_sets);
> +static DEVICE_ATTR_RO(size);
> +static DEVICE_ATTR_RO(attributes);
> +static DEVICE_ATTR_RO(shared_cpu_map);
> +static DEVICE_ATTR_RO(shared_cpu_list);
> +static DEVICE_ATTR_RO(physical_line_partition);
> +
> +static struct attribute *cache_default_attrs[] = {
> +	&dev_attr_type.attr,
> +	&dev_attr_level.attr,
> +	&dev_attr_shared_cpu_map.attr,
> +	&dev_attr_shared_cpu_list.attr,
> +	&dev_attr_coherency_line_size.attr,
> +	&dev_attr_ways_of_associativity.attr,
> +	&dev_attr_number_of_sets.attr,
> +	&dev_attr_size.attr,
> +	&dev_attr_attributes.attr,
> +	&dev_attr_physical_line_partition.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group cache_default_group = {
> +	.attrs = cache_default_attrs,
> +	.is_visible = cache_default_attrs_is_visible,
> +};
> +
> +static const struct attribute_group *cache_default_groups[] = {
> +	&cache_default_group,
> +	NULL,
> +};
> +
> +static struct attribute_group cache_private_group = {
> +	.is_visible = cache_default_attrs_is_visible,
> +};
> +
> +static const struct attribute_group *cache_private_groups[] = {
> +	&cache_default_group,
> +	(const struct attribute_group *)&cache_private_group,
> +	NULL,
> +};
> +
> +const struct attribute **
> +__weak cache_get_priv_attr(struct cacheinfo *this_leaf)
> +{
> +	return NULL;
> +}
> +
> +static const struct attribute_group **
> +cache_get_attribute_groups(struct cacheinfo *this_leaf)
> +{
> +	const struct attribute **priv_attr = cache_get_priv_attr(this_leaf);
> +
> +	if (!priv_attr)
> +		return cache_default_groups;
> +
> +	if (!cache_private_group.attrs)
> +		cache_private_group.attrs = (struct attribute **)priv_attr;
> +
> +	return cache_private_groups;
> +}

There's lots of odd casting going on here. Can we change
cache_get_priv_attr() to cache_get_priv_attr_group() and then rework x86
code to return a group instead of a bunch of attribute pointers? Then
drop const from cache_default_groups, add an extra blank NULL entry for
the possible arch specific groups and then use ARRAY_SIZE() - 1 to set
that entry with whatever we get from cache_get_priv_attr_group(). Also
drop the whole cache_private_groups thing.

> +
> +/* Add/Remove cache interface for CPU device */
> +static void cpu_cache_sysfs_exit(unsigned int cpu)
> +{
> +	int i;
> +	struct device *ci_dev;
> +
> +	if (per_cpu_index_dev(cpu)) {
> +		for (i = 0; i < cache_leaves(cpu); i++) {
> +			ci_dev = per_cache_index_dev(cpu, i);
> +			if (!ci_dev)
> +				continue;
> +			device_unregister(ci_dev);
> +		}
> +		kfree(per_cpu_index_dev(cpu));
> +		per_cpu_index_dev(cpu) = NULL;
> +	}
> +	device_unregister(per_cpu_cache_dev(cpu));
> +	per_cpu_cache_dev(cpu) = NULL;
> +}
> +
> +static int cpu_cache_sysfs_init(unsigned int cpu)
> +{
> +	struct device *dev = get_cpu_device(cpu);
> +
> +	if (per_cpu_cacheinfo(cpu) == NULL)
> +		return -ENOENT;
> +
> +	per_cpu_cache_dev(cpu) = device_create(dev->class, dev, cpu,
> +					       NULL, "cache");
> +	if (IS_ERR_OR_NULL(per_cpu_cache_dev(cpu)))
> +		return PTR_ERR(per_cpu_cache_dev(cpu));
> +
> +	/* Allocate all required memory */
> +	per_cpu_index_dev(cpu) = kcalloc(cache_leaves(cpu),
> +					 sizeof(struct device *), GFP_KERNEL);
> +	if (unlikely(per_cpu_index_dev(cpu) == NULL))
> +		goto err_out;
> +
> +	return 0;
> +
> +err_out:
> +	cpu_cache_sysfs_exit(cpu);
> +	return -ENOMEM;
> +}
> +
> +static int cache_add_dev(unsigned int cpu)
> +{
> +	unsigned short i;

unsigned int?

> +	int rc;
> +	struct device *ci_dev, *parent;
> +	struct cacheinfo *this_leaf;
> +	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
> +	const struct attribute_group **cache_groups;
> +
> +	rc = cpu_cache_sysfs_init(cpu);
> +	if (unlikely(rc < 0))
> +		return rc;
> +
> +	parent = per_cpu_cache_dev(cpu);
> +	for (i = 0; i < cache_leaves(cpu); i++) {
> +		this_leaf = this_cpu_ci->info_list + i;
> +		if (this_leaf->disable_sysfs)
> +			continue;
> +		cache_groups = cache_get_attribute_groups(this_leaf);
> +		ci_dev = device_create_with_groups(parent->class, parent, i,
> +						   this_leaf, cache_groups,
> +						   "index%1u", i);
> +		if (IS_ERR_OR_NULL(ci_dev)) {

IS_ERR?

> +			rc = PTR_ERR(ci_dev);
> +			goto err;
> +		}
> +		per_cache_index_dev(cpu, i) = ci_dev;
> +	}
> +	cpumask_set_cpu(cpu, &cache_dev_map);
> +
> +	return 0;
> +err:
> +	cpu_cache_sysfs_exit(cpu);
> +	return rc;
> +}
> +
> +static void cache_remove_dev(unsigned int cpu)
> +{
> +	if (!cpumask_test_cpu(cpu, &cache_dev_map))
> +		return;
> +	cpumask_clear_cpu(cpu, &cache_dev_map);
> +
> +	cpu_cache_sysfs_exit(cpu);
> +}
> +
> +static int cacheinfo_cpu_callback(struct notifier_block *nfb,
> +				  unsigned long action, void *hcpu)
> +{
> +	unsigned int cpu = (unsigned long)hcpu;
> +	int rc = 0;
> +
> +	switch (action) {

Looks like we can do action & ~CPU_TASKS_FROZEN to save two lines here

> +	case CPU_ONLINE:
> +	case CPU_ONLINE_FROZEN:
> +		rc = detect_cache_attributes(cpu);
> +		if (!rc)
> +			rc = cache_add_dev(cpu);
> +		break;
> +	case CPU_DEAD:
> +	case CPU_DEAD_FROZEN:
> +		cache_remove_dev(cpu);
> +		if (per_cpu_cacheinfo(cpu))
> +			free_cache_attributes(cpu);
> +		break;
> +	}
> +	return notifier_from_errno(rc);
> +}

Hm... adding/detecting/destroying this stuff every time a CPU is
logically hotplugged seems like a waste of time and energy. Why can't we
only do this work when the CPU is actually physically removed? The path
for that is via the subsys_interface and it would make it easier on
programs that want to learn about cache info as long as the CPU is
present in the system even if it isn't online at the time of reading.

> +
> +static int __init cacheinfo_sysfs_init(void)
> +{
> +	int cpu, rc = 0;
> +
> +	cpu_notifier_register_begin();
> +
> +	for_each_online_cpu(cpu) {
> +		rc = detect_cache_attributes(cpu);
> +		if (rc) {
> +			pr_err("error detecting cacheinfo..cpu%d\n", cpu);
> +			goto out;
> +		}
> +		rc = cache_add_dev(cpu);
> +		if (rc) {
> +			free_cache_attributes(cpu);
> +			pr_err("error populating cacheinfo..cpu%d\n", cpu);
> +			goto out;
> +		}
> +	}
> +	__hotcpu_notifier(cacheinfo_cpu_callback, 0);
> +
> +out:
> +	cpu_notifier_register_done();
> +	return rc;
> +}
> +
> +device_initcall(cacheinfo_sysfs_init);
> +
> +#endif	/* CONFIG_SYSFS */
> diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
> new file mode 100644
> index 000000000000..3d67b4910aa8
> --- /dev/null
> +++ b/include/linux/cacheinfo.h
> @@ -0,0 +1,73 @@
> +#ifndef _LINUX_CACHEINFO_H
> +#define _LINUX_CACHEINFO_H
> +
> +#include <linux/bitops.h>
> +#include <linux/compiler.h>
> +#include <linux/cpumask.h>
> +#include <linux/device.h>
> +#include <linux/of.h>
> +#include <linux/sysfs.h>

These last three look like they could be removed and we could have
forward declarations for required types. What's compiler.h for?

> +
> +enum cache_type {
> +	CACHE_TYPE_NOCACHE = 0,
> +	CACHE_TYPE_INST = BIT(0),
> +	CACHE_TYPE_DATA = BIT(1),
> +	CACHE_TYPE_SEPARATE = CACHE_TYPE_INST | CACHE_TYPE_DATA,
> +	CACHE_TYPE_UNIFIED = BIT(2),
> +};
> +
> +struct cacheinfo {
> +	/* core properties */
> +	enum cache_type type; /* data, inst or unified */
> +	unsigned int level;
> +	unsigned int coherency_line_size; /* cache line size  */
> +	unsigned int number_of_sets; /* no. of sets per way */
> +	unsigned int ways_of_associativity; /* no. of ways */
> +	unsigned int physical_line_partition; /* no. of lines per tag */
> +	unsigned int size; /* total cache size */
> +	cpumask_t shared_cpu_map;
> +	unsigned int attributes;
> +#define CACHE_WRITE_THROUGH	BIT(0)
> +#define CACHE_WRITE_BACK	BIT(1)
> +#define CACHE_READ_ALLOCATE	BIT(2)
> +#define CACHE_WRITE_ALLOCATE	BIT(3)
> +
> +	/* book keeping */
> +	struct device_node *of_node;	/* cpu if no explicit cache node */
> +	bool disable_sysfs; /* don't expose this leaf through sysfs */
> +	void *priv;
> +};

Can we use real kernel doc notation here please?

> +
> +struct cpu_cacheinfo {
> +	struct cacheinfo *info_list;
> +	unsigned int num_levels;
> +	unsigned int num_leaves;
> +};
> +
> +/*
> + * Helpers to make sure "func" is executed on the cpu whose cache
> + * attributes are being detected
> + */
> +#define DEFINE_SMP_CALL_FUNCTION(func)				\
> +static void _##func(void *ret)					\
> +{								\
> +	int cpu = smp_processor_id();				\
> +	*(int *)ret = __##func(cpu);				\
> +}								\
> +								\
> +int func(unsigned int cpu)					\
> +{								\
> +	int ret;						\
> +	smp_call_function_single(cpu, _##func, &ret, true);	\
> +	return ret;						\
> +}
> +

Bikeshed: Maybe this should be called DEFINE_SMP_CALL_CACHE_FUNCTION()?
Missing include for <linux/smp.h> here?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

