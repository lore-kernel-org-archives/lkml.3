Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3CUA4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:56:13 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62037 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3CUA4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:56:10 -0400
Message-ID: <514A5AED.1050405@ozlabs.ru>
Date: Thu, 21 Mar 2013 11:57:17 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio powerpc: implement IOMMU driver for VFIO
References: <1363660844.24132.452.camel@bling.home>  <1363676892-3891-1-git-send-email-aik@ozlabs.ru> <1363812324.24132.544.camel@bling.home>
In-Reply-To: <1363812324.24132.544.camel@bling.home>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/13 07:45, Alex Williamson wrote:
> On Tue, 2013-03-19 at 18:08 +1100, Alexey Kardashevskiy wrote:
>> VFIO implements platform independent stuff such as
>> a PCI driver, BAR access (via read/write on a file descriptor
>> or direct mapping when possible) and IRQ signaling.
>>
>> The platform dependent part includes IOMMU initialization
>> and handling. This patch implements an IOMMU driver for VFIO
>> which does mapping/unmapping pages for the guest IO and
>> provides information about DMA window (required by a POWERPC
>> guest).
>>
>> The counterpart in QEMU is required to support this functionality.
>>
>> Changelog:
>> * documentation updated
>> * containter enable/disable ioctls added
>> * request_module(spapr_iommu) added
>> * various locks fixed
>>
>> Cc: David Gibson <david@gibson.dropbear.id.au>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>
>
> Looking pretty good.  There's one problem with the detach_group,
> otherwise just some trivial comments below.  What's the status of the
> tce code that this depends on?  Thanks,


It is done, I am just waiting till other patches of the series will be 
reviewed (by guys) and fixed (by me) and then I'll post everything again.

[skipped]

>> +static int tce_iommu_enable(struct tce_container *container)
>> +{
>> +	int ret = 0;
>> +	unsigned long locked, lock_limit, npages;
>> +	struct iommu_table *tbl = container->tbl;
>> +
>> +	if (!container->tbl)
>> +		return -ENXIO;
>> +
>> +	if (!current->mm)
>> +		return -ESRCH; /* process exited */
>> +
>> +	mutex_lock(&container->lock);
>> +	if (container->enabled) {
>> +		mutex_unlock(&container->lock);
>> +		return -EBUSY;
>> +	}
>> +
>> +	/*
>> +	 * Accounting for locked pages.
>> +	 *
>> +	 * On sPAPR platform, IOMMU translation table contains
>> +	 * an entry per 4K page. Every map/unmap request is sent
>> +	 * by the guest via hypercall and supposed to be handled
>> +	 * quickly, ecpesially in real mode (if such option is
>
> s/ecpesially/especially/


I replaced the whole text by the one written by Ben and David.

[skipped]

>> +	}
>> +
>> +	return -ENOTTY;
>> +}
>> +
>> +static int tce_iommu_attach_group(void *iommu_data,
>> +		struct iommu_group *iommu_group)
>> +{
>> +	int ret;
>> +	struct tce_container *container = iommu_data;
>> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
>> +
>> +	BUG_ON(!tbl);
>> +	mutex_lock(&container->lock);
>> +	pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
>> +			iommu_group_id(iommu_group), iommu_group);
>> +	if (container->tbl) {
>> +		pr_warn("tce_vfio: Only one group per IOMMU container is allowed, existing id=%d, attaching id=%d\n",
>> +				iommu_group_id(container->tbl->it_group),
>> +				iommu_group_id(iommu_group));
>> +		mutex_unlock(&container->lock);
>> +		return -EBUSY;
>> +	}
>> +
>> +	ret = iommu_take_ownership(tbl);
>> +	if (!ret)
>> +		container->tbl = tbl;
>> +
>> +	mutex_unlock(&container->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static void tce_iommu_detach_group(void *iommu_data,
>> +		struct iommu_group *iommu_group)
>> +{
>> +	struct tce_container *container = iommu_data;
>> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
>> +
>> +	BUG_ON(!tbl);
>> +	mutex_lock(&container->lock);
>> +	if (tbl != container->tbl) {
>> +		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
>> +				iommu_group_id(iommu_group),
>> +				iommu_group_id(tbl->it_group));
>> +	} else if (container->enabled) {
>> +		pr_err("tce_vfio: detaching group #%u from enabled container\n",
>> +				iommu_group_id(tbl->it_group));
>
> Hmm, something more than a pr_err needs to happen here.  Wouldn't this
> imply a disable and going back to an unprivileged container?

Ah. It does not return error code... Then something like that?

...
          } else if (container->enabled) {
                  pr_warn("tce_vfio: detaching group #%u from enabled 
container, forcing disable\n",
                                  iommu_group_id(tbl->it_group));
                  tce_iommu_disable(container);
...

-- 
Alexey
