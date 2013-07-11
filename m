Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3GKRGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 13:06:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3GKRGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 13:06:49 -0400
Date: Thu, 11 Jul 2013 10:06:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-kernel@vger.kernel.org, linux@roeck-us.net, khali@linux-fr.org
Subject: Re: [PATCH v2 2/7] sysfs.h: add ATTRIBUTE_GROUPS() macro
Message-ID: <20130711170648.GC23056@kroah.com>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-3-git-send-email-gregkh@linuxfoundation.org>
 <51DE9DE5.20905@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DE9DE5.20905@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 01:58:29PM +0200, Oliver Schinagl wrote:
> On 11-07-13 02:36, Greg Kroah-Hartman wrote:
> >To make it easier for driver subsystems to work with attribute groups,
> >create the ATTRIBUTE_GROUPS macro to remove some of the repetitive
> >typing for the most common use for attribute groups.
> But binary groups are discriminated against :(

Yes, as they are "rarer" by far, as they should be.  binary sysfs files
should almost never be used, as they are only "pass-through" files to
the hardware, so I want to see you do more work in order to use them, as
they should not be created lightly.

> The attached patch should help here.

Can you give me an example of using these macros?  I seem to be lost in
them somehow, or maybe my morning coffee just hasn't kicked in...

> I suppose one more additional helper wouldn't be bad to have:
> 
> #define ATTRIBUTE_(BIN_)GROUPS_R[O/W](_name(, _size)) \
> ATTRIBUTE_(BIN_)ATTR_R[O/W](_name, _size); \
> ATTRIBUTE_(BIN_)GROUPS(_name)

Would that ever be needed?

> >From 003ab7a74ff689daa6934e7bc50c498b2d35a1cc Mon Sep 17 00:00:00 2001
> From: Oliver Schinagl <oliver@schinagl.nl>
> Date: Thu, 11 Jul 2013 13:48:18 +0200
> Subject: [PATCH] sysfs: add more helper macro's for (bin_)attribute(_groups)
> 
> With the recent changes to sysfs there's various helper macro's.
> However there's no RW, RO BIN_ helper macro's. This patch adds them.
> 
> Additionally there are no BIN_ group helpers so there's that aswell
> Moreso, if both bin and normal attribute groups are used, there's a
> simple helper for that, though the naming code be better. _TXT_ for the
> show/store ones and neither TXT or BIN for both, but that would change
> things to extensivly.
> 
> Finally there's also helpers for ATTRIBUTE_ATTRS.
> 
> After this patch, create default attributes can be as easy as:
> 
> ATTRIBUTE_(BIN_)ATTR_RO(name, SIZE);
> ATTRIBUTE_BIN_GROUPS(name);
> 
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
> ---
>  include/linux/sysfs.h | 96 ++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 84 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 2c3b6a3..0ebed11 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -17,6 +17,7 @@
>  #include <linux/list.h>
>  #include <linux/lockdep.h>
>  #include <linux/kobject_ns.h>
> +#include <linux/stat.h>
>  #include <linux/atomic.h>
>  
>  struct kobject;
> @@ -94,15 +95,32 @@ struct attribute_group {
>  #define __ATTR_IGNORE_LOCKDEP	__ATTR
>  #endif
>  
> -#define ATTRIBUTE_GROUPS(name)					\
> -static const struct attribute_group name##_group = {		\
> -	.attrs = name##_attrs,					\
> +#define __ATTRIBUTE_GROUPS(_name)				\
> +static const struct attribute_group *_name##_groups[] = {	\
> +	&_name##_group,						\
> +	NULL,							\
> +}
> +
> +#define ATTRIBUTE_GROUPS(_name)					\
> +static const struct attribute_group _name##_group = {		\
> +	.attrs = _name##_attrs,					\
>  };								\
> -static const struct attribute_group *name##_groups[] = {	\
> -	&name##_group,						\
> +__ATTRIBUTE_GROUPS(_name)
> +
> +#define __ATTRIBUTE_ATTRS(_name)				\
> +struct bin_attribute *_name##_attrs[] = {			\
> +	&_name##_attr,						\
>  	NULL,							\
>  }
>  
> +#define ATTRIBUTE_ATTR_RO(_name, _size)				\
> +struct attribute _name##_attr = __ATTR_RO(_name, _size);	\
> +__ATTRIBUTE_ATTRS(_name)
> +
> +#define ATTRIBUTE_ATTR_RW(_name, _size)				\
> +struct attribute _name##_attr = __ATTR_RW(_name, _size);	\
> +__ATTRIBUTE_ATTRS(_name)

