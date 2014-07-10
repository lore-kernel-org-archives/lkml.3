Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaGJNgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:36:11 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57260 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbaGJNgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:36:08 -0400
Message-ID: <53BE9713.8090700@arm.com>
Date: Thu, 10 Jul 2014 14:37:23 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/9] drivers: base: support cpu cache information interface
 to userspace via sysfs
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1403717444-23559-3-git-send-email-sudeep.holla@arm.com> <20140710000905.GA18025@kroah.com>
In-Reply-To: <20140710000905.GA18025@kroah.com>
X-OriginalArrivalTime: 10 Jul 2014 13:36:05.0020 (UTC) FILETIME=[E5DC5DC0:01CF9C43]
X-MC-Unique: 114071014360512501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for reviewing this.

On 10/07/14 01:09, Greg Kroah-Hartman wrote:
> On Wed, Jun 25, 2014 at 06:30:37PM +0100, Sudeep Holla wrote:
>> +static const struct device_attribute *cache_optional_attrs[] = {
>> +	&dev_attr_coherency_line_size,
>> +	&dev_attr_ways_of_associativity,
>> +	&dev_attr_number_of_sets,
>> +	&dev_attr_size,
>> +	&dev_attr_attributes,
>> +	&dev_attr_physical_line_partition,
>> +	NULL
>> +};
>> +
>> +static int device_add_attrs(struct device *dev,
>> +			    const struct device_attribute **dev_attrs)
>> +{
>> +	int i, error = 0;
>> +	struct device_attribute *dev_attr;
>> +	char *buf;
>> +
>> +	if (!dev_attrs)
>> +		return 0;
>> +
>> +	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>> +	if (!buf)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; dev_attrs[i]; i++) {
>> +		dev_attr = (struct device_attribute *)dev_attrs[i];
>> +
>> +		/* create attributes that provides meaningful value */
>> +		if (dev_attr->show(dev, dev_attr, buf) < 0)
>> +			continue;
>> +
>> +		error = device_create_file(dev, dev_attrs[i]);
>> +		if (error) {
>> +			while (--i >= 0)
>> +				device_remove_file(dev, dev_attrs[i]);
>> +			break;
>> +		}
>> +	}
>> +
>> +	kfree(buf);
>> +	return error;
>> +}
>
> Ick, why create your own function for this when the driver core has this
> functionality built into it?  Look at the is_visible() callback, and how
> it is use for an attribute group please.
>

I agree even I added this function hesitantly as didn't realize that I can use
is_visible for this purpose. Thanks for pointing that out I will have a look
at it.

>> +static void device_remove_attrs(struct device *dev,
>> +				const struct device_attribute **dev_attrs)
>> +{
>> +	int i;
>> +
>> +	if (!dev_attrs)
>> +		return;
>> +
>> +	for (i = 0; dev_attrs[i]; dev_attrs++, i++)
>> +		device_remove_file(dev, dev_attrs[i]);
>> +}
>
> You should just remove a whole group at once, not individually.
>

Right, I must be able to get rid of these 2 functions once I use
is_visible callback.

>> +
>> +const struct device_attribute **
>> +__weak cache_get_priv_attr(struct device *cache_idx_dev)
>> +{
>> +	return NULL;
>> +}
>> +
>> +/* Add/Remove cache interface for CPU device */
>> +static void cpu_cache_sysfs_exit(unsigned int cpu)
>> +{
>> +	int i;
>> +	struct device *tmp_dev;
>> +	const struct device_attribute **ci_priv_attr;
>> +
>> +	if (per_cpu_index_dev(cpu)) {
>> +		for (i = 0; i < cache_leaves(cpu); i++) {
>> +			tmp_dev = per_cache_index_dev(cpu, i);
>> +			if (!tmp_dev)
>> +				continue;
>> +			ci_priv_attr = cache_get_priv_attr(tmp_dev);
>> +			device_remove_attrs(tmp_dev, ci_priv_attr);
>> +			device_remove_attrs(tmp_dev, cache_optional_attrs);
>> +			device_unregister(tmp_dev);
>> +		}
>> +		kfree(per_cpu_index_dev(cpu));
>> +		per_cpu_index_dev(cpu) = NULL;
>> +	}
>> +	device_unregister(per_cpu_cache_dev(cpu));
>> +	per_cpu_cache_dev(cpu) = NULL;
>> +}
>> +
>> +static int cpu_cache_sysfs_init(unsigned int cpu)
>> +{
>> +	struct device *dev = get_cpu_device(cpu);
>> +
>> +	if (per_cpu_cacheinfo(cpu) == NULL)
>> +		return -ENOENT;
>> +
>> +	per_cpu_cache_dev(cpu) = device_create(dev->class, dev, cpu,
>> +					       NULL, "cache");
>> +	if (IS_ERR_OR_NULL(per_cpu_cache_dev(cpu)))
>> +		return PTR_ERR(per_cpu_cache_dev(cpu));
>> +
>> +	/* Allocate all required memory */
>> +	per_cpu_index_dev(cpu) = kzalloc(sizeof(struct device *) *
>> +					 cache_leaves(cpu), GFP_KERNEL);
>> +	if (unlikely(per_cpu_index_dev(cpu) == NULL))
>> +		goto err_out;
>> +
>> +	return 0;
>> +
>> +err_out:
>> +	cpu_cache_sysfs_exit(cpu);
>> +	return -ENOMEM;
>> +}
>> +
>> +static int cache_add_dev(unsigned int cpu)
>> +{
>> +	unsigned short i;
>> +	int rc;
>> +	struct device *tmp_dev, *parent;
>> +	struct cacheinfo *this_leaf;
>> +	const struct device_attribute **ci_priv_attr;
>> +	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
>> +
>> +	rc = cpu_cache_sysfs_init(cpu);
>> +	if (unlikely(rc < 0))
>> +		return rc;
>> +
>> +	parent = per_cpu_cache_dev(cpu);
>> +	for (i = 0; i < cache_leaves(cpu); i++) {
>> +		this_leaf = this_cpu_ci->info_list + i;
>> +		if (this_leaf->disable_sysfs)
>> +			continue;
>> +		tmp_dev = device_create_with_groups(parent->class, parent, i,
>> +						    this_leaf,
>> +						    cache_default_groups,
>> +						    "index%1u", i);
>> +		if (IS_ERR_OR_NULL(tmp_dev)) {
>> +			rc = PTR_ERR(tmp_dev);
>> +			goto err;
>> +		}
>> +
>> +		rc = device_add_attrs(tmp_dev, cache_optional_attrs);
>> +		if (unlikely(rc))
>> +			goto err;
>> +
>> +		ci_priv_attr = cache_get_priv_attr(tmp_dev);
>> +		rc = device_add_attrs(tmp_dev, ci_priv_attr);
>> +		if (unlikely(rc))
>> +			goto err;
>
> You just raced with userspace here, creating these files _after_ the
> device was announced to userspace, causing problems with anyone wanting
> to read these attributes :(
>
> I think if you fix up the is_visible() thing above, these calls will go
> away, right?
>

Yes I agree.

Regards,
Sudeep

