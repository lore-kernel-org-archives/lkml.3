Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbaGVSuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:50:09 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55958 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaGVSuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:50:06 -0400
Date: Tue, 22 Jul 2014 12:50:02 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] resource: Add device-managed
 request/release_resource()
Message-ID: <20140722185002.GC19181@google.com>
References: <1405062505-2606-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405062505-2606-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Tejun, LKML]

On Fri, Jul 11, 2014 at 09:08:24AM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Provide device-managed implementations of the request_resource() and
> release_resource() functions. Upon failure to request a resource, the
> new devm_request_resource() function will output an error message for
> consistent error reporting.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

This seems OK to me, but I don't consider myself a devres maintainer.  I
added Tejun and LKML for any comment.  Minor nit below.

> ---
>  Documentation/driver-model/devres.txt |  2 +
>  include/linux/ioport.h                |  5 +++
>  kernel/resource.c                     | 73 +++++++++++++++++++++++++++++++++++
>  3 files changed, 80 insertions(+)
> 
> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> index 034d32b00846..b466f3d19bcb 100644
> --- a/Documentation/driver-model/devres.txt
> +++ b/Documentation/driver-model/devres.txt
> @@ -252,6 +252,8 @@ IIO
>    devm_iio_device_unregister()
>  
>  IO region
> +  devm_request_resource()
> +  devm_release_resource()
>    devm_request_region()
>    devm_request_mem_region()
>    devm_release_region()
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 142ec544167c..2c5250222278 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -215,6 +215,11 @@ static inline int __deprecated check_region(resource_size_t s,
>  
>  /* Wrappers for managed devices */
>  struct device;
> +
> +extern int devm_request_resource(struct device *dev, struct resource *root,
> +				 struct resource *new);
> +extern void devm_release_resource(struct device *dev, struct resource *new);
> +
>  #define devm_request_region(dev,start,n,name) \
>  	__devm_request_region(dev, &ioport_resource, (start), (n), (name))
>  #define devm_request_mem_region(dev,start,n,name) \
> diff --git a/kernel/resource.c b/kernel/resource.c
> index da14b8d09296..39d99aa401a6 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1248,6 +1248,79 @@ int release_mem_region_adjustable(struct resource *parent,
>  /*
>   * Managed region resource
>   */
> +static void devm_resource_release(struct device *dev, void *ptr)
> +{
> +	struct resource **r = ptr;
> +
> +	release_resource(*r);
> +}
> +
> +/**
> + * devm_request_resource() - request and reserve an I/O or memory resource
> + * @dev: device for which to request the resource
> + * @root: root of the resource tree from which to request the resource
> + * @new: descriptor of the resource to request
> + *
> + * This is a device-managed version of request_resource(). There is usually
> + * no need to release resources requested by this function explicitly since
> + * that will be taken care of when the device is unbound from its driver.
> + * If for some reason the resource needs to be released explicitly, because
> + * of ordering issues for example, drivers must call devm_release_resource()
> + * rather than the regular release_resource().
> + *
> + * When a conflict is detected between any existing resources and the newly
> + * requested resource, an error message will be printed.
> + *
> + * Returns 0 on success or a negative error code on failure.
> + */
> +int devm_request_resource(struct device *dev, struct resource *root,
> +			  struct resource *new)
> +{
> +	struct resource *conflict, **ptr;
> +
> +	ptr = devres_alloc(devm_resource_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return -ENOMEM;
> +
> +	*ptr = new;
> +
> +	conflict = request_resource_conflict(root, new);
> +	if (!conflict) {
> +		devres_add(dev, ptr);
> +		return 0;
> +	}
> +
> +	dev_err(dev, "resource collision: %pR conflicts with %s %pR\n", new,
> +		conflict->name, conflict);
> +	devres_free(ptr);
> +	return -EBUSY;

Personally I would write this as:

  conflict = request_resource_conflict(...);
  if (conflict) {
    dev_err(...);
    devres_free(...);
    return -EBUSY;
  }

  devres_add(...);
  return 0;

so the straight-line path is the normal, non-error path and errors are
detected and dealt with in the "if" bodies.  Right now the "if" bodies
are a mix of error handling and normal path.  But that's just my personal
preference.

> +}
> +EXPORT_SYMBOL(devm_request_resource);
> +
> +static int devm_resource_match(struct device *dev, void *res, void *data)
> +{
> +	struct resource **ptr = res;
> +
> +	if (WARN_ON(!ptr || !*ptr))
> +		return 0;
> +
> +	return *ptr == data;
> +}
> +
> +/**
> + * devm_release_resource() - release a previously requested resource
> + * @dev: device for which to release the resource
> + * @new: descriptor of the resource to release
> + *
> + * Releases a resource previously requested using devm_request_resource().
> + */
> +void devm_release_resource(struct device *dev, struct resource *new)
> +{
> +	WARN_ON(devres_release(dev, devm_resource_release, devm_resource_match,
> +			       new));
> +}
> +EXPORT_SYMBOL(devm_release_resource);
> +
>  struct region_devres {
>  	struct resource *parent;
>  	resource_size_t start;
> -- 
> 2.0.1
> 