What do these two help out with?  "attribute attribute read-write" seems
a bit "clunky", don't you think? :)

> +
>  #define attr_name(_attr) (_attr).attr.name
>  
>  struct file;
> @@ -132,15 +150,69 @@ struct bin_attribute {
>   */
>  #define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&(bin_attr)->attr)
>  
> -/* macro to create static binary attributes easier */
> -#define BIN_ATTR(_name, _mode, _read, _write, _size)		\
> -struct bin_attribute bin_attr_##_name = {			\
> -	.attr = {.name = __stringify(_name), .mode = _mode },	\
> -	.read	= _read,					\
> -	.write	= _write,					\
> -	.size	= _size,					\
> +/* macros to create static binary attributes easier */
> +#define __BIN_ATTR(_name, _mode, _read, _write, _size) {		\
> +	.attr = { .name = __stringify(_name), .mode = _mode },		\
> +	.read	= _read,						\
> +	.write	= _write,						\
> +	.size	= _size,						\
> +}
> +
> +#define __BIN_ATTR_RO(_name, _size) {					\
> +	.attr	= { .name = __stringify(_name), .mode = S_IRUGO },	\
> +	.read	= _name##_read,						\
> +	.size	= _size,						\
> +}
> +
> +#define __BIN_ATTR_RW(_name, _size) __BIN_ATTR(_name,			\
> +				   (S_IWUSR | S_IRUGO), _name##_read,	\
> +				   _name##_write)
> +
> +#define __BIN_ATTR_NULL __ATTR_NULL
> +
> +#define BIN_ATTR(_name, _mode, _read, _write, _size)			\
> +struct bin_attribute bin_attr_##_name = __BIN_ATTR(_name, _mode, _read,	\
> +					_write, _size)
> +
> +#define BIN_RO_ATTR(_name, _size)					\
> +struct bin_attribute bin_attr_##_name = __BIN_ATTR_RO(_name, _size)
> +
> +#define BIN_RW_ATTR(_name, _size)					\
> +struct bin_attribute bin_attr_##_name = __BIN_ATTR_RW(_name, _size)

To be consistent, these shoudl be BIN_ATTR_RO and BIN_ATTR_RW, right?

These all look fine to me, thanks.

It's these that I'm confused about:

> +
> +#define __ATTRIBUTE_BIN_GROUPS(_name)					\
> +static const struct attribute_group *_name##_bin_groups[] = {		\
> +	&_name##_bin_group,						\
> +	NULL,								\
>  }
>  
> +#define ATTRIBUTE_BIN_GROUPS(_name)					\
> +static const struct attribute_group _name##_bin_group = {		\
> +	.bin_attrs = _name##_bin_attrs,					\
> +};									\
> +__ATTRIBUTE_BIN_GROUPS(_name)
> +
> +#define ATTRIBUTE_FULL_GROUPS(_name)					\
> +static const struct attribute_group _name##_full_group = {		\
> +	.attrs = _name##_attrs,						\
> +	.bin_attrs = _name##_bin_attrs,					\
> +};									\
> +__ATTRIBUTE_GROUPS(_name); __ATTRIBUTE_BIN_GROUPS(_name)
> +
> +#define __ATTRIBUTE_BIN_ATTRS(_name)					\
> +struct bin_attribute *_name##_bin_attrs[] = {				\
> +	&_name##_bin_attr,						\
> +	NULL,								\
> +}
> +
> +#define ATTRIBUTE_BIN_ATTR_RO(_name, _size)				\
> +struct bin_attribute _name##_bin_attr = __BIN_ATTR_RO(_name, _size);	\
> +__ATTRIBUTE_BIN_ATTRS(_name)
> +
> +#define ATTRIBUTE_BIN_ATTR_RW(_name, _size)				\
> +struct bin_attribute _name##_bin_attr = __BIN_ATTR_RW(_name, _size);	\
> +__ATTRIBUTE_BIN_ATTRS(_name)

Can you show me how these would be used in a real-world example?

thanks,

greg k-h
