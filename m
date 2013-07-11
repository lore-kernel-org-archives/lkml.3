Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3GKLrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:47:47 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:38026 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab3GKLrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:47:45 -0400
Message-ID: <51DE9AF1.90105@schinagl.nl>
Date: Thu, 11 Jul 2013 13:45:53 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux@roeck-us.net, khali@linux-fr.org
Subject: Re: [PATCH v2 5/7] sysfs: add support for binary attributes in groups
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org> <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org> <1373502965-1683-6-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1373502965-1683-6-git-send-email-gregkh@linuxfoundation.org>
Content-Type: multipart/mixed;
 boundary="------------070206080704050103070707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070206080704050103070707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11-07-13 02:36, Greg Kroah-Hartman wrote:
> groups should be able to support binary attributes, just like it
> supports "normal" attributes.  This lets us only handle one type of
> structure, groups, throughout the driver core and subsystems, making
> binary attributes a "full fledged" part of the driver model, and not
> something just "tacked on".
However when only using binary attributes it warns and doesn't create 
anything. The attached patch fixes that.
>
> Reported-by: Oliver Schinagl <oliver+list@schinagl.nl>
If I may be so bold and ask to change my e-mail address to 
<oliver@schinagl.nl> that would be kind. I use the +list delimiter to 
put all the mailing list mails in a separate mailbox.

> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/sysfs/group.c      | 66 +++++++++++++++++++++++++++++++++++----------------
>   include/linux/sysfs.h |  4 ++--
>   2 files changed, 48 insertions(+), 22 deletions(-)
>
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index aec3d5c..e5719c6 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -20,38 +20,64 @@ static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>   			 const struct attribute_group *grp)
>   {
>   	struct attribute *const* attr;
> -	int i;
> +	struct bin_attribute *const* bin_attr;
>
> -	for (i = 0, attr = grp->attrs; *attr; i++, attr++)
> -		sysfs_hash_and_remove(dir_sd, NULL, (*attr)->name);
> +	if (grp->attrs)
> +		for (attr = grp->attrs; *attr; attr++)
> +			sysfs_hash_and_remove(dir_sd, NULL, (*attr)->name);
> +	if (grp->bin_attrs)
> +		for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++)
> +			sysfs_remove_bin_file(kobj, *bin_attr);
>   }
>
>   static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>   			const struct attribute_group *grp, int update)
>   {
>   	struct attribute *const* attr;
> +	struct bin_attribute *const* bin_attr;
>   	int error = 0, i;
>
> -	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
> -		umode_t mode = 0;
> +	if (grp->attrs) {
> +		for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
> +			umode_t mode = 0;
> +
> +			/*
> +			 * In update mode, we're changing the permissions or
> +			 * visibility.  Do this by first removing then
> +			 * re-adding (if required) the file.
> +			 */
> +			if (update)
> +				sysfs_hash_and_remove(dir_sd, NULL,
> +						      (*attr)->name);
> +			if (grp->is_visible) {
> +				mode = grp->is_visible(kobj, *attr, i);
> +				if (!mode)
> +					continue;
> +			}
> +			error = sysfs_add_file_mode(dir_sd, *attr,
> +						    SYSFS_KOBJ_ATTR,
> +						    (*attr)->mode | mode);
> +			if (unlikely(error))
> +				break;
> +		}
> +		if (error) {
> +			remove_files(dir_sd, kobj, grp);
> +			goto exit;
> +		}
> +	}
>
> -		/* in update mode, we're changing the permissions or
> -		 * visibility.  Do this by first removing then
> -		 * re-adding (if required) the file */
> -		if (update)
> -			sysfs_hash_and_remove(dir_sd, NULL, (*attr)->name);
> -		if (grp->is_visible) {
> -			mode = grp->is_visible(kobj, *attr, i);
> -			if (!mode)
> -				continue;
> +	if (grp->bin_attrs) {
> +		for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++) {
> +			if (update)
> +				sysfs_remove_bin_file(kobj, *bin_attr);
> +			error = sysfs_create_bin_file(kobj, *bin_attr);
> +			if (error)
> +				break;
>   		}
> -		error = sysfs_add_file_mode(dir_sd, *attr, SYSFS_KOBJ_ATTR,
> -					    (*attr)->mode | mode);
> -		if (unlikely(error))
> -			break;
> +		if (error)
> +			remove_files(dir_sd, kobj, grp);
>   	}
> -	if (error)
> -		remove_files(dir_sd, kobj, grp);
> +exit:
>   	return error;
>   }
>
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index d50a96b..2c3b6a3 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -21,6 +21,7 @@
>
>   struct kobject;
>   struct module;
> +struct bin_attribute;
>   enum kobj_ns_type;
>
>   struct attribute {
> @@ -59,10 +60,9 @@ struct attribute_group {
>   	umode_t			(*is_visible)(struct kobject *,
>   					      struct attribute *, int);
>   	struct attribute	**attrs;
> +	struct bin_attribute	**bin_attrs;
>   };
>
> -
> -
>   /**
>    * Use these macros to make defining attributes easier. See include/linux/device.h
>    * for examples..
>


--------------070206080704050103070707
Content-Type: text/x-patch;
 name="0001-sysfs-prevent-warning-when-only-using-binary-attribu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-sysfs-prevent-warning-when-only-using-binary-attribu.pa";
 filename*1="tch"

>From 5a4066011878134c1ab9412bc147c28c30f0fa4b Mon Sep 17 00:00:00 2001
From: Oliver Schinagl <oliver@schinagl.nl>
Date: Thu, 11 Jul 2013 13:40:20 +0200
Subject: [PATCH] sysfs: prevent warning when only using binary attributes

When only using bin_attrs instead of attrs the kernel prints a warning
and refuses to create the sysfs entry. This fixes that.

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 fs/sysfs/group.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index e5719c6..09a1a25 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -93,8 +93,8 @@ static int internal_create_group(struct kobject *kobj, int update,
 	/* Updates may happen before the object has been instantiated */
 	if (unlikely(update && !kobj->sd))
 		return -EINVAL;
-	if (!grp->attrs) {
-		WARN(1, "sysfs: attrs not set by subsystem for group: %s/%s\n",
+	if (!grp->attrs && !grp->bin_attrs) {
+		WARN(1, "sysfs: (bin_)attrs not set by subsystem for group: %s/%s\n",
 			kobj->name, grp->name ? "" : grp->name);
 		return -EINVAL;
 	}
-- 
1.8.1.5


--------------070206080704050103070707--
